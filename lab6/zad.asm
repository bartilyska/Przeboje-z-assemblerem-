; Program gwiazdki.asm
; Wyœwietlanie znaków * w takt przerwañ zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zakoñczenie programu po naciœniêciu klawisza 'x'
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;
.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy
;============================================================
; procedura obs³ugi przerwania zegarowego
obsluga_zegara PROC
; przechowanie u¿ywanych rejestrów
push ax
push bx
push cx
push dx
push es
; wpisanie adresu pamiêci ekranu do rejestru ES - pamiêæ
; ekranu dla trybu tekstowego zaczyna siê od adresu B8000H,
; jednak do rejestru ES wpisujemy wartoœæ B800H,
; bo w trakcie obliczenia adresu procesor ka¿dorazowo mno¿y
; zawartoœæ rejestru ES przez 16
inc cs:licznik_przerwan
cmp cs:licznik_przerwan, 2 ; zmienic na 18 by co sekunde
jb koniec
mov cs:licznik_przerwan, 0
mov ax, 0B800h ;adres pamiêci ekranu
mov es, ax
; zmienna 'licznik' zawiera adres bie¿¹cy w pamiêci ekranu
mov bx, cs:licznik
; przes³anie do pamiêci ekranu kodu ASCII wyœwietlanego znaku
; i kodu koloru: bia³y na czarnym tle (do nastêpnego bajtu)
cmp cs:poprzedni_znak,0
je continue
mov dx,bx
mov bx,cs:poprzednia_pozycja
dec bx
mov cl,cs:poprzedni_kolor
mov byte PTR es:[bx],cl
dec bx
mov cl,cs:poprzedni_znak
mov byte PTR es:[bx],cl
mov bx,dx
continue:
mov cl,byte PTR es:[bx] ;zapisz poprzedni znak
mov cs:poprzedni_znak,cl
mov cl,byte PTR es:[bx+1]
mov cs:poprzedni_kolor,cl
mov byte PTR es:[bx], '*' ; kod ASCII
mov byte PTR es:[bx+1], 00011110B ; kolor
; zwiêkszenie o 2 adresu bie¿¹cego w pamiêci ekranu
add bx,2
mov cs:poprzednia_pozycja,bx
; sprawdzenie czy adres bie¿¹cy osi¹gn¹³ koniec pamiêci ekranu
cmp bx,600
jb wysw_dalej ; skok gdy nie koniec ekranu
; wyzerowanie adresu bie¿¹cego, gdy ca³y ekran zapisany
mov bx, 0
;zapisanie adresu bie¿¹cego do zmiennej 'licznik'
wysw_dalej:
mov cs:licznik,bx
koniec:
; odtworzenie rejestrów
pop es
pop dx
pop cx
pop bx
pop ax
; skok do oryginalnej procedury obs³ugi przerwania zegarowego
jmp dword PTR cs:wektor8
; dane programu ze wzglêdu na specyfikê obs³ugi przerwañ
; umieszczone s¹ w segmencie kodu
poprzednia_pozycja dw 320
poprzedni_znak db 0
poprzedni_kolor db 0
licznik_przerwan dw 0 ;licznik przerwañ zegarowych
licznik dw 320 ; wyœwietlanie pocz¹wszy od 2. wiersza
wektor8 dd ?
obsluga_zegara ENDP
;============================================================
; program g³ówny - instalacja i deinstalacja procedury
; obs³ugi przerwañ
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
mov al, 0
mov ah, 5
int 10
mov ax, 0
mov ds,ax ; zerowanie rejestru DS
; odczytanie zawartoœci wektora nr 8 i zapisanie go
; w zmiennej 'wektor8' (wektor nr 8 zajmuje w pamiêci 4 bajty
; pocz¹wszy od adresu fizycznego 8 * 4 = 32)
mov eax,ds:[32] ; adres fizyczny 0*16 + 32 = 32
mov cs:wektor8, eax

; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
mov ax, SEG obsluga_zegara ; czêœæ segmentowa adresu
mov bx, OFFSET obsluga_zegara ; offset adresu
cli ; zablokowanie przerwañ
; zapisanie adresu procedury do wektora nr 8
mov ds:[32], bx ; OFFSET
mov ds:[34], ax ; cz. segmentowa
sti ;odblokowanie przerwañ
; oczekiwanie na naciœniêcie klawisza 'x'
aktywne_oczekiwanie:
mov ah,1
int 16H
; funkcja INT 16H (AH=1) BIOSu ustawia ZF=1 jeœli
; naciœniêto jakiœ klawisz
jz aktywne_oczekiwanie
; odczytanie kodu ASCII naciœniêtego klawisza (INT 16H, AH=0)
; do rejestru AL
mov ah, 0
int 16H
cmp al, 'x' ; porównanie z kodem litery 'x'
jne aktywne_oczekiwanie ; skok, gdy inny znak
; deinstalacja procedury obs³ugi przerwania zegarowego
; odtworzenie oryginalnej zawartoœci wektora nr 8

mov ax, 0B800h ;adres pamiêci ekranu
mov es, ax
mov dx,bx
mov bx,cs:poprzednia_pozycja
dec bx
mov cl,cs:poprzedni_kolor
mov byte PTR es:[bx],cl
dec bx
mov cl,cs:poprzedni_znak
mov byte PTR es:[bx],cl
mov bx,dx

mov eax, cs:wektor8
cli
mov ds:[32], eax ; przes³anie wartoœci oryginalnej
; do wektora 8 w tablicy wektorów
; przerwañ
sti
; zakoñczenie programu
mov al, 0
mov ah, 4CH
int 21H
rozkazy ENDS
nasz_stos SEGMENT stack
db 128 dup (?)
nasz_stos ENDS
END zacznij
