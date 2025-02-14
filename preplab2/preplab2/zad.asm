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
    male1250 db 185,230,234,179,241,243,156,159,191 ;1250 jest dla MessageBoxA
    duze1250 db 165,198,202,163,209,211,140,143,175
.code
_main PROC
    ; wy�wietlenie tekstu informacyjnego
    ; liczba znak�w tekstu
    mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz) ; fajny spos�b na liczenie ilo�ci znak�w
    push ecx
    push OFFSET tekst_pocz ; adres tekstu
    push 1 ; nr urz�dzenia (tu: ekran - nr 1)
    call __write ; wy�wietlenie tekstu pocz�tkowego
    add esp, 12 ; usuni�cie parametr�w ze stosu
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
    dec eax ;zeby nie ogarnialo ostatniego entera
    mov liczba_znakow, eax
    ; rejestr ECX pe�ni rol� licznika obieg�w p�tli
    mov ecx, eax
    mov ebx, 0 ; indeks pocz�tkowy
ptl:
    mov dl, magazyn[ebx] ; pobranie kolejnego znaku
    ; Sprawdzamy, czy znak jest ma�� liter� ASCII
    cmp dl, 'A'
    jb zamien_na_gwiazdke ; skok, gdy znak nie wymaga zamiany
    cmp dl, 'Z'
    ja szukaj_malych_liter ; skok, gdy znak nie wymaga zamiany
    add dl, 20H ; zamiana na male litery
    ; odes�anie znaku do pami�ci
    mov magazyn[ebx], dl
    jmp dalej

szukaj_malych_liter:
    cmp dl,'a' ;tu jestem tylko gdy to nie sa litery A-Z 
    jb zamien_na_gwiazdke
    cmp dl, 'z'
    ja sprawdz_ogonki
    sub dl, 20H ; male zamienione na duze
    mov magazyn[ebx], dl
    jmp dalej

zamien_na_gwiazdke:
    mov dl,42
    mov magazyn[ebx], dl
    jmp dalej

sprawdz_ogonki: 
    ; Sprawdzanie znak�w z ogonkami
    mov esi, 0
petla_ogonki:
    cmp dl, malelatin[esi] ; por�wnujemy z liter� z tablicy ma�ych liter z ogonkami
    je zamien_male_ogonki ; je�li znak pasuje, przechodzimy do zamiany
    cmp dl, duzelatin[esi] ; jezeli jest duza z ogonkiem to trzeba zmienic na odpowiednik
    je zamien_duze_ogonki ; jezeli to duza z ogonkiem to na mala
    inc esi
    cmp esi, 9 ; mamy 9 znak�w z ogonkami
    jne petla_ogonki
    jmp zamien_na_gwiazdke ; je�li nie znaleziono pasuj�cego znaku, zamieniamy na gwiazdke wszystko powyzej 'z'

zamien_male_ogonki:
    mov dl, duze1250[esi] ; zamiana na wielk� liter� z ogonkiem
    mov magazyn[ebx], dl
    jmp dalej ; wazny jump zeby nie wraca�o bo juz zmienilo

zamien_duze_ogonki:
    mov dl, male1250[esi]
    mov magazyn[ebx], dl
    jmp dalej

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
