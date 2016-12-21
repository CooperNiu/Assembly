;***************************************************
;*         第二次试验—————简单并口IN.asm           *
;***************************************************
ls244 equ 2a0h      ;EQU语句给符合定义一个值，或者其他符号名，此处赋值地址,ls273 只是一个名字，可以改变     
data segment
    str db "press esc to exit...,press other key to output in the screen$";提示按任何键导致退出
data ends   

stack segment stack
    dw 32 dup(0)
stack ends       

code segment 'code' ;  'code' 类别，把类型名相同的code段放在连续的存储区内
    assume cs:code,ds:data,ss,stack
    
start: mov dx,ls244   ;从2A0输入一个数据
       in al,dx       ;读入AL中
       mov dl,al      ;再将数据保存到DL中
       mov ah,02      ;ah=02h,显示输出，dl=要显示的ASCII字符
       int 21h
       mov dl,0dh     ;显示回车符 0dh=00001101B ，查表 为CR，即为回车
       int 21h         
       mov dl,0ah     ;显示换行符 0ah=00001010B , 查表 为LF，即为换行
       int 21h
       mov ah,06h     ;入口参数：ah=06h,dl=0ffh
       mov dl,0ffh    ;当dl=0ffh时，从键盘键入一字符，若为其他值时，表示在屏幕上显示字符
       int 21h        ;出口参数：当DL=0FFH,标志ZF=0时，AL=键入的字符
                      ;          当DL=0FFH,标志ZF=1时，AL=00，表示无有效字符输入
       jnz exit       ;ZF等于0，有键按下，退出
       je start       ;ZF=1, 没有键按下，表示无有效字符输入,转到start
exit:  mov ah,4ch
       int 21h
code ends
end start
