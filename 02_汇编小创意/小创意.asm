data segment
	screenpoint struc
		color dw ?
		x dw ?
		y dw ?
		v_x dw ?
		v_y dw ?
	screenpoint ends
	point screenpoint 1 dup(< >)
	NUM equ 0ah
	other screenpoint NUM dup(< >)
	kill screenpoint 1 dup(< >)
	QUIT equ 01h
	i dw 0
data ends
code segment
	assume ds:data,cs:code
start:	
	mov ax,data
	mov ds,ax
	
	mov ah,0
	mov al,4
	int 10h
	
	mov ah,0bh
	mov bh,1
	mov bl,0
	int 10h
	
	mov ah,0bh
	mov bh,0
	mov bl,0
	int 10h
	;;;;;;;;;;;;;
	mov point.x,0
	mov point.y,0
	mov point.v_x,1
	mov point.v_y,1
	;;;;;;;;;;;;;	
rungame:	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ax,point.x
	mov bx,point.y
	add ax,bx
	mov point.color,ax
	;;;;;;;;;;;
	;mov ah,0ch
	;mov dx,kill.x
	;mov cx,kill.y
	;mov al,0
	;int 10h	
	;;;;;;;;;;;
	mov ax,point.v_x
	add point.x,ax
	mov ax,point.v_y
	add point.y,ax
	;;;;;;;;;;;
	mov cx,0ffffh
	mov ax,point.x
	cmp ax,0
	jl xl
	cmp ax,200
	jg xg
	mov ax,point.y	
	cmp ax,0
	jl yl
	cmp ax,320
	jg yg	
	jmp endcheck
xl:	mov point.x,0
	mov ax,point.v_x
	imul cx
	and dx,80h
	or ax,dx	
	mov point.v_x,ax
	jmp endcheck	
xg:	mov point.x,200
	mov ax,point.v_x
	imul cx
	and dx,80h
	or ax,dx
	mov point.v_x,ax
	jmp endcheck		
yl:	mov point.y,0
	mov ax,point.v_y
	imul cx
	and dx,80h
	or ax,dx	
	mov point.v_y,ax
	jmp endcheck		
yg:	mov point.y,320
	mov ax,point.v_y
	imul cx
	and dx,80h
	or ax,dx
	mov point.v_y,ax
	jmp endcheck		
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
endcheck:
	mov ah,0ch
	mov dx,point.x
	mov cx,point.y
	mov al,byte ptr point.color
	int 10h
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov bx,offset other
	mov dx,[bx].x
	mov kill.x,dx
	mov dx,[bx].y
	mov kill.y,dx
	mov i,0
moveloop:
	add bx,type screenpoint
	mov ax,[bx].x
	mov cx,[bx].y
	sub bx,type screenpoint
	mov [bx].x,ax
	mov [bx].y,cx
	add bx,type screenpoint
	inc i
	mov dx,i
	inc dx
	cmp dx,NUM
	jnz moveloop
	;;
	mov dx,point.x
	mov [bx].x,dx
	mov dx,point.y
	mov [bx].y,dx
	;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ah,01h 
	int 16h  
	jz goon  
	;;;;;;			
	mov ah,00h    
	int 16h
        cmp ah,QUIT   			
	jz over
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
goon:
	;mov ah,0
	;int 16h
	jmp rungame
	
over:	
	
	
	mov ah,0
	int 16h
	mov ah,0
	mov al,3
	int 10h
	
	mov ah,4ch
	int 21h
code ends
	end start
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	