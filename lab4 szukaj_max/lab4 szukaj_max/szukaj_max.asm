.686
.model flat
public _szukaj_max
.code
_szukaj_max PROC
	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp, esp ; kopiowanie zawartoœci ESP do EBP
	push ebx
	push esi
	mov ecx, 3; tyle porownan trzeba zrobic dla 4 liczb
	mov esi, 2;indeks w obszarze danych zaczynamy od 2 bo 0 to ebp 1 to slad 
	mov eax, [ebp+4*esi] ; liczba u 4* bo int ma 4 bajty
	petla:
		inc esi
		mov ebx,[ebp+4*esi]
		cmp eax,ebx ;jesli eax wiekszy to nic nie rob jesli ebx wiekszy wstaw na eax
		jge koniecpetli
		mov eax,ebx
	koniecpetli:
	loop petla
	pop ebx
	pop esi
	pop ebp
	ret
	_szukaj_max ENDP
END