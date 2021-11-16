package tasks

import (
	"github.com/hibiken/asynq"
	"log"
	"pigs/common"
	"pigs/models/cmdb"
)

func TaskBeta() {
	//client := asynq.NewClient(
	//	asynq.RedisClientOpt{
	//		Addr:     ":6379",
	//		Password: "",
	//	})
	//
	//payload, err := json.Marshal(EmailTaskPayloadTest{
	//	UserID: 100,
	//	Msg:    "test",
	//})
	//if err != nil {
	//	log.Fatal(err)
	//}
	//t1 := asynq.NewTask("task:oneTask", payload)
	//
	//// 定时执行
	//setDate := "2021-11-11 15:10:00"
	//dateFormats := "2006-01-02 15:04:05"
	//// 获取时区
	//loc, _ := time.LoadLocation("Local")
	//// 指定日期 转 当地 日期对象 类型为 time.Time
	//timeObj, err := time.ParseInLocation(dateFormats, setDate, loc)
	//if err != nil {
	//	fmt.Println("parse time failed err :", err)
	//	return
	//}
	//
	//info, err := client.Enqueue(t1, asynq.ProcessAt(timeObj), asynq.Queue("test"))
	//if err != nil {
	//	log.Fatal(err)
	//}
	//
	//log.Printf(" [*] Successfully enqueued task: %+v", info)

	c := common.CONFIG.Redis
	// 周期性任务
	scheduler := asynq.NewScheduler(
		asynq.RedisClientOpt{
			Addr:     c.Host,
			Username: c.UserName,
			Password: c.PassWord,
			DB:       c.DB,
		}, nil)

	// 每隔5分钟同步一次
	var account cmdb.CloudPlatform
	common.DB.Table("cloud_platform").Where("enable != ? and type = ?", 0, "aliyun").Find(&account)
	syncResource := NewAliCloudTask(&account)
	entryID, err := scheduler.Register("*/30 * * * *", syncResource)

	if err != nil {
		log.Fatal(err)
	}
	log.Printf("registered an entry: %q\n", entryID)

	if err := scheduler.Run(); err != nil {
		log.Fatal(err)
	}
}
