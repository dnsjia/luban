package tools

import (
	"fmt"
	"strconv"
)

func ParseFloat2F(value float64) float64 {
	newValue, err := strconv.ParseFloat(fmt.Sprintf("%.2f", value), 64)
	if err != nil {
		fmt.Println("保留2位小数, 转换float出错")
		return value
	}
	return newValue

}

func ParseStringToInt64(value string) int64 {

	newValue, err := strconv.ParseInt(value, 10, 64)
	if err != nil {
		fmt.Println("string转换int64出错")
		return 0
	}
	return newValue
}
