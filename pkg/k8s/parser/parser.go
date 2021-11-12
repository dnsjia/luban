package parser

import (
	"github.com/gin-gonic/gin"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
	"strconv"
	"strings"
)

func parsePaginationPathParameter(request *gin.Context) *dataselect.PaginationQuery {
	itemsPerPage, err := strconv.ParseInt(request.Query("itemsPerPage"), 10, 0)
	if err != nil {
		return dataselect.NoPagination
	}

	page, err := strconv.ParseInt(request.Query("page"), 10, 0)
	if err != nil {
		return dataselect.NoPagination
	}

	// Frontend pages start from 1 and backend starts from 0
	return dataselect.NewPaginationQuery(int(itemsPerPage), int(page-1))
}

func parseFilterPathParameter(request *gin.Context) *dataselect.FilterQuery {
	return dataselect.NewFilterQuery(strings.Split(request.Query("filterBy"), ","))
}

// Parses query parameters of the request and returns a SortQuery object
func parseSortPathParameter(request *gin.Context) *dataselect.SortQuery {
	return dataselect.NewSortQuery(strings.Split(request.Query("sortBy"), ","))
}

// ParseDataSelectPathParameter parses query parameters of the request and returns a DataSelectQuery object
func ParseDataSelectPathParameter(request *gin.Context) *dataselect.DataSelectQuery {
	paginationQuery := parsePaginationPathParameter(request)
	sortQuery := parseSortPathParameter(request)
	filterQuery := parseFilterPathParameter(request)
	return dataselect.NewDataSelectQuery(paginationQuery, sortQuery, filterQuery)
}

// ParseNamespacePathParameter parses namespace selector for list pages in path parameter.
// The namespace selector is a comma separated list of namespaces that are trimmed.
// No namespaces means "view all user namespaces", i.e., everything except kube-system.
func ParseNamespacePathParameter(request *gin.Context) *k8scommon.NamespaceQuery {
	namespace := request.Query("namespace")
	namespaces := strings.Split(namespace, ",")
	var nonEmptyNamespaces []string
	for _, n := range namespaces {
		n = strings.Trim(n, " ")
		if len(n) > 0 {
			nonEmptyNamespaces = append(nonEmptyNamespaces, n)
		}
	}
	return k8scommon.NewNamespaceQuery(nonEmptyNamespaces)
}
