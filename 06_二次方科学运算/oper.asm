data segment
	a db ?
	a_ db ?
	b db ?
	b_ db ?
	i db ?
	operator dw ?
	answer db ?
	answer_ db ?
data ends
public answer,answer_
code segment
	assume ds:data,cs:code
	public operation
operation proc far		;push in a,a_,b,b_  were in AH,AL
	push ax
	push cx
	push bp
	mov bp,sp

	mov ax,[bp+14]
	mov a,ah
	mov a_,al
	mov ax,[bp+12]
	mov b,ah
	mov b_,al
	mov ax,[bp+10]
	mov operator,ax
	cmp ax,03h
	jz muldata_zz		;go mul
	cmp ax,04h
	jz divdata_zz		;go div
	jmp addsubdata
	muldata_zz:	jmp muldata
	divdata_zz:	jmp divdata
addsubdata:	
	mov al,b_
	cmp a_,al
	jg addsubbig
	mov cl,b_		;in case a_<=b_
	sub cl,a_
	sar a,cl
	mov al,a
	jnc addsubsmallnot0	;last one is 0 ,can not be 0
	cmp al,0ffh
	jnz addsubsmallnot0 	;not == 1111,1111
	mov al,0h
addsubsmallnot0:
	mov cx,operator
	cmp cx,01h
	jz adddata1
	cmp cx,02h
	jz subdata1
adddata1:
	add al,b
	jmp endaddsub1data
subdata1:
	sub al,b
	jmp endaddsub1data
endaddsub1data:	
	mov answer,al
	mov al,b_
	mov answer_,al
	pop bp
	pop cx
	pop ax
	ret 6
	;;;;;;;;;;;;;;;;;;;;;;;;;
addsubbig:	
	mov cl,a_		;in case a_>b_
	sub cl,b_
	sar b,cl		
	mov al,b
	jnc addsubbignot0	;last one is 0 ,can not be 0
	cmp al,0ffh
	jnz addsubbignot0 		;not == 1111,1111
	mov al,0h
addsubbignot0:
	mov cx,operator
	cmp cx,01h
	jz adddata2
	cmp cx,02h
	jz subdata2
adddata2:
	add al,a
	jmp endaddsub2data
subdata2:
	sub a,al
	mov al,a
	jmp endaddsub2data
endaddsub2data:	
	mov answer,al
	mov al,a_
	mov answer_,al
	pop bp
	pop cx
	pop ax	
	ret 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
muldata:
	mov i,0h
	mov al,a
	imul b
mulmove:
	mov cx,ax
	and cx,0f0h
	cmp cx,0h
	jz mulmoveend
	inc i
	sar ax,1h
	jmp mulmove
mulmoveend:
	mov answer,al
	mov al,a_
	add al,b_
	add al,i
	mov answer_,al
	pop bp
	pop cx
	pop ax	
	ret 6	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
divdata:
	mov i,0
	mov al,a
	cmp al,0
	jz divmoveend
	cmp al,0
	jl divmoveN		;if <0 
	jmp divmoveP		;if >0
divmoveN:
	mov cl,al
	and cl,40h
	cmp cl,0
	jz divmoveend
	inc i
	sal al,1
	jmp divmoveN
	;;;;;;;;
divmoveP:
	mov cl,al
	and cl,40h
	cmp cl,40h
	jz divmoveend
	inc i
	sal al,1
	jmp divmoveP
divmoveend:
	mov ah,0
	idiv b
	mov answer,al
	mov al,a_
	sub al,b_
	sub al,i
	mov answer_,al
	pop bp
	pop cx
	pop ax	
	ret 6
operation endp
code ends
	end 

















