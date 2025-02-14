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
    ;             ¹    æ    ê    ³    ñ    ó  œ  Ÿ   ¿
    malelatin db 165, 134, 169, 136,228,162,152,171,190
    duzelatin db 164, 143, 168, 157, 227,224,151,141,189
    male1250 db 185,230,234,179,241,243,156,159,191
    duze1250 db 165,198,202,163,209,211,140,143,175
.code

check_and_replace proc
    pop esi
    mov edi,[esi]
    ; Check for MOV opcode: 0x88 (byte) or 0x89 (word/dword)
    cmp byte ptr [edi], 088h
    je swap_mov
    cmp byte ptr [edi], 089h
    je swap_mov

    ; Check for LOOP instruction: 0xE2
    cmp byte ptr [edi], 0E2h
    je skip_loop

    jmp done                ; Exit if no modification

swap_mov:
    xor byte ptr [edi], 2   ; Flip the 'd' bit (bit 1)
    jmp done

skip_loop:
    add dword ptr [esi], 2  ; Skip LOOP instruction (2-byte instruction)
    push esi
done:
    ret
check_and_replace endp

_main PROC
    ; wyœwietlenie tekstu informacyjnego
    ; liczba znaków tekstu
    mov ebx,1
    mov ecx,2
    call check_and_replace
    mov ebx,ecx
    mov ecx,ebx
    mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz); fajny sposób na liczenie iloœci znaków
    push ecx
    push OFFSET tekst_pocz ; adres tekstu
    push 1 ; nr urz¹dzenia (tu: ekran - nr 1)
    call __write ; wyœwietlenie tekstu pocz¹tkowego
    add esp, 12 ; usuniêcie parametrów ze stosu
    mov eax, OFFSET tekst_pocz
    mov ebx,8
    mov edx,[eax][2][ebx][2]
    ; czytanie wiersza z klawiatury
    push 80 ; maksymalna liczba znaków
    push OFFSET magazyn
    push 0 ; nr urz¹dzenia (tu: klawiatura - nr 0)
    call __read ; czytanie znaków z klawiatury
    add esp, 12 ; usuniêcie parametrów ze stosu
    ; kody ASCII napisanego tekstu zosta³y wprowadzone
    ; do obszaru 'magazyn'
    ; funkcja read wpisuje do rejestru EAX liczbê
    ; wprowadzonych znaków
    dec eax
    mov liczba_znakow, eax
    ; rejestr ECX pe³ni rolê licznika obiegów pêtli
    mov ecx, eax
    mov ebx, 0 ; indeks pocz¹tkowy
ptl:
    mov dl, magazyn[ebx] ; pobranie kolejnego znaku
    ; Sprawdzamy, czy znak jest ma³¹ liter¹ ASCII
    cmp dl, 'a'
    jb sprawdz_lac ; skok, gdy znak nie wymaga zamiany
    cmp dl, 'z'
    ja sprawdz_lac ; skok, gdy znak nie wymaga zamiany
    sub dl, 20H ; zamiana na wielkie litery
    ; odes³anie znaku do pamiêci
    mov magazyn[ebx], dl
    jmp dalej

sprawdz_lac: 
    ; Sprawdzanie znaków z ogonkami
    mov esi, 0
petla_lac:
    cmp dl, malelatin[esi] ; porównujemy z liter¹ z tablicy ma³ych liter z ogonkami
    je zamien_lac ; jeœli znak pasuje, przechodzimy do zamiany
    inc esi
    cmp esi, 9 ; mamy 9 znaków z ogonkami
    jne petla_lac
    jmp dalej ; jeœli nie znaleziono pasuj¹cego znaku, przechodzimy dalej

zamien_lac:
    mov dl, duze1250[esi] ; zamiana na wielk¹ literê z ogonkiem TUTAJ ZMIENIAC FORMAT TYCH OGONKOW
    mov magazyn[ebx], dl

dalej:
    inc ebx ; inkrementacja indeksu
    dec ecx
    jnz ptl
    ; wyœwietlenie przekszta³conego tekstu
    ;push liczba_znakow
    ;push OFFSET magazyn
    ;push 1
    ;call __write ; wyœwietlenie przekszta³conego tekstu
    ;boxA
    push 0 ; sta³a MB_OK
        ; adres obszaru zawieraj¹cego tytu³
    push OFFSET magazyn
        ; adres obszaru zawieraj¹cego tekst
    push OFFSET magazyn
    push 0 ; NULL
    call _MessageBoxA@16
    add esp, 16 ; usuniêcie parametrów ze stosu
    push 0
    call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END
