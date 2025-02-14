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
	fld jeden
	mov ecx,1
	ety:
	fmul dword ptr [ebp+8]
	fxch;zamien by dzielnik byl na st0
	push ecx
	fstp st(0)
	fild dword ptr [esp];nie moge z ecx bezposrednio
	add esp,4
	fxch ;dzielna st1 dzielnik st0
	fdiv st(0),st(1)
	;wynik do st0 by sie dalo dodac
	fadd st(2),st(0)
	add ecx,1
	cmp ecx,20
	jne ety
	fstp st(0)
	fstp st(0)
	pop ebp
	ret
_nowy_exp ENDP
END
