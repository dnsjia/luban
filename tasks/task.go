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
	"context"
	"encoding/json"
	"github.com/dnsjia/luban/inner/cloud/cloudsync"
	"github.com/dnsjia/luban/inner/cloud/cloudvendor"
	"github.com/dnsjia/luban/models/cmdb"
	"github.com/hibiken/asynq"
	"log"
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
