4.1
data   segment 
       org 100H
buf   db 3 dup(00h) 
count  equ $-buf1
data   ends
code   segment
       assume cs:code,ds:data1
start: mov ax,data
       mov ds,ax
       mov si,offset buf
       mov cx,count
       xor al,al
next:  mov [si],al 
       inc al
       inc si
       loop next
       mov ah,4ch
       int 21h
code   ends
       end start

PPT例题
data segment
one db 20 dup(32),1,'Welcome you!'，7,13,10
count equ $-one
data ends
stack segment stack'stack'
top equ this word
stap db 256 dup(00h)
stack ends
code segment
assume cs:code,ds,data,ss,stack
start:mov ax,data
mov ds,ax
mov ax,stack
mov si,offset one
mov cx,count
next: mov dl,[si]
mov ah,2
int 21h
inc si
loop next
mov ah,4ch
int 21h
code ends
end start


4.2
data   segment 
       org 100H
buf   db 256 dup(00h) 
count  equ $-buf
data   ends
code   segment
       assume cs:code,ds:data
start: mov ax,data
       mov ds,ax
       mov si,offset buf
       mov cx,count
       xor al,al
next:  mov [si],al 
       inc al
       inc si
       loop next
next2: mov cx,count
       mov si,offset buf
       xor bx,bx;bl和bh分别存放正、负数的个数
       xor dh,dh;dh寄存器存放0元素的个数
next3: mov al,[si]
       cmp al,0 ;al的值与0比较，若相等，zf=1 
       jz zero  ;若zf=1,则，al=0,跳至zero,dh+1
       js negat
       jmp plus 
zero:  inc dh
       jmp next4
negat: inc bh
       jmp next4
plus:  inc bl
next4: inc si
       loop next3
       mov [si],dh
       inc si
       mov [si],bh ;存入正数的个数
       inc si 
       mov [si],bl;存入负数的个数
       mov ah,4ch
       int 21h
code   ends
       end start


4.5
data   segment 
buf    dw 18h,4Eh,8Fh
sum    dw 00h 
data   ends
code   segment
       assume cs:code,ds:data

       mov ah,4ch
       int 21h
code   ends
       end start

4.18
data   segment 
block  dw 2122h,4114h,4646h,7767h,3496h,7848h,7fffh,123Eh,3562H,54A2h
count  equ  ($-block)/2 ;count为双字节数的个数
pingjun dw 2 dup(00h) ;存放平均数和余数
data  ends
code  segment 
      assume cs:code,ds:data
start:mov ax,data
      mov ds,ax
      mov si,offset block
      mov di,offset pingjun 
      mov cx,count-1    ;相加次数为9次
      xor dx,dx         
      mov ax,[si]
next: inc si
      inc si
      add ax,[si]
      jnc next1
      inc dx
next1:loop next
      mov cx,count
      div cx
      mov [di],ax
      mov [di+2],dx
      mov ah,4ch
      int 21h
code  ends
end start

附加题
data   segment  
buf dw 7482h
data  ends
code   segment
       assume cs:code,ds:data 
start: mov ax,data
       mov ds,ax
       mov si,offset buf   
       mov ax,7482h
       mov dx,80h ;指定端口地址
       out dx,ax;把ax=7482h送入端口地址80h中
       in ax,dx;把端口



data segment

data   ends
code   segment
assume cs:code,ds:data1
start: mov dx,80h
in ax,dx
xor dl,dl
mov cx,10h
next1: shl ax,1
jc next2
inc dl
next2: loop next1
mov ah,4ch
int 21h
code ends
end start

    



