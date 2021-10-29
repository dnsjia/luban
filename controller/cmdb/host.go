package cmdb

import (
	"github.com/gin-gonic/gin"
	"pigs/common"
	"pigs/controller/response"
	mcmdb "pigs/models/cmdb"
	"pigs/services/cmdb"
	"strconv"
)

// ListHostGroup 列出主机分组
func ListHostGroup(c *gin.Context) {
	// 对查询出来的数据进行处理, echo 需要获取url中获取echo字段，  api/v1/cmdb/hosts/groups?echo=1
	// 获取到传true echo=true
	TreeList := cmdb.GetMenu(0)
	response.OkWithDetailed(cmdb.DataRes{Data: TreeList}, "获取成功", c)
	return
}

// ListHost 列出主机
func ListHost(c *gin.Context) {
	//_ = CloudECS()
	var ecs []mcmdb.VirtualMachine
	id, err := strconv.Atoi(c.Query("treeId"))
	if err != nil {
		response.FailWithMessage(1001, "传入的参数有误！", c)
		return
	}

	treeId := mcmdb.TreeMenu{ID: id}
	if err := common.DB.Model(&treeId).Preload("Groups").Association("VirtualMachines").Find(&ecs); err != nil {
		response.FailWithMessage(1000, "获取资产信息失败", c)
		return
	}
	response.OkWithData(&ecs, c)
	return
}
