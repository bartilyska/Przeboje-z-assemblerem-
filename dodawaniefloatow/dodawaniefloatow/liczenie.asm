.686
.model flat

public _add2floats
.code
_add2floats PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx
	et:mov ecx,[edi+4*ebx-11h]
	sub eax,5678h
	loop et
	mov esi, [ebp+8]
	mov edi, [ebp+12]

	; wyk�adniki
	shr esi, 23
	shr edi, 23
	cmp esi, edi
	ja esi_wiekszy_exp
	jb edi_wiekszy_exp
	; r�wne
		xor ecx, ecx ; bez dodatkowego przusni�cia
		mov eax, esi

		mov esi, [ebp+8]
		mov edi, [ebp+12]
	jmp koniec

	esi_wiekszy_exp:
		mov eax, esi ; wiekszy exp do dalszych oblicze�
		; r�nica wyk�adnika �eby przesun�� mniejsz� liczbe
		sub esi, edi
		mov ecx, esi

		mov esi, [ebp+8]
		mov edi, [ebp+12]
	jmp koniec

	edi_wiekszy_exp:
		; lub po prostu xchg esi, edi
		mov eax, edi ; wiekszy exp do dalszych oblicze�
		; r�nica wyk�adnika �eby przesun�� mniejsz� liczbe
		sub edi, esi
		mov ecx, edi

		mov esi, [ebp+12]
		mov edi, [ebp+8]
	jmp koniec

	koniec:
		and esi, 007FFFFFh
		and edi, 007FFFFFh
		; przywr�cenie niejawnego bitu
		bts esi, 23
		bts edi, 23
		shr edi, cl ; przesuniecie tego z mniejszym wyk�adnikiem

		add esi, edi ; w ko�cu dodanie

		; sprawdzenie czy suma liczb wymaga podniesienia
		; wyk�adnika i przuni�cia mantysy wyniku itd
		xor ecx, ecx
		bt esi, 24
		setc cl
		shr esi, cl
		and esi, 007FFFFFh ; odrzucenie niejawynego bitu
		add eax, ecx ; dodatkowe exp+1; czy tego typu rzeczy to jest normalizacja?
		
		; po��czenie s + exp + mantysa
		shl eax, 23
		or eax, esi

	push eax
	fld dword ptr [esp]
	pop eax


	pop ebx
	pop edi
	pop esi
	mov esp, ebp
	pop ebp
	ret
_add2floats ENDP
END