package services

import (
	"errors"
	"fmt"
	"golang.org/x/crypto/bcrypt"
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

func Login(l model.User) (model.User, error) {
	var user model.User

	_ = common.GVA_DB.Where("username = ?", l.UserName).First(&user)
	if user.UserName == "" {
		return model.User{}, errors.New(fmt.Sprintf("user %v does not exists", l.UserName))
	}
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(l.Password)); err != nil {
		return model.User{}, errors.New("密码验证失败")
	}

	return user, nil
}
