
.386
rozkazy SEGMENT use16 ;zmienne sa w segmencie kodu wiec odwolujemy sie do nich przez CS
ASSUME CS:rozkazy ;wymiary 80x25 = 2000 znakow
; podprogram 'wyswietl_AL' wy�wietla zawarto�� rejestru AL
; w postaci liczby dziesi�tnej bez znaku
wyswietl_AL PROC
; wy�wietlanie zawarto�ci rejestru AL na ekranie wg adresu
; podanego w ES:BX
; stosowany jest bezpo�redni zapis do pami�ci ekranu
; przechowanie rejestr�w
push ax
push bx
push cx
push dx
; Odczyt scancode z portu 60h
in al, 60h   
; Wpisanie adresu pami�ci ekranu do ES
mov bx, 0B800h ;adres pami�ci ekranu
mov es, bx
mov bx, 160 ; od drugiej linii

mov cl, 10 ; dzielnik
mov ah, 0 ; zerowanie starszej cz�ci dzielnej
; dzielenie liczby w AX przez liczb� w CL, iloraz w AL,
; reszta w AH (tu: dzielenie przez 10)
div cl
add ah, 30H ; zamiana na kod ASCII
mov es:[bx+4], ah ; cyfra jedno�ci
mov ah, 0
div cl ; drugie dzielenie przez 10
add ah, 30H ; zamiana na kod ASCII
mov es:[bx+2], ah ; cyfra dziesi�tek
add al, 30H ; zamiana na kod ASCII
mov es:[bx+0], al ; cyfra setek
; wpisanie kodu koloru (intensywny bia�y) do pami�ci ekranu
mov al, 00001111B
mov es:[bx+1],al
mov es:[bx+3],al
mov es:[bx+5],al
; odtworzenie rejestr�w
pop dx
pop cx
pop bx
pop ax
; skok do oryginalnej procedury obs�ugi przerwania zegarowego
jmp dword PTR cs:wektor9
wyswietl_AL ENDP
;============================================================
; program g��wny - instalacja i deinstalacja procedury
; obs�ugi przerwa�
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
wektor9 dd ?
mov al, 0
mov ah, 5
int 10
mov ax, 0
mov ds,ax ; zerowanie rejestru DS
mov eax,ds:[36] ; adres fizyczny (1+8) * 4 = 36
mov cs:wektor9, eax
; wpisanie do wektora nr 9 adresu procedury 'wyswietl_AL'
mov ax, SEG wyswietl_AL ; cz�� segmentowa adresu
mov bx, OFFSET wyswietl_AL ; offset adresu
cli ; zablokowanie przerwa�
; zapisanie adresu procedury do wektora nr 8
mov ds:[36], bx ; OFFSET
mov ds:[38], ax ; cz. segmentowa
sti ;odblokowanie przerwa�
czekaj_na_x:
    in al, 60h
    cmp al, 2Dh ; Kod scancode dla klawisza 'x'
    jne czekaj_na_x
mov eax, cs:wektor9
cli
mov ds:[36], eax
sti
mov ax, 4C00h
int 21h
rozkazy ENDS
nasz_stos SEGMENT stack
db 128 dup(?)
nasz_stos ENDS
END zacznij
