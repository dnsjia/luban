package cmdb

type TreeMenu struct {
	ID              int               `gorm:"not null;primary_key; AUTO_INCREMENT" json:"id"`
	Name            string            `gorm:"type:varchar(32); not null" json:"name"`
	ParentId        int64             `gorm:"default:0" json:"parent_id"`
	Hide            int               `gorm:"default:0" json:"hide"`
	SortId          int               `json:"sort_id"`
	VirtualMachines []*VirtualMachine `gorm:"many2many:hosts_group_virtual_machines" json:"-"`
}

func (t TreeMenu) TableName() string {
	return "hosts_group"
}

type TreeData struct {
	Key      string      `json:"key"`
	Value    string      `json:"value"`
	Title    string      `json:"title"`
	Name     string      `json:"name"`
	Children interface{} `json:"children"`
}
