data segment
	A db 9,0,10 dup('$')
	last_A dw ?
	B db 9,0,10 dup('$') 
	last_B dw ?
	c db ?
	zjANS db 10 dup(0)
	ANS db 50 dup(0),'$'
	i dw 0
	j db 0
data ends
code segment
	assume cs:code,ds:data
start:	mov ax,data
	mov ds,ax
	mov es,ax
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov dx,offset A
	mov ah,0ah
	int 21h
	
	mov ah,02h
	mov dl,0dh
	int 21h
	mov dl,0ah				;cin
	int 21h
	
	mov dx,offset B
	mov ah,0ah
	int 21h	
	
	mov ah,02h
	mov dl,0dh
	int 21h
	mov dl,0ah
	int 21h
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	mov si,offset A+1
	mov last_A,si
	mov dl,[si]
	mov dh,0
	add last_A,dx				;find the last of a and b
	
	mov si,offset B+1
	mov last_B,si
	mov dl,[si]
	mov dh,0
	add last_B,dx	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov i,0
	mov cx,offset B+1
mulloop:	
	mov si,last_B
	mov dl,[si]
	mov c,dl
	
	mov j,0
	
	and c,0fh
	mov di,offset zjANS
	mov byte ptr[di],0
	mov si,last_A
	mov bx,offset A+1
	
l1:	
	inc j
	mov al,[si]
	dec si
	and al,0fh
	mul c				;a*b
	aam
	add al,[di]
	aaa
	mov [di],al
	inc di
	mov [di],ah
	cmp si,bx
	jnz l1
	
	push ax
	push bx
	push cx	
	push dx	
	push si	
	push di
	
	mov si,offset zjANS
	mov di,offset ANS
	add di,i
	inc i
	inc j
	mov ah,0h
	
	
	mov cx,4
l3:	mov al,[si]
	inc si
	sahf
	adc al,[di]
	aaa
	lahf
	mov [di],al
	inc di
	
	dec j
	mov dl,j
	cmp dl,0
	jnz l3
	
	and ah,01h
	mov [di],ah
	
	pop di
	pop si
	pop dx	
	pop cx	
	pop bx
	pop ax
		
	dec last_B
	mov dx,last_B
	cmp dx,cx
	jnz mulloop_ZZ
	jmp outANS
	mulloop_ZZ:jmp mulloop
outANS:	
	mov i,0
	mov di,offset ANS
findlast:
	inc di
	inc i
	mov dl,[di]
	cmp dl,'$'
	jnz findlast 
	dec di
			

l2:	mov dl,[di]
	or dl,30h
	mov ah,02h
	int 21h
	dec di
	dec i
	mov dx,i
	cmp dx,0
	jnz l2
	
	mov ah,4ch
	int 21h
code ends
	end start
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	