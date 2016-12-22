;***************************************************
;*         第二次试验—————简单并行接口OUT.asm      *
;***************************************************
ls273  equ 2a8h      ;EQU语句给符合定义一个值，或者其他符号名，此处赋值地址,ls273 只是一个名字，可以改变     
data segment
    
data ends   

stack segment stack
    dw 32 dup(0)
stack ends       

code segment 'code'
 assume  cs:code,ds:data,ss:stack
start: mov ah,2      ;调用号ah=02h，显示输出，DL=要显示的ASCII字符代码
       mov dl,0dh    ;显示回车符 0dh=00001101B ，查表 为CR，即为回车
       int 21h
       mov ah,1      ;调用号ah=01h,读键盘字符并回显，出口参数AL=读到的键盘字符
       int 21h
       cmp al,27     ;判断是否为ESC键，因为27=1Bh=00011011b,参见课本389页附录三
       je exit       ;若是，则直接退出
       mov dx,ls273  ;否则，把地址给DX
       out dx,al     ;然后把从键盘中读到的字符输出
       jmp L1        ;继续循环
exit:  mov ah,4ch
       int 21h
code ends
end start
