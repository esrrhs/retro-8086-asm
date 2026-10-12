data segment
	point struc
		x dw ?
		y dw ?
	point ends
	snakepoint point 100 dup(< >) 
	body_hight dw 10
	body_width dw 10
	i dw 0
	j dw 0
	k dw 0
	x1 dw ?
	y1 dw ?
	x2 dw ?
	y2 dw ?
	drawpoint_x dw ?
	drawpoint_y dw ?
	long dw 30
	dir dw ?
	x_min dw 0
	y_min dw 0
	x_max dw 190
	y_max dw 310
	head_x dw ?
	head_y dw ?
data ends
code segment
	assume cs:code,ds:data
go:	mov ax,data
	mov ds,ax
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
;	mov bx,offset snakepoint
;	mov [bx].x,40
;	mov [bx].y,40
;	add bx,type snakepoint
;	mov [bx].x,30
;	mov [bx].y,30
;	add bx,type snakepoint
;	mov [bx].x,20
;	mov [bx].y,20
;	add bx,type snakepoint
;	mov [bx].x,10
;	mov [bx].y,10
	mov i,0
	mov bx,offset snakepoint
	mov dx,body_hight
	mov cx,body_width
	mov ah,3
	mov al,2
ini:	mov [bx].x,dx
	mov [bx].y,cx
	
	;add dx,10
	;add cx,10	
	cmp dx,x_max
	jz sub_ini_x
	cmp dx,x_min
	jz add_ini_x
	cmp cx,y_max
	jz sub_ini_y
	cmp cx,y_min
	jz add_ini_y
	jmp end_ini	
	
	sub_ini_x:	mov ah,1
		jmp end_ini	
	add_ini_x:	mov ah,3
		jmp end_ini	
	sub_ini_y:	mov al,4
		jmp end_ini	
	add_ini_y:	mov al,2
		jmp end_ini	
end_ini:		
	cmp ah,1
	jz sub_p_x
	cmp ah,3
	jz add_p_x	
	sub_p_x:	sub dx,body_hight
			jmp end_ini_x
	add_p_x:	add dx,body_hight
			jmp end_ini_x
	end_ini_x:
			
	cmp al,4
	jz sub_p_y
	cmp al,2
	jz add_p_y	
	sub_p_y:	sub cx,body_width
			jmp end_ini_y
	add_p_y:	add cx,body_width	
			jmp end_ini_y
	end_ini_y:

	add bx,type snakepoint
	inc i
	mov j,cx
	mov cx,long
	cmp i,cx
	mov cx,j
	jnz ini
	
	mov dir,1		
	mov i,0	
run:	;call cls
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
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov j,0
	mov bx,offset snakepoint
draw:	mov dx,[bx].x;start point
	mov x1,dx
	add dx,body_hight
	mov x2,dx
	
	mov dx,[bx].y
	mov y1,dx
	add dx,body_width
	mov y2,dx

	mov dx,x1
	mov drawpoint_x,dx
	mov cx,y1
	mov drawpoint_y,cx

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
	;;
	inc drawpoint_x
	mov dx,x2
	cmp drawpoint_x,dx
	jnz l1
	;;
	add bx,type snakepoint
	inc j
	mov ax,j
	cmp ax,long
	jnz draw
	;;;;;;;;;;;;;;

        ;mov ah,0
	;int 16h	
	
	;mov bx,offset snakepoint
	;add [bx].y,10	
	;add bx,type snakepoint	
	;add [bx].y,10	
	;add bx,type snakepoint	
	;add [bx].y,10	
	;add bx,type snakepoint	
	;add [bx].y,10	
	
	mov bx,offset snakepoint
	mov dx,[bx].x
	mov head_x,dx
	mov dx,[bx].y
	mov head_y,dx
	
	
	mov ax,dir
	cmp ax,1
	jz up_zz
	cmp ax,2
	jz right_zz
	cmp ax,3
	jz down_zz
	cmp ax,4
	jz left_zz			
	up_zz:		jmp up	
	right_zz:	jmp right
	down_zz:	jmp down	
	left_zz:	jmp left
up:	mov bx,offset snakepoint
	mov dx,[bx].x
	mov cx,[bx].y
	cmp dx,x_min
	jz out_up1
	cmp dx,x_max
	jz out_down1
	cmp cx,y_min
	jz out_left1
	cmp cx,y_max
	jz out_right1
	
	mov bx,offset snakepoint	
	sub [bx].x,10
	add [bx].y,10
	jmp end1
	
	out_up1:	
		mov dir,2
		mov bx,offset snakepoint	
		mov ax,y_max
		cmp [bx].y,ax
		jz return11
		add [bx].x,10
		add [bx].y,10			
		jmp end1
		return11:	mov dir,3
				add [bx].x,10
				sub [bx].y,10
		jmp end1
	out_down1:			
		jmp end1	
	out_left1:			
		jmp end1	
	out_right1:	
		mov dir,4
		mov bx,offset snakepoint
		mov ax,x_min
		cmp [bx].x,ax
		jz return12	
		sub [bx].x,10
		sub [bx].y,10			
		jmp end1
		return12:	mov dir,3
				add [bx].x,10
				sub [bx].y,10	
		jmp end1
	;;;;;;;;;;;;;;;;;;;;
right:	mov bx,offset snakepoint
	mov dx,[bx].x
	mov cx,[bx].y
	cmp dx,x_min
	jz out_up2
	cmp dx,x_max
	jz out_down2
	cmp cx,y_min
	jz out_left2
	cmp cx,y_max
	jz out_right2
	
	mov bx,offset snakepoint
	mov dir,2	
	add [bx].x,10
	add [bx].y,10
	jmp end1

	out_up2:		
		jmp end1
	out_down2:		
		mov dir,1
		mov bx,offset snakepoint
		mov ax,y_max
		cmp [bx].y,ax
		jz return21	
		sub [bx].x,10
		add [bx].y,10				
		jmp end1	
		return21:	mov dir,4
				sub [bx].x,10
				sub [bx].y,10	
		jmp end1
	out_left2:			
		jmp end1	
	out_right2:	
		mov dir,3
		mov bx,offset snakepoint	
		mov ax,x_max
		cmp [bx].x,ax
		jz return22
		add [bx].x,10
		sub [bx].y,10			
		jmp end1	
		return22:	mov dir,4
				sub [bx].x,10
				sub [bx].y,10	
		jmp end1		
	;;;;;;;;;;;;;;;;;;;;	
down:	mov bx,offset snakepoint
	mov dx,[bx].x
	mov cx,[bx].y
	cmp dx,x_min
	jz out_up3
	cmp dx,x_max
	jz out_down3
	cmp cx,y_min
	jz out_left3
	cmp cx,y_max
	jz out_right3
	
	mov bx,offset snakepoint	
	add [bx].x,10
	sub [bx].y,10
	jmp end1

	out_up3:				
		jmp end1
	out_down3:			
		mov dir,4
		mov bx,offset snakepoint
		mov ax,y_min
		cmp [bx].y,ax
		jz return31	
		sub [bx].x,10
		sub [bx].y,10		
		jmp end1	
		return31:	mov dir,1
				sub [bx].x,10
				add [bx].y,10	
		jmp end1		
	out_left3:	
		mov dir,2
		mov bx,offset snakepoint
		mov ax,x_max
		cmp [bx].x,ax
		jz return32	
		add [bx].x,10
		add [bx].y,10			
		jmp end1	
		return32:	mov dir,1
				sub [bx].x,10
				add [bx].y,10	
		jmp end1		
	out_right3:					
		jmp end1	
	;;;;;;;;;;;;;;;;;;;;	
left:	mov bx,offset snakepoint
	mov dx,[bx].x
	mov cx,[bx].y
	cmp dx,x_min
	jz out_up4
	cmp dx,x_max
	jz out_down4
	cmp cx,y_min
	jz out_left4
	cmp cx,y_max
	jz out_right4
	
	mov bx,offset snakepoint	
	sub [bx].x,10
	sub [bx].y,10
	jmp end1

	out_up4:	
		mov dir,3
		mov bx,offset snakepoint
		mov ax,y_min
		cmp [bx].y,ax
		jz return41		
		add [bx].x,10
		sub [bx].y,10			
		jmp end1
		return41:	mov dir,2
				add [bx].x,10
				add [bx].y,10	
		jmp end1		
	out_down4:			
		jmp end1	
	out_left4:	
		mov dir,1
		mov bx,offset snakepoint
		mov ax,x_min
		cmp [bx].x,ax
		jz return42		
		sub [bx].x,10
		add [bx].y,10			
		jmp end1
		return42:	mov dir,2
				add [bx].x,10
				add [bx].y,10	
		jmp end1			
	out_right4:					
		jmp end1	
	;;;;;;;;;;;;;;;;;;;;	
		
end1:	
	mov bx,offset snakepoint
	add bx,type snakepoint	
	mov cx,bx	
	mov j,0
	mov ax,long
	sub ax,2
	mov_ini:	add bx,type snakepoint
			inc j
			cmp j,ax
			jnz mov_ini
		
	;add bx,type snakepoint
	;add bx,type snakepoint
move:	
	sub bx,type snakepoint
	mov dx,[bx].x
	mov ax,[bx].y
	add bx,type snakepoint
	mov [bx].x,dx
	mov [bx].y,ax
	sub bx,type snakepoint
	cmp cx,bx
	jnz move
	
	mov bx,offset snakepoint
	add bx,type snakepoint	
	mov dx,head_x
	mov [bx].x,dx
	mov dx,head_y
	mov [bx].y,dx

;	mov bx,offset snakepoint
;	add bx,type snakepoint
;	add bx,type snakepoint
;	mov dx,[bx].x
;	mov cx,[bx].y
;	add bx,type snakepoint
;	mov [bx].x,dx
;	mov [bx].y,cx
;
;	mov bx,offset snakepoint
;	add bx,type snakepoint
;	mov dx,[bx].x
;	mov cx,[bx].y
;	add bx,type snakepoint
;	mov [bx].x,dx
;	mov [bx].y,cx
;
;	mov bx,offset snakepoint
;	mov dx,head_x
;	mov cx,head_y
;	add bx,type snakepoint
;	mov [bx].x,dx
;	mov [bx].y,cx
		
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ok

	mov dx,999
	inc i
	cmp dx,i
	jz quit
        jmp run
	;;;;;;;;;;;;;
quit:
	mov ah,0
	int 16h
	mov ah,0
	mov al,3
	int 10h
	mov ah,4ch
	int 21h
cls 	proc near
	mov cx,0
	mov dh,24
	mov dl,79
	mov bh,7
	mov ax,600h
	int 10h
	ret
cls 	endp
code ends
	end go