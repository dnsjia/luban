package cmdb

import (
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/models/cmdb"
)

type TreeList struct {
	ID       int         `json:"id"`
	Name     string      `json:"name"`
	ParentId int64       `json:"parent_id"`
	Hide     int         `json:"hide"`
	SortId   int         `json:"sort_id"`
	Children []*TreeList `json:"children"`
}

type DataRes struct {
	Data []*TreeList `json:"treeData"`
}

// GetMenu 生成目录树
func GetMenu(pid int, echo int) []*TreeList {

	var (
		menu     []cmdb.TreeMenu
		treeList []*TreeList
	)

	if err := common.DB.Where("parent_id = ?", pid).Order("sort_id").Find(&menu).Error; err != nil {
		return nil
	}

	for _, v := range menu {
		child := GetMenu(v.ID, 0)
		node := &TreeList{
			ID:       v.ID,
			Name:     v.Name,
			SortId:   v.SortId,
			ParentId: v.ParentId,
		}
		// ToServer()
		node.Children = child
		treeList = append(treeList, node)
	}
	return treeList
}
