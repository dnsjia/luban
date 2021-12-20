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
