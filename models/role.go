package models

type Role struct {
	GModel
	Name  string `gorm:"column:name;comment:'角色名称';size:128" json:"name"`
	Desc  string `gorm:"column:desc;comment:'角色描述';size:128" json:"desc"`
	Menus []Menu `gorm:"many2many:relation_role_menu" json:"menus"`
	Users []User `gorm:"foreignkey:RoleId"`
}

func (m Role) TableName() string {
	return m.GModel.TableName("role")
}
