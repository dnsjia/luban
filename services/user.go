package services

import (
	"errors"
	"fmt"
	"gorm.io/gorm"
	"pigs/common"
	"pigs/models"
)

func UserRegister(u models.User) (userInter models.User, err error) {
	var user models.User

	if !errors.Is(common.DB.Where("username = ? ", u.UserName).First(&user).Error, gorm.ErrRecordNotFound) {
		return userInter, errors.New(fmt.Sprintf("user %v already exists", u.UserName))
	}
	err = common.DB.Create(&u).Error

	return u, err
}

func Login(l models.LoginUser) (models.User, error) {
	var user models.User
	err := common.DB.Preload("Role").Where("email = ?", l.Email).First(&user).Error
	return user, err
}
