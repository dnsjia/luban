package common

import (
	"go.uber.org/zap"
	"os"
)

func PathExists(path string) (bool, error) {
	/*
		文件目录是否存在
	*/
	_, err := os.Stat(path)
	if err == nil {
		return true, nil
	}
	if os.IsNotExist(err) {
		return false, nil
	}
	return false, err
}

func CreateDir(dirs ...string) (err error) {
	/*
		批量创建文件夹
		https://github.com/piexlmax
	*/
	for _, v := range dirs {
		exist, err := PathExists(v)
		if err != nil {
			return err
		}
		if !exist {
			LOG.Debug("create directory" + v)
			err = os.MkdirAll(v, os.ModePerm)
			if err != nil {
				LOG.Error("create directory"+v, zap.Any(" error:", err))
			}
		}
	}
	return err
}
