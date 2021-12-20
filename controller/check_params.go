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
	"github.com/gin-gonic/gin"
)

func CheckParams(c *gin.Context, ptr interface{}) error {
	if ptr == nil {
		return nil
	}
	switch t := ptr.(type) {
	case string:
		if t != "" {
			panic(t)
		}
	case error:
		panic(t.Error())
	}
	if err := c.ShouldBindJSON(&ptr); err != nil {
		common.LOG.Warn(fmt.Sprintf("解析参数出错：%v", err.Error()))
		//response.FailWithMessage(response.ParamError, "", c)
		return err

	}
	return nil
}
