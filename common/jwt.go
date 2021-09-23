package common

import (
	"github.com/dgrijalva/jwt-go"
	"pigs/models"
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
			Issuer:    "pigs",
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
