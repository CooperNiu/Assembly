data   segment para public 'data'
       count100 db 100
       tenhour  db 0
       hour     db 0,':'
       tenmin   db 0
       minute   db 0,':'
       tensec   db 0
       second   db 0
data  ends

stack segment para stack 'stack'
       db 256 dup(0)
stack ends

code segment para public 'code'
;main program
assume cs:code
start:  mov ax,data
        mov es,ax   ;建立附加段的段基址
assume es:data
        mov si,82h
        mov di,offset tenhour
        mov cx,8
        cld        ;df清0，递增进行
        rep movsb
；建立正常的数据段段基址
        mov ds,ax
        assume ds:data
        mov ah,0
        int 16h     ;读键盘
；建立属于我们的中断时间服务程序路线
        cli     ;if=0,不响应外部可屏蔽中断
        mov ax,0
        mov es,ax
        mov di,20h
        mov ax,offset timer
        stosw       ;该指令将al或ax寄存器的内容存入到由di寻址的存储器单元内,课本92页
        mov ax,cs
        stosw
;一个100次中断每秒的程序
         mov al,36h
         out 43h,al
         mov bx,11932
         mov al,bl
         out 40h,al
         mov al,bh
         out 40h,al
;现在中断控制器8259允许中断
         mov al,0fch
         out 21h,al
         sti   ;if=1,响应外部可屏蔽中断
；展示时间在屏幕上
forever: mov bx,offset tenhour
         mov cx,8
dispclk: mov al,[bx]
         call dispchar
         inc bx
         loop dispclk
         mov al,0dh
         call dispchar
         mov al,second

next:   cmp al,second
        je next
        jmp forever
time proc far
        push ax
        dec count100
        jnz timerx
        mov count100,100


        inc second
        cmp second,'9'
        jle timerx
        mov second,'0'
        inc tensec
        cmp tensec,'6'
        jl timerx
        mov tensec,'0'
        inc minute
        cmp minute,'9'
        jle timerx
        mov minute,'0'
        inc tenmin
        cmp tenmin,'6'
        jl tmerx
        mov tenmin,'0'
        inc hour
        cmp hour,'9'
        ja adjhour
        cmp hour,'3'
        jnz timerx
        cmp tenhour,'1'
        jnz timerx
        mov hour,'1'
        mov tenhour,'0'
        jmp short timerx
adjhour:inc tenhour
        mov hou,'0'

timerx: mov al,20h
        out,20h,al
        pop ax
        iret
timer   endp

dispchar proc near
        push bx
        mox bx,0
        mov ah,14
        int 10
        pop bx
        ret
dispchar endp
 code ends
 end start
