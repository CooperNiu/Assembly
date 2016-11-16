; multi-segment executable file template.

data segment
    ; add your data here!
    
data ends

stack segment stack
    
stack ends

code segment 'code'
      assume  cs: code , ds: data , ss: stack    
      org 100h
start:  
      mov al,0
      mov ch,0
      mov cl,0
      mov dh,24
      mov dl,79
      mov bh,7
      mov ah,06h
      int 10h
      mov ah,4ch
      int 21h

code ends

end start ; set entry point and stop the assembler. 
    