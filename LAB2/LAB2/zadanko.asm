.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
extern _MessageBoxA@16 : PROC
public _main
.data
	tekst_pocz db 10, 'Proszê napisaæ jakiœ tekst '
	db 'i nacisnac Enter', 10
	koniec_t db ?
	magazyn db 80 dup (?)
	nowa_linia db 10
	liczba_znakow dd ?
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
	 call __read ; czytanie znaków z klawiatury
	 add esp, 12 ; usuniecie parametrów ze stosu

	; liczba wprowadzonych znaków
	 mov liczba_znakow, eax
	 mov ecx, eax    ; licznik znaków
	 mov ebx, 0      ; indeks pocz¹tkowy
	 mov esi, 0      ; licznik d³ugoœci aktualnego wyrazu

ptl:
	 mov dl, magazyn[ebx] ; pobranie kolejnego znaku
	 cmp dl,' '
	 je koniec_wyrazu_spacja
	 cmp dl,10
	 je koniec_wyrazu

	 cmp dl,'0'
	 jb dalej
	 cmp dl,'9'
	 ja szukaj_duzych
	 mov magazyn[ebx],'_'
	 jmp reset

szukaj_duzych:
	 cmp dl, 'A'
	 jb reset
	 cmp dl, 'Z'
	 ja szukaj_malych

	 jmp zwieksz_dlugosc
szukaj_malych:
	 cmp dl, 'a'
	 jb reset
	 cmp dl, 'z'
	 jbe zwieksz_dlugosc

	 jmp reset

zwieksz_dlugosc:
	 inc esi  ; inkrementacja d³ugoœci wyrazu
	 jmp dalej

koniec_wyrazu_spacja:
	  mov magazyn[ebx],'!'

koniec_wyrazu:
	 cmp esi, 3
	 jbe reset
	 mov edi, ebx
	 sub edi, esi
  ; ustalenie poczatku
zamien_na_gwiazdke:
	 cmp esi, 0
	 je reset
	 mov magazyn[edi], '*'
	 inc edi
	 dec esi
	 jmp zamien_na_gwiazdke

reset:
	 mov esi, 0 ; reset dlugosci

dalej:
	 inc ebx
	 loop ptl

	; wyœwietlenie przekszta³conego tekstu
	 push liczba_znakow
	 push OFFSET magazyn
	 push 1
	 call __write ; wyœwietlenie przekszta³conego tekstu
	 add esp, 12 ; usuniecie parametrów ze stosu

	 push 0 ; sta³a MB_OK
        ; adres obszaru zawieraj¹cego tytu³
     push OFFSET magazyn
        ; adres obszaru zawieraj¹cego tekst
     push OFFSET magazyn
     push 0 ; NULL
     call _MessageBoxA@16
     add esp, 16 ; usuniêcie parametrów ze stosu
	 ; zakoñczenie programu

	 push 0
	 call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END
