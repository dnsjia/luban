package tasks

import (
	"encoding/json"
	"fmt"
	"github.com/hibiken/asynq"
	"log"
	"time"
)

type EmailTaskPayloadTest struct {
	Msg    string
	UserID int
}

func TaskBate() {
	client := asynq.NewClient(
		asynq.RedisClientOpt{
			Addr:     ":6379",
			Password: "",
		})

	payload, err := json.Marshal(EmailTaskPayloadTest{
		UserID: 100,
		Msg:    "test",
	})
	if err != nil {
		log.Fatal(err)
	}
	t1 := asynq.NewTask("task:oneTask", payload)

	// 定时执行
	setDate := "2021-11-11 15:10:00"
	dateFormats := "2006-01-02 15:04:05"
	// 获取时区
	loc, _ := time.LoadLocation("Local")
	// 指定日期 转 当地 日期对象 类型为 time.Time
	timeObj, err := time.ParseInLocation(dateFormats, setDate, loc)
	if err != nil {
		fmt.Println("parse time failed err :", err)
		return
	}

	info, err := client.Enqueue(t1, asynq.ProcessAt(timeObj), asynq.Queue("test"))
	if err != nil {
		log.Fatal(err)
	}

	log.Printf(" [*] Successfully enqueued task: %+v", info)

	// 周期性任务
	scheduler := asynq.NewScheduler(
		asynq.RedisClientOpt{
			Addr:     ":6379",
			Password: "",
			DB:       0,
		}, nil)

	// 每隔5分钟同步一次
	syncResource := NewAliCloudTask()
	entryID, err := scheduler.Register("*/5 * * * *", syncResource, asynq.Queue("sync_cloud"))

	if err != nil {
		log.Fatal(err)
	}
	log.Printf("registered an entry: %q\n", entryID)

	if err := scheduler.Run(); err != nil {
		log.Fatal(err)
	}
}
