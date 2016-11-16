; multi-segment executable file template.

data segment
    ; add your data here!
    
data ends

stack segment stack
    
stack ends

code segment 'code'
      assume  cs: code , ds: data , ss: stack
start:  
       
      mov dl,'A'
      mov ah,2
      int 21h

code ends

end start ; set entry point and stop the assembler. 