package cloudvendor

import (
	"os"
	"pigs/models/cmdb"
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
