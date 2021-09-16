package model

import "gorm.io/gorm"

type User struct {
	gorm.Model
	UserName string `gorm:"column:username" json:"username" binding:"required"`
	Password string `gorm:"column:password" json:"password" binding:"required"`
}

type Login struct {
	UserName string `json:"username"`
	Password string `json:"password"`
	Phone int64 `json:"phone"`
}