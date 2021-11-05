package cloudvendor

import (
	"fmt"
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
		fmt.Println(*region)
	}
}
