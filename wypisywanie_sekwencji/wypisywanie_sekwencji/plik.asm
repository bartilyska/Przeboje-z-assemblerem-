.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC
extern __read : PROC
public _main
.data
	znaki db 12 dup (?) ; deklaracja do przechowywania tworzonych cyfr
	obszar db 12 dup (?)
	dziesiec dd 10 ; mno¿nik
	znak db ' '
.code

wczytaj_do_EAX PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp
	; max iloœæ znaków wczytywanej liczby
	push dword PTR 12
	push dword PTR OFFSET obszar ; adres obszaru pamiêci
	push dword PTR 0; numer urz¹dzenia (0 dla klawiatury)
	call __read ; odczytywanie znaków z klawiatury
	; (dwa znaki podkreœlenia przed read)
	add esp, 12 ; usuniêcie parametrów ze stosu
	; bie¿¹ca wartoœæ przekszta³canej liczby przechowywana jest
	; w rejestrze EAX; przyjmujemy 0 jako wartoœæ pocz¹tkow¹
	mov eax, 0 ; w eaxie wczesniej byla by liczba  znakow wczytanych temu trzeba wyzerowac
	mov ebx, OFFSET obszar ; adres obszaru ze znakami
	pobieraj_znaki:
		mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie ASCII
		inc ebx ; zwiêkszenie indeksu
		cmp cl,10 ; sprawdzenie czy naciœniêto Enter
		je byl_enter ; skok, gdy naciœniêto Enter
		sub cl, 30H ; zamiana kodu ASCII na wartoœæ cyfry
		movzx ecx, cl ; przechowanie wartoœci cyfry w rejestrze ECX
		; mno¿enie wczeœniej obliczonej wartoœci razy 10
		mul dword PTR dziesiec	
		add eax, ecx ; dodanie ostatnio odczytanej cyfry
		jmp pobieraj_znaki ; skok na pocz¹tek pêt
	byl_enter:
	; wartoœæ binarna wprowadzonej liczby znajduje siê teraz w rejestrze EAX
	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX ENDP

ciag PROC
	pusha
	mov eax, 1 ; pierwszy element
	mov ecx, 0 ; licznik petli oraz argument do sumowania
	mov edx, 0 ; FLAG 0 - odejmowanie, 1 - dodawanie
	sprawdz:
		mov znak,' ' ;zeby znak nie byl ciagle na minusie
		call wyswietl_EAX
		inc ecx
		cmp dx, 0
		je odejmowanie
		jne dodawanie
	dodawanie:
		add eax, ecx ; dodajemy do EAX wartosc ECX
		xor dx, dx ; DX = 0 -> odejmowanie next
		cmp ecx, 30
		je koniec
		jne sprawdz
	odejmowanie:
		neg ecx ; negowanie ECX
		add eax, ecx
		neg ecx ;przywracanie stanu ecx
		inc dx
		cmp ecx, 30
		je koniec
		jne sprawdz
	koniec:
	popa
	ret
ciag ENDP

wyswietl_EAX PROC
		pusha
		rol eax, 1 ; rotacja bitow w lewo by sprawdzic bit znaku
		jnc dodatnia ; w carry jest 0 jesli dodatnia 1 jesli ujemna
		mov znak, '-' ; dodanie - do outputu
		ror eax, 1 ; powrot do oryginalnej liczby
		neg eax ;robimy dodatnia bo mamy juz minus
		jmp przedKonwersja

	dodatnia:
		ror eax, 1 ;wroc do stanu normalnego liczby bo uzyte bylo rol

	przedKonwersja:
		mov esi, 10 ; indeks w tablicy 'znaki'
		mov ebx, 10 ; dzielnik równy 10
		; konwersja na kod ASCII
	konwersja:
		mov edx, 0 ; zerowanie starszej czesci dzielnej
		div ebx ; dzielenie przez 10, reszta w EDX  iloraz w EAX
		add dl, 30h ; zamiana reszty z dzielenia na kod ASCII
		mov znaki[esi], dl ; zapisanie cyfry w kodzie ASCII
		mov dl,znaki[si]
		dec esi ; zmniejszenie indeks
		cmp eax, 0 ; sprawdzenie czy iloraz = 0
		jne konwersja
		; wypelnienie pozostalych bajtow spacjami
		; znak liczby
		mov cl, znak
		mov znaki[esi], cl
		dec esi
	wypeln:
		or esi, esi
		jz wyswietl ; gdy indeks = 0
		mov byte PTR znaki[esi], 20h ; kod spacji
		dec esi
		jmp wypeln

	wyswietl:
		mov ecx,1 ;indeks po znakach
		mov edx,1 ;indeks po obszarze
	spacja:
		inc ecx
	przesuwanie:
		mov al, znaki[ecx]
		cmp al, ' '
		je spacja
		cmp al, 0Ah ;czy enter
		je koniec
	przepisz:
		mov obszar[edx], al
		inc edx
		inc ecx
		cmp ecx, 12
		jb przesuwanie
	koniec:
		mov byte PTR obszar[0], 0Ah ; kod nowego wiersza
		mov byte PTR obszar[11], 0Ah ; w zerowym i 11 indeksie sa newliny
		push dword PTR 12
		push dword PTR OFFSET obszar
		push dword PTR 1
		call __write
		add esp, 12
		popa
		ret
wyswietl_EAX ENDP

_main PROC
	;call wczytaj_do_EAX
	call ciag
	push 0
	call _ExitProcess@4

_main ENDP

END