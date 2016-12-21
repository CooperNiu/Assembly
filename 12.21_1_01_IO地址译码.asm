;***************************************************
;*              第一次试验——————I/O地址            *
;***************************************************
outport1 equ 2a0h       ;EQU语句给符合定义一个值，或者其他符号名，此处赋值地址
outport2 equ 2a8h       
data segment
    str db "press any key to exit...$";提示按任何键导致退出
data ends   

stack segment stack
    dw 32 dup(0)
stack ends       

code segment 'code' ;  'code' 类别，把类型名相同的code段放在连续的存储区内
    assume cs:code,ds:date,ss,stack
    
start: mov ax,data
       mov ds,ax
       mov es,ax
       mov dx,offset str  ;取偏移地址
       mov ah,9  ;课本137页，字符串显示，调用号为ah=09h  ds:dx,此寄存器对指向内存中的字符串的首址，
       int 21h   ;此功能调用显示字符直到遇到终止字符串的$字符
forever:
       mov dx,outport1
       out dx,al
       call delay  ;调用延时子程序
       mov dx,outport2
       out dx,al
       call delay  ;调用延时子程序 
       mov ah,1    ;判断有无按键输入，调用号为ah=01h
       int 16h     ;出口参数：ZF=0代表有按键键入，ZF=1代表没有按键键入 
       jz forever  ;若没有按键输入，继续循环
       mov ah,4ch  ;若有按键输入，结束循环
       int 21h  
       
delay proc near    ;定义delay子过程
       mov bx,200
qwe1:  mov cx,0
qwe2:  loop qwe2  ;LOOP指令相当于以下两条指令： DEC CX,JNZ disp 此处CX从 0000h 减一后变成 FFFFh，然后继续循环
       dec bx
       jne qwe1   ;bx不等于0，继续循环
       ret
delay endp
code ends
end start
