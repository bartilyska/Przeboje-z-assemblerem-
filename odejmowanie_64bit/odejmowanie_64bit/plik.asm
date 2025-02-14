.686
.model flat
public _roznica
.code
_roznica PROC
	push ebp
	mov ebp,esp
	push ebx
	push esi
	push edi
	mov ecx,[ebp+20] ;ilosc
	mov edi,[ebp+16] ;wynikowa
	mov ebx,[ebp+12] ;odjemnik
	mov esi,[ebp+8] ;odjemna to sa dalej 4 bitowe adresy bo jestesmy w 32-bitowym
	petla:
		mov eax, dword ptr [esi]
		sub eax, dword ptr [ebx]
		mov dword ptr[edi] , eax
		mov dword ptr[edi+4] , 0
		add ebx,8
		add esi,8
		add edi,8
	loop petla
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_roznica ENDP
END