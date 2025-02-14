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
    magazyn db 160 dup (0) ; w magazynie beda dalej zera wiec jak wyjdziemy z szukaniem /t nic nie bedzie
    wynik dw 160 dup(?)
    nowa_linia db 10
    liczba_znakow dd ?
    ;             ¹    æ    ê    ³    ñ    ó  œ  Ÿ   ¿
    malelatin db 165, 134, 169, 136,228,162,152,171,190
    duzelatin db 164, 143, 168, 157, 227,224,151,141,189
    maleUTF16 dw 0105h,0107h,0119h,0142h,0144h,00F3h,015BH,017AH,017CH
    duzeUTF16 dw 0104H,0106H,0118H,0141H,0143H,00D3H,015AH,0179H,017BH
.code
_main PROC
    ; wyœwietlenie tekstu informacyjnego
    ; liczba znaków tekstu
    mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz); fajny sposób na liczenie iloœci znaków
    push ecx
    push OFFSET tekst_pocz ; adres tekstu
    push 1 ; nr urz¹dzenia (tu: ekran - nr 1)
    call __write ; wyœwietlenie tekstu pocz¹tkowego
    add esp, 12 ; usuniêcie parametrów ze stosu
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
    mov ebx, 0 ; indeks wejscia
    mov edi, 0 ; indeks wyjscia
ptl:
    mov edx, 0 
    mov dl, magazyn[ebx] ; pobranie kolejnego znaku
    cmp dl,'/'
    jne nieznaleziono
    inc ebx
    mov dl,magazyn[ebx]
    cmp dl, 't'
    jne cofnijznak
    ;udalo sie znalezc /t 
    ;wstaw 5 kropek, zmien ecx bo o raz mniej bedzie i zrownowaz edi
    dec ecx
    mov wynik[edi],002Eh ; wstaw kropke
    add edi,2
     mov wynik[edi],002Eh ; wstaw kropke
    add edi,2
     mov wynik[edi],002Eh ; wstaw kropke
    add edi,2
     mov wynik[edi],002Eh ; wstaw kropke
    add edi,2
     mov wynik[edi],002Eh ; wstaw kropke
     jmp dalej
     ; add edi,2 ostatnie jest w etykiecie dalej
cofnijznak: 
       dec ebx
       mov dl,magazyn[ebx]
nieznaleziono:    mov esi, 0
    ; Sprawdzanie znaków z ogonkami
petla_lac:
    cmp dl, malelatin[esi] ; porównujemy z liter¹ z tablicy ma³ych liter z ogonkami
    je zamienmale_lac ; jeœli znak pasuje, przechodzimy do zamiany
    cmp dl, duzelatin[esi]
    je zamienduze_lac
    inc esi ; esi trzeba tez zwiekszac 
    cmp esi, 9 ; mamy 9 znaków z ogonkami
    jne petla_lac
    mov wynik[edi],dx
    jmp dalej ; jeœli nie znaleziono pasuj¹cego znaku, przechodzimy dalej

zamienmale_lac:
    mov dx, maleUTF16[2*esi] ; zamiana na literê z ogonkiem TUTAJ ZMIENIAC FORMAT TYCH OGONKOW
    mov wynik[edi], dx ;jezeli UTF16 to pamietac *2 przez dw
    jmp dalej

zamienduze_lac:
    mov dx,duzeUTF16[2*esi]
    mov wynik[edi], dx
    jmp dalej

dalej:
    inc ebx ; inkrementacja indeksu
    add edi,2 ;edi co dwa bo dw
    dec ecx
    jnz ptl

    push 0 ; sta³a MB_OK
        ; adres obszaru zawieraj¹cego tytu³
    push OFFSET wynik
        ; adres obszaru zawieraj¹cego tekst
    push OFFSET wynik
    push 0 ; NULL
    call _MessageBoxW@16
    add esp, 16 ; usuniêcie parametrów ze stosu
    push 0
    call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END
