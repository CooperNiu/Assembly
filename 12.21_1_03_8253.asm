;***************************************************
;*        第三次试验—-可编程定时器/计数器          *
;***************************************************
io8253a  equ 283h      ;EQU语句给符合定义一个值，或者其他符号名，此处赋值地址,ls273 只是一个名字，可以改变      
io8253b  equ 280h
data segment

data ends   

stack segment stack
    dw 32 dup(0)
stack ends       

code segment 'code'
 assume  cs:code,ds:data,ss:stack
start: mov al,14h     ;14h=00010100B.设置8253通道0为工作方式2，只读/写计数器低字节。二进计数
       mov dx,io8253a
       out dx,al
       mov dx,io8253b ;地址为280h
       mov al,0fh
       out dx,al      
L1:    in al,dx    ;读计数初值
       call disp   ;调用显示的子程序
       push dx
       mov ah,06h
       int 21h
       pop dx
       jz L1
       mov ah,4ch    ;退出
       int 21h 
disp proc near     ; 显示子程序定义
       push dx
       and al,0fh  ;首先取低四位
       mov dl,al
       cmp dl,9    ;判断是否<=9
       jle num     ;若是则为‘0-9’，ASCII码加30H
       add dl,7    ;否则为‘A-F’，ASCII码加37H
num:   add dl,30h
       mov ah,02h  ;显示，调用号AH=02H
       int 21h
       mov dl,0dh  ;回车符
       int 21h
       mov dl,0ah  ;换行符
       int 21h
       pop dx
       ret         ;子程序返回
disp endp
code ends
end start
