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

package common

import (
	"github.com/dgrijalva/jwt-go"
	"github.com/dnsjia/luban/models"
	"time"
)

var jwtKey = []byte("a_secret_creat")

type CustomClaims struct {
	ID         uint
	Username   string
	NickName   string
	Role       string
	BufferTime int64
	jwt.StandardClaims
}

func ReleaseToken(u models.User) (string, error) {
	/*
		创建token
	*/
	expirationTime := time.Now().Add(7 * 24 * time.Hour)
	claims := &CustomClaims{
		ID:       u.ID,
		Username: u.UserName,
		NickName: u.NickName,
		Role:     u.Role.Name,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: expirationTime.Unix(),
			IssuedAt:  time.Now().Unix(),
			Issuer:    "luban",
			Subject:   "user token",
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(jwtKey)

	if err != nil {
		return "", err
	}
	return tokenString, nil
}

func ParseToken(token string) (*jwt.Token, *CustomClaims, error) {
	/*
		解析token
	*/
	claims := &CustomClaims{}
	tk, err := jwt.ParseWithClaims(token, claims, func(token *jwt.Token) (interface{}, error) {
		return jwtKey, nil
	})
	return tk, claims, err
}
