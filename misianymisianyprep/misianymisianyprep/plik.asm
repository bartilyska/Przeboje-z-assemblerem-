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
	mov esi,[ebp+8] ;odjemna
	petla:
		mov eax, dword ptr [esi]
		sub eax, dword ptr [ebx]
		mov dword ptr[edi] , eax
		add ebx,4
		add esi,4
		add edi,4
	loop petla
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_roznica ENDP
END