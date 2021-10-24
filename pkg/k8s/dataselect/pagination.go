package dataselect

// By default backend pagination will not be applied.
var NoPagination = NewPaginationQuery(-1, -1)

// No items will be returned
var EmptyPagination = NewPaginationQuery(0, 0)

// Returns 10 items from page 1
var DefaultPagination = NewPaginationQuery(10, 0)

// NewPaginationQuery return pagination query structure based on given parameters
func NewPaginationQuery(itemsPerPage, page int) *PaginationQuery {
	return &PaginationQuery{itemsPerPage, page}
}

// GetPaginationSettings based on number of items and pagination query parameters returns start
// and end index that can be used to return paginated list of items.
func (p *PaginationQuery) GetPaginationSettings(itemsCount int) (startIndex int, endIndex int) {
	startIndex = p.ItemsPerPage * p.Page
	endIndex = startIndex + p.ItemsPerPage

	if endIndex > itemsCount {
		endIndex = itemsCount
	}

	return startIndex, endIndex
}
