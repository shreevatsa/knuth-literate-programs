/*6:*/
#line 85 "./gb_io.w"

/*7:*/
#line 93 "./gb_io.w"

#include <stdio.h> 
#ifdef SYSV
#include <string.h> 
#else
#include <strings.h> 
#endif

/*:7*/
#line 86 "./gb_io.w"

extern long io_errors;


/*:6*//*13:*/
#line 204 "./gb_io.w"

#define unexpected_char  127
extern char imap_chr();
extern long imap_ord();

/*:13*//*16:*/
#line 224 "./gb_io.w"

extern void gb_newline();
extern long new_checksum();

/*:16*//*19:*/
#line 258 "./gb_io.w"

extern long gb_eof();

/*:19*//*21:*/
#line 275 "./gb_io.w"

extern char gb_char();
extern void gb_backup();

/*:21*//*23:*/
#line 306 "./gb_io.w"

extern long gb_digit();
extern unsigned long gb_number();

/*:23*//*25:*/
#line 351 "./gb_io.w"

#define STR_BUF_LENGTH 160
extern char str_buf[];
extern char*gb_string();


/*:25*//*29:*/
#line 426 "./gb_io.w"

#define gb_raw_open gb_r_open
extern void gb_raw_open();
extern long gb_open();

/*:29*//*41:*/
#line 567 "./gb_io.w"

#define gb_raw_close gb_r_close
extern long gb_close();
extern long gb_raw_close();

/*:41*/
