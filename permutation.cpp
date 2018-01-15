/*
  The source code file is released under GNU GPL V2,V3
  Author: Tongguang Zhang
  Date: 2018-01-12
*/

//----------------------------------------------------------------------//
//      cmbprmv.cpp  combinations and permutations example              //
//----------------------------------------------------------------------//
// http://www.cplusplus.com/
// http://cboard.cprogramming.com/
// http://cboard.cprogramming.com/cplusplus-programming/157834-all-possible-permutations-%27n%27-strings-c%3D-n-n-k-possibly-%27n%27-%27k%27.html
//g++ permutation.cpp -o permutation

#include <algorithm>
#include <iostream>
#include <string>
#include <vector>

using namespace std;

int g;				// number of permutation & combination of array of strings

int next_combination(vector < int >&, int, int);

// number of permutation & combination of array of strings
int number_of_combination(int lev, int num_of_keywords)
{
	int n = 1;
	for (int i = 0; i < lev; i++) {
		n = n * num_of_keywords--;
	}
	return n;
}

// really to use in get_service.cpp
// return value is array of strings
std::vector < std::string > str_permutation(int lev, int num_of_keywords, char **argv)
{
	std::vector < std::string > combinStrings;

	int i, k;

	int n = num_of_keywords;	// n things k at a time

	int level = lev;	// number to show strings
	if (level > n) {
		cout << "level <= num_of_keywords " << endl;
		exit(0);
	}

	vector < string > vs(n);	// create vector of strings
	for (i = 0; i < n; i++) {
		vs[i] = argv[i];
	}
	//for (i = 0; i < n; i++) {
	//      s[s.size() - 1] = '0' + i;
	//      vs[i] = s;
	//}

	vector < int >c(n);	// combination array

	//for (k = 1; k <= n; k++) {    // n things k at a time
	for (k = level; k <= level; k++) {	// n things k at a time
		for (i = 0; i < k; i++)	// create initial combination
			c[i] = i;
		do {		// do combination
			do {	// do permutation
				string combin_str="";

				for (i = 0; i < k; i++)
				{
					//cout << vs[c[i]] << " ";
					combin_str=combin_str+vs[c[i]];
				}
				//cout << combin_str << endl;
				combinStrings.push_back(combin_str);
				//g++;
			}
			while (next_permutation(c.begin(), c.begin() + k));
			//cout << endl;
		}
		while (next_combination(c, k, n));
		//cout << g << endl;
		//*len=g;
	}

	return combinStrings;
}

//----------------------------------------------------------------------//
//      main                                                            //
//----------------------------------------------------------------------//
//int main(int argc, char **argv)
int main_permutation(int argc, char **argv)
//int main(int argc, char **argv)
{

	std::vector < std::string > combinStrings;

/*
	std::vector < std::string > combinStrings;
	combinStrings.push_back(std::string("string1"));
	combinStrings.push_back(std::string("string2"));

	std::vector < std::string >::iterator iter = combinStrings.begin();
	std::vector < std::string >::iterator end = combinStrings.end();
	while (iter != end) {
		std::cout << (*iter) << std::endl;
		++iter;
	}
*/

	if (argc < 3) {
		cout << "usage: command num str1 str2 ... " << endl;
		return (0);
	}
	//string s = "string x";        // numbered string
	//int n = 4;            // n things k at a time
	int i, k;

	int num_of_keywords = argc - 2;
	int n = num_of_keywords;	// n things k at a time

	int level = atoi(argv[1]);	// number to show strings
	if (level > n) {
		cout << "usage: command num str1 str2 ... " << endl << "num < number of str-n" << endl;
		return (0);
	}

	vector < string > vs(n);	// create vector of strings
	for (i = 0; i < n; i++) {
		vs[i] = argv[i + 2];
	}
	//for (i = 0; i < n; i++) {
	//      s[s.size() - 1] = '0' + i;
	//      vs[i] = s;
	//}

	vector < int >c(n);	// combination array

	//for (k = 1; k <= n; k++) {    // n things k at a time
	for (k = level; k <= level; k++) {	// n things k at a time
		for (i = 0; i < k; i++)	// create initial combination
			c[i] = i;

		do {		// do combination
			do {	// do permutation
				string combin_str="";

				for (i = 0; i < k; i++)
				{
					//cout << vs[c[i]] << " ";
					combin_str=combin_str+vs[c[i]];
				}
				cout << combin_str << endl;
				combinStrings.push_back(combin_str);
				//g++;
			}
			while (next_permutation(c.begin(), c.begin() + k));
			cout << endl;
		}
		while (next_combination(c, k, n));
		//cout << g << " " << level << " " << num_of_keywords << endl;
		cout << number_of_combination(level, num_of_keywords) << endl;
	}

	std::vector < std::string >::iterator iter = combinStrings.begin();
	std::vector < std::string >::iterator end = combinStrings.end();
	while (iter != end) {
		std::cout << (*iter) << std::endl;
		++iter;
	}

	return (0);
}

//----------------------------------------------------------------------//
//      next_combination                                                //
//----------------------------------------------------------------------//
int next_combination(vector < int >&c, int k, int n)
{
	int i, j;

	i = k - 1;		// find next element to increment
	while (c[i] == (n - k + i)) {
		--i;
		if (i < 0) {	// if done, ...
			for (i = 0; i < k; i++)
				c[i] = i;
			return (0);	// ... return with initial combination
		}
	}

	c[i] += 1;		// increment element

	for (j = i + 1; j < k; j++)	// create increasing string
		c[j] = c[i] + j - i;

	return (1);		// return with new combination
}
