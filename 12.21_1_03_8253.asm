;***************************************************
;*        第三次试验—-可编程定时器/计数器          *
;***************************************************
io8253a  equ 283h      ;EQU语句给符合定义一个值，或者其他符号名，此处赋值地址,ls273 只是一个名字，可以改变      
io8253b  equ 280h
data segment
    str db "press esc to exit...,press other key to output in the screen$";提示按任何键导致退出
data ends   

stack segment stack
    dw 32 dup(0)
stack ends       

code segment 'code'
 assume  cs:code,ds:data,ss:stack
start: mov al,14h
       mov dx,io8253a
       out dx,al
       mov dx,io8253b
       mov al,0fh
       out dx,al      
L1:    in al,dx
       call disp
       push dx
       mov ah,06h
       int 21h
       pop dx
       jz L1
       mov ah,4ch
       int 21h 
disp proc near 
       push dx
       and al,ofh
       mov dl,al
       cmp dl,9
       jle num
       add dl,7
num:   add dl,30h
       mov ah,02h
       int 21h
       mov dl,0dh
       int 21h
       mov dl,0ah
       int 21h
       pop dx
       ret
disp endp
code ends
end start
