/*2:*/
#line 52 "./gb_save.w"

#include "gb_io.h" 
#include "gb_graph.h"

#define MAX_SV_STRING 4095
#define MAX_SV_ID 154 \

#define panic(c) {panic_code= c;goto sorry;} \

#define fillin(l,t) if(fill_field((util*) &(l) ,t) ) goto sorry \

#define buffer (&item_buf[MAX_SV_STRING+3])  \

#define bad_type_code 0x1
#define string_too_long 0x2
#define addr_not_in_data_area 0x4
#define addr_in_mixed_block 0x8
#define bad_string_char 0x10
#define ignored_data 0x20 \

#define unk 0
#define ark 1
#define vrt 2
#define mxt 3 \

#define lookup(l,t) classify((util*) &(l) ,t)  \

#define append_comma *buf_ptr++= ',' \

#define trans(l,t) translate_field((util*) &(l) ,t)  \


#line 56 "./gb_save.w"

/*21:*/
#line 449 "./gb_save.w"

typedef struct{
char*start_addr;
char*end_addr;
long offset;
long cat;
long expl;
}block_rep;

/*:21*/
#line 57 "./gb_save.w"

/*8:*/
#line 249 "./gb_save.w"

static long comma_expected;
static Vertex*verts;
static Vertex*last_vert;
static Arc*arcs;
static Arc*last_arc;

/*:8*//*13:*/
#line 301 "./gb_save.w"

static char item_buf[MAX_SV_STRING+3+81];

/*:13*//*19:*/
#line 406 "./gb_save.w"

static long anomalies;
static FILE*save_file;

/*:19*//*22:*/
#line 468 "./gb_save.w"

static block_rep*blocks;
static Area working_storage;

/*:22*//*34:*/
#line 669 "./gb_save.w"

static char*buf_ptr;
static long magic;

/*:34*/
#line 58 "./gb_save.w"

/*7:*/
#line 224 "./gb_save.w"

static long fill_field(l,t)
util*l;
char t;
{register char c;
if(t!='Z'&&comma_expected){
if(gb_char()!=',')return(panic_code= syntax_error-1);
if(gb_char()=='\n')gb_newline();
else gb_backup();
}
else comma_expected= 1;
c= gb_char();
switch(t){
case'I':/*9:*/
#line 256 "./gb_save.w"

if(c=='-')l->I= -gb_number(10);
else{
gb_backup();
l->I= gb_number(10);
}
break;

/*:9*/
#line 237 "./gb_save.w"
;
case'V':/*10:*/
#line 264 "./gb_save.w"

if(c=='V'){
l->V= verts+gb_number(10);
if(l->V>=last_vert||l->V<verts)
panic_code= syntax_error-2;
}else if(c=='0'||c=='1')l->I= c-'0';
else panic_code= syntax_error-3;
break;

/*:10*/
#line 238 "./gb_save.w"
;
case'S':/*12:*/
#line 284 "./gb_save.w"

if(c!='"')
panic_code= syntax_error-6;
else{register char*p;
p= gb_string(item_buf,'"');
while(*(p-2)=='\n'&&*(p-3)=='\\'&&p> item_buf+2&&p<=buffer){
gb_newline();p= gb_string(p-3,'"');
}
if(gb_char()!='"')
panic_code= syntax_error-7;
else if(item_buf[0]=='\0')l->S= null_string;
else l->S= gb_save_string(item_buf);
}
break;

/*:12*/
#line 239 "./gb_save.w"
;
case'A':/*11:*/
#line 273 "./gb_save.w"

if(c=='A'){
l->A= arcs+gb_number(10);
if(l->A>=last_arc||l->A<arcs)
panic_code= syntax_error-4;
}else if(c=='0')l->A= NULL;
else panic_code= syntax_error-5;
break;

/*:11*/
#line 240 "./gb_save.w"
;
default:gb_backup();break;
}
return panic_code;
}

/*:7*//*14:*/
#line 307 "./gb_save.w"

static long finish_record()
{
if(gb_char()!='\n')
return(panic_code= syntax_error-8);
gb_newline();
comma_expected= 0;
return 0;
}

/*:14*//*25:*/
#line 519 "./gb_save.w"

static void classify(l,t)
util*l;
char t;
{register block_rep*cur_block;
register char*loc;
register long tcat;
register long tsize;
switch(t){
default:return;
case'V':if(l->I==1)return;
tcat= vrt;
tsize= sizeof(Vertex);
break;
case'A':tcat= ark;
tsize= sizeof(Arc);
break;
}
if(l->I==0)return;
/*26:*/
#line 546 "./gb_save.w"

loc= (char*)l->V;
for(cur_block= blocks;cur_block->start_addr> loc;cur_block++);
if(loc<cur_block->end_addr){
if((loc-cur_block->start_addr)%tsize!=0||loc+tsize> cur_block->end_addr)
cur_block->cat= mxt;
if(cur_block->cat==unk)cur_block->cat= tcat;
else if(cur_block->cat!=tcat)cur_block->cat= mxt;
}

/*:26*/
#line 538 "./gb_save.w"
;
}

/*:25*//*35:*/
#line 673 "./gb_save.w"

static void flushout()
{
*buf_ptr++= '\n';
*buf_ptr= '\0';
magic= new_checksum(buffer,magic);
fputs(buffer,save_file);
buf_ptr= buffer;
}

/*:35*//*36:*/
#line 687 "./gb_save.w"

static void prepare_string(s)
char*s;
{register char*p,*q;
item_buf[0]= '"';
p= &item_buf[1];
if(s==0)goto sready;
for(q= s;*q&&p<=&item_buf[MAX_SV_STRING];q++,p++)
if(*q=='"'||*q=='\n'||*q=='\\'||imap_ord(*q)==unexpected_char){
anomalies|= bad_string_char;
*p= '?';
}else*p= *q;
if(*q)anomalies|= string_too_long;
sready:*p= '"';
*(p+1)= '\0';
}

/*:36*//*37:*/
#line 710 "./gb_save.w"

static void move_item()
{register long l= strlen(item_buf);
if(buf_ptr+l> &buffer[78]){
if(l<=78)flushout();
else{register char*p= item_buf;
if(buf_ptr> &buffer[77])flushout();

do{
for(;buf_ptr<&buffer[78];buf_ptr++,p++,l--)*buf_ptr= *p;
*buf_ptr++= '\\';
flushout();
}while(l> 78);
strcpy(buffer,p);
buf_ptr= &buffer[l];
return;
}
}
strcpy(buf_ptr,item_buf);
buf_ptr+= l;
}

/*:37*//*39:*/
#line 748 "./gb_save.w"

static void translate_field(l,t)
util*l;
char t;
{register block_rep*cur_block;
register char*loc;
register long tcat;
register long tsize;
if(comma_expected)append_comma;
else comma_expected= 1;
switch(t){
default:anomalies|= bad_type_code;

case'Z':buf_ptr--;
if(l->I)anomalies|= ignored_data;
return;
case'I':numeric:sprintf(item_buf,"%ld",l->I);goto ready;
case'S':prepare_string(l->S);goto ready;
case'V':if(l->I==1)goto numeric;
tcat= vrt;tsize= sizeof(Vertex);break;
case'A':tcat= ark;tsize= sizeof(Arc);break;
}
/*40:*/
#line 774 "./gb_save.w"

loc= (char*)l->V;
item_buf[0]= '0';item_buf[1]= '\0';
if(loc==NULL)goto ready;
for(cur_block= blocks;cur_block->start_addr> loc;cur_block++);
if(loc> cur_block->end_addr){
anomalies|= addr_not_in_data_area;
goto ready;
}
if(cur_block->cat!=tcat||(loc-cur_block->start_addr)%tsize!=0){
anomalies|= addr_in_mixed_block;
goto ready;
}
sprintf(item_buf,"%c%ld",t,
cur_block->offset+((loc-cur_block->start_addr)/tsize));

/*:40*/
#line 770 "./gb_save.w"
;
ready:move_item();
}

/*:39*/
#line 59 "./gb_save.w"

/*4:*/
#line 148 "./gb_save.w"

Graph*restore_graph(f)
char*f;
{Graph*g= NULL;
register char*p;
long m;
long n;
/*5:*/
#line 171 "./gb_save.w"

gb_raw_open(f);
if(io_errors)panic(early_data_fault);
while(1){
gb_string(str_buf,')');
if(sscanf(str_buf,"* GraphBase graph (util_types %14[ZIVSA],%ldV,%ldA",
str_buf+80,&n,&m)==3&&strlen(str_buf+80)==14)break;
if(str_buf[0]!='*')panic(syntax_error);
}

/*:5*/
#line 155 "./gb_save.w"
;
/*6:*/
#line 185 "./gb_save.w"

g= gb_new_graph(0L);
if(g==NULL)panic(no_room);
gb_free(g->data);
g->vertices= verts= gb_typed_alloc(n==0?1:n,Vertex,g->data);
last_vert= verts+n;
arcs= gb_typed_alloc(m==0?1:m,Arc,g->data);
last_arc= arcs+m;
if(gb_trouble_code)panic(no_room+1);

strcpy(g->util_types,str_buf+80);
gb_newline();
if(gb_char()!='"')panic(syntax_error+1);

p= gb_string(g->id,'"');
if(*(p-2)=='\n'&&*(p-3)=='\\'&&p> g->id+2){
gb_newline();gb_string(p-3,'"');
}
if(gb_char()!='"')panic(syntax_error+2);

/*15:*/
#line 317 "./gb_save.w"

panic_code= 0;
comma_expected= 1;
fillin(g->n,'I');
fillin(g->m,'I');
fillin(g->uu,g->util_types[8]);
fillin(g->vv,g->util_types[9]);
fillin(g->ww,g->util_types[10]);
fillin(g->xx,g->util_types[11]);
fillin(g->yy,g->util_types[12]);
fillin(g->zz,g->util_types[13]);
if(finish_record())goto sorry;

/*:15*/
#line 205 "./gb_save.w"
;

/*:6*/
#line 156 "./gb_save.w"
;
/*16:*/
#line 332 "./gb_save.w"

{register Vertex*v;
gb_string(str_buf,'\n');
if(strcmp(str_buf,"* Vertices")!=0)
panic(syntax_error+3);
gb_newline();
for(v= verts;v<last_vert;v++){
fillin(v->name,'S');
fillin(v->arcs,'A');
fillin(v->u,g->util_types[0]);
fillin(v->v,g->util_types[1]);
fillin(v->w,g->util_types[2]);
fillin(v->x,g->util_types[3]);
fillin(v->y,g->util_types[4]);
fillin(v->z,g->util_types[5]);
if(finish_record())goto sorry;
}
}

/*:16*/
#line 157 "./gb_save.w"
;
/*17:*/
#line 351 "./gb_save.w"

{register Arc*a;
gb_string(str_buf,'\n');
if(strcmp(str_buf,"* Arcs")!=0)
panic(syntax_error+4);
gb_newline();
for(a= arcs;a<last_arc;a++){
fillin(a->tip,'V');
fillin(a->next,'A');
fillin(a->len,'I');
fillin(a->a,g->util_types[6]);
fillin(a->b,g->util_types[7]);
if(finish_record())goto sorry;
}
}

/*:17*/
#line 158 "./gb_save.w"
;
/*18:*/
#line 367 "./gb_save.w"

{long s;
gb_string(str_buf,'\n');
if(sscanf(str_buf,"* Checksum %ld",&s)!=1)
panic(syntax_error+5);
if(gb_raw_close()!=s&&s>=0)
panic(late_data_fault);
}

/*:18*/
#line 159 "./gb_save.w"
;
return g;
sorry:gb_raw_close();gb_recycle(g);return NULL;
}

/*:4*//*20:*/
#line 410 "./gb_save.w"

long save_graph(g,f)
Graph*g;
char*f;
{/*24:*/
#line 497 "./gb_save.w"

register block_rep*cur_block;
long block_count;

/*:24*//*31:*/
#line 630 "./gb_save.w"

long m;
long n;
register long s;

/*:31*/
#line 414 "./gb_save.w"

if(g==NULL||g->vertices==NULL)return-1;
anomalies= 0;
/*27:*/
#line 559 "./gb_save.w"

{long activity;
/*23:*/
#line 480 "./gb_save.w"

{Area t;
for(*t= *(g->data),block_count= 0;*t;*t= (*t)->next)block_count++;
blocks= gb_typed_alloc(block_count+1,block_rep,working_storage);
if(blocks==NULL)return-3;
for(*t= *(g->data),block_count= 0;*t;*t= (*t)->next,block_count++){
cur_block= blocks+block_count;
while(cur_block> blocks&&(cur_block-1)->start_addr<(*t)->first){
cur_block->start_addr= (cur_block-1)->start_addr;
cur_block->end_addr= (cur_block-1)->end_addr;
cur_block--;
}
cur_block->start_addr= (*t)->first;
cur_block->end_addr= (char*)*t;
}
}

/*:23*/
#line 561 "./gb_save.w"
;
lookup(g->vertices,'V');
lookup(g->uu,g->util_types[8]);
lookup(g->vv,g->util_types[9]);
lookup(g->ww,g->util_types[10]);
lookup(g->xx,g->util_types[11]);
lookup(g->yy,g->util_types[12]);
lookup(g->zz,g->util_types[13]);
do{activity= 0;
for(cur_block= blocks;cur_block->end_addr;cur_block++){
if(cur_block->cat==vrt&&!cur_block->expl)
/*28:*/
#line 588 "./gb_save.w"

{register Vertex*v;
for(v= (Vertex*)cur_block->start_addr;
(char*)(v+1)<=cur_block->end_addr&&cur_block->cat==vrt;v++){
lookup(v->arcs,'A');
lookup(v->u,g->util_types[0]);
lookup(v->v,g->util_types[1]);
lookup(v->w,g->util_types[2]);
lookup(v->x,g->util_types[3]);
lookup(v->y,g->util_types[4]);
lookup(v->z,g->util_types[5]);
}
}

/*:28*/
#line 572 "./gb_save.w"

else if(cur_block->cat==ark&&!cur_block->expl)
/*29:*/
#line 602 "./gb_save.w"

{register Arc*a;
for(a= (Arc*)cur_block->start_addr;
(char*)(a+1)<=cur_block->end_addr&&cur_block->cat==ark;a++){
lookup(a->tip,'V');
lookup(a->next,'A');
lookup(a->a,g->util_types[6]);
lookup(a->b,g->util_types[7]);
}
}

/*:29*/
#line 574 "./gb_save.w"

else continue;
cur_block->expl= activity= 1;
}
}while(activity);
}

/*:27*/
#line 417 "./gb_save.w"
;
save_file= fopen(f,"w");
if(!save_file)return-2;
/*30:*/
#line 615 "./gb_save.w"

/*32:*/
#line 641 "./gb_save.w"

m= 0;/*33:*/
#line 658 "./gb_save.w"

n= 0;
for(cur_block= blocks+block_count-1;cur_block>=blocks;cur_block--)
if(cur_block->start_addr==(char*)g->vertices){
n= (cur_block->end_addr-cur_block->start_addr)/sizeof(Vertex);
break;
}

/*:33*/
#line 642 "./gb_save.w"
;
for(cur_block= blocks+block_count-1;cur_block>=blocks;cur_block--){
if(cur_block->cat==vrt){
s= (cur_block->end_addr-cur_block->start_addr)/sizeof(Vertex);
cur_block->end_addr= cur_block->start_addr+((s-1)*sizeof(Vertex));
if(cur_block->start_addr!=(char*)g->vertices){
cur_block->offset= n;n+= s;
}
}else if(cur_block->cat==ark){
s= (cur_block->end_addr-cur_block->start_addr)/sizeof(Arc);
cur_block->end_addr= cur_block->start_addr+((s-1)*sizeof(Arc));
cur_block->offset= m;
m+= s;
}
}

/*:32*/
#line 616 "./gb_save.w"
;
/*38:*/
#line 732 "./gb_save.w"

buf_ptr= buffer;
magic= 0;
fputs("* GraphBase graph (util_types ",save_file);
{register char*p;
for(p= g->util_types;p<g->util_types+14;p++)
if(*p=='Z'||*p=='I'||*p=='V'||*p=='S'||*p=='A')fputc(*p,save_file);
else fputc('Z',save_file);
}
fprintf(save_file,",%ldV,%ldA)\n",n,m);

/*:38*/
#line 617 "./gb_save.w"
;
/*41:*/
#line 790 "./gb_save.w"

prepare_string(g->id);
if(strlen(g->id)> MAX_SV_ID){
strcpy(item_buf+MAX_SV_ID+1,"\"");
anomalies|= string_too_long;
}
move_item();
comma_expected= 1;
trans(g->n,'I');
trans(g->m,'I');
trans(g->uu,g->util_types[8]);
trans(g->vv,g->util_types[9]);
trans(g->ww,g->util_types[10]);
trans(g->xx,g->util_types[11]);
trans(g->yy,g->util_types[12]);
trans(g->zz,g->util_types[13]);
flushout();

/*:41*/
#line 618 "./gb_save.w"
;
/*42:*/
#line 808 "./gb_save.w"

{register Vertex*v;
fputs("* Vertices\n",save_file);
for(cur_block= blocks+block_count-1;cur_block>=blocks;cur_block--)
if(cur_block->cat==vrt&&cur_block->offset==0)
/*43:*/
#line 819 "./gb_save.w"

for(v= (Vertex*)cur_block->start_addr;
v<=(Vertex*)cur_block->end_addr;v++){
comma_expected= 0;
trans(v->name,'S');
trans(v->arcs,'A');
trans(v->u,g->util_types[0]);
trans(v->v,g->util_types[1]);
trans(v->w,g->util_types[2]);
trans(v->x,g->util_types[3]);
trans(v->y,g->util_types[4]);
trans(v->z,g->util_types[5]);
flushout();
}

/*:43*/
#line 813 "./gb_save.w"
;
for(cur_block= blocks+block_count-1;cur_block>=blocks;cur_block--)
if(cur_block->cat==vrt&&cur_block->offset!=0)
/*43:*/
#line 819 "./gb_save.w"

for(v= (Vertex*)cur_block->start_addr;
v<=(Vertex*)cur_block->end_addr;v++){
comma_expected= 0;
trans(v->name,'S');
trans(v->arcs,'A');
trans(v->u,g->util_types[0]);
trans(v->v,g->util_types[1]);
trans(v->w,g->util_types[2]);
trans(v->x,g->util_types[3]);
trans(v->y,g->util_types[4]);
trans(v->z,g->util_types[5]);
flushout();
}

/*:43*/
#line 816 "./gb_save.w"
;
}

/*:42*/
#line 619 "./gb_save.w"
;
/*44:*/
#line 834 "./gb_save.w"

{register Arc*a;
fputs("* Arcs\n",save_file);
for(cur_block= blocks+block_count-1;cur_block>=blocks;cur_block--)
if(cur_block->cat==ark)
for(a= (Arc*)cur_block->start_addr;a<=(Arc*)cur_block->end_addr;a++){
comma_expected= 0;
trans(a->tip,'V');
trans(a->next,'A');
trans(a->len,'I');
trans(a->a,g->util_types[6]);
trans(a->b,g->util_types[7]);
flushout();
}
}

/*:44*/
#line 620 "./gb_save.w"
;
/*45:*/
#line 850 "./gb_save.w"

fprintf(save_file,"* Checksum %ld\n",magic);

/*:45*/
#line 621 "./gb_save.w"
;

/*:30*/
#line 420 "./gb_save.w"
;
/*46:*/
#line 853 "./gb_save.w"

if(anomalies){
fputs("> WARNING: I had trouble making this file from the given graph!\n",
save_file);
if(anomalies&bad_type_code)
fputs(">> The original util_types had to be corrected.\n",save_file);
if(anomalies&ignored_data)
fputs(">> Some data suppressed by Z format was actually nonzero.\n",
save_file);
if(anomalies&string_too_long)
fputs(">> At least one long string had to be truncated.\n",
save_file);
if(anomalies&bad_string_char)
fputs(">> At least one string character had to be changed to '?'.\n",
save_file);
if(anomalies&addr_not_in_data_area)
fputs(">> At least one pointer led out of the data area.\n",save_file);
if(anomalies&addr_in_mixed_block)
fputs(">> At least one data block had an illegal mixture of records.\n",
save_file);
if(anomalies&(addr_not_in_data_area+addr_in_mixed_block))
fputs(">>  (Pointers to improper data have been changed to 0.)\n",
save_file);
fputs("> You should be able to read this file with restore_graph,\n",
save_file);
fputs("> but the graph you get won't be exactly like the original.\n",
save_file);
}

/*:46*/
#line 421 "./gb_save.w"
;
fclose(save_file);
gb_free(working_storage);
return anomalies;
}

/*:20*/
#line 60 "./gb_save.w"


/*:2*/
