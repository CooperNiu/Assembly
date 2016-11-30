;***********************************
;宏定义                            *
;print-把时间转换成字符用于输出    *
;printchar-打印字符串              *
;set_cusor_location-设置光标       *
;hour-定位表上的小时               *
;drawmin-画显示分钟的数码管        *
;***********************************

;---------------------------------
;功能：把ax中的数转换成十进制数按
;      字节存放在di指向的数据段中
;入口参数：num-占用内存位数
;出口参数：无 
;---------------------------------
print   macro    num         
        local trans
        push    ax
        push    bx
        push    cx
        push    dx    ;通用寄存器数据保护   
        mov cx,num
        mov bl,0ah
trans:  
        div bl   
        add ah,30h
        mov [si],ah 
        mov ah,0
        dec si
        loop trans
        pop     dx
        pop     cx
        pop     bx
        pop     ax    
endm
;---------------------------------
;功能：把dl中的字符打印出来
;入口参数：无
;出口参数：无
;---------------------------------
printchar macro
     push    ax
     mov ah,09h
     int 21h 
     pop     ax
endm 
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
;---------------------------------
;功能：在表上标出现在的小时
;入口参数：former-小时数减1  
;          later-当前小时
;出口参数：无
;---------------------------------
hour macro former,later
    push    ax
    push    bx
    push    cx
    push    dx
    mov ah,6
    mov al,1
    mov bh,01110100b
    mov cx,[former]
    mov dx,[former]
    int 10h           ;上一时刻恢复
    mov ah,6
    mov al,1
    mov bh,11001111b
    mov cx,[later]
    mov dx,[later]
    int 10h           ;这一时刻标出
    pop     dx
    pop     cx
    pop     bx
    pop     ax
endm 
;---------------------------------
;功能：显示分钟（数码管形式）
;入口参数：row-行  
;          col-列 
;          cou-要显示的时间
;出口参数：无
;---------------------------------
drawmin macro row,col,cou 
     local  cir,cir1
     push    ax
     push    bx
     push    cx
     push    dx
     mov bh,row
     mov bl,col 
     xor ax,ax
     mov dx,offset num  
     mov al,15   
     mov cl,cou
     mul cl 
     add dl,al
     mov di,dx
     mov cx,5
cir: set_cusor_location bh,bl
     push cx  
     mov cx,3
cir1:mov dl,[di]
     inc di 
     mov ah,2
     int 21h
     loop cir1
     pop cx
     inc bh
     loop cir 
     pop     dx
     pop     cx
     pop     bx
     pop     ax
endm  

;***********************************
;段定义
;data-数据段
;stack-堆栈段
;code-代码段  
;***********************************

data segment   
    count100  db 100  
    flag      db 0 
    flagh     db 0
    flagm     db 0
    flags     db 0 
    countsec  db 0 
    countmint db 0
    countmin  db 0
    counthour db 0 
    num db 45,45,45,3 dup(124,0,124),45,45,45
        db 5 dup(0,124,0)
        db 45,45,45,0,0,124,45,45,45,124,0,0,45,45,45
        db 2 dup(45,45,45,0,0,124),45,45,45
        db 2 dup(124,0,124),45,45,45,2 dup(0,0,124)
        db 45,45,45,124,0,0,45,45,45,0,0,124,45,45,45
        db 45,45,45,124,0,0,45,45,45,124,0,124,45,45,45
        db 45,45,45,4 dup(0,0,124)
        db 45,45,45,124,0,124,45,45,45,124,0,124,45,45,45
        db 45,45,45,124,0,124,45,45,45,0,0,124,45,45,45,'$'
    points  dw 414h,617h,919h,0c17h,0e14h,0f10h,0e0ch,0c09h,906h,608h,40bh,0310h
    year    db 4 dup('0') 
    a1      db '/'               
    month   db 2 dup('0')   
    a2      db '/'               
    day     db 2 dup('0')  
    a3      db 2 dup(0)           ;  年月日  
    h2      db '0'
    h1      db '0'
    a4      db ':'               
    m2      db '0'                
    m1      db '0'          
    a5      db ':'
    s2      db '0'
    s1      db '0' 
    a6      db 2 dup(0) 
    m02     db '0'
    m01     db '0'
    a7      db ':'              
    s02     db '0'               
    s01     db '0'          
    a8      db ':'
    ms02    db '0'
    ms01    db '0' 
    readme  db 'press s:start,r:reset,p:pause,q:quit',0dh,0ah,'$' 
    clock   db '               12                ',0dh,0ah
            db '          11        1            ',0dh,0ah 
            db '                                 ',0dh,0ah
            db '       10              2         ',0dh,0ah 
            db '                                 ',0dh,0ah
            db '                                 ',0dh,0ah    
            db '      9       hour       3       ',0dh,0ah  
            db '                                 ',0dh,0ah
            db '                                 ',0dh,0ah 
            db '         8             4         ',0dh,0ah  
            db '                                 ',0dh,0ah
            db '            7       5            ',0dh,0ah  
            db '                6                ',0dh,0ah ,'$' 
     copyright db 'copyright heqing','$'
     time      db 'time is: ','$'
     counter   db 'counter','$'   
     wminute   db 'minute','$'
     wsecond   db 'second','$' 
     yanyu     db 'every minute counts!','$'
data ends 

stack  segment  stack 'stack'
       db 256 dup(0)
stack  ends   

code segment
 assume  cs:code,ds:data,ss:stack
start:
;----------------------------------------
;初始化
;----------------------------------------
        mov ax,data
        mov ds,ax
        mov al,3h                   ;al=3h，屏幕 80*25彩色	
        mov ah,0 
        int 10h                     ;置显示模式                             
        call far ptr clearscreen    ;调用清全屏子过程
        cli                         ;清中断标志
        cld                         ;清方向标志,df=0,增量
        mov       ax,0000h          ;设置中断向量
        mov       ds,ax
        mov       si,0020h          
        lodsw
        mov       bx,ax
        lodsw
        push      ax
        push      bx                
        mov       ax,data           
        mov       ds,ax
        mov       ax,0000h          
        mov       es,ax             
        mov       di,0020h         
        mov       ax,offset timer   
        stosw
        mov       ax,seg timer      
        stosw
        ;初始化8253               
        mov       al,00110110b      ;0计数器，工作方式3，先写最底有效字节，再写最高有效字节
        out       43h,al
        mov       ax,10923          ;设初值
        out       40h,al
        mov       al,ah
        out       40h,al
        in        al,21h
        push      ax
        mov       al,0fch           ;中断屏蔽，只对键盘和电子时钟基准开中断
        out       21h,al
        sti                         ;中断初始化             
        set_cusor_location 0dh,36                ;初始打印
        mov dx,offset readme 
        printchar
        set_cusor_location 21,22
        mov dx,offset wminute 
        printchar
        set_cusor_location 23,0bh
        mov dx,offset wsecond 
        printchar 
        set_cusor_location 10h,44
        mov dx,offset yanyu 
        printchar
        set_cusor_location 22,60
        mov dx,offset copyright
        printchar                   
        call far ptr initialization  ;时间初始化   
;-------------------------------------------
;主循环
;-------------------------------------------        
forever:
        call far ptr show            ;显示秒表 
        cmp       flagh,1
        jz        drawpoint
        cmp       flagm,1
        jz        jdrawmin 
        cmp       flags,1
        jz        drawsec            ;分别判断时，分，秒标志位
        mov       ah,0bh             ;检测是否有键按下,检查输入设备，课本139页
        int       21h
        cmp       al,00h               
        jz        forever            ;al=00h,代表无键按下,转入forever 
        mov       ah,08h             ;有键输入,读取键值但不回显.出口参数为al=键盘输入的字符
        int       21h
        cmp       al,'s'             ;s被按下
        jz        flag1 
        cmp       al,'r'             ;r被按下
        jz        reset 
        cmp       al,'q'             ;q被按下
        jz        exit  
        cmp       al,'p'             ;p被按下
        jz        pause 
        jmp forever   
     
  jdrawmin:                          ;分钟数码管显示
        call far ptr drawminute
        jmp forever                   
  drawsec:                           ;秒，箭头显示
        call far ptr drawsecond
        jmp forever 
  flag1:                             ;开始计时
        mov flag,1
        jmp forever    
  reset:  
        mov       m02,'0'            ;计时归零
        mov       m01,'0'
        mov       s02,'0'
        mov       s01,'0'
        mov       ms02,'0'
        mov       ms01,'0' 
        mov       flag,0
        jmp       forever  
  pause:                             ;计时暂停
        mov flag,0
        jmp forever 
                                     ;在表上显示小时
  drawpoint:
        call far ptr drawhour
        jmp forever 
   
  exit:                              ;退出
        mov ah,4ch
        int 21h  
;***********************************
;过程定义
;initialization-初始化时间
;show-显示时间
;clearscreen-清屏 
;dispchar-打印字符
;drawhour-时
;drawminute-分钟 
;drawsecond-秒
;timer-中断
;*********************************** 
       
;-------------------------------------
initialization proc far  
      push      ax
      push      bx
      push      cx 
      push      dx
      mov ah,2ah       ;取日期 cx:dx
      int 21h  
      mov  ax, cx  
      mov si,offset year
      add si,3
      print 4 
      mov ah,0
      mov al,dh
      mov si,offset month
      inc si
      print 2
      mov al,dl
      mov si,offset day
      inc si
      print 2  
      mov ah,2ch        ;取时间 cx:dx
      int 21h 
      mov ah,0 
      mov  al, ch 
      cmp ch,12
      push cx
      jna movh
      sub ch,12 
movh: mov counthour,ch 
      pop cx  
      mov si,offset h1
      print 2 
      mov ah,0
      mov al,cl   
      mov si,offset m1
      print 2
      mov al,dh  
      mov si,offset s1
      print 2 

      mov al,counthour   ;初始化counthour
      mov ah,0           ;初始标出时
      dec al
      jz zero
      shl al,1
      mov dx,offset points
      add dx,ax 
      mov cx,dx
      sub cx,2
      mov si,cx
      mov di,dx 
      jmp phour
 zero:mov dx,offset points  
      mov di,dx
      add dx,22
      mov si,dx
phour:hour si,di
      set_cusor_location 3,0 
      mov dx,offset clock
      printchar 
        
      mov al,m2           ;初始化countmint
      mov countmint,al    ;初始画出分钟
      sub countmint,30h
      mov al,m1
      mov countmin,al  
      sub countmin,30h
      drawmin 17,12,countmint
      drawmin 17,16,countmin   
        
      mov al,s1           ;初始化countsec
      sub al,30h
      mov countsec,al  
      pop       dx
      pop       cx
      pop       bx
      pop       ax
      ret
initialization endp      

;-------------------------------------------------
show    proc far
        push      ax
        push      bx
        push      cx 
        push      dx
        set_cusor_location 8,36
        mov dx,offset time 
        printchar
        mov dx,0830h
        mov ah,2
        mov bx,0
        mov cx,0
        int 10h   
        mov bx,offset year     ;读year首地址
        mov cx,22              ;循环
disp1:  mov al,[bx]            ;取bx对应的值
        call far ptr dispchar   ;显示[bx]
        inc bx                 ;指向下一存储单元 
        loop disp1 
        
        set_cusor_location 0ah,36
        mov dx,offset counter 
        printchar
        mov dx,0a30h
        mov ah,2 
        mov cx,0
        mov bx,0
        int 10h
        mov bx,offset m02      ;读m02首地址
        mov cx,8               ;循环
disp2:  mov al,[bx]            ;取bx对应的值
        call far ptr dispchar   ;显示[bx]
        inc bx                 ;指向下一存储单元 
        loop disp2          
        pop       dx
        pop       cx
        pop       bx
        pop       ax
        ret
show    endp

;------------------------
clearscreen proc far
       push      ax
       push      bx
       push      cx 
       push      dx   
       mov al,0    ;整个窗口为空白
       mov bh,01110100b  ;bit0~2 :字体颜色 (0:黑，1:蓝，2:绿，3:青，4:红，5:紫，6:棕，7:白)
			 ;bit3 :字体亮度 (0:字体正常，1:字体高亮度)
			 ;bit4~6 :背景颜色 (0:黑，1:蓝，2:绿，3:青，4:红，5:紫，6:棕，7:白)
			 ;bit7 :字体闪烁 (0:不闪烁，1:字体闪烁)  
			 ;白底红字
       mov ch,0    ;窗口左上角的行位置
       mov cl,0    ;窗口左上角的列位置
       mov dh,24   ;窗口右下角的行位置
       mov dl,79   ;窗口右下角的列位置
       mov ah,6    ;当前页上滚
       int 10h     ;显示器驱动程序
       pop       dx
       pop       cx
       pop       bx
       pop       ax
       ret
clearscreen endp  

;------------------------------
dispchar proc far  ;要显示的字符输入给al ，然后在当前光标位置写属性或字符
       push      bx
       push      cx 
       mov cx,1    ;字符重复次数
       mov bx,000fh;bh=显示页,bl=属性,al=字符   
       mov ah,9    ;在光标位置显示字符及其属性
       int 10h  
       mov ah,0eh  ;显示字符(光标前移),bl = 前景色
       int 10h
       pop       cx
       pop       bx
       ret
dispchar endp      
;-------------------------------------------------
drawhour proc far
        mov flagh,0 
        push ax
        push bx 
        push cx 
        push dx 
        mov ah,2ch                      ;取时间 cx:dx
        int 21h 
        mov ah,0 
        mov  al, ch 
        cmp ch,12
        push cx
        jna movh1
        sub ch,12 
 movh1: mov counthour,ch 
        pop cx  
        mov al,counthour
        mov ah,0
        dec al
        jz zero1
        shl al,1
        mov dx,offset points
        add dx,ax 
        mov cx,dx
        sub cx,2
        mov si,cx
        mov di,dx 
        jmp phour1
  zero1:mov dx,offset points  
        mov di,dx
        add dx,22
        mov si,dx
 phour1:hour si,di
        set_cusor_location 3,0 
        mov dx,offset clock
        printchar
        pop dx
        pop cx
        pop bx
        pop ax
        ret
drawhour endp  
;-------------------------------------------------
drawminute proc far 
        push      ax
        push      bx
        push      cx 
        push      dx
        mov flagm,0 
        mov al,m2
        mov countmint,al 
        sub countmint,30h
        mov al,m1
        mov countmin,al  
        sub countmin,30h
        drawmin 17,12,countmint
        drawmin 17,16,countmin 
        pop       dx
        pop       cx
        pop       bx
        pop       ax
    ret
drawminute endp
;-------------------------------------------------
drawsecond proc far
        push      ax
        push      bx
        push      cx 
        push      dx
        mov flags,0 
        set_cusor_location 22,0ah
        mov ah,6
        mov al,1
        mov cx,1600h
        mov dx,1620h
        mov bh,01110100b
        int 10h
        mov al,s1
        sub al,30h 
        mov ah,0 
        inc al
        mov cx,ax
  csec: mov dl,26
        mov ah,2
        int 21h
        loop csec 
        pop       dx
        pop       cx
        pop       bx
        pop       ax
        ret
drawsecond endp
;------------------------------
          
timer  proc  far
         push      ax          
         cmp       flag,0
         je        date  
jishi:   inc       ms01
         cmp       ms01,'9'         
         jle       date
         mov       ms01,'0'             ;大于'9'，ms1位清零
         inc       ms02
         cmp       ms02,'9'
         jl        date
         mov       ms02,'0'             ;大于'9'，ms2位清零 
         inc       s01
         cmp       s01,'9'
         jle       date
         mov       s01,'0'              ;大于'9'，s1位清零
         inc       s02
         cmp       s02,'6'
         jl        date
         mov       s02,'0'              ;大于'5'，s2位清零
         inc       m01
         cmp       m01,'9'
         jle       date
         mov       m01,'0'              ;大于'9'，m1位清零
         inc       m02
         cmp       m02,'6'
         jl        date
         mov       m02,'0'              ;大于'5'，m2位清零
         
date:    dec       count100
         jnz       timext
         mov       count100,100  
         mov       flags,1
         inc       s1
         cmp       s1,'9'         
         jle       timext
         mov       s1,'0'             ;大于'9'，ms1位清零
         inc       s2
         cmp       s2,'6'
         jl        timext
         mov       s2,'0'             ;大于'9'，ms2位清零 
         inc       m1 
         mov       flagm,1
         cmp       m1,'9'
         jle       timext
         mov       m1,'0'              ;大于'9'，s1位清零
         inc       m2
         cmp       m2,'6'
         jl        timext
         mov       m2,'0'              ;大于'5'，s2位清零
         inc       h1 
         mov       flagh,1
         cmp       h1,'9'
         jle       timext
         mov       h1,'0'              ;大于'9'，m1位清零
         inc       h2
         cmp       h2,'6'
         jl        timext
         mov       h2,'0'              ;大于'5'，m2位清零 
         
timext:  
         mov       al,20h
         out       20h,al
         pop       ax
         iret
timer  endp

code   ends
       end start
