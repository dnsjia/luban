package utils

import (
	"bytes"
	"compress/zlib"
	"os"
	"strconv"
	"unsafe"
)

// Str2Uint 字符串转Unit
func Str2Uint(str string) uint {
	num, err := strconv.ParseUint(str, 10, 32)
	if err != nil {
		return 0
	}
	return uint(num)
}

// ZlibCompress 进行zlib压缩
func ZlibCompress(src []byte) []byte {
	var in bytes.Buffer
	w := zlib.NewWriter(&in)
	w.Write(src)
	w.Close()
	return in.Bytes()
}

func Bytes2Str(b []byte) string {
	return *(*string)(unsafe.Pointer(&b))
}

// FileExist 判断文件或文件夹是否存在
func FileExist(path string) bool {
	_, err := os.Stat(path)
	if err != nil && os.IsNotExist(err) {
		return false
	}
	return true
}

func Str2Bytes(s string) []byte {
	x := (*[2]uintptr)(unsafe.Pointer(&s))
	h := [3]uintptr{x[0], x[1], x[1]}
	return *(*[]byte)(unsafe.Pointer(&h))
}
