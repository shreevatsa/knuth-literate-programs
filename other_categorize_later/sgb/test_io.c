/*2:*/
#line 29 "./gb_io.w"

#include "gb_io.h"

#define exit_test(m) \
 {fprintf(stderr,"%s!\n(Error code = %ld)\n",m,io_errors);return -1;}

int main()
{
/*28:*/
#line 420 "./gb_io.w"

if(gb_open("test.dat")!=0)
exit_test("Can't open test.dat");

/*:28*/
#line 37 "./gb_io.w"
;
/*27:*/
#line 376 "./gb_io.w"

if(gb_number(10)!=123456789)
io_errors|= 1L<<20;
if(gb_digit(16)!=10)
io_errors|= 1L<<21;
gb_backup();gb_backup();
if(gb_number(16)!=0x9ABCDEF)
io_errors|= 1L<<22;
gb_newline();
if(gb_char()!='\n')
io_errors|= 1L<<23;
if(gb_char()!='\n')
io_errors|= 1L<<24;
if(gb_number(60)!=0)
io_errors|= 1L<<25;
{char temp[100];
if(gb_string(temp,'\n')!=temp+1)
io_errors|= 1L<<26;
gb_newline();
if(gb_string(temp,':')!=temp+5||strcmp(temp,"Oops"))
io_errors|= 1L<<27;
}
if(io_errors)
exit_test("Sorry, it failed. Look at the error code for clues");
if(gb_digit(10)!=-1)exit_test("Digit error not detected");
if(gb_char()!=':')
io_errors|= 1L<<28;
if(gb_eof())
io_errors|= 1L<<29;
gb_newline();
if(!gb_eof())
io_errors|= 1L<<30;

/*:27*/
#line 38 "./gb_io.w"
;
/*38:*/
#line 531 "./gb_io.w"

if(gb_close()!=0)
exit_test("Bad checksum, or difficulty closing the file");

/*:38*/
#line 39 "./gb_io.w"
;
printf("OK, the gb_io routines seem to work!\n");
return 0;
}

/*:2*/
