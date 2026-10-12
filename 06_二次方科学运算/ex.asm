extrn operation:far
data segment

data ends

extrn answer:byte
extrn answer_:byte
code segment
	assume ds:data,cs:code
start:	

	mov ah,0ffh
	mov al,03h
	push ax
	mov ah,04h
	mov al,0ffh
	push ax
	mov ax,4
	push ax
	call operation	
	
	mov ah,02h
	mov dl,answer
	add dl,30h
	int 21h
	mov ah,02h
	mov dl,answer_
	add dl,30h
	int 21h
		
	mov ah,4ch
	int 21h	
code ends
	end start

















