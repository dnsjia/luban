/*
Copyright 2021 The DnsJia Authors.
WebSite:  https://github.com/dnsjia/luban
Email:    OpenSource@dnsjia.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package cmdb

import (
	"errors"
	"fmt"
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/models/cmdb"
	"github.com/dnsjia/luban/pkg/utils"
	WsSession "github.com/dnsjia/luban/pkg/websocket"
	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
	uuid "github.com/satori/go.uuid"
	"net/http"
	"strconv"
	"sync"
	"time"
)

var (
	UpGrader = websocket.Upgrader{
		ReadBufferSize:  1024,
		WriteBufferSize: 1024 * 1024 * 10,
		// 允许跨域
		CheckOrigin: func(r *http.Request) bool {
			return true
		},
	}
)

type streamMap struct {
	sync.RWMutex
	innerMap map[string]*WsSession.WebSocketStream
}

var (
	SteamMap = NewStreamMap() // 全局 websocket 连接流的 map, 管理所有连接SSH的客户端
)

func NewStreamMap() *streamMap {
	sm := new(streamMap)
	sm.innerMap = make(map[string]*WsSession.WebSocketStream)
	return sm
}

func (sm *streamMap) Set(key string, value *WsSession.WebSocketStream) {
	sm.Lock()
	sm.innerMap[key] = value
	sm.Unlock()
}

func (sm *streamMap) Get(key string) (*WsSession.WebSocketStream, error) {
	sm.RLock()
	value := sm.innerMap[key]
	sm.RUnlock()
	if value == nil {
		err := errors.New("对象不存在")
		return nil, err
	}
	return value, nil
}

func (sm *streamMap) Remove(key string) {
	sm.RLock()
	delete(sm.innerMap, key)
	sm.RUnlock()
	return
}

func WebSocketConnect(c *gin.Context) {
	instanceId := utils.Str2Uint(c.Query("instanceId"))

	var host cmdb.VirtualMachine
	err := common.DB.Table(host.TableName()).Where("uuid = ?", instanceId).First(&host).Error
	if err != nil {
		common.LOG.Error(err.Error())
		return
	}
	// 设置默认xterm窗口大小
	cols, _ := strconv.Atoi(c.DefaultQuery("cols", "188"))
	rows, _ := strconv.Atoi(c.DefaultQuery("rows", "42"))

	uid := uuid.NewV4().String()

	// 获取SSH配置 TODO: 从资产表获取服务器账号、密码
	terminalConfig := WsSession.Config{
		IpAddress:     host.PrivateAddr,
		Port:          "22",
		UserName:      "",
		Password:      "",
		PrivateKey:    "",
		KeyPassphrase: "",
		Width:         cols,
		Height:        rows,
	}

	// 获取ws连接
	ws, err := UpGrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		common.LOG.Error(fmt.Sprintf("创建消息连接失败: %v", err))
		return
	}
	terminal, err := WsSession.NewTerminal(terminalConfig)

	if err != nil {
		_ = ws.WriteMessage(websocket.BinaryMessage, []byte(err.Error()))
		_ = ws.Close()
		return
	}

	wsConn := WsSession.NewWsConn(ws)
	stream := WsSession.NewWebSocketSteam(terminal, wsConn, WsSession.Meta{
		TERM:      terminal.TERM,
		Width:     terminalConfig.Width,
		Height:    terminalConfig.Height,
		ConnectId: uid,
		UserName:  "root",
		HostName:  host.HostName,
		HostId:    uint(host.ID),
	})

	err = stream.Terminal.Connect(stream, stream, stream)

	if err != nil {
		_ = ws.WriteMessage(websocket.BinaryMessage, []byte(err.Error()))
		_ = ws.Close()
		return
	}
	// 断开ws和ssh的操作
	stream.Terminal.SetCloseHandler(func() error {
		// 记录用户的操作
		if err := stream.Write2Log(); err != nil {
			return err
		}
		SteamMap.Remove(uid)
		return stream.Conn.Ws.Close()
	})

	stream.Conn.Ws.SetCloseHandler(func(code int, text string) error {
		SteamMap.Remove(uid)
		return terminal.Close()
	})

	SteamMap.Set(uid, stream)
	// 发送websocketKey给前端
	stream.Conn.WriteMessage(websocket.TextMessage, utils.Str2Bytes("Anew-Sec-WebSocket-Key:"+uid+"\r\n"))

	go func() {
		for {
			// 每5秒
			timer := time.NewTimer(5 * time.Second)
			<-timer.C

			if stream.Terminal.IsClosed() {
				_ = timer.Stop()
				break
			}
			// 如果有 10 分钟没有数据流动，则断开连接
			if time.Now().Unix()-stream.UpdatedAt.Unix() > 60*10 {
				stream.Conn.WriteMessage(websocket.TextMessage, utils.Str2Bytes("检测到终端闲置，已断开连接...\r\n"))
				stream.Conn.WriteMessage(websocket.BinaryMessage, utils.Str2Bytes("检测到终端闲置，已断开连接..."))
				stream.Conn.Ws.Close()
				_ = timer.Stop()
				break
			}
		}
	}()

}
