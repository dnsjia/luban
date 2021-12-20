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

package cloudvendor

import (
	"github.com/dnsjia/luban/models/cmdb"
	"os"
	"testing"
)

var aliTestClient VendorClient

func init() {
	conf := cmdb.CloudPlatform{
		Type:      cmdb.AliYun,
		AccessKey: os.Getenv("ALiCLOUD_SECRET_ID"),
		SecretKey: os.Getenv("ALiCLOUD_SECRET_KEY"),
	}
	var err error
	aliTestClient, err = GetVendorClient(&conf)
	if err != nil {
		panic(err.Error())
	}
}

func TestALiGetRegions(t *testing.T) {
	regionSet, err := aliTestClient.GetRegions()
	if err != nil {
		t.Fatal(err)
	}

	for i, region := range regionSet {
		t.Logf("i:%d, vpc:%#v\n", i, *region)
	}
}

func TestALiGetInstances(t *testing.T) {
	region := "cn-hangzhou"
	instancesInfo, err := aliTestClient.GetInstances(region)
	if err != nil {
		t.Fatal(err)
	}

	t.Logf("instances count:%#v\n", instancesInfo)
	for i, instance := range instancesInfo {
		t.Logf("i:%d, instance:%#v\n", i, instance)
	}
}
