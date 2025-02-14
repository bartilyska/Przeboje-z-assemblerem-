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
    ;             �    �    �    �    �    �  �  �   �
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
    ; wy�wietlenie tekstu informacyjnego
    ; liczba znak�w tekstu
    mov ebx,1
    mov ecx,2
    call check_and_replace
    mov ebx,ecx
    mov ecx,ebx
    mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz); fajny spos�b na liczenie ilo�ci znak�w
    push ecx
    push OFFSET tekst_pocz ; adres tekstu
    push 1 ; nr urz�dzenia (tu: ekran - nr 1)
    call __write ; wy�wietlenie tekstu pocz�tkowego
    add esp, 12 ; usuni�cie parametr�w ze stosu
    mov eax, OFFSET tekst_pocz
    mov ebx,8
    mov edx,[eax][2][ebx][2]
    ; czytanie wiersza z klawiatury
    push 80 ; maksymalna liczba znak�w
    push OFFSET magazyn
    push 0 ; nr urz�dzenia (tu: klawiatura - nr 0)
    call __read ; czytanie znak�w z klawiatury
    add esp, 12 ; usuni�cie parametr�w ze stosu
    ; kody ASCII napisanego tekstu zosta�y wprowadzone
    ; do obszaru 'magazyn'
    ; funkcja read wpisuje do rejestru EAX liczb�
    ; wprowadzonych znak�w
    dec eax
    mov liczba_znakow, eax
    ; rejestr ECX pe�ni rol� licznika obieg�w p�tli
    mov ecx, eax
    mov ebx, 0 ; indeks pocz�tkowy
ptl:
    mov dl, magazyn[ebx] ; pobranie kolejnego znaku
    ; Sprawdzamy, czy znak jest ma�� liter� ASCII
    cmp dl, 'a'
    jb sprawdz_lac ; skok, gdy znak nie wymaga zamiany
    cmp dl, 'z'
    ja sprawdz_lac ; skok, gdy znak nie wymaga zamiany
    sub dl, 20H ; zamiana na wielkie litery
    ; odes�anie znaku do pami�ci
    mov magazyn[ebx], dl
    jmp dalej

sprawdz_lac: 
    ; Sprawdzanie znak�w z ogonkami
    mov esi, 0
petla_lac:
    cmp dl, malelatin[esi] ; por�wnujemy z liter� z tablicy ma�ych liter z ogonkami
    je zamien_lac ; je�li znak pasuje, przechodzimy do zamiany
    inc esi
    cmp esi, 9 ; mamy 9 znak�w z ogonkami
    jne petla_lac
    jmp dalej ; je�li nie znaleziono pasuj�cego znaku, przechodzimy dalej

zamien_lac:
    mov dl, duze1250[esi] ; zamiana na wielk� liter� z ogonkiem TUTAJ ZMIENIAC FORMAT TYCH OGONKOW
    mov magazyn[ebx], dl

dalej:
    inc ebx ; inkrementacja indeksu
    dec ecx
    jnz ptl
    ; wy�wietlenie przekszta�conego tekstu
    ;push liczba_znakow
    ;push OFFSET magazyn
    ;push 1
    ;call __write ; wy�wietlenie przekszta�conego tekstu
    ;boxA
    push 0 ; sta�a MB_OK
        ; adres obszaru zawieraj�cego tytu�
    push OFFSET magazyn
        ; adres obszaru zawieraj�cego tekst
    push OFFSET magazyn
    push 0 ; NULL
    call _MessageBoxA@16
    add esp, 16 ; usuni�cie parametr�w ze stosu
    push 0
    call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END
