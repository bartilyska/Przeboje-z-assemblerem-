.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
extern _MessageBoxW@16 : PROC
public _main
.data
	tekst_pocz db 10, 'Proszê napisaæ jakiœ tekst '
	db 'i nacisnac Enter', 10
	koniec_t db ?
	magazyn db 80 dup (?)
	nowa_linia db 10
	liczba_znakow dd ?
	naUTF16 dw 40 dup (?)
	bezsamoglosek dw 40 dup (?)
	samogloski dw 'a','A','e','E','i','I','o','O','u','U' ; w UTF - 16 trzeba dw bo zapisane jako 00xx
.code
_main PROC
	; wyœwietlenie tekstu informacyjnego
	; liczba znaków tekstu
	 mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
	 push ecx
	 push OFFSET tekst_pocz ; adres tekstu
	 push 1 ; nr urz¹dzenia (tu: ekran - nr 1)
	 call __write ; wyœwietlenie tekstu pocz¹tkowego
	 add esp, 12 ; usuniecie parametrów ze stosu
	; czytanie wiersza z klawiatury
	 push 80 ; maksymalna liczba znaków
	 push OFFSET magazyn
	 push 0 ; nr urz¹dzenia (tu: klawiatura - nr 0)
	 call __read ; czytanie znaków z klawiatury LATIN 2
	 add esp, 12 ; usuniecie parametrów ze stosu
	; kody ASCII napisanego tekstu zosta³y wprowadzone
	; do obszaru 'magazyn'
	; funkcja read wpisuje do rejestru EAX liczbê
	; wprowadzonych znaków
	dec eax
	 mov liczba_znakow, eax
	; rejestr ECX pe³ni rolê licznika obiegów pêtli
	 mov ecx, eax
	 mov ebx, 0 ; indeks pocz¹tkowy
	 mov edx, 0
	ptl: 
	 mov dl, magazyn[ebx] ; pobranie kolejnego znaku
	 mov naUTF16[ebx*2], dx
	 inc ebx ; inkrementacja indeksu
	 loop ptl ; sterowanie pêtl¹
	 mov naUTF16[ebx*2],0D83Dh ;dodaj emotke
	 inc ebx
	 mov naUTF16[ebx*2],0DE0Eh
	 inc ebx
	push 0 ; stala MB_OK
	; adres obszaru zawieraj¹cego tytu³
	push OFFSET naUTF16
	; adres obszaru zawieraj¹cego tekst
	push OFFSET naUTF16
	push 0 ; NULL
	call _MessageBoxW@16
	add esp,16

	;usuniecie samoglosek
	mov ebx , 0 ;indeksuje glowny
	mov edi , 0 ; indeksuje wyjscie
	mov ecx,liczba_znakow ; na nowo liczba znakow w tekscie
	mov edx,0
	szuk:
		mov dx,naUTF16[ebx] ; pobranie znaku
		add ebx,2 ; +2 bo dw
		mov esi,0 ; szukaj w tablicy tego znaku
		szukaj_samogloski:
			cmp dx,samogloski[esi]
			je koniec ; znaleziono samogloske niedodawaj jej
			add esi,2 ; +2 bo dw
			cmp esi,20 ; mamy 10 samoglosek * 2 bo dw
		jne szukaj_samogloski
	;dodaj znak bo to nie samogloska
	mov bezsamoglosek[edi],dx
	add edi,2
	koniec:
	loop szuk

	push 0 ; stala MB_OK
	; adres obszaru zawieraj¹cego tytu³
	push OFFSET bezsamoglosek
	; adres obszaru zawieraj¹cego tekst
	push OFFSET bezsamoglosek
	push 0 ; NULL
	call _MessageBoxW@16
	add esp,16
	push 0
	call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END
