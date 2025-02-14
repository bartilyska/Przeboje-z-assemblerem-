.686
.model flat
public _moja
.data
.code
_moja proc
	;[ebp+8] - r [ebp+12] -R [ebp+16] - H
	push ebp
	mov ebp,esp
	finit 
	fldz
	fld dword ptr [ebp+8]
	fmul st, st
	fld dword ptr [ebp+12]
	fmul st, st
	fld dword ptr [ebp+8]
	fld dword ptr [ebp+12]
	fmulp st(1), st
	faddp st(1), st
	faddp st(1), st
	fld dword ptr [ebp+16]
	fmulp st(1), st
	fldpi 
	fmulp st(1), st
	push dword ptr 3
	fild dword ptr [esp]
	pop eax
	fdivp st(1), st
	pop ebp
	ret
_moja endp
end