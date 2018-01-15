/*
  The source code file is released under GNU GPL V2,V3
  Author: Tongguang Zhang
  Date: 2018-01-12
*/

//mysql_operate.cpp
// g++ -I/usr/include/mysql -L/usr/lib64/mysql -lmysqlclient -o get_service get_service.cpp permutation.cpp

// indent -npro -kr -i8 -ts8 -sob -l280 -ss -ncs -cp1 *.c *.h

#include "mysql_operate.h"

CMysqlOperate::CMysqlOperate(const char *host, const char *user, const char *passwd, const char *dbname, const unsigned int dbport)
{
	_host = host;
	_user = user;
	_passwd = passwd;
	_dbname = dbname;
	_dbport = dbport;

	_bOpen = false;
	Open();
}

CMysqlOperate::~CMysqlOperate()
{
	Close();
}

bool CMysqlOperate::GetConState()
{
	return _bOpen;
}

bool CMysqlOperate::Open()
{
	if (!mysql_init(&mysql)) {
		printf("\nFailed to initate MySQL connection ");
		return false;
	}
	if (!mysql_real_connect(&mysql, _host, _user, _passwd, _dbname, _dbport, NULL, 0)) {
		printf("Failed to connect to MySQL: Error: %s\n", mysql_error(&mysql));
		return false;
	}
	printf("Logged on to database sucessfully\n");
	_bOpen = true;
	return _bOpen;
}

void CMysqlOperate::Close()
{
	if (_bOpen) {
		mysql_close(&mysql);
		_bOpen = false;
	}
}

bool CMysqlOperate::ExecuteSql(const char *chSql)
{
	if (!GetConState())
		return false;
	if (mysql_real_query(&mysql, chSql, strlen(chSql)) == 0)
		return true;
}

MYSQL_RES *CMysqlOperate::OpenRecordset(const char *chSql)
{
	MYSQL_RES *rs = NULL;
	if (ExecuteSql(chSql)) {
		rs = mysql_store_result(&mysql);
	}
	return rs;
}

void CMysqlOperate::FreeResult(MYSQL_RES * result)
{
	if (result)
		mysql_free_result(result);
}
