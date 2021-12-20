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

package tools

import (
	"fmt"
	"strconv"
)

func ParseFloat2F(value float64) float64 {
	newValue, err := strconv.ParseFloat(fmt.Sprintf("%.2f", value), 64)
	if err != nil {
		fmt.Println("保留2位小数, 转换float出错")
		return value
	}
	return newValue

}

func ParseStringToInt64(value string) int64 {

	newValue, err := strconv.ParseInt(value, 10, 64)
	if err != nil {
		fmt.Println("string转换int64出错")
		return 0
	}
	return newValue
}
