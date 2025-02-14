; Program przyk³adowy ilustruj¹cy operacje SSE procesora
; Poni¿szy podprogram jest przystosowany do wywo³ywania
; z poziomu jêzyka C (program arytmc_SSE.c)
.686
.XMM ; zezwolenie na asemblacjê rozkazów grupy SSE
.model flat
public _dodaj_SSE, _pierwiastek_SSE, _odwrotnosc_SSE,_sumka,_int2float,_pm_jeden
.data
	tab dd 4 dup(1.0)
.code
_dodaj_SSE PROC
 push ebp
 mov ebp, esp
 push ebx
 push esi
 push edi
 mov esi, [ebp+8] ; adres pierwszej tablicy
 mov edi, [ebp+12] ; adres drugiej tablicy
 mov ebx, [ebp+16] ; adres tablicy wynikowej
; ³adowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
; kowych 32-bitowych - liczby zostaj¹ pobrane z tablicy,
; której adres poczatkowy podany jest w rejestrze ESI
; interpretacja mnemonika "movups" :
; mov - operacja przes³ania,
; u - unaligned (adres obszaru nie jest podzielny przez 16),
; p - packed (do rejestru ³adowane s¹ od razu cztery liczby),
; s - short (inaczej float, liczby zmiennoprzecinkowe
; 32-bitowe)
 movups xmm5, [esi]
 movups xmm6, [edi]
; sumowanie czterech liczb zmiennoprzecinkowych zawartych
; w rejestrach xmm5 i xmm6
 addps xmm5, xmm6
 ; zapisanie wyniku sumowania w tablicy w pamiêci
 movups [ebx], xmm5
 pop edi
 pop esi
 pop ebx
 pop ebp
 ret
_dodaj_SSE ENDP
;=========================================================
_pierwiastek_SSE PROC
 push ebp
 mov ebp, esp
 push ebx
 push esi
 mov esi, [ebp+8] ; adres pierwszej tablicy
 mov ebx, [ebp+12] ; adres tablicy wynikowej
; ³adowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
; kowych 32-bitowych - liczby zostaj¹ pobrane z tablicy,
; której adres pocz¹tkowy podany jest w rejestrze ESI
; mnemonik "movups": zob. komentarz podany w funkcji dodaj_SSE
 movups xmm6, [esi]
; obliczanie pierwiastka z czterech liczb zmiennoprzecinkowych
; znajduj¹cych sie w rejestrze xmm6
; - wynik wpisywany jest do xmm5
 sqrtps xmm5, xmm6

; zapisanie wyniku sumowania w tablicy w pamiêci
 movups [ebx], xmm5
 pop esi
 pop ebx
 pop ebp
 ret
_pierwiastek_SSE ENDP
;=========================================================
; rozkaz RCPPS wykonuje obliczenia na 12-bitowej mantysie
; (a nie na typowej 24-bitowej) - obliczenia wykonywane s¹
; szybciej, ale s¹ mniej dok³adne
_odwrotnosc_SSE PROC
 push ebp
 mov ebp, esp
 push ebx
 push esi
 mov esi, [ebp+8] ; adres pierwszej tablicy
 mov ebx, [ebp+12] ; adres tablicy wynikowej
; ladowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
; kowych 32-bitowych - liczby zostaj¹ pobrane z tablicy,
; której adres poczatkowy podany jest w rejestrze ESI
; mnemonik "movups": zob. komentarz podany w funkcji dodaj_SSE
 movups xmm5, [esi]
; obliczanie odwrotnoœci czterech liczb zmiennoprzecinkowych
; znajduj¹cych siê w rejestrze xmm6
; - wynik wpisywany jest do xmm5
 rcpps xmm5, xmm6

; zapisanie wyniku sumowania w tablicy w pamieci
 movups [ebx], xmm5
 pop esi
 pop ebx
 pop ebp
 ret
_odwrotnosc_SSE ENDP
_sumka PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	mov esi, [ebp+8] ; adres pierwszej tablicy
	mov edi, [ebp+12] ; adres drugiej tablicy
	mov ebx, [ebp+16] ; adres tablicy wynikowej
	movups xmm0,[esi]
	movups xmm1,[edi]
	PADDSB xmm0,xmm1
	movups [ebx],xmm0
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_sumka ENDP
_int2float PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	mov esi, [ebp+8] ; adres pierwszej tablicy
	mov edi, [ebp+12] ; adres drugiej tablicy
	cvtpi2ps xmm5, qword PTR [esi]
	movups [edi],xmm5
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_int2float ENDP
_pm_jeden PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
		mov esi, [ebp+8] ; adres pierwszej tablicy
		movups xmm0,[esi]
		movups xmm1,tab
		ADDSUBPS xmm0,xmm1
		movups [esi],xmm0
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_pm_jeden ENDP
END
