.686
.model flat


extern  _ExitProcess@4 : proc
extern _MessageBoxW@16 : proc
extern _MessageBoxA@16 : proc
Comment |
Napisa� podprogram w asemblerze �wyswietl_EAX�, kt�ry wy�wietli na ekranie 
zawarto�� rejestru EAX w postaci liczby dziesi�tnej. 
Zak�adamy, �e w rejestrach EDX:EAX znajduje si� 128-bitowa liczba binarna bez znaku.
Cyfry uzyskiwane w trakcie kolejnych dziele� nale�y zapisywa� w 12-bajtowym 
obszarze pami�ci zarezerwowanym na stosie. 
Podprogram jest podobny do opisanego w instrukcji laboratoryjnej do �w. 3 
(wersja A),  gdzie dane tymczasowe przechowywane s� w sekcji danych programu 
(nie na stosie).

Opracowany podprogram w��czy� do kompletnego programu w asemblerze, 
w kt�rym podprogram b�dzie kilkakrotnie wywo�ywany dla r�nych warto�ci 
argument�w.

| 

public _wyswietl_EAX, _jaka
.code
_jaka PROC
ret
_jaka ENDP


_wyswietl_EAX proc
   push ebp
   mov ebp,esp
   sub esp,24  ; rezerwacja zmiennej lokalnej
   push esi
   push edi
   push ebx
   
   
   mov eax,[ebp+8]  ;  L
   mov _w0,eax
   mov edx,[ebp+12] ;  H
   mov _w1,edx
   MOV EBX,10
   mov ecx,0
et2:
   mov eax,_w1
   mov _a1,eax
   mov eax,_w0
   mov _a0,eax
   mov edx,0
   mov eax,_a1 
   div ebx
   mov _w1,eax
   mov eax,_a0
   div ebx
   mov _w0,eax
   add dl,'0'
   push edx
   inc ecx
   add eax,_w1
   jnz et2 

   
   lea edi,[ebp-24]   ; mov edi, OFFSET output_stack
et3:
	pop edx
	mov [edi],dl
	inc edi
	loop et3
	mov [edi],byte ptr 0  ; koniec �a�cucha

	lea edi,[ebp-24]
		PUSH 0
		PUSH edi 
		PUSH edi 
		PUSH 0
		CALL _MessageBoxA@16
		

		pop ebx
		pop edi
		pop esi
		add esp,24    ; likwidacja zmiennej lokalnej

		pop ebp
		RET
_wyswietl_EAX endp

main PROC	
	

	;mov eax,12345
	
	push 12345;  3039h
	call  _wyswietl_EAX

	
	
	push 0  ; exit code
	call _ExitProcess@4
main ENDP


	

  
.data
_w1 dd 0
_w0 dd 0
_a1 dd 0
_a0 dd 0
liczba db '12345',0
output db  10 DUP (' '),0
;output_stack db 10 DUP (0),0
END