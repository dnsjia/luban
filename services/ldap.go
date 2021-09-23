package services
//
//import (
//	"github.com/toolkits/pkg/logger"
//	"time"
//)
//
//func UserGet(where string, args ...interface{}) (*User, error) {
//	var obj User
//	has, err := common.GVA_DB.Where(where, args...).Get(&obj)
//	if err != nil {
//		logger.Errorf("mysql.error: query user(%s)%+v fail: %s", where, args, err)
//		return nil, internalServerError
//	}
//
//	if !has {
//		return nil, nil
//	}
//
//	return &obj, nil
//}
//
//func UserGetByUsername(username string) (*User, error) {
//	return UserGet("username=?", username)
//}
//
//func LdapLogin(username, pass string) (*User, error) {
//	sr, err := ldapReq(username, pass)
//	if err != nil {
//		return nil, err
//	}
//
//	user, err := UserGetByUsername(username)
//	if err != nil {
//		return nil, err
//	}
//
//	if user == nil {
//		// default user settings
//		user = &User{
//			UserName: username,
//			NickName: username,
//		}
//	}
//
//	// copy attributes from ldap
//	attrs := LDAP.Attributes
//	if attrs.Nickname != "" {
//		user.NickName = sr.Entries[0].GetAttributeValue(attrs.Nickname)
//	}
//	if attrs.Email != "" {
//		user.Email = sr.Entries[0].GetAttributeValue(attrs.Email)
//	}
//	if attrs.Phone != "" {
//		user.Phone = sr.Entries[0].GetAttributeValue(attrs.Phone)
//	}
//
//	if user.Id > 0 {
//		if LDAP.CoverAttributes {
//			_, err := DB.Where("id=?", user.Id).Update(user)
//			if err != nil {
//				logger.Errorf("mysql.error: update user %+v fail: %v", user, err)
//				return nil, internalServerError
//			}
//		}
//		return user, nil
//	}
//
//	now := time.Now().Unix()
//
//	user.Password = "******"
//	user.CreateAt = now
//	user.CreateBy = "ldap"
//
//	err = DBInsertOne(user)
//	return user, err
//}
//
