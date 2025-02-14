.686
.model flat


extern  _ExitProcess@4 : proc
extern _MessageBoxW@16 : proc
extern _MessageBoxA@16 : proc
Comment |
Napisaæ podprogram w asemblerze ‘wyswietl_EAX’, który wyœwietli na ekranie 
zawartoœæ rejestru EAX w postaci liczby dziesiêtnej. 
Zak³adamy, ¿e w rejestrze EAX znajduje siê 32-bitowa liczba binarna bez znaku.
Cyfry uzyskiwane w trakcie kolejnych dzieleñ nale¿y zapisywaæ w 12-bajtowym 
obszarze pamiêci zarezerwowanym na stosie. 
Podprogram jest podobny do opisanego w instrukcji laboratoryjnej do æw. 3 
(wersja A),  gdzie dane tymczasowe przechowywane s¹ w sekcji danych programu 
(nie na stosie).

Opracowany podprogram w³¹czyæ do kompletnego programu w asemblerze, 
w którym podprogram bêdzie kilkakrotnie wywo³ywany dla ró¿nych wartoœci 
argumentów.

| 

public _wyswietl_EAX
.code

_wyswietl_EAX proc
   push ebp
   mov ebp,esp
   sub esp,12  ; rezerwacja zmiennej lokalnej
   push esi
   push edi
   push ebx
   
   
   mov eax,[ebp+8]
  
   MOV EBX,10
   mov ecx,0
et2:
   mov edx,0
   div ebx
   add dl,'0'
   push edx
   inc ecx
   cmp eax,0
   jne et2

   
   lea edi,[ebp-12]   ; mov edi, OFFSET output_stack
et3:
	pop edx
	mov [edi],dl
	inc edi
	loop et3
	mov [edi],byte ptr 0  ; koniec ³añcucha

	lea edi,[ebp-12]
		PUSH 0
		PUSH edi 
		PUSH edi 
		PUSH 0
		CALL _MessageBoxA@16
		

		pop ebx
		pop edi
		pop esi
		add esp,12    ; likwidacja zmiennej lokalnej

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

liczba db '12345',0
output db  10 DUP (' '),0
;output_stack db 10 DUP (0),0
END