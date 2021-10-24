package tools

import (
	"fmt"
	"strconv"
)

func ParseFloat2F(value float64) float64 {
	newValue, err := strconv.ParseFloat(fmt.Sprintf("%.2f", value), 64)
	if err != nil {
		fmt.Println("转换float出错")
		return value
	}
	return newValue

}
