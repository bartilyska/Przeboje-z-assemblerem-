.686
.model flat

Comment |
W 48-bajtowej tablicy bufor znajduje si� tekst np. "Po��czenia kolejowo � autobusowe"
zakodowany w formacie UTF-8. W tek�cie wyst�puj� tak�e symbole parowozu i autobusu. 
Napisa� program w asemblerze, kt�ry wy�wietli ten tekst na ekranie w postaci komunikatu typu MessageBoxW. 
W poni�szej tablicy wyst�puj� ci�gi UTF-8  1-, 2-, 3 i 4-bajtowe
| 



dlugosc equ 17

extern _MessageBoxA@16 : PROC
extern _MessageBoxW@16 : PROC
extern _ExitProcess@4 : PROC

.code 
 _main PROC
 push 4
 push OFFSET tytul
 push OFFSET tekst
 push 0   ; NULL  
 call _MessageBoxA@16

 ; konwersja ASCII na utf-16
 MOV esi,0  ; ustawienie indeks�w na obszar wej�ciowy i wyj�ciowy
 mov edi,0
 mov ecx,dlugosc  ; liczba powt�rze� p�tli
 mov ah, 0	; wyzerowanie starszej cz��i znaku w UTF-16
 et:
	mov al,tekst[esi]		; odczyt znaku ASCII
	add esi,1			    ; przesuni�cie indeksu na nast�pny znak z wej�cia
	mov tekstW[edi],ax		; zapis znaku w UTF-16
	add edi,2				; przesuni�cie indeksu w buforze wyj�ciowym
	loop et

 push 4
 push OFFSET tytulW
 push OFFSET tekstW
 push 0   ; NULL  
 call _MessageBoxW@16

 push  0  ; kod powrotu
 call _ExitProcess@4
 _main ENDP

.data
a  dd ? 
tekst   db "Czy lubisz  AKO?",0
caption   db "Pytanie",0


liczba dw  30h
	   db 30h
	   db 0AAh
l_x	   dw 'AB'
	   dd 414243h

tekstW   dw  dlugosc dup (0)
captionW   dw 'P','y','t','a','n','i','e',0


.data
; bufor ze znakami wej�ciowymi w utf-8
bufor	db	50H, 6FH, 0C5H, 82H, 0C4H, 85H, 63H, 7AH, 65H, 6EH, 69H, 61H, 20H 
		db	0F0H, 9FH, 9AH, 82H   ; parow�z
		db	20H, 20H, 6BH, 6FH, 6CH, 65H, 6AH, 6FH, 77H, 6FH, 20H
		db	0E2H, 80H, 93H ; p�pauza
		db	20H, 61H, 75H, 74H, 6FH, 62H, 75H, 73H, 6FH, 77H, 65H, 20H, 20H
		db	0F0H,  9FH,  9AH,  8CH ; autobus


END





