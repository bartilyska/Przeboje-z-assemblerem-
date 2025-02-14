.686
.model flat
public _konwertuj
.code
_konwertuj proc
	;liczba w [ebp+8]
	push ebp
	mov ebp,esp
	mov eax,[ebp+8]
	xor ecx,ecx
	;odpowiedz do ecx
	bt eax,15
	jnc dalej
		mov ecx,80000000H
	dalej:
	;wykladnik do edx
	mov edx,eax
	shl edx,17
	shr edx,17
	shr edx,10;wykladnik
	sub edx,15
	add edx,127
	shl edx,23
	or ecx,edx
	shl ax,6
	shr ax,6;sama mantysa w ax tylko dopasowac ja do floata czyli 13 w lewo
	shl eax,13
	or eax,ecx
	finit 
	push eax
	fld dword ptr [esp]
	pop eax
	pop ebp
	ret
_konwertuj endp
end