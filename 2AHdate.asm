data segment
    ; add your data here!    
data ends

stack segment stack
    
stack ends

code segment 'code'
      assume  cs: code , ds: data , ss: stack  
      org 100h
start:jmp begin
str1  db 2 dup(0),'/'  ;'The date isssss'    ;要显示的字符
str2  db 2 dup(0),'/'
str3  db 2 dup(0),'/'
mouth db 0
day   db 0
year  dw 0
due   db '$' 

;Convert number to ASCII
num2asc proc
      mov si,10  ;si作为除数，除数为10
next: xor dx,dx  ;dx清0
      div si     ;ax的内容被10除
      add dx,'0' ;把余数转换成ASCII值
      dec bx     ;指向下一个字符位置
      mov [bx],dl;把转换为ASCII值的字符存入字符串中
      or ax,ax   ;有无更多的数位转换
      jnz next   ;有，转换下一位
      ret        ;没有，返回
num2asc endp   

;main program
begin: mov ax,cs
       mov ds,ax
       mov ah,2ah            ;取日期功能号2aH
       int 21h
       mov byte ptr mouth,dh ;保存月份       
       mov byte ptr mouth,dl ;存日
       mov word ptr mouth,cx ;存年  
       
          mov bx,offset str1+2  ;得到字符串末尾地址
          xor ax,ax
          mov al,byte ptr mouth ;取出月份
          call num2asc          ;把月份二进制数转换成ASCII    
       
          mov bx,offset str2+2  ;得到字符串末尾地址  
          xor ax,ax
          mov al,byte ptr day   ;取出日期  
          call num2asc          ;把日期二进制数转换成ASCII        
       
          mov bx,offset str3+4  ;得到字符串末尾地址 
          mov ax,word ptr year  ;取出年份
          call num2asc          ;把年份二进制数转换成ASCII      
       
       mov dx,offset str1    ;指向要显示字符串的首址
       mov ah,09h           
       int 21h
       mov ah,4ch
       int 21h    
code ends

end start 