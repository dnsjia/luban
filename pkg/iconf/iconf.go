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

package iconf

import (
	"path"

	"github.com/toolkits/pkg/file"
	"github.com/toolkits/pkg/runner"
)

func GetYmlFile(module string) string {
	confdir := path.Join(runner.Cwd, "etc")

	yml := path.Join(confdir, module+".local.yml")
	if file.IsExist(yml) {
		return yml
	}

	yml = path.Join(confdir, module+".yml")
	if file.IsExist(yml) {
		return yml
	}

	return ""
}
