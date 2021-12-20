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

package tasks

import (
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/models/cmdb"
	"github.com/hibiken/asynq"
	"log"
)

func TaskBeta() {

	config := common.CONFIG
	// 周期性任务
	scheduler := asynq.NewScheduler(
		asynq.RedisClientOpt{
			Addr:     config.Redis.Host,
			Username: config.Redis.UserName,
			Password: config.Redis.PassWord,
			DB:       config.Redis.DB,
		}, nil)

	// 每隔5分钟同步一次
	var account cmdb.CloudPlatform
	common.DB.Table("cloud_platform").Where("enable != ? and type = ?", 0, "aliyun").Find(&account)
	syncResource := NewAliCloudTask(&account)
	entryID, err := scheduler.Register(config.Crontab.AliYun, syncResource)

	if err != nil {
		log.Fatal(err)
	}
	log.Printf("registered an entry: %q\n", entryID)

	if err := scheduler.Run(); err != nil {
		log.Fatal(err)
	}
}
