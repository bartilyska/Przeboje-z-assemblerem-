.686
.model flat
public _przestaw
public _abs_med
.code
_przestaw PROC
	push ebp ; zapisanie zawarto�ci EBP na stosie
	mov ebp,esp ; kopiowanie zawarto�ci ESP do EBP
	push ebx ; przechowanie zawarto�ci rejestru EBX

	mov ebx, [ebp+8] ;licz abs adres
	mov ecx, [ebp+12] ;liczba el

	petla:
		mov eax, [ebx]
		cmp eax,0
		jge kn
		neg eax
		mov dword ptr [ebx],eax
	kn:
		add ebx,4
	loop petla

	mov ebx, [ebp+8] ; adres tablicy tabl
	mov ecx, [ebp+12] ; liczba element�w tablicy
	dec ecx
	; wpisanie kolejnego elementu tablicy do rejestru EAX
	cmp ecx,0 ;ubezpiecznienie by ecx>0
	je koniec
	ptl: mov eax, [ebx]
		; por�wnanie elementu tablicy wpisanego do EAX z nast�pnym
		cmp eax, [ebx+4]
		jle gotowe ; skok, gdy nie ma przestawiania
		; zamiana s�siednich element�w tablicy
		mov edx, [ebx+4]
		mov [ebx], edx
		mov [ebx+4], eax
	gotowe:
	add ebx, 4 ; wyznaczenie adresu kolejnego elementu
	loop ptl ; organizacja p�tli
	koniec:
	pop ebx ; odtworzenie zawarto�ci rejestr�w
	pop ebp
	ret ; powr�t do programu g��wnego
_przestaw ENDP

_abs_med PROC
	push ebp ; zapisanie zawarto�ci EBP na stosie
	mov ebp,esp ; kopiowanie zawarto�ci ESP do EBP
	push ebx ; przechowanie zawarto�ci rejestru EBX

	mov ebx, [ebp+8]
	mov ecx, [ebp+12]
	xor eax,eax
	bt ecx,0 ;sprawdz czy parzysta
	jc nieparzysta
		;parzysta
		shr ecx,1
		mov eax,[ebx+4*ecx];dalszy element med
		add eax,[ebx+4*ecx-4];blizszy element med
		shr eax,1
	jmp koniec
	nieparzysta:
		shr ecx,1
		mov eax,[ebx+4*ecx];srodkowy
	koniec:
	pop ebx ; odtworzenie zawarto�ci rejestr�w
	pop ebp
	ret ; powr�t do programu g��wnego
_abs_med ENDP
 END