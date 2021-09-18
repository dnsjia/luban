package model

type Dept struct {
	GModel
	Name     string `gorm:"comment:'部门名称';size:64" json:"name"`
	Sort     int    `gorm:"default:0;type:int(3);comment:'排序'" json:"sort"`
	ParentId uint   `gorm:"default:0;comment:'父级部门(编号为0时表示根)'" json:"parent_id"`
	Children []Dept `gorm:"-" json:"children"` // 下属部门集合
	Users    []User `gorm:"foreignkey:DeptId"` // 一个部门有多个user
}

func (m Dept) TableName() string {
	return m.GModel.TableName("dept")
}
