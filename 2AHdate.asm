data segment
    ; add your data here!    
data ends

stack segment stack
    
stack ends

code segment 'code'
      assume  cs: code , ds: data , ss: stack  
      org 100h
start:jmp begin
str1  db 2 dup(0),'/'  ;'The date isssss'    ;Ҫ��ʾ���ַ�
str2  db 2 dup(0),'/'
str3  db 2 dup(0),'/'
mouth db 0
day   db 0
year  dw 0
due   db '$' 

;Convert number to ASCII
num2asc proc
      mov si,10  ;si��Ϊ����������Ϊ10
next: xor dx,dx  ;dx��0
      div si     ;ax�����ݱ�10��
      add dx,'0' ;������ת����ASCIIֵ
      dec bx     ;ָ����һ���ַ�λ��
      mov [bx],dl;��ת��ΪASCIIֵ���ַ������ַ�����
      or ax,ax   ;���޸������λת��
      jnz next   ;�У�ת����һλ
      ret        ;û�У�����
num2asc endp   

;main program
begin: mov ax,cs
       mov ds,ax
       mov ah,2ah            ;ȡ���ڹ��ܺ�2aH
       int 21h
       mov byte ptr mouth,dh ;�����·�       
       mov byte ptr mouth,dl ;����
       mov word ptr mouth,cx ;����  
       
          mov bx,offset str1+2  ;�õ��ַ���ĩβ��ַ
          xor ax,ax
          mov al,byte ptr mouth ;ȡ���·�
          call num2asc          ;���·ݶ�������ת����ASCII    
       
          mov bx,offset str2+2  ;�õ��ַ���ĩβ��ַ  
          xor ax,ax
          mov al,byte ptr day   ;ȡ������  
          call num2asc          ;�����ڶ�������ת����ASCII        
       
          mov bx,offset str3+4  ;�õ��ַ���ĩβ��ַ 
          mov ax,word ptr year  ;ȡ�����
          call num2asc          ;����ݶ�������ת����ASCII      
       
       mov dx,offset str1    ;ָ��Ҫ��ʾ�ַ�������ַ
       mov ah,09h           
       int 21h
       mov ah,4ch
       int 21h    
code ends

end start 