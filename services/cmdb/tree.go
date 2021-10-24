package cmdb

import (
	"pigs/common"
	"pigs/models/cmdb"
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
func GetMenu(pid int) []*TreeList {
	var menu []cmdb.TreeMenu
	common.GVA_DB.Where("parent_id = ?", pid).Order("sort_id").Find(&menu)
	var treeList []*TreeList
	for _, v := range menu {
		child := GetMenu(v.ID)
		node := &TreeList{
			ID:       v.ID,
			Name:     v.Name,
			SortId:   v.SortId,
			ParentId: v.ParentId,
		}
		node.Children = child
		treeList = append(treeList, node)
	}
	return treeList
}
