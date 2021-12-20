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
	"github.com/dnsjia/luban/controller/response"
	"github.com/dnsjia/luban/models"
	"github.com/dnsjia/luban/services/cmdb"
	"github.com/gin-gonic/gin"
	"strconv"
)

// ListHostGroup 列出主机分组
func ListHostGroup(c *gin.Context) {
	// 对查询出来的数据进行处理, echo 需要获取url中获取echo字段，  api/v1/cmdb/hosts/groups?echo=1
	// 获取到传true echo=true
	echo := c.DefaultQuery("echo", "0")
	echoInt, err := strconv.Atoi(echo)
	if err != nil {
		return
	}

	TreeList := cmdb.GetMenu(0, echoInt)
	response.OkWithDetailed(cmdb.DataRes{Data: TreeList}, "获取成功", c)
	return

}

// ListHost 列出主机
func ListHost(c *gin.Context) {
	treeId := c.Query("treeId")
	page, _ := strconv.Atoi(c.Query("page"))
	pageSize, _ := strconv.Atoi(c.Query("pageSize"))

	query := models.PaginationQ{
		Page: page,
		Size: pageSize,
	}
	host, err := cmdb.ListVirtualMachine(treeId, &query)

	if err != nil {
		return
	}

	response.OkWithDetailed(response.PageResult{
		Data:  &host,
		Total: query.Total,
		Size:  query.Size,
		Page:  query.Page,
	}, "获取主机成功", c)

	return
}
