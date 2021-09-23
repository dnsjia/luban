package models

import "github.com/toolkits/pkg/logger"

func DBInsertOne(bean interface{}) error {
	_, err := DB.InsertOne(bean)
	if err != nil {
		logger.Errorf("mysql.error: insert fail: %v, to insert object: %+v", err, bean)
		return internalServerError
	}

	return nil
}
