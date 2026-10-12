data segment
	point struc
		x dw ?
		y dw ?
		color db ?
	point ends
	snakepoint point 100 dup(< >) 
	head point 1 dup(< >)
	last point 1 dup(< >)
	food point 1 dup(< >)
	
	body_hight dw 10
	body_width dw 10
	x_min dw 0
	y_min dw 0
	x_max dw 190
	y_max dw 310
	
	maxlength dw 40
	long dw ?
	dir dw ?
	p_head dw ?
	backcolor db 0
	time dw ?
	
	i dw 0
	j dw 0
	k dw 0
	
	x1 dw ?
	y1 dw ?
	x2 dw ?
	y2 dw ?
	drawpoint_color db ?
	drawpoint_x dw ?
	drawpoint_y dw ?
	
	LEFT     EQU     4Bh  
	RIGHT    EQU     4Dh
	UP       EQU     48h
	DOWN     EQU     50h
	QUIT  EQU 01h
data ends
code segment
	assume cs:code,ds:data
go:	mov ax,data
	mov ds,ax
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
	mov bx,offset snakepoint
	mov ax,body_hight
	mov cx,body_width
	mov [bx].x,ax
	mov [bx].y,cx
	mov [bx].color,01h         ;0
	add bx,type snakepoint
	add cx,body_width
	mov [bx].x,ax
	mov [bx].y,cx             ;1
	mov [bx].color,02h 

	mov p_head,bx
	
	mov time,10
	
	mov food.x,100
	mov food.y,100
	mov food.color,01h
	mov last.x,100
	mov last.y,110
	mov dl,backcolor
	mov last.color,dl

	mov dir,2
	
	mov long,2
	
	mov i,0	
	mov ah,0
	mov al,0dh
	int 10h

	mov ah,0bh
	mov bh,1
	mov bl,0
	int 10h

	mov ah,0bh
	mov bh,0
	mov bl,backcolor
	int 10h
	
	mov k,0 
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
run:	
	mov j,0
	mov bx,offset snakepoint
draw:	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov dx,[bx].x				;start deaw  point
	mov x1,dx
	add dx,body_hight
	mov x2,dx
	
	mov dx,[bx].y
	mov y1,dx
	add dx,body_width
	mov y2,dx
	
	mov dl,[bx].color
	mov drawpoint_color,dl

	call drawbox
	;;
	add bx,type snakepoint
	inc j
	mov ax,j
	cmp ax,long
	jnz draw                         ;end draw snake
	;;;;;;;;;;;;;;;;;;;;;;;;;	
	mov bx,p_head
	mov dx,[bx].x
	mov head.x,dx			;ini head and p_head
	mov dx,[bx].y
	mov head.y,dx
	mov dl,[bx].color
	mov head.color,dl
	;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	mov dx,food.x          ;draw food point
	mov x1,dx
	add dx,body_hight
	mov x2,dx
	
	mov dx,food.y
	mov y1,dx
	add dx,body_width
	mov y2,dx
	mov dl,food.color
	mov drawpoint_color,dl
	
	call drawbox
	;;;;;;;;;;;;;;;;;;;;

	mov dx,last.x          ;un draw point
	mov x1,dx
	add dx,body_hight
	mov x2,dx
	
	mov dx,last.y
	mov y1,dx
	add dx,body_width
	mov y2,dx
	mov dl,last.color
	mov drawpoint_color,dl
	
	call drawbox	
	;;;;;;;;;;;;;;;;;;;
   	;mov ah,0			;pause
	;int 16h	
	;;;;;;;;;;;;;;;;;;;;;;;;;  	draw ok
	inc k
	mov dx,time
	dec dx
	cmp dx,long
	jle fatest
	sub dx,long
	cmp k,dx
	jnz cannotmove
	mov k,0
	jmp move
cannotmove:
	jmp nextrun
	fatest:		mov dx,1
			mov k,0
			jmp move
	;;;;;;;;;;;;;;;;;;;;;;;;
move:	mov bx,offset snakepoint
	mov dx,[bx].x
	mov last.x,dx
	mov dx,[bx].y
	mov last.y,dx			;move body
	mov j,0
movebody:
	add bx,type snakepoint
	mov dx,[bx].x
	mov cx,[bx].y
	sub bx,type snakepoint
	mov [bx].x,dx
	mov [bx].y,cx				
	add bx,type snakepoint
	inc j
	mov dx,long
	dec dx
	cmp dx,j
	jnz movebody
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;	;check cin

	mov dx,body_hight
	mov cx,body_width
	mov bx,p_head
		
	mov ah,01h 
	int 16h  
	jz virtulcin   			;if no keydown go on

	mov ah,00h    
	int 16h   
	cmp ah,LEFT     		;left
	jz check_LEFT
	cmp ah,RIGHT   			;right
	jz check_RIGHT
	cmp ah,UP  			;up
	jz check_UP			
	cmp ah,DOWN 	  		;down
	jz check_DOWN
        cmp ah,QUIT   			;over
	jz check_QUIT
	jmp virtulcin
check_LEFT:
	cmp dir,2
	jz virtulcin
	mov dir,4
	jmp virtulcin
check_RIGHT:	
	cmp dir,4
	jz virtulcin
	mov dir,2
	jmp virtulcin
check_UP:
	cmp dir,3
	jz virtulcin
	mov dir,1
	jmp virtulcin
check_DOWN:
	cmp dir,1
	jz virtulcin
	mov dir,3
	jmp virtulcin
check_QUIT:
	jmp over	
	;;;;;;;;;;;;;;;;;;;;;;;;;;
	virtulcin:	
	cmp dir,1
	jz go_UP
	cmp dir,2
	jz go_RIGHT
	cmp dir,3
	jz go_DOWN
	cmp dir,4
	jz go_LEFT
go_UP:
	sub [bx].x,dx
	jmp endcin
go_RIGHT:
	add [bx].y,cx
	jmp endcin
go_DOWN:
	add [bx].x,dx
	jmp endcin
go_LEFT:
	sub [bx].y,cx
	jmp endcin
	endcin:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;cin ok		
	mov bx,p_head
	mov dx,[bx].x
	mov head.x,dx			 
	mov dx,[bx].y
	mov head.y,dx			;ini head again
	mov dl,[bx].color
	mov head.color,dl
	;;;;;;;;;;;;;;;;;;;;;;;;	

	mov dx,head.x
	cmp dx,x_min
	jl outorPZ
	cmp dx,x_max
	jg outorPZ
	mov dx,head.y
	cmp dx,y_min
	jl outorPZ
	cmp dx,y_max
	jg outorPZ	
	jmp checkPZ
outorPZ:
	dec long
	cmp long,1
	jz dead_zz
	sub p_head,type snakepoint
	mov bx,p_head
	mov dx,[bx].x
	mov head.x,dx			;sub p_head and ini head 
	mov dx,[bx].y
	mov head.y,dx
	mov dl,[bx].color
	mov head.color,dl
	jmp checkover
	dead_zz:			
		jmp dead
	;;;;;;;;;;;;;;;;;;;;		
checkPZ:
	mov j,0	
	mov bx,offset snakepoint
checkPZloop:
	mov dx,[bx].x
	cmp dx,head.x
	jnz endcheckPZ
	mov dx,[bx].y
	cmp dx,head.y
	jnz endcheckPZ			;test if [bx].x==head.x && [bx].y==head.y ,PZ
	jmp outorPZ
	endcheckPZ:
	add bx,type snakepoint
	inc j
	mov dx,long
	dec dx
	cmp dx,j
	jnz checkPZloop
checkover:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;	;check out and PZ ok	
	mov dx,food.x
	cmp dx,head.x
	jnz endcheckfood_zz
	mov dx,food.y
	cmp dx,head.y
	jnz endcheckfood_zz
	jmp eatfood
	endcheckfood_zz:	jmp endcheckfood
eatfood:
	mov dx,long
	cmp dx,maxlength
	jz newfood_zz
	;;
	inc long
	add p_head,type snakepoint
	mov bx,p_head
	
	mov dx,food.x
	mov cx,food.y
	cmp dir,1
	jz foodup
	cmp dir,2
	jz foodright
	cmp dir,3
	jz fooddown
	cmp dir,4
	jz foodleft
	newfood_zz:	jmp newfood
	foodup:
		sub dx,body_hight
		jmp fooddirend
	foodright:
		add cx,body_width
		jmp fooddirend
	fooddown:
		add dx,body_hight
		jmp fooddirend
	foodleft:
		sub cx,body_width
		jmp fooddirend
	fooddirend:

	mov [bx].x,dx
	mov head.x,dx
	mov [bx].y,cx			;add p_head and ini head 
	mov head.y,cx
	mov dl,food.color
	mov [bx].color,dl
	mov head.color,dl
	
	jmp newfood
	newfood:
	;mov ah,0               		;make rand
        ;int 1ah
	;mov ax,dx
	;mov ah,0
	;mov bl,32
	;div bl
	;mov al,ah
	;mov bl,10
	;mul bl
	;mov food.x,ax
	mov dx,last.x
	mov food.x,dx
	;mov ah,0               		;make rand
        ;int 1ah
	;mov ax,dx
	;mov ah,0
	;mov bl,20
	;div bl
	;mov al,ah
	;mov bl,10
	;mul bl	
	;mov food.y,ax
	mov dx,last.y
	mov food.y,dx
	
        colorloop:
	mov ah,0               		;make color rand
        int 1ah
        mov ax,dx
        mov ah,0
        mov dl,10
        div dl        
        mov food.color,ah
        cmp ah,backcolor
        jz colorloop
        jmp endcheckfood
endcheckfood:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;	;check eat food ok

nextrun:
	;mov dx,9
	;inc i
	;cmp dx,i
	;jz over
        jmp run
	;;;;;;;;;;;;;
dead:
	jmp go
over:
	mov ah,0
	int 16h
	mov ah,0
	mov al,3
	int 10h
	mov ah,4ch
	int 21h
drawbox proc near
	push ax
	push bx
	push cx
	push dx
	 
	mov dx,x1
	mov drawpoint_x,dx
	mov cx,y1
	mov drawpoint_y,cx

l1:	mov cx,y1
	mov drawpoint_y,cx
 
l2:	mov dx,drawpoint_x
	mov cx,drawpoint_y
	mov ah,0ch
	mov al,drawpoint_color
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
	
	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
drawbox	endp	
code ends
	end go