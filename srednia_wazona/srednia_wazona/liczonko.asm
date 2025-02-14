.686
.model flat
public _licz_srednia
.data
.code
_licz_srednia PROC
	push ebp
	mov ebp,esp
	mov ebx,[ebp+8];ilosc
	mov edx,[ebp+12];jakosc
	mov ecx,[ebp+16];ilczba elementow
	finit
	fldz
	et:
		fiadd dword ptr [ebx]
		add ebx,4
	loop et
	mov ecx,[ebp+16]
	mov ebx,[ebp+8]
	fldz
	fldz
	ety:
		fiadd dword ptr [ebx]
		fmul dword ptr [edx]
		fadd st(1),st(0)
		fstp st(0)
		fldz
		add ebx,4
		add edx,4
	loop ety
	fstp st(0)
	fxch
	fdivp
	pop ebp
	ret
_licz_srednia ENDP
END