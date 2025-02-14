.686
.model flat
extern _ExitProcess@4 :PROC
public _main
.data
.code
_main proc
	mov eax, 50
	shl eax, 12
	push 0
	call _ExitProcess@4
_main endp
END