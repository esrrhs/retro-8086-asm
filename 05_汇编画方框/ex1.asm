extrn draw:far
data segment
	x1 dw 0
	y1 dw 0
	x2 dw 200
	y2 dw 160
data ends
code segment
	assume cs:code,ds:data
go:	mov ax,data
	mov ds,ax
	push x1
	push y1
	push x2
	push y2
	call draw
	mov ah,0
	int 16h
	mov ah,0
	mov al,3
	int 10h
	mov ah,4ch
	int 21h
code ends
	end go
