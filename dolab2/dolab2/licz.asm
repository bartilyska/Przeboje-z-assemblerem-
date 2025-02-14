.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
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

	; Logika zamiany liter w wyrazach d³u¿szych ni¿ 3 znaki na '*'
	 mov ecx, eax    ; licznik znaków
	 mov ebx, 0      ; indeks pocz¹tkowy
	 mov esi, 0      ; licznik d³ugoœci aktualnego wyrazu

ptl:
	 mov dl, magazyn[ebx] ; pobranie kolejnego znaku

	 ; Sprawdzenie, czy znak jest liter¹ (ma³¹ lub wielk¹)
	 cmp dl, 'a'
	 jb check_end_of_word
	 cmp dl, 'z'
	 jbe increment_word_length
	 cmp dl, 'A'
	 jb check_end_of_word
	 cmp dl, 'Z'
	 ja check_end_of_word

increment_word_length:
	 inc esi  ; inkrementacja d³ugoœci wyrazu
	 jmp next_char

check_end_of_word:
	 ; Zamiana liter w wyrazach d³u¿szych ni¿ 3 znaki
	 cmp esi, 3
	 jbe reset_word_length

	 ; Pêtla zamiany liter w wyrazie na '*'
	 mov edi, ebx
	 sub edi, esi
	; add edi, 1      ; ustalenie pocz¹tku wyrazu
replace_with_star:
	 cmp esi, 0
	 je reset_word_length
	 mov magazyn[edi], '*'
	 inc edi
	 dec esi
	 jmp replace_with_star

reset_word_length:
	 mov esi, 0 ; reset d³ugoœci aktualnego wyrazu

next_char:
	 inc ebx
	 loop ptl

	; wyœwietlenie przekszta³conego tekstu
	 push liczba_znakow
	 push OFFSET magazyn
	 push 1
	 call __write ; wyœwietlenie przekszta³conego tekstu
	 add esp, 12 ; usuniecie parametrów ze stosu

	; zakoñczenie programu
	 push 0
	 call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END
