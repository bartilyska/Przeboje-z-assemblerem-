.686
.model flat
extern __write : PROC
extern _MessageBoxA@16 : PROC
extern _MessageBoxW@16 : PROC
extern _ExitProcess@4 : PROC
extern __read : PROC
public _main
.data
	znaki db 12 dup (?) ; deklaracja do przechowywania tworzonych cyfr
	ciag dw 12 dup (?) ;do messageboxW
	obszar db 12 dup (?)
	dziesiec dd 10 ; mno�nik
	dekoder db '0123456789ABCDEFG'
	siedemnascie dd 17
.code

wczytaj_do_EAX PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp
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
	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX ENDP

wczytaj_do_EAX_17 PROC
	; wczytywanie liczby 17 z klawiatury � liczba po
	; konwersji na posta� binarn� zostaje wpisana do rejestru EAX
	; po wprowadzeniu ostatniej cyfry nale�y nacisn�� klawisz
	; Enter
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp
	; rezerwacja 12 bajt�w na stosie przeznaczonych na tymczasowe
	; przechowanie cyfr szesnastkowych wy�wietlanej liczby
	sub esp, 12 ; rezerwacja poprzez zmniejszenie ESP
	mov esi, esp ; adres zarezerwowanego obszaru pami�ci
	push dword PTR 10 ; max ilo�� znak�w wczytyw. liczby
	push esi ; adres obszaru pami�ci
	push dword PTR 0; numer urz�dzenia (0 dla klawiatury)
	call __read ; odczytywanie znak�w z klawiatury
	; (dwa znaki podkre�lenia przed read)
	add esp, 12 ; usuni�cie parametr�w ze stosu
	mov eax, 0 ; dotychczas uzyskany wynik
	pocz_konw:
	mov dl, [esi] ; pobranie kolejnego bajtu
	inc esi ; inkrementacja indeksu
	cmp dl, 10 ; sprawdzenie czy naci�ni�to Enter
	je gotowe ; skok do ko�ca podprogramu
	; sprawdzenie czy wprowadzony znak jest cyfr� 0, 1, 2 , ..., 9
	cmp dl, '0'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, '9'
	ja sprawdzaj_dalej
	sub dl, '0' ; zamiana kodu ASCII na warto�� cyfry
	dopisz:
	movzx ecx,dl ;wazne bo jak do edx zapisuje sie starsza czesc mnozenia czyli bylo by zerowane
	mul dword PTR siedemnascie 
	add eax,ecx
	jmp pocz_konw ; skok na pocz�tek p�tli konwersji
	; sprawdzenie czy wprowadzony znak jest cyfr� A, B, ..., F
	sprawdzaj_dalej:
	cmp dl, 'A'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'G'
	ja sprawdzaj_dalej2
	sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
	jmp dopisz
	; sprawdzenie czy wprowadzony znak jest cyfr� a, b, ..., f
	sprawdzaj_dalej2:
	cmp dl, 'a'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'g'
	ja pocz_konw ; inny znak jest ignorowany
	sub dl, 'a' - 10
	jmp dopisz
	gotowe:
	; zwolnienie zarezerwowanego obszaru pami�ci
	add esp, 12
	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX_17 ENDP

wyswietl_EAX_17 PROC
		pusha
		mov esi, 10 ; indeks w tablicy 'znaki'
		mov ebx, 17 ; dzielnik r�wny 17
		; konwersja na kod ASCII
	konwersja:
		mov edx, 0 ; zerowanie starszej czesci dzielnej
		div ebx ; dzielenie przez 17, reszta w EDX  iloraz w EAX
		cmp dl, 9
		ja litera
			add dl, '0' ; zamiana reszty z dzielenia na kod ASCII
			jmp dalej
		litera:
			add dl,'A' - 10
		dalej:
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

		push 0 ; parameter uType
		push OFFSET znaki ; adres ci�gu znak�w stanowi�cych nag��wek komunikatu
		push OFFSET znaki ; adres ci�gu znak�w stanowi�cych tre�� komunikatu
		push 0 ; uchwyt
		call _MessageBoxA@16 ; skok do podprogramu systemowego MessageBox
		; w przypadku �a�cuch�w w Unicode call _MessageBoxW@16
		
		mov esi, 0
		mov edi, 0
		petl:
			mov dx,0
			mov dl,znaki[esi]
			mov ciag[edi],dx
			inc esi
			add edi,2
			cmp esi,12
			jne petl
		popa

		push 0 ; parameter uType
		push OFFSET ciag ; adres ci�gu znak�w stanowi�cych nag��wek komunikatu
		push OFFSET ciag ; adres ci�gu znak�w stanowi�cych tre�� komunikatu
		push 0 ; uchwyt
		call _MessageBoxW@16 ; skok do podprogramu systemowego MessageBox
		; w przypadku �a�cuch�w w Unicode call _MessageBoxW@16
		ret
wyswietl_EAX_17 ENDP

wyswietl_EAX_hex PROC
	; wy�wietlanie zawarto�ci rejestru EAX
	; w postaci liczby szesnastkowej
	pusha ; przechowanie rejestr�w

	; rezerwacja 12 bajt�w na stosie (poprzez zmniejszenie
	; rejestru ESP) przeznaczonych na tymczasowe przechowanie
	; cyfr szesnastkowych wy�wietlanej liczby
	sub esp, 12
	mov edi, esp ; adres zarezerwowanego obszaru
	; pami�ci
	; przygotowanie konwersji
	mov ecx, 8 ; liczba obieg�w p�tli konwersji
	mov esi, 1 ; indeks pocz�tkowy u�ywany przy
	; zapisie cyfr
	; p�tla konwersji
	ptl3hex:
		; przesuni�cie cykliczne (obr�t) rejestru EAX o 4 bity w lewo
		; w szczeg�lno�ci, w pierwszym obiegu p�tli bity nr 31 - 28
		; rejestru EAX zostan� przesuni�te na pozycje 3 - 0
		rol eax, 4
		; wyodr�bnienie 4 najm�odszych bit�w i odczytanie z tablicy
		; 'dekoder' odpowiadaj�cej im cyfry w zapisie szesnastkowym
		mov ebx, eax ; kopiowanie EAX do EBX
		and ebx, 0000000FH ; zerowanie bit�w 31 - 4 rej.EBX
		mov dl, dekoder[ebx] ; pobranie cyfry z tablicy
		; przes�anie cyfry do obszaru roboczego
		mov [edi][esi], dl
		inc esi ;inkrementacja modyfikatora
	loop ptl3hex ; sterowanie p�tl�
	; wpisanie znaku nowego wiersza przed i po cyfrach
	mov byte PTR [edi+0], 10
	mov byte PTR [edi+9], 10
	; wy�wietlenie przygotowanych cyfr
	push 10 ; 8 cyfr + 2 znaki nowego wiersza
	push edi ; adres obszaru roboczego
	push 1 ; nr urz�dzenia (tu: ekran)
	call __write ; wy�wietlenie

	; usuni�cie ze stosu 24 bajt�w, w tym 12 bajt�w zapisanych
	; przez 3 rozkazy push przed rozkazem call
	; i 12 bajt�w zarezerwowanych na pocz�tku podprogramu
	add esp, 24

	popa ; odtworzenie rejestr�w
	ret ; powr�t z podprogramu
wyswietl_EAX_hex ENDP

_main PROC
	mov ecx,eax
	xor ebx,ebx
	sub ebx,1
	mov ebx,0
	call wczytaj_do_EAX_17
	add eax,10
	call wyswietl_EAX_17
	push 0
	call _ExitProcess@4
_main ENDP

END