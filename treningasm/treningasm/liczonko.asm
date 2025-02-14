.686
.model flat
public _main
extern _GetUserNameA@8 : PROC
extern _ExitProcess@4 : PROC
.data
.code
_main PROC
	nop
	sub esp,32
	mov edi,esp
	sub esp,4
	mov dword ptr [esp],32
	push esp
	push edi
	call _GetUserNameA@8
	add esp,36
	push 0
	call _ExitProcess@4
_main ENDP
END