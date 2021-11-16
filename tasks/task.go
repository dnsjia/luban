package tasks

import (
	"context"
	"encoding/json"
	"github.com/hibiken/asynq"
	"log"
	"pigs/inner/cloud/cloudsync"
	"pigs/inner/cloud/cloudvendor"
	"pigs/models/cmdb"
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

func HandleAliCloudTask(ctx context.Context, t *asynq.Task) error {

	var a cmdb.CloudPlatform
	if err := json.Unmarshal(t.Payload(), &a); err != nil {
		return err
	}

	_, err := cloudvendor.GetVendorClient(&a)
	if err != nil {
		log.Fatalf("AccountVerify GetVendorClient failed，%v", err)
		return err
	}

	cloudsync.SyncAliYunHost(&a)

	log.Printf("Aliyun Cloud assets are successfully synchronized...")
	return nil
}

// NewTencentCloudTask 腾讯云资产同步任务
func NewTencentCloudTask() *asynq.Task {
	//payload, err := json.Marshal(&AK{})
	//if err != nil {
	//	panic(err)
	//}
	return asynq.NewTask(SyncTencentCloud, nil)
}
