package models

import (
	"github.com/toolkits/pkg/logger"
	"time"
)

type User struct {
	GModel
	UId      int64  `gorm:"column:uid;comment:'用戶uid'" json:"uid"`
	UserName string `gorm:"column:username;comment:'用户名';size:128;uniqueIndex:uk_username" json:"username" binding:"required"`
	Password string `gorm:"column:password;comment:'用户密码';size:128" json:"password" binding:"required"`
	Phone    string `gorm:"column:phone;comment:'手机号码';size:11" json:"phone"`
	Email    string `gorm:"column:email;comment:'邮箱';size:128" json:"email"`
	NickName string `gorm:"column:nick_name;comment:'用户昵称';size:128" json:"nick_name"`
	Avatar   string `gorm:"column:avatar;default:http://qmplusimg.henrongyi.top/head.png;comment:'用户头像';size:128" json:"avatar"`
	Status   *bool  `gorm:"type:tinyint(1);default:true;comment:'用户状态(正常/禁用, 默认正常)'"`
	RoleId   uint   `gorm:"column:role_id;comment:'角色id外键'" json:"role_id"`
	Role     Role   `gorm:"foreignkey:RoleId" json:"role"`
	DeptId   uint   `gorm:"comment:'部门id外键'" json:"dept_id"`
	Dept     Dept   `gorm:"foreignkey:DeptId" json:"dept"`
	CreateBy string `gorm:"column:create_by;comment:'创建来源'" json:"create_by"`
}

type LoginUser struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

func (u User) TableName() string {
	return u.GModel.TableName("users")
}

func UserGet(where string, args ...interface{}) (*User, error) {
	var obj User
	has, err := DB.Where(where, args...).Get(&obj)
	if err != nil {
		logger.Errorf("mysql.error: query user(%s)%+v fail: %s", where, args, err)
		return nil, internalServerError
	}

	if !has {
		return nil, nil
	}

	return &obj, nil
}

func UserGetByUsername(username string) (*User, error) {
	return UserGet("username=?", username)
}

func LdapLogin(username, pass string) (*User, error) {
	sr, err := ldapReq(username, pass)
	if err != nil {
		return nil, err
	}

	user, err := UserGetByUsername(username)
	if err != nil {
		return nil, err
	}

	if user == nil {
		// default user settings
		user = &User{
			UserName: username,
			NickName: username,
		}
	}

	// copy attributes from ldap
	attrs := LDAP.Attributes
	if attrs.Nickname != "" {
		user.NickName = sr.Entries[0].GetAttributeValue(attrs.Nickname)
	}
	if attrs.Email != "" {
		user.Email = sr.Entries[0].GetAttributeValue(attrs.Email)
	}
	if attrs.Phone != "" {
		user.Phone = sr.Entries[0].GetAttributeValue(attrs.Phone)
	}

	if user.Id > 0 {
		if LDAP.CoverAttributes {
			_, err := DB.Where("id=?", user.Id).Update(user)
			if err != nil {
				logger.Errorf("mysql.error: update user %+v fail: %v", user, err)
				return nil, internalServerError
			}
		}
		return user, nil
	}

	now := time.Now().Unix()

	user.Password = "******"
	user.CreateAt = now
	user.CreateBy = "ldap"

	err = DBInsertOne(user)
	return user, err
}
