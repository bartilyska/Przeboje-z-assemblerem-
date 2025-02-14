.686
.model flat
public _szukaj_max
.code
_szukaj_max PROC
	push ebp
	mov ebp,esp
	push ebx
	;ebp+12 n ebp+8 wskaznik na tablice
	mov ecx,[ebp+12]
	mov ebx,[ebp+8] ;ebx to wskaznnik na tablice
	mov edx,[ebx] ; w edx najwieksza wartosc w eax adres do zwrotu
	mov eax,ebx ; pierwszy element to na razie maximum
	dec ecx
	cmp ecx,0
	je koniec
	petla:
		add ebx,4;int ma 4 bajty
		cmp edx,[ebx]
		jge kontynuj
		mov eax,ebx
		mov edx,[ebx]
	kontynuj:
	loop petla
	koniec:
	pop ebx
	pop ebp
	ret
_szukaj_max ENDP
END