.686
.model flat

Comment |
W 48-bajtowej tablicy bufor znajduje siê tekst np. "Po³¹czenia kolejowo – autobusowe"
zakodowany w formacie UTF-8. W tekœcie wystêpuj¹ tak¿e symbole parowozu i autobusu. 
Napisaæ program w asemblerze, który wyœwietli ten tekst na ekranie w postaci komunikatu typu MessageBoxW. 
W poni¿szej tablicy wystêpuj¹ ci¹gi UTF-8  1-, 2-, 3 i 4-bajtowe
| 



dlugosc equ 48

extern _MessageBoxA@16 : PROC
extern _MessageBoxW@16 : PROC
extern _ExitProcess@4 : PROC

.code 
 _main PROC
 ;push 4
 ;push OFFSET tytul
 ;push OFFSET tekst
 ;push 0   ; NULL  
 ;call _MessageBoxA@16

 ; konwersja ASCII na utf-16
 MOV esi,0  ; ustawienie indeksów na obszar wejœciowy i wyjœciowy
 mov edi,0
 mov ecx,dlugosc  ; liczba powtórzeñ pêtli
 
 et:
	movzx eax,bufor[esi]		; odczyt znaku ASCII
	add esi,1			    ; przesuniêcie indeksu na nastêpny znak z wejœcia
	cmp al,7fh		; sprawdzenie czy znak utf-8 jest jednobajtowy
	ja   znak_utf8_wielobajtowy
	; analiza znaku jednobajtowego
	mov output[edi],ax		; zapis znaku w UTF-16
	add edi,2				; przesuniêcie indeksu w buforze wyjœciowym
	jmp koniec

znak_utf8_wielobajtowy:
	bt ax,5  ; sprawdzenie czy znak jest dwubajtowy
	jc   znak_3_lub_4_bajtowy
	; znak dwubajtowy
	mov ah,bufor[esi]
	add esi,1
	xchg ah,al   ; ax = 110xxxxx 10xxxxxx
	shl al,2
	shl ax,3
	shr ax,5  ; w ax punkt kodowy a jednoczeœnie znaku utf-16
	mov output[edi],ax		; zapis znaku w UTF-16
	add edi,2				; przesuniêcie indeksu w buforze wyjœciowym
	sub ecx,1
	jmp koniec

znak_3_lub_4_bajtowy:
	bt ax,4  ; sprawdzenie czy znak jest dwubajtowy
	jc   znak_4_bajtowy
	; znak trzybajtowy
	shl ax,8
	mov al,bufor[esi]
	add esi,1
	shl al,2
	shl eax,6
	mov al,bufor[esi]
	add esi,1
	shl al,2
    shr eax,2
	mov output[edi],ax		; zapis znaku w UTF-16
	add edi,2				; przesuniêcie indeksu w buforze wyjœciowym
	sub ecx,2
	jmp koniec

znak_4_bajtowy:
	; znak czterobajtowy
	shl ax,8
	mov al,bufor[esi]
	add esi,1
	shl al,2
	shl eax,6
	mov al,bufor[esi]
	add esi,1
	shl al,2
	shl eax,6
	mov al,bufor[esi]
	add esi,1
	shl al,2
	shr eax,2
	shl eax,11
	shr eax,11		; punkt kodowy dla znaku 4bajtowego w eax
	sub eax,10000H
	; eax = 0000 0000 0000 xxxx       xxxx xx yyyy yyyy yy
	; 110 110 xxxx xxxx xx     110 111 yyyy yyyy yy
	mov ebx,eax
	shl bx,6
	shr bx,6   ; 000000 yyyy yyyy yy
	add bx,1101110000000000b
	shr eax,10 ; eax = 00...00 xxxx xxxx xx
	shl ax,6
	shr ax,6   ; 000000 yyyy yyyy yy
	add ax,1101100000000000b


	mov output[edi],ax		; zapis starszej czêsci znaku w UTF-16
	add edi,2				; przesuniêcie indeksu w buforze wyjœciowym
	mov output[edi],bx		; zapis m³odszej czêœci znaku w UTF-16
	add edi,2				; przesuniêcie indeksu w buforze wyjœciowym
	sub ecx,3
	
koniec:
	sub ecx,1
	cmp ecx,0
	jnz et
	;loop et

 push 4
 push OFFSET output
 push OFFSET output
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

output  dw 48 dup (0),0 

END





