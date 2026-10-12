data segment
	A db 9,0,10 dup('$')
	NUM db ?
	i db ?
	lj db ?
data ends
code segment
	assume cs:code,ds:data
start:	mov ax,data
	mov ds,ax
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov dx,offset A
	mov ah,0ah
	int 21h
					;cin
	mov ah,02h
	mov dl,0dh
	int 21h
	mov dl,0ah				
	int 21h
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	mov bx,offset A+1
	mov ah,[bx]
	mov NUM,ah
	mov bx,offset A+2
	mov i,0
	mov lj,1		;0 is not ok,1 is ok
check:	
	mov ah,[bx]
	inc bx
	mov dh,[bx]	
	cmp ah,dh
	jb change
	jmp endcheck
change:	
	mov ch,ah
	mov ah,dh
	mov dh,ch
	mov [bx],dh
	dec bx
	mov [bx],ah
	inc bx
	mov lj,0		;if change,just try more,so one more loop	
endcheck:
	inc i
	mov ah,i
	inc ah
	cmp ah,NUM
	jz again
	jmp goon
again:	
	mov ah,lj
	cmp ah,1
	jz over
	mov i,0
	mov bx,offset A+2
	mov lj,1
	jmp check
goon:		
	jmp check	
over:	
	mov dx,offset A+2
	mov ah,09h
	int 21h
	
	mov ah,4ch
	int 21h
code ends
	end start
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	