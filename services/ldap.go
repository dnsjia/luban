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

package services

import (
	"errors"
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/models"
	"github.com/toolkits/pkg/logger"
	"golang.org/x/crypto/bcrypt"
)

func UserGet(where string, args ...interface{}) (*models.User, error) {
	var obj models.User
	err := common.DB.Where(where, args...).First(&obj).Error
	if err != nil {
		logger.Errorf("mysql.error: query user(%s)%+v fail: %s", where, args, err)
		return nil, err
	}

	return &obj, nil
}

func UserGetByUsername(username string) (*models.User, error) {
	// todo 多条件查询
	return UserGet("username=?", username)
}

func PassLogin(username, pass string) (*models.User, error) {
	user, err := UserGetByUsername(username)
	if err != nil {
		return nil, err
	}

	if user == nil {
		logger.Infof("password auth fail, no such user: %s", username)
		return nil, err
	}
	// 校验加密后密码是否一致
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(pass)); err != nil {
		logger.Infof("password auth fail, password error, user: %s", username)
		return nil, errors.New("login fail, check your username and password")
	}

	return user, nil
}

func LdapLogin(username, pass string) (*models.User, error) {
	// 从ldap查询用户信息
	sr, e := models.LdapReq(username, pass)

	if e != nil {
		return nil, e // ldap auth fail, no such user: admin
	}

	user, _ := UserGetByUsername(username)
	//if err != nil {
	//	return nil, err
	//}

	if user == nil {
		// default user settings
		user = &models.User{
			UserName: username,
			NickName: username,
		}
	}

	// copy attributes from ldap
	attrs := models.LDAP.Attributes
	if attrs.Nickname != "" {
		user.NickName = sr.Entries[0].GetAttributeValue(attrs.Nickname)
	}
	if attrs.Email != "" {
		user.Email = sr.Entries[0].GetAttributeValue(attrs.Email)
	}
	if attrs.Phone != "" {
		user.Phone = sr.Entries[0].GetAttributeValue(attrs.Phone)
	}

	if attrs.UID != "" {
		user.UID = sr.Entries[0].GetAttributeValue(attrs.UID)
	}

	if user.ID > 0 {
		if models.LDAP.CoverAttributes {
			err := common.DB.Where("id=?", user.ID).Updates(&user)
			if err != nil {
				logger.Errorf("mysql.error: update user %+v fail: %v", user, err)
				return nil, err.Error
			}
		}
		return user, nil
	}

	//now := time.Now().Unix()
	//
	hashPassword, _ := bcrypt.GenerateFromPassword([]byte(pass), bcrypt.DefaultCost)
	user.Password = string(hashPassword)

	//user.Password = pass
	//user.CreatedAt = now
	user.CreateBy = "ldap"

	err := common.DBInsertOne(user)
	return user, err
}
