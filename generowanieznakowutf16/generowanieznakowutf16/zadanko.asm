.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
extern _MessageBoxW@16 : PROC
public _main
.data
	litery dw 80 dup (?)
	znaki dw 500 dup (?)
	literki dw 80 dup(?)
	spacja EQU 20h
.code
_main PROC
;zadanie A
	mov ebx,0
	mov edx,'A'
	mov ecx,26
	ptl:
		mov litery[ebx],dx
		add ebx,2
		inc dx
	loop ptl
	push 0 ; stala MB_OK
	; adres obszaru zawieraj¹cego tytu³
	push OFFSET litery
	; adres obszaru zawieraj¹cego tekst
	push OFFSET litery
	push 0 ; NULL
	call _MessageBoxW@16
	add esp,16
;zadanie B
	;od U+100 128 znakow i potem odwrocic bez U+0119 i U+0141 i spacje
	;uzywanie stosu do odwrocenia pozniej
	mov ecx,128
	mov edx,100h
	et:
		cmp edx,119h
		jne dod
		cmp edx, 141h ;omin te litery
		jne dod
		inc dx
		jmp et
	dod:
		push edx ;walnij na stos
		inc dx
	loop et
	mov ebx,0
	mov ecx,128
	ety:
		pop edx ;odwroc kolejnosc
		mov znaki[ebx],dx
		add ebx,2
		mov znaki[ebx],spacja ;dodaj spacje po
		add ebx,2
	loop ety

	push 0 ; stala MB_OK
	; adres obszaru zawieraj¹cego tytu³
	push OFFSET znaki
	; adres obszaru zawieraj¹cego tekst
	push OFFSET znaki
	push 0 ; NULL
	call _MessageBoxW@16
	add esp,16

	;zad 3
	mov ebx,0
	mov edx,01F68H
	mov ecx,32
	pl:
		mov literki[ebx],dx
		add ebx,2
		mov literki[ebx],spacja
		add ebx,2
		inc dx
	loop pl

	push 0 ; stala MB_OK
	; adres obszaru zawieraj¹cego tytu³
	push OFFSET literki
	; adres obszaru zawieraj¹cego tekst
	push OFFSET literki
	push 0 ; NULL
	call _MessageBoxW@16
	add esp,16
	push 0
	call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END
