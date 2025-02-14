.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC
extern __read : PROC
public _main
.data
	znaki db 12 dup (?) ; deklaracja do przechowywania tworzonych cyfr
	obszar db 12 dup (?)
	dziesiec dd 10 ; mno�nik
.code
wczytaj_do_EAX PROC
	push ebx
	push ecx
	push edx
	push esi
	; max ilo�� znak�w wczytywanej liczby
	push dword PTR 12
	push dword PTR OFFSET obszar ; adres obszaru pami�ci
	push dword PTR 0; numer urz�dzenia (0 dla klawiatury)
	call __read ; odczytywanie znak�w z klawiatury
	; (dwa znaki podkre�lenia przed read)
	add esp, 12 ; usuni�cie parametr�w ze stosu
	; bie��ca warto�� przekszta�canej liczby przechowywana jest
	; w rejestrze EAX; przyjmujemy 0 jako warto�� pocz�tkow�
	mov eax, 0 ; w eaxie wczesniej byla by liczba  znakow wczytanych temu trzeba wyzerowac
	mov ebx, OFFSET obszar ; adres obszaru ze znakami
	pobieraj_znaki:
		mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie ASCII
		inc ebx ; zwi�kszenie indeksu
		cmp cl,10 ; sprawdzenie czy naci�ni�to Enter
		je byl_enter ; skok, gdy naci�ni�to Enter
		sub cl, 30H ; zamiana kodu ASCII na warto�� cyfry
		movzx ecx, cl ; przechowanie warto�ci cyfry w rejestrze ECX
		; mno�enie wcze�niej obliczonej warto�ci razy 10
		mul dword PTR dziesiec	
		add eax, ecx ; dodanie ostatnio odczytanej cyfry
		jmp pobieraj_znaki ; skok na pocz�tek p�t
	byl_enter:
	; warto�� binarna wprowadzonej liczby znajduje si� teraz w rejestrze EAX
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX ENDP

wyswietl_EAX PROC
		pusha
		mov ecx,eax
		mul ecx
		mov esi, 10 ; indeks w tablicy 'znaki'
		mov ebx, 10 ; dzielnik r�wny 10
		; konwersja na kod ASCII
	konwersja:
		mov edx, 0 ; zerowanie starszej czesci dzielnej
		div ebx ; dzielenie przez 10, reszta w EDX  iloraz w EAX
		add dl, 30h ; zamiana reszty z dzielenia na kod ASCII
		mov znaki[esi], dl ; zapisanie cyfry w kodzie ASCII
		dec esi ; zmniejszenie indeks
		cmp eax, 0 ; sprawdzenie czy iloraz = 0
		jne konwersja
		; wypelnienie pozostalych bajtow spacjami
	wypeln:
		or esi, esi
		jz wyswietl ; gdy indeks = 0
		mov byte PTR znaki[esi], 20h ; kod spacji
		dec esi
		jmp wypeln
	wyswietl:
		mov byte PTR znaki[0], 0Ah ; kod nowego wiersza
		mov byte PTR znaki[11], 0Ah
		push dword PTR 12
		push dword PTR OFFSET znaki
		push dword PTR 1
		call __write
		add esp, 12
		popa
		ret
wyswietl_EAX ENDP

_main PROC
	xor ebx,ebx
	call wczytaj_do_EAX
	call wyswietl_EAX
	push 0
	call _ExitProcess@4

_main ENDP

END