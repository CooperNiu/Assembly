data  segment
    table db 0,1,4,9,16,25,36,49,64,81
    buf   db 'please input one number(0-9):',0dh,0ah,'$'
data ends
stack segment para stack 'stack'
    stap db 100 dup(00h)
    top equ length stap
stack ends
code  segment 
    assume cs:code,ds,data,ss,stack
start: mov ax,data
       mov ds,ax
       mov ax,stack      
       mov ss,ax
       mov sp,top
       mov bx,offset table
next:  mov dx,offset buf  
       mov ah,9
       int 21h
       mov ah,1
       int 21h
       mov ah,0
       and al,0fh 
       add bx,ax
       mov al,[bx]
       mov ah,4ch
       int 21h
code ends
end start
    
  