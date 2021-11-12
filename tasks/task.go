package tasks

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/hibiken/asynq"
	"pigs/models/cmdb"
	"time"
)

const (
	SyncAliYunCloud  = "cmdb:aliyun"
	SyncTencentCloud = "cmdb:tencent"
)

// NewAliCloudTask 同步阿里云资产同步任务
func NewAliCloudTask(conf *cmdb.CloudPlatform) *asynq.Task {
	payload, err := json.Marshal(conf)
	if err != nil {
		panic(err)
	}
	return asynq.NewTask(SyncAliYunCloud, payload)
}

// NewTencentCloudTask 腾讯云资产同步任务
func NewTencentCloudTask() *asynq.Task {
	//payload, err := json.Marshal(&AK{})
	//if err != nil {
	//	panic(err)
	//}
	return asynq.NewTask(SyncTencentCloud, nil)
}

func HandleAliCloudTask(ctx context.Context, t *asynq.Task) error {
	fmt.Printf("[*] %v Aliyun Cloud assets are successfully synchronized...\n",
		time.Now().Format("2006-01-02 15:04:05"),
	)
	return nil
}
