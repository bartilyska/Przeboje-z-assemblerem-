.686
.model flat

Comment |
W 48-bajtowej tablicy bufor znajduje siê tekst np. "Po³¹czenia kolejowo – autobusowe"
zakodowany w formacie UTF-8. W tekœcie wystêpuj¹ tak¿e symbole parowozu i autobusu. 
Napisaæ program w asemblerze, który wyœwietli ten tekst na ekranie w postaci komunikatu typu MessageBoxW. 
W poni¿szej tablicy wystêpuj¹ ci¹gi UTF-8  1-, 2-, 3 i 4-bajtowe
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
 MOV esi,0  ; ustawienie indeksów na obszar wejœciowy i wyjœciowy
 mov edi,0
 mov ecx,dlugosc  ; liczba powtórzeñ pêtli
 mov ah, 0	; wyzerowanie starszej czêœæi znaku w UTF-16
 et:
	mov al,tekst[esi]		; odczyt znaku ASCII
	add esi,1			    ; przesuniêcie indeksu na nastêpny znak z wejœcia
	mov tekstW[edi],ax		; zapis znaku w UTF-16
	add edi,2				; przesuniêcie indeksu w buforze wyjœciowym
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
; bufor ze znakami wejœciowymi w utf-8
bufor	db	50H, 6FH, 0C5H, 82H, 0C4H, 85H, 63H, 7AH, 65H, 6EH, 69H, 61H, 20H 
		db	0F0H, 9FH, 9AH, 82H   ; parowóz
		db	20H, 20H, 6BH, 6FH, 6CH, 65H, 6AH, 6FH, 77H, 6FH, 20H
		db	0E2H, 80H, 93H ; pó³pauza
		db	20H, 61H, 75H, 74H, 6FH, 62H, 75H, 73H, 6FH, 77H, 65H, 20H, 20H
		db	0F0H,  9FH,  9AH,  8CH ; autobus


END





