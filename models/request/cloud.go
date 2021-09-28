package request

type PageInfo struct {
	Page       int `json:"page" form:"page"`
	PageSize   int `json:"pageSize" form:"pageSize"`
	PageSelect int `json:"pageSelect" form:"pageSelect"`
}
