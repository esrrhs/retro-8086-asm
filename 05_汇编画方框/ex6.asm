data segment
	x1 dw ?
	y1 dw ?
	x2 dw ?
	y2 dw ?
	drawpoint_x dw ?
	drawpoint_y dw ?
data ends
code segment 
	assume cs:code,ds:data
public draw 
draw 	proc far
	push bp
	mov bp,sp

	call cls

	mov ah,0
	mov al,04h
	int 10h

	mov ah,0bh
	mov bh,1
	mov bl,1
	int 10h

	mov ah,0bh
	mov bh,0
	mov bl,0
	int 10h	

	mov dx,[bp+12];start point
	mov x1,dx
	mov dx,[bp+10]
	mov y1,dx
	mov dx,[bp+8]
	mov x2,dx
	mov dx,[bp+6]
	mov y2,dx

	mov dx,x1
	mov drawpoint_x,dx
	mov cx,y1
	mov drawpoint_y,cx
	;mov ah,0ch
	;mov al,1
	;int 10h


l1:	mov cx,y1
	mov drawpoint_y,cx
 
l2:	mov dx,drawpoint_x
	mov cx,drawpoint_y
	mov ah,0ch
	mov al,1
	int 10h
	inc drawpoint_y
	mov dx,y2
	cmp drawpoint_y,dx
	jnz l2

	inc drawpoint_x
	mov dx,x2
	cmp drawpoint_x,dx
	jnz l1

	pop bp
	ret 8
draw endp
cls 	proc near
	mov cx,0
	mov dh,24
	mov dl,79
	mov bh,7
	mov ax,600h
	int 10h
	ret
cls 	endp
code 	ends
	end