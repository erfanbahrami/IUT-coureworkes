#include <mega16.h>
#include <alcd.h>
#include <stdio.h>


void q4(void)
{
unsigned char str[17];
unsigned char show[7];
unsigned char y,i;
i=0;
while(y!=')')
{
y=getchar(); 
if(i<7) show[i]=y;
i++;
}
if(i<7) printf("\r length of frame not correct \r");
else if(i>7) printf("\r frame must be 5 integer \r");
else if(show[0]=='(' && (show[1] <= '9' && show[1] >= '0') &&( show[2] <= '9' && show[2] >= '0') &&( show[3] <= '9' && show[3] >= '0') &&( show[4] <= '9' && show[4] >= '0') &&( show[5] <= '9' && show[5] >= '0') && show[6]==')')
{
printf("\r frame is correct \r");
sprintf(str,"%c%c%c%c%c",show[1],show[2],show[3],show[4],show[5]);
lcd_clear();
lcd_puts(str);
} 
else printf("\r frame must be 5 integer \r");
y='';
}