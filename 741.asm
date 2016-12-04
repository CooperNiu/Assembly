        dosseg
        .model small
        .stack 100h
        .data  
msgi    db 'Today is:'
year    db 4 dup(0),'-'
mon     db 2 dup(0),'-'
day     db 2 dup(0),0dh,0ah,'$'
msg2    db 'The time is:$'
time    db '00:00:00$'     
leng    equ $-msg2
ymd     db 4 dup(0)
hms     db 9 dup(0)       ;用于缓存时分秒，各三个
buff1   db 0               
buff2   db 0               
pict    db '          ',0ah,0dh
        db 'Thank you !','$'
        
str1    db 2 dup(0),':'    
str2    db 2 dup(0),':'    
str3    db 2 dup(0),'$'  
  
sen1    db 'Press a to Start  $'   
sen2    db 'Press b to Restart$'   
sen3    db 'Press c to Close  $'   
sen4    db 'Press d to Exit   $'
sen5    db 'Thank you ! $'
sen6    db 'By Chen Chunxu$'
sen7    db 'Time table$'     
        .code
        
num2asc proc           ;asc码转换
    	push    ax
   	push    bx
    	push    cx
    	push    dx
        cmp ax,10 ;
        jl next1
        mov di,10
next:   xor dx,dx
        div di
        add dx,'0'
        dec bx
        mov [bx],dl
        or ax,ax
        jnz next
        jmp exit
next1:  add al,30h
        dec bx
        mov [bx],al
        mov al,'0'
        dec bx
        mov [bx],al
exit:   ret
        pop     dx
 	pop     cx
   	pop     bx
        pop     ax
num2asc endp

disply  proc
    	push    ax
   	push    bx       
        mov bh,0
        mov ah,14
        int 10h
    	pop    ax
   	pop    bx
        ret
disply  endp 

transf  macro x,y           ;转换为asc码的宏
    	push    ax
   	push    bx
        mov bx,offset x
        xor ax,ax
        mov al,byte ptr y
        call num2asc 
        pop    ax
   	pop    bx
endm 

disp    macro x             ;显示字符串的宏
        push ax
        push dx
        mov dx,offset x
        mov ah,09h
        int 21h
        pop ax
        pop dx
endm 
 
point   macro x,y          ;光标位置处于x行，y列的宏 
        mov dh,x
        mov dl,y
        mov bh,0
        mov ah,02h
        int 10h
endm  

clear   macro x,y,z,w,t,s  ;清屏的宏
        push    ax
   	push    bx
    	push    cx
    	push    dx
        mov al,t           
        mov ch,x           
        mov cl,y           
        mov dh,z           
        mov dl,w           
        mov bh,s           
        mov ah,6h          
        int 10h 
        pop     dx
 	pop     cx
   	pop     bx
        pop     ax           
endm

start:  clear 0,0,24,79,0,03h     ;主程序
        point 3,30            
        mov ax,@data
        mov ds,ax
        mov si,offset ymd 
        mov ah,2ah
        int 21h
        mov [si],cx
        add si,2
        mov [si],dh
        inc si  
        mov [si],dl
        mov bx,offset year+4
        xor ax,ax
        mov ax,word ptr ymd
        call num2asc               ;调用转换ASCII码的子程序
        transf mon+2,ymd+2         ;调用宏       
        transf day+2,ymd+3
        mov dx,offset msgi
        mov ah,09h
        int 21h
date:   mov ah,2ch            
        int 21h                 
        mov byte ptr hms,ch     
        mov byte ptr hms+3,cl   
        mov byte ptr hms+6,dh   
        mov bx,offset str1+2     
        xor ax,ax                
        mov al,byte ptr hms     
        call num2asc             
        mov bx,offset str2+2     
        xor ax,ax                
        mov al,byte ptr hms+3   
        call num2asc             
        mov bx,offset str3+2     
        mov al,byte ptr hms+6  
        call num2asc 
        point 2,35                      
        disp sen7               
        point 4,30
        disp msg2
        point 6,30
        disp sen1
        point 8,30
        disp sen4
        point 4,43               
        disp str1                
        point 12,35
        disp sen5 
        point 15,32
        disp sen6            
        mov si,offset buff1      ;把buff1的偏移量给si
        cmp byte ptr [si],01     ;判断[si]是否为1
        je timing2               ;为1的话继续计时
        mov ah,01h               ;判断是否有键盘输入
        int 16h
        jnz timing1              ;如果有的话跳转到timing1 
        mov si,offset buff2      ;把buff2的偏移量给si
        cmp byte ptr [si],0      ;判断buff2的值是否为0
        je shi                   ;是的话跳转到shi
        cmp byte ptr [si],1      ;判断buff2的值是否为1
        je fou                   ;是的话跳转到fou
        mov byte ptr [si],0h     ;buff2中数据清零
        jmp g2
        
shi:     
        inc byte ptr [si]        
        jmp g2
        
fou:     
        inc byte ptr [si]        
        
g2:     
change: mov ah,2ch
        int 21h                  ;取时间
        mov al,byte ptr hms+6   
        cmp al,dh                ;判断秒有没有变化
        je change                ;若不变化则一直循环，直至变化
        jmp date                 ;返回date，继续取时间显示


timing1:mov ah,08h               ;读取键盘输入的ASCII值到al里面
        int 21h
        cmp al,'d'               ;输入的是d或者D，则进入退出程序
        je tr1                
        cmp al,'D'               
        je tr1
        cmp al,'a'               ;输入的是a或A，则进入开始计时程序
        je jishi
        cmp al,'A'              
        je jishi
        jmp date                 ;如果输入不满足要求程序继续循环
tr1 :jmp far ptr ending        
timing2:                         ;开始计时时显示 
        point 7,30
        disp sen2                
        point 8,30               
        disp sen3 
        point 9,30  
        disp sen4              
        mov si,offset buff2      
        cmp byte ptr [si],0      
        je qaz
        cmp byte ptr [si],1      
        je wsx
        mov byte ptr [si],0h
        jmp g3
        
qaz:     
        inc byte ptr [si]
        jmp g3

wsx:    inc byte ptr [si]        
        jmp g3
                 
g3:     mov ah,1                 
        int 16h
        jnz g                  
        jmp g1 
                          
g:      mov ah,8              ;取键盘输入,并判断程序运行时键入的是b，c，还是d 
        int 21h
        cmp al,'d'
        je tr2
        cmp al,'D'
        je tr2
        cmp al,'b'
        je jishi
        cmp al,'B'
        je jishi
        cmp al,'c'
        je tr3
        cmp al,'C'
        je tr3

tr3:   jmp far ptr cancel  
tr2:   jmp far ptr ending  
       
g1:     mov ah,2ch
        int 21h
        mov byte ptr hms,ch     ;把小时存入预设的hms中
        mov byte ptr hms+3,cl   ;把分钟存入预设的hms中
        mov byte ptr hms+6,dh   ;把秒钟存入预设的hms中
        mov ah,byte ptr hms+6   
        sub ah,byte ptr hms+7  
        jge c1                   
        dec byte ptr hms+3      
        add ah,60               
        jmp c1           
       
c1:     mov byte ptr hms+8,ah           ;c1,c2,c3用于执行计时时刻与当前时间的差值，此为计时器时间
        mov ah,byte ptr hms+3
        sub ah,byte ptr hms+4  
        jge c2
        dec byte ptr hms        
        add ah,60 
                       
c2:     mov hms+5,ah
        mov ah,byte ptr hms
        sub ah,byte ptr hms+1
        jge c3
        add ah,24
        
c3:     mov hms+2,ah
        transf time+2,hms+2     
        transf time+5,hms+5   
        transf time+8,hms+8  
        point 10,36              
        disp time               
        mov byte ptr buff1,01h
        
edc:    mov ah,2ch
        int 21h                 
        mov al,byte ptr hms+6
        cmp al,dh
        je edc
        jmp date
        
        mov ah,01                  
        int 21h
        jmp ending

cancel label far        
        mov si,offset buff1    ;
        mov byte ptr [si],00h
        clear 9,35,9,45,1,05h
        point 6,30
        disp sen1
        point 8,30
        disp sen4
        jmp start
        
jishi:   
        mov ah,2ch                         ;记录计时一刻的时间
        int 21h
        mov byte ptr hms+1,ch   
        mov byte ptr hms+4,cl 
        mov byte ptr hms+7,dh  
        mov byte ptr buff1,01h     
        jmp date 

ending label far  
        mov ah,4ch               ;终止程序
        int 21h

        end start           
