%{
	#include<string>
	#include<iostream>
	#include<fstream>
	#include<stack>
	#include<assert.h>
	#include<regex>
	#include<unistd.h>
	#include<vector>
	#include<chrono>

	using namespace std;

	class step1_noinc_commentScanner : public step1_noinc_commentFlexLexer {
	public :
		int linenumber ;
		int charnumber ;
		string filename ;
		step1_noinc_commentScanner(const string & fn , ifstream * pis) :
			filename{fn},
			linenumber(1),
			charnumber(0),
			step1_noinc_commentFlexLexer(pis)
		{ }
		int yylex();
		void print_pos () { cerr<< filename << " : " << linenumber << " : " << charnumber << endl << flush; }
		void incLineNumber () { linenumber++; charnumber=0 ; }
		void incCharNumber (int n) { charnumber+=n ; }
	};

	void prt_fatal(string str)  { cerr<<"FATAL : "<<str<<endl<<flush; return; }
	void prt_info (string str)  { cerr<<"INFO  : "<<str<<endl<<flush; return; }

	vector<string> includePath;
	void usage() {
		cerr<<"step1_noinc_comment [input filenamea] -I [head file dir] -I ..."<<endl;
		return;
	}
	
	bool testFileExistenceInDir(string dirname_filename) {
		ifstream foo( dirname_filename );
		return foo.is_open();
	}
	
	string findFile(string filename) {
		for(auto & path : includePath) {
			string dirname_filename=path+filename;
			if(testFileExistenceInDir(dirname_filename)) 
				return dirname_filename;
		}
		return "";
	}
%}

%option noyywrap
%option yylineno


string \"[^\n"]+\"
alpha [A-Za-z]
digit [0-9]a

%x comment include

%%
\r 

\n	{
	/*counting lines*/
	this->incLineNumber();
	ECHO;
}

"//"[^\n]* /*discard one line comment*/

"/*" {
	yy_push_state(comment);
}

"`include"[ \t]* {
	yy_push_state(include);
}

<include>{
	\r 

	\n	{
		/*counting lines*/
		this->incLineNumber();
		ECHO;
	}
	
	"//"[^\n]* /*discard one line comment*/
	
	"/*" {
		yy_push_state(comment);
	}

	[ \t]+ 

	"\""[ \t]*[a-zA-Z0-9\._\/]+[ \t]*"\"" {
		string s {yytext};
		s.erase(0,1);
		s.erase(s.length()-1,1);
		while(s[0]==' ') {s.erase(0,1);}
		while(s[s.length()-1]==' ') {s.erase(s.length()-1,1);}
		
		string fullpathname = findFile( s );
		if( "" == fullpathname ) {
			prt_fatal ( "can not find file " + s ) ;
		} else  {
			prt_info ( "including "+fullpathname ) ;
			cout<<"\n`line 1 "<<fullpathname<<" 1 \n";
			ifstream foo( fullpathname );
			step1_noinc_commentScanner * lexer= new step1_noinc_commentScanner(fullpathname,&foo);
			while(lexer->yylex()!=0);
		}

		cout<<"\n`line "<< (linenumber + 1) << " " <<filename<<" 2 \n";

		yy_pop_state();
	}

	.
}

<comment>{
	"*/" {
		yy_pop_state();
	}
	
	"/*" {
		yy_push_state(comment);
	}

	\r 

	\n	{
	/*counting lines*/
		this->incLineNumber();
		ECHO;
	}
	
	[^\*\/\n]+	{
		this->incCharNumber(yyleng);
	}

	. {
		this->incCharNumber(yyleng);
	}

}

%%



extern char *optarg;
extern int optind, optopt, opterr;
int main ( int argc, char * argv[] ) {
	std::chrono::time_point<std::chrono::system_clock> start, end;
	start = std::chrono::system_clock::now();
	std::time_t st_time = std::chrono::system_clock::to_time_t(start);
	std::cerr << "step1 start computation at " << std::ctime(&st_time);

	//adding current dir to includePath
	includePath.push_back("");
	//handling options
	int c;
	while ((c = getopt (argc, argv, "I:")) != -1) {
		switch (c)
		{
		case 'I': {
			string pathname{optarg};
			if(pathname[pathname.length()-1]!='/') pathname.push_back('/');
			includePath.push_back(pathname);
			}
			break;
		case '?' : {
			if (optopt == 'I')
				cerr << "Option -" <<optopt << " requires an argument.\n";
			else if (isprint (optopt))
				cerr << "Unknown option `-" << optopt << "'.\n";
			else
				cerr << "Unknown option character `\\xi" << optopt << "'.\n";
			usage();
			}
			return 1;
		default:
			usage();
			return 1;
		}
	}

	if(optind<argc-1)  {
		prt_fatal ( "only allow 1 filename");
		usage();
		return 1;
	}

	//testing existence of file
	if( false == testFileExistenceInDir(argv[argc-1])) {
	   prt_fatal ( "input file doesn't exist " ) ;
		 return 1;
	}

	ifstream foo( argv[argc-1] );
	//creating files handler and scanner
	step1_noinc_commentScanner * lexer= new step1_noinc_commentScanner(argv[argc-1],&foo);
	while(lexer->yylex()!=0) {
		prt_fatal ("improper return");
		//cout<<"// return here\n"<<flush;
	}

	end = std::chrono::system_clock::now();
	std::chrono::duration<double> elapsed_seconds = end-start;
	std::time_t end_time = std::chrono::system_clock::to_time_t(end);
	std::cerr << "step1 finished computation at " << std::ctime(&end_time)
	<< "elapsed time: " << elapsed_seconds.count() << "s\n";

	return 0;
}

