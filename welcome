; multi-segment executable file template.

data segment
    ; add your data here!
    one db 2 dup (32),1,'WELCOME YOU!',7,13,10   ; 1,7,13,10 都是十进制数，翻看ASC码表 分别为 笑脸，警铃，回车，换行
    count  equ  $-one
data ends

stack segment stack
    stap  db  256  dup (00H)
    top  equ  this  word
stack ends

code segment 'code'
      assume  cs: code , ds: data , ss: stack
start:    mov  ax , data
          mov  ds , ax
          mov  ax , stack
          mov  ss , ax                           
          ;mov  sp , offset  top
          mov  si , offset  one
          mov  cx , count
next:     mov  dl , [si]
          mov  ah , 2
          int  21h
          inc  si
          loop  next

          mov ax, 4c00h ; exit to operating system.
          int 21h    
          
code ends

end start ; set entry point and stop the assembler.
