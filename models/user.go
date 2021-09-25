package models

type User struct {
	GModel
	UID      string `gorm:"column:uid;comment:'用戶uid'" json:"uid"`
	UserName string `gorm:"column:username;comment:'用户名';size:128;uniqueIndex:uk_username" json:"username" binding:"required"`
	Password string `gorm:"column:password;comment:'用户密码';size:128" json:"password" binding:"required"`
	Phone    string `gorm:"column:phone;comment:'手机号码';size:11" json:"phone"`
	Email    string `gorm:"column:email;comment:'邮箱';size:128" json:"email"`
	NickName string `gorm:"column:nick_name;comment:'用户昵称';size:128" json:"nick_name"`
	Avatar   string `gorm:"column:avatar;default:http://qmplusimg.henrongyi.top/head.png;comment:'用户头像';size:128" json:"avatar"`
	Status   *bool  `gorm:"type:tinyint(1);default:true;comment:'用户状态(正常/禁用, 默认正常)'"`
	RoleId   uint   `gorm:"column:role_id;comment:'角色id外键'" json:"role_id"`
	Role     Role   `gorm:"foreignkey:RoleId" json:"role"`
	DeptId   uint64 `gorm:"comment:'部门id外键'" json:"dept_id"`
	Dept     Dept   `gorm:"foreignkey:DeptId" json:"dept"`
	CreateBy string `gorm:"column:create_by;comment:'创建来源'" json:"create_by"`
}

type LoginUser struct {
	Email      string `json:"email"`
	Password   string `json:"password"`
	LdapEnable bool   `json:"ldap_enable"`
}

func (u User) TableName() string {
	return u.GModel.TableName("users")
}
