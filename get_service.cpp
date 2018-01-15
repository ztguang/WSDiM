//g++ -I/usr/include/mysql -L/usr/lib64/mysql -lmysqlclient -std=c++11 -O2 -o get_service get_service.cpp mysql_operate.cpp permutation.cpp

// indent -npro -kr -i8 -ts8 -sob -l280 -ss -ncs -cp1 *.c *.h

/*
致命错误：mysql/mysql.h：No such file or directory
						# dnf install mariadb-devel
*/

/*
CREATE DATABASE test;

CREATE TABLE `test` (
	`id` int(11) NOT NULL auto_increment,
	PRIMARY KEY (`id`)
);

ALTER TABLE `test` ADD COLUMN `name` varchar(20);
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <mysql/mysql.h>

#include <iostream>
#include <cstdlib>
#include <vector>

#include "mysql_operate.h"
#include "permutation.h"

#define MAX_BUF_SIZE 1024	// 缓冲区最大字节数

using namespace std;

//# systemctl start mariadb.service

const char *host = "localhost";
const char *user = "root";
const char *pwd = "123456";
const char *dbn = "bpms";
const unsigned int dbp = 3306;

int SoInputs = 0, SoOutputs = 0;

char *get_keywords(char *SFD);	// get keywords from service function description
int get_num_of_keywords(char *keywords);	// get number of keywords
char *generate_clusterID(char *keywords);	// generate clusterID from keywords
int get_semantic_similarity(char *para1, char *para2);	// compute similarity for SoInputs, SoOutputs
void compute_similarity(const char *QInputs, const char *QOutputs, const char *keywords);

void compute_similarity(const char *QInputs, const char *QOutputs, const char *SFD)
{
	double weight1 = 1.0e+01, weight2 = 1.0e+02, weight3 = 1.0e+03, weight4 = 1.0e+04, weight5 = 1.0e+05;
	double weight6 = 1.0e+06, weight7 = 1.0e+07, weight8 = 1.0e+08, weight9 = 1.0e+09, weight10 = 1.0e+10;
	double weighti = 10, weighto = 10;

	char keywords[240] = "aa-bb-cc";	//get_keywords(SFD);	// keywords separated by '-', such as aa-bb-cc
	int num_of_keywords=8;	//get_num_of_keywords(keywords);
	//C++new delete 动态申请二维数组
	char ** argv;
	argv = new char*[num_of_keywords];		// 关键字 首字母 大小写  没关系， 在 MySQL中，SQL的模式缺省是忽略大小写的。
	for( int i = 0; i < num_of_keywords; i++ )
		argv[i] = new char[10];
/*
	strcpy(argv[0],"UAV");	strcpy(argv[1],"speed");							//22	//*/
/*
	strcpy(argv[0],"UAV");	strcpy(argv[1],"speed");	strcpy(argv[2],"get");				//33	//*/
/*
	strcpy(argv[0],"UAV");	strcpy(argv[1],"speed");	strcpy(argv[2],"get");	strcpy(argv[3],"the");	//44	//*/
/*
	strcpy(argv[0],"get");	strcpy(argv[1],"UAV");	strcpy(argv[2],"speed");
	strcpy(argv[3],"the");	strcpy(argv[4],"of");	strcpy(argv[5],"to");					//66	//*/

/*
	strcpy(argv[0],"get");	strcpy(argv[1],"UAV");	strcpy(argv[2],"speed");
	strcpy(argv[3],"the");	strcpy(argv[4],"of");	strcpy(argv[5],"to");
	strcpy(argv[6],"it");	strcpy(argv[7],"a");								//88	//*/

	char clusterID[36] = "B3A8099C349A45AE9AF9E272838E7712";		//generate_clusterID(keywords);
	char sql[MAX_BUF_SIZE];

	//构造对象
	CMysqlOperate *db = new CMysqlOperate(host, user, pwd, dbn, dbp);

	//查询数据
	MYSQL_RES *res = NULL;
	MYSQL_ROW row;
 
	//初始化为0
	sprintf(sql, "update wslt set similarity=0, SoInputs=0, SoOutputs=0, ToMW1=0, ToMW2=0, ToMW3=0, ToMW4=0, ToMW5=0, ToMW6=0, ToMW7=0, ToMW8=0, ToMW9=0, ToMW10=0 where clusterID='%s'", clusterID);
	db->ExecuteSql(sql);

	sprintf(sql, "select * from wslt where clusterID='%s'", clusterID);
	//cout << sql << "\n" << endl;
	res = db->OpenRecordset(sql);

	if (res) {
		cout << "OpenRecordset\n" << endl;
		while (row = mysql_fetch_row(res)) {
			int row_id= atoi(row[0]);

			//cout << row[0] << endl;
			//exit(0);

			SoInputs = 1;	//get_semantic_similarity (QInputs, SInputs);
			SoOutputs = 1;	//get_semantic_similarity (QOutputs, SOutputs);

			sprintf(sql, "update wslt set SoInputs=SoInputs,SoOutputs=SoOutputs where id=%d", row_id);
			db->ExecuteSql(sql);

			for (int lev = 1; lev <= num_of_keywords; lev++) {		//number of keywords
				std::vector < std::string > combinStrings = str_permutation(lev, num_of_keywords, argv);
				std::vector < std::string >::iterator iter = combinStrings.begin();
				std::vector < std::string >::iterator end = combinStrings.end();
				while (iter != end) {
					//std::cout << (*iter) << std::endl;
					sprintf(sql, "update wslt set ToMW%d=ToMW%d+1 where id=%d and keywords like \'%%%s%%\'",lev, lev, row_id, (*iter).c_str());
					db->ExecuteSql(sql);
					++iter;
					//cout << sql << "\n" << endl;
					//exit(0);
				}
			}
		}
	}

	//C++ new delete 动态申请二维数组	释放
	for( int i = 0; i < num_of_keywords; i++ )
		delete[]argv[i];
	delete[]argv;

	//computing service similarity
	sprintf(sql, "select id from wslt where clusterID='%s'", clusterID);
	res = db->OpenRecordset(sql);

	if (res) {
		while (row = mysql_fetch_row(res)) {
			int row_id= atoi(row[0]);
			sprintf(sql, "update wslt set similarity=SoInputs*%lf + SoOutputs*%lf + ToMW1*%lf + ToMW2*%lf + ToMW3*%lf + ToMW4*%lf + ToMW5*%lf + ToMW6*%lf + ToMW7*%lf + ToMW8*%lf + ToMW9*%lf + ToMW10*%lf where id=%d", weighti, weighto, weight1, weight2, weight3, weight4, weight5, weight6, weight7, weight8, weight9, weight10, row_id);
			db->ExecuteSql(sql);
			//cout << sql << "\n" << endl;
			//exit(0);
		}
	}

	//解析对象
	db->FreeResult(res);
	delete db;
	db = NULL;

}


int main(int argc, char **argv)
{

	compute_similarity("aa", "bb", "cc");	// now, hard code in compute_similarity()

	//main_permutation(argc, argv);		// usage: command num str1 str2 ...

	//puts("!!!Hello World!!!");

/*
	//构造对象
	CMysqlOperate *db = new CMysqlOperate(host, user, pwd, "test", dbp);
	//创建一个张
	db->ExecuteSql("create table tt(id int, name varchar(20))");
	//插入一个数据
	db->ExecuteSql("insert into tt(id,name) values('31', 'abc')");
	//查询数据
	MYSQL_RES *res = NULL;
	MYSQL_ROW row;
	res = db->OpenRecordset("select * from tt");
	if (res) {
		cout << "OpenRecordset\n" << endl;
		while (row = mysql_fetch_row(res)) {
			for (int t = 0; t < mysql_num_fields(res); t++) {
				printf("%s\t", row[t]);
			}
			printf("\n");
		}
	}
	//解析对象
	db->FreeResult(res);
	delete db;
	db = NULL;
*/
	return EXIT_SUCCESS;
}
