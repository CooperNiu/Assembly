DOSSEG
.MODEL SMALL
.STACK 20
.DATA
  message db "Hello world!$" 
  cnt equ $-message
.CODE
start:
    mov ax,@data
    mov ds,ax
    mov dx,offset message
    mov ah,09h
    int 21h
    mov ah,4ch
    int 21h
end start
  
       
    