.model flat

public main, _wyswietl_EAX
extern _MessageBoxW@16 : PROC
extern _MessageBoxA@16 : PROC
extern _ExitProcess@4 : PROC
Comment |
Napisa� podprogram w asemblerze �wyswietl_EAX�, kt�ry wy�wietli na ekranie 
zawarto�� rejestru EAX w postaci liczby dziesi�tnej. 
Zak�adamy, �e w rejestrze EAX znajduje si� 32-bitowa liczba binarna bez znaku.
Cyfry uzyskiwane w trakcie kolejnych dziele� nale�y zapisywa� w 12-bajtowym 
obszarze pami�ci zarezerwowanym na stosie. 
Podprogram jest podobny do opisanego w instrukcji laboratoryjnej do �w. 3 
(wersja A),  gdzie dane tymczasowe przechowywane s� w sekcji danych programu 
(nie na stosie).

Opracowany podprogram w��czy� do kompletnego programu w asemblerze, 
w kt�rym podprogram b�dzie kilkakrotnie wywo�ywany dla r�nych warto�ci 
argument�w.

| 

.data





	
.code
_wyswietl_EAX PROC
	push ebp
	mov ebp,esp
	sub esp,12   ; zmienna lokalna output
	push edi
	push esi
	push ebx
	mov eax,[ebp+8]
	
	mov edi,9
	mov ebx,10	
	
	;mov eax,0
powt:
	mov edx,0
	div ebx
	add edx,30h   ; '0'
	mov output[edi],dl

	dec edi
	cmp eax,0
	jne powt

	;mov ebx,offset output
	;add ebx,edi
	;add edi,1

	lea ebx,[output+edi+1]


	push 0
	push ebx
	push offset output
	push 0
	call _MessageBoxA@16

; wypisanie przy u�yciu zmiennej dynamicznej
	mov eax,[ebp+8]  ; argument

	

	mov ebx,10	
	
	;mov eax,0
	mov ecx,0
powt2:
	mov edx,0
	div ebx
	add edx,30h   ; '0'
	push edx
	inc ecx
	cmp eax,0
	jne powt2

	lea edi,[ebp-12]
	;mov edi,ebp
	;sub edi,12
powt3:
	pop edx
	mov [edi],dl
	inc edi
	loop powt3

	mov [edi], byte ptr 0 
	;mov ebx,offset output
	;add ebx,edi
	;add edi,1




	lea ebx,[ebp-12]


	push 0
	push ebx
	push ebx
	push 0
	call _MessageBoxA@16

	pop ebx
	pop esi
	pop edi
	add esp,12  ; likwidacja zmiennej lokalnej
	pop ebp
	ret
_wyswietl_EAX ENDP


main PROC  

	;mov eax,12345  ; iloraz = 1234 reszta 5  - +30h '0' -> 35h '5'
				   ; iloraz = 123  reszta 4
				   ; iloraz = 12  reszta 3
				   ; iloraz = 1  reszta 2
				   ; iloraz = 0  reszta 1
    push 12345
	call _wyswietl_EAX


	push 0
	call _ExitProcess@4

main ENDP

.data
tekst db '12345',0
output db 10 dup (' '),0
 END
