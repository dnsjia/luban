package common

import (
	"github.com/dgrijalva/jwt-go"
	"pigs/model"
	"time"
)
var jwtKey = []byte("a_secret_creat")

type Claims struct {
	UserId uint
	jwt.StandardClaims
}

func ReleaseToken(u model.User) (string, error) {
	/*
	创建token
	 */
	expirationTime := time.Now().Add(7 * 24 * time.Hour)
	claims := &Claims{
		UserId: u.ID,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: expirationTime.Unix(),
			IssuedAt: time.Now().Unix(),
			Issuer: "oceanlearn.tech",
			Subject: "user token",

		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(jwtKey)

	if err != nil {
		return "", err
	}
	return tokenString, nil
}


func ParseToken(token string) (*jwt.Token, *Claims, error)  {
	/*
	解析token
	 */
	claims := &Claims{}
	tk, err := jwt.ParseWithClaims(token, claims, func(token *jwt.Token) (interface{}, error) {
		return jwtKey, nil
	})
	return tk, claims, err
}