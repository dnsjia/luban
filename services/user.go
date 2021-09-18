package services

import (
	"errors"
	"fmt"
	"gorm.io/gorm"
	"pigs/common"
	"pigs/model"
)

func UserRegister(u model.User) (userInter model.User, err error) {
	var user model.User

	if !errors.Is(common.GVA_DB.Where("username = ? ", u.UserName).First(&user).Error, gorm.ErrRecordNotFound) {
		return userInter, errors.New(fmt.Sprintf("user %v already exists", u.UserName))
	}
	err = common.GVA_DB.Create(&u).Error

	return u, err
}

func Login(l model.LoginUser) (model.User, error) {
	var user model.User
	fmt.Printf("查询Email: %v", l.Email)
	err := common.GVA_DB.Preload("Role").Where("email = ?", l.Email).First(&user).Error
	return user, err
}
