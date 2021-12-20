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

package controller

import (
	"fmt"
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/controller/response"
	"github.com/dnsjia/luban/services"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type CasBinPolicy struct {
	Group  string `json:"group" binding:"required"`
	URL    string `json:"url" binding:"required"`
	Method string `json:"method" binding:"required"`
}

func AddCasBin(c *gin.Context) {

	var policy []CasBinPolicy
	err := CheckParams(c, &policy)
	if err != nil {
		response.FailWithMessage(response.ParamError, "", c)
		return
	}
	e := services.Casbin()
	err = e.LoadPolicy()
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	if len(policy) > 0 {
		for _, p := range policy {
			if ok, err := e.AddPolicy(p.Group, p.URL, p.Method); !ok {
				common.LOG.Warn("权限已存在", zap.Any("err", err))
			} else {
				common.LOG.Info(fmt.Sprintf("权限添加成功: %s", p))
			}
		}
		response.Ok(c)
		return

	} else {
		response.FailWithMessage(response.ERROR, "添加权限不能为空", c)
		return
	}

}

func DeleteCasBin(c *gin.Context) {
	e := services.Casbin()
	group := ""
	url := ""
	method := ""
	if ok, _ := e.RemovePolicy(group, url, method); !ok {
		fmt.Println("Policy不存在")
	} else {
		fmt.Println("删除成功")
		response.Ok(c)
		return
	}
}

func GetCasBin(c *gin.Context) {
	e := services.Casbin()
	data := e.GetPolicy()
	response.OkWithData(data, c)
	return
}
