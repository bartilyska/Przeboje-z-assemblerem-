.686
.model flat
public _nowy_exp
.data
	jeden dd 1.0
.code
_nowy_exp PROC
	push ebp 
	mov ebp,esp
	mov eax,[ebp+8]
	finit 
	fld jeden
	fld jeden
	mov ecx,1
	et:
		fmul dword ptr [ebp+8]
		push ecx
		fidiv dword ptr[esp]
		add esp,4
		fadd st(1),st(0)
		add ecx,1
		cmp ecx,20
	jne et
	fstp st(0)
	pop ebp
	ret
_nowy_exp ENDP
END