;***************************************************
;*         第二次试验—————简单并行接口OUT.asm      *
;***************************************************
ls273  equ 2a8h      ;EQU语句给符合定义一个值，或者其他符号名，此处赋值地址,ls273 只是一个名字，可以改变 
;---------------------------------
;功能：设置光标位置
;入口参数：row-行   column-列
;出口参数：无
;---------------------------------
set_cusor_location macro row,column
    push    ax
    push    bx
    push    cx
    push    dx
    mov dh,row
    mov dl,column
    mov bx,0
    mov ah,2   ;设置光标位置调用号
    int 10h   
    pop     dx
    pop     cx
    pop     bx
    pop     ax
endm   

data segment
    str db "press esc to exit...,press other key to output in the screen$";提示按任何键导致退出
data ends   

stack segment stack
    dw 32 dup(0)
stack ends       

code segment 'code' ;  'code' 类别，把类型名相同的code段放在连续的存储区内
    assume cs:code,ds:data,ss,stack
    
start: mov ax,data
       mov ds,ax
       mov es,ax
       mov dx,offset str  ;取偏移地址
       mov ah,9      ;课本137页，字符串显示，调用号为ah=09h  ds:dx,此寄存器对指向内存中的字符串的首址，
       int 21h       ;此功能调用显示字符直到遇到终止字符串的$字符
      
L1:    mov ah,2      ;调用号ah=02h，显示输出，DL=要显示的ASCII字符代码
       mov dl,0dh
       int 21h
       mov ah,1      ;调用号ah=01h,读键盘字符并回显，出口参数AL=读到的键盘字符
       int 21h
       cmp al,27     ;判断是否为ESC键，因为27=1Bh=00011011b,参见课本389页附录三
       je exit       ;若是，则直接退出
       mov dx,ls273  ;否则，把地址给DX           
       set_cusor_location 20,20
       out dx,al     ;然后把从键盘中读到的字符输出
       jmp L1        ;继续循环
exit:  mov ah,4ch
       int 21h
code ends
end start
