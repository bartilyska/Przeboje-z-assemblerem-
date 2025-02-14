.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)
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

	; Logika zamiany liter w wyrazach d�u�szych ni� 3 znaki na '*'
	 mov ecx, eax    ; licznik znak�w
	 mov ebx, 0      ; indeks pocz�tkowy
	 mov esi, 0      ; licznik d�ugo�ci aktualnego wyrazu

ptl:
	 mov dl, magazyn[ebx] ; pobranie kolejnego znaku

	 ; Sprawdzenie, czy znak jest liter� (ma�� lub wielk�)
	 cmp dl, 'a'
	 jb check_end_of_word
	 cmp dl, 'z'
	 jbe increment_word_length
	 cmp dl, 'A'
	 jb check_end_of_word
	 cmp dl, 'Z'
	 ja check_end_of_word

increment_word_length:
	 inc esi  ; inkrementacja d�ugo�ci wyrazu
	 jmp next_char

check_end_of_word:
	 ; Zamiana liter w wyrazach d�u�szych ni� 3 znaki
	 cmp esi, 3
	 jbe reset_word_length

	 ; P�tla zamiany liter w wyrazie na '*'
	 mov edi, ebx
	 sub edi, esi
	; add edi, 1      ; ustalenie pocz�tku wyrazu
replace_with_star:
	 cmp esi, 0
	 je reset_word_length
	 mov magazyn[edi], '*'
	 inc edi
	 dec esi
	 jmp replace_with_star

reset_word_length:
	 mov esi, 0 ; reset d�ugo�ci aktualnego wyrazu

next_char:
	 inc ebx
	 loop ptl

	; wy�wietlenie przekszta�conego tekstu
	 push liczba_znakow
	 push OFFSET magazyn
	 push 1
	 call __write ; wy�wietlenie przekszta�conego tekstu
	 add esp, 12 ; usuniecie parametr�w ze stosu

	; zako�czenie programu
	 push 0
	 call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END
