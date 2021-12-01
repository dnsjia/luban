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
