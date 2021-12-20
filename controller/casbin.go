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
