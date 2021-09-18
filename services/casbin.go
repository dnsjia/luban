package services

import (
	"github.com/casbin/casbin/util"
	"github.com/casbin/casbin/v2"
	gormAdapter "github.com/casbin/gorm-adapter/v3"
	_ "github.com/go-sql-driver/mysql"
	"pigs/common"
	"strings"
)

func Casbin() *casbin.Enforcer {
	admin := common.GVA_CONFIG.Mysql
	a, _ := gormAdapter.NewAdapter(common.GVA_CONFIG.System.DbType, admin.Username+":"+admin.Password+"@("+admin.Path+")/"+admin.Dbname, true)
	e, _ := casbin.NewEnforcer(common.GVA_CONFIG.Casbin.ModelPath, a)
	e.AddFunction("ParamsMatch", ParamsMatchFunc)
	_ = e.LoadPolicy()
	return e
}

func ParamsMatch(fullNameKey1 string, key2 string) bool {
	/*
		自定义规则函数
		fullNameKey1 string, key2 string
	*/
	key1 := strings.Split(fullNameKey1, "?")[0]
	// 剥离路径后再使用casbin的keyMatch2
	return util.KeyMatch2(key1, key2)
}

func ParamsMatchFunc(args ...interface{}) (interface{}, error) {
	/*
		自定义规则函数
	*/
	name1 := args[0].(string)
	name2 := args[1].(string)

	return ParamsMatch(name1, name2), nil
}
