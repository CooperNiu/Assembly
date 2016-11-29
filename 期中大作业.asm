;***********************************
;宏定义                            *
;PRINT-把时间转换成字符用于输出    *
;PRINTCHAR-打印字符串              *
;GBIAO-设置光标                    *
;HOUR-定位表上的小时               *
;DRAWMIN-画显示分钟的数码管        *
;***********************************

;---------------------------------
;功能：把ax中的数转换成十进制数按
;      字节存放在DI指向的数据段中
;入口参数：NUM-占用内存位数
;出口参数：无 
;---------------------------------
PRINT   MACRO    NUM         
        LOCAL trans
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX    ;通用寄存器数据保护   
        MOV CX,NUM
        MOV BL,0Ah
trans:  
        DIV BL   
        ADD AH,30h
        MOV [SI],AH 
        MOV AH,0
        DEC SI
        LOOP trans
        POP     DX
        POP     CX
        POP     BX
        POP     AX    
ENDM
;---------------------------------
;功能：把dl中的字符打印出来
;入口参数：无
;出口参数：无
;---------------------------------
PRINTCHAR MACRO
     PUSH    AX
     MOV AH,09H
     INT 21H 
     POP     AX
ENDM 
;---------------------------------
;功能：设置光标位置
;入口参数：HANG-行   LIE-列
;出口参数：无
;---------------------------------
GBIAO MACRO HANG,LIE
    PUSH    AX
    PUSH    BX
    PUSH    CX
    PUSH    DX
    MOV DH,HANG
    MOV DL,LIE
    MOV BX,0
    MOV AH,2   ;设置光标位置调用号
    INT 10H   
    POP     DX
    POP     CX
    POP     BX
    POP     AX
ENDM  
;---------------------------------
;功能：在表上标出现在的小时
;入口参数：FORMER-小时数减1  
;          LATER-当前小时
;出口参数：无
;---------------------------------
HOUR MACRO FORMER,LATER
    PUSH    AX
    PUSH    BX
    PUSH    CX
    PUSH    DX
    MOV AH,6
    MOV AL,1
    MOV BH,01110100b
    MOV CX,[FORMER]
    MOV DX,[FORMER]
    INT 10H           ;上一时刻恢复
    MOV AH,6
    MOV AL,1
    MOV BH,11001111b
    MOV CX,[LATER]
    MOV DX,[LATER]
    INT 10H           ;这一时刻标出
    POP     DX
    POP     CX
    POP     BX
    POP     AX
ENDM 
;---------------------------------
;功能：显示分钟（数码管形式）
;入口参数：ROW-行  
;          COL-列 
;          COU-要显示的时间
;出口参数：无
;---------------------------------
DRAWMIN MACRO ROW,COL,COU 
     LOCAL  CIR,cir1
     PUSH    AX
     PUSH    BX
     PUSH    CX
     PUSH    DX
     MOV BH,ROW
     MOV BL,COL 
     XOR AX,AX
     MOV DX,OFFSET num  
     MOV AL,15   
     MOV CL,COU
     MUL CL 
     ADD DL,AL
     MOV DI,DX
     MOV CX,5
CIR: GBIAO BH,BL
     PUSH CX  
     MOV CX,3
cir1:MOV DL,[DI]
     INC DI 
     MOV AH,2
     INT 21h
     LOOP cir1
     POP CX
     INC BH
     LOOP CIR 
     POP     DX
     POP     CX
     POP     BX
     POP     AX
ENDM  

;***********************************
;段定义
;data-数据段
;STACK-堆栈段
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
    a1      db '-'               
    month   db 2 dup('0')   
    a2      db '-'               
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
     yanyu     db 'Every minute counts!','$'
data ends 

STACK  SEGMENT  stack 'stack'
       DW 128 DUP(0)
STACK  ENDS   

code segment
 assume  cs:code,ds:data,ss:stack
start:
;----------------------------------------
;初始化
;----------------------------------------
        mov ax,data
        mov ds,ax
        mov al,3h                   ;al=3h 80*25彩色	
        mov ah,0 
        int 10h                     ;置显示模式                             
        call far ptr clearall       ;调用清全屏子过程
        cli                         ;清中断标志
        cld                         ;清方向标志,df=0,增量
        mov       ax,0000H          ;设置中断向量
        mov       ds,ax
        mov       SI,0020H          
        lodsw
        mov       bx,ax
        lodsw
        push      ax
        push      bx                
        mov       ax,data           
        mov       ds,ax
        mov       ax,0000H          
        mov       es,ax             
        mov       di,0020H         
        mov       ax,offset TIMER   
        stosw
        mov       ax,seg TIMER      
        stosw
        ;初始化8253               
        MOV       AL,00110110B      ;0计数器，工作方式3，先写最底有效字节，再写最高有效字节
        OUT       43H,AL
        MOV       AX,10923          ;设初值
        OUT       40H,AL
        MOV       AL,AH
        OUT       40H,AL
        IN        AL,21H
        PUSH      AX
        MOV       AL,0FCH           ;中断屏蔽，只对键盘和电子时钟基准开中断
        OUT       21H,AL
        STI                         ;中断初始化             
        GBIAO 0dh,36                ;初始打印
        mov dx,offset readme 
        PRINTCHAR
        GBIAO 21,22
        mov dx,offset wminute 
        PRINTCHAR
        GBIAO 23,0bh
        mov dx,offset wsecond 
        PRINTCHAR 
        GBIAO 10h,44
        mov dx,offset yanyu 
        PRINTCHAR
        GBIAO 22,60
        mov dx,offset copyright
        PRINTCHAR                   
        call far ptr initialization  ;时间初始化   
;-------------------------------------------
;主循环
;-------------------------------------------        
FOREVER:
        call far ptr show            ;显示秒表 
        CMP       flagh,1
        JE        DRAWPOINT
        CMP       flagm,1
        JE        JDRAWMIN 
        CMP       flags,1
        JE        DRAWSEC            ;分别判断时，分，秒标志位
        MOV       AH,0BH             ;检测是否有键按下
        INT       21H
        CMP       AL,00H              
        JZ        FOREVER            ;无键按下,转FOREVER 
        MOV       AH,08H             ;有键,读键值AL
        INT       21H
        CMP       AL,'s'             ;S被按下
        JE        FLAG1 
        CMP       AL,'r'             ;R被按下
        JE        RESET 
        CMP       AL,'q'             ;Q被按下
        JE        EXIT  
        CMP       AL,'p'             ;P被按下
        JE        PAUSE 
        JMP FOREVER   
     
  JDRAWMIN:                          ;分钟数码管显示
        call far ptr drawminute
        JMP FOREVER                   
  DRAWSEC:                           ;秒，箭头显示
        call far ptr drawsecond
        JMP FOREVER 
  FLAG1:                             ;开始计时
        MOV flag,1
        JMP FOREVER    
  RESET:  
        MOV       m02,'0'            ;计时归零
        MOV       m01,'0'
        MOV       s02,'0'
        MOV       s01,'0'
        MOV       ms02,'0'
        MOV       ms01,'0' 
        MOV       flag,0
        JMP       FOREVER  
  PAUSE:                             ;计时暂停
        MOV flag,0
        JMP FOREVER 
                                     ;在表上显示小时
  DRAWPOINT:
        call far ptr drawhour
        JMP FOREVER 
   
  EXIT:                              ;退出
        MOV AH,4CH
        INT 21H  
;***********************************
;过程定义
;initialization-初始化时间
;show-显示时间
;clearall-清屏 
;dispchar-打印字符
;drawhour-时
;drawminute-分钟 
;drawsecond-秒
;TIMER-中断
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
      PRINT 4 
      mov ah,0
      mov al,dh
      mov si,offset month
      inc si
      PRINT 2
      mov al,dl
      mov si,offset day
      inc si
      PRINT 2  
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
      PRINT 2 
      mov ah,0
      mov al,cl   
      mov si,offset m1
      PRINT 2
      mov al,dh  
      mov si,offset s1
      PRINT 2 

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
phour:HOUR si,di
      GBIAO 3,0 
      mov dx,offset clock
      PRINTCHAR 
        
      mov al,m2           ;初始化countmint
      mov countmint,al    ;初始画出分钟
      sub countmint,30h
      mov al,m1
      mov countmin,al  
      sub countmin,30h
      DRAWMIN 17,12,countmint
      DRAWMIN 17,16,countmin   
        
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
        GBIAO 8,36
        mov dx,offset time 
        PRINTCHAR
        mov dx,0830h
        mov ah,2
        mov bx,0
        mov cx,0
        int 10h   
        mov bx,offset year     ;读year首地址
        mov cx,22              ;循环
DISP1:  mov al,[bx]            ;取bx对应的值
        call far ptr dispchar   ;显示[bx]
        inc bx                 ;指向下一存储单元 
        loop DISP1 
        
        GBIAO 0ah,36
        mov dx,offset counter 
        PRINTCHAR
        mov dx,0a30h
        mov ah,2 
        mov cx,0
        mov bx,0
        int 10h
        mov bx,offset m02      ;读m02首地址
        mov cx,8               ;循环
DISP2:  mov al,[BX]            ;取bx对应的值
        call far ptr dispchar   ;显示[bx]
        inc bx                 ;指向下一存储单元 
        loop DISP2          
        pop       dx
        pop       cx
        pop       bx
        pop       ax
        ret
show    endp

;------------------------
clearall proc far
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
clearall endp  

;------------------------------
dispchar proc far
       push      bx
       push      cx 
       mov cx,1    ;字符重复次数
       mov bx,000fh;bh=显示页,bl=属性,al=字符   
       mov ah,9    ;在光标位置显示字符及其属性
       int 10h  
       mov ah,0eh  ;显示字符(光标前移),al = 字符,bl = 前景色
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
 phour1:HOUR si,di
        GBIAO 3,0 
        mov dx,offset clock
        PRINTCHAR
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
        DRAWMIN 17,12,countmint
        DRAWMIN 17,16,countmin 
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
        GBIAO 22,0ah
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
          
TIMER  PROC  FAR
         PUSH      AX          
         CMP       flag,0
         JE        DATE  
JISHI:   INC       ms01
         CMP       ms01,'9'         
         JLE       DATE
         MOV       ms01,'0'             ;大于'9'，ms1位清零
         INC       ms02
         CMP       ms02,'9'
         JL        DATE
         MOV       ms02,'0'             ;大于'9'，ms2位清零 
         INC       s01
         CMP       s01,'9'
         JLE       DATE
         MOV       s01,'0'              ;大于'9'，s1位清零
         INC       s02
         CMP       s02,'6'
         JL        DATE
         MOV       s02,'0'              ;大于'5'，s2位清零
         INC       m01
         CMP       m01,'9'
         JLE       DATE
         MOV       m01,'0'              ;大于'9'，m1位清零
         INC       m02
         CMP       m02,'6'
         JL        DATE
         MOV       m02,'0'              ;大于'5'，m2位清零
         
DATE:    DEC       count100
         JNZ       TIMEXT
         MOV       count100,100  
         MOV       flags,1
         INC       s1
         CMP       s1,'9'         
         JLE       TIMEXT
         MOV       s1,'0'             ;大于'9'，ms1位清零
         INC       s2
         CMP       s2,'6'
         JL        TIMEXT
         MOV       s2,'0'             ;大于'9'，ms2位清零 
         INC       m1 
         MOV       flagm,1
         CMP       m1,'9'
         JLE       TIMEXT
         MOV       m1,'0'              ;大于'9'，s1位清零
         INC       m2
         CMP       m2,'6'
         JL        TIMEXT
         MOV       m2,'0'              ;大于'5'，s2位清零
         INC       h1 
         MOV       flagh,1
         CMP       h1,'9'
         JLE       TIMEXT
         MOV       h1,'0'              ;大于'9'，m1位清零
         INC       h2
         CMP       h2,'6'
         JL        TIMEXT
         MOV       h2,'0'              ;大于'5'，m2位清零 
         
TIMEXT:  
         MOV       AL,20H
         OUT       20H,AL
         POP       AX
         IRET
TIMER  ENDP

code   ends
       end start

