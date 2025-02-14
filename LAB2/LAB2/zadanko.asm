.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)
extern _MessageBoxA@16 : PROC
public _main
.data
	tekst_pocz db 10, 'Prosz� napisa� jaki� tekst '
	db 'i nacisnac Enter', 10
	koniec_t db ?
	magazyn db 80 dup (?)
	nowa_linia db 10
	liczba_znakow dd ?
.code
_main PROC
	; wy�wietlenie tekstu informacyjnego
	; liczba znak�w tekstu
	 mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
	 push ecx
	 push OFFSET tekst_pocz ; adres tekstu
	 push 1 ; nr urz�dzenia (tu: ekran - nr 1)
	 call __write ; wy�wietlenie tekstu pocz�tkowego
	 add esp, 12 ; usuniecie parametr�w ze stosu

	; czytanie wiersza z klawiatury
	 push 80 ; maksymalna liczba znak�w
	 push OFFSET magazyn
	 push 0 ; nr urz�dzenia (tu: klawiatura - nr 0)
	 call __read ; czytanie znak�w z klawiatury
	 add esp, 12 ; usuniecie parametr�w ze stosu

	; liczba wprowadzonych znak�w
	 mov liczba_znakow, eax
	 mov ecx, eax    ; licznik znak�w
	 mov ebx, 0      ; indeks pocz�tkowy
	 mov esi, 0      ; licznik d�ugo�ci aktualnego wyrazu

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
	 inc esi  ; inkrementacja d�ugo�ci wyrazu
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

	; wy�wietlenie przekszta�conego tekstu
	 push liczba_znakow
	 push OFFSET magazyn
	 push 1
	 call __write ; wy�wietlenie przekszta�conego tekstu
	 add esp, 12 ; usuniecie parametr�w ze stosu

	 push 0 ; sta�a MB_OK
        ; adres obszaru zawieraj�cego tytu�
     push OFFSET magazyn
        ; adres obszaru zawieraj�cego tekst
     push OFFSET magazyn
     push 0 ; NULL
     call _MessageBoxA@16
     add esp, 16 ; usuni�cie parametr�w ze stosu
	 ; zako�czenie programu

	 push 0
	 call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END
