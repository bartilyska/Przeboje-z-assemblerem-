	.686
	.XMM
	.model flat
	extern _GetComputerNameA@8 :PROC
	.data 
	align 8
	a dq 01111222233334444h
	.code
	_salt PROC
	push ebp
	mov ebp,esp
	sub esp,260
	push ebx
	push esi
	push edi
	;mov 256 do [ebp-260]
	;wskaznik by³ na 
	lea edi,[ebp-260]
	mov [edi],dword ptr 256
	push edi
	add edi,4
	push edi
	call _GetComputerNameA@8
	; zwraca nazwe kompa do tego miejsca i wpisuje ilosc znakow
	mov edi,[ebp-260];ilosc
	mov al, byte ptr [ebp-258+edi]
	movzx eax,al ;wyzeruj reszte gowna
	;mamy znak w al 
	push eax
	fild dword ptr [esp]
	add esp,4
	fptan
	fdiv
	fabs
	fld dword ptr [ebp+12]
	fmul 
	push 256
	fild dword ptr [esp]
	add esp,4
	fmul 

	push 100
	fild dword ptr [esp]
	add esp,4
	fdiv

	; dlugosc slowa
	mov ecx,0 ;licznik 
	mov edx,[ebp+8];wskaznik na slowo
	petla:
	mov bx,[edx+2*ecx];wrzuca znak nastepny
	inc ecx
	cmp bx,0
	jne petla

	dec ecx ; w ecx liczba znakow len

	fstp qword ptr [esp] ; wrzuc te dziwne wyrazenie

	mov eax,dword ptr[esp]
	mov edx, dword ptr [esp+4]; tu jest 64-liczba do obracania

	bt edx,31;pobierz do cf

	petla2:
	rcl eax,1
	rcl edx,1 ; chyba jest ok ;p
	loop petla2


	pop edi
	pop esi
	pop ebx
	mov esp,ebp
	pop ebp
	ret 
	_salt ENDP
	_mul64 PROC
	push ebp 
	mov ebp,esp
	push ebx
	push esi
	push edi
	
	mov eax,[ebp+8]
	mov ebx,[ebp+16]
	mul ebx;eax - edx
	mov edi, eax;najmlodszaaaaa
	mov ecx,edx

	mov eax,[ebp+12]
	mov ebx,[ebp+20]
	mul ebx
	mov esi,edx;najstarszaaaaa
	mov ebx,eax

	mov eax,[ebp+8]
	mov edx,[ebp+20]
	mul edx;eax - edx
	add ecx,eax
	adc ebx,edx
	adc esi,0

	mov eax,[ebp+12]
	mov edx,[ebp+16]
	mul edx
	add ecx,eax
	adc ebx,edx
	adc esi,0

	;esi-ebx-ecx-edi
	push esi;[esp+12]
	push ebx;[esp+8]
	push ecx ;[esp+4]
	push edi;[esp]
	movups xmm0,[esp]
	add esp,16

	pop edi
	pop esi
	pop ebx
	mov esp,ebp
	pop ebp
	ret 
	_mul64 ENDP 

	_mulinny PROC
	push ebp 
	mov ebp,esp
	push ebx
	push esi
	push edi

	push 0
	push 0
	mov eax,[ebp+12]
	push eax
	mov eax,[ebp+8]
	push eax
	movups xmm1,[esp]

	push 0
	push 0
	mov eax,[ebp+20]
	push eax
	mov eax,[ebp+16]
	push eax
	movups xmm2,[esp]
	pop edi
	pop esi
	pop ebx
	mov esp,ebp
	pop ebp
	ret 
	_mulinny ENDP
	_gen_xi PROC
	push ebp 
	mov ebp,esp
	push ebx
	push esi
	push edi
	
	;c razy pomnozyc ta liczbe * a (sta³a) i wyciagnac mod 48
	mov edi,[ebp+12];ilosc wywolan rekurencyjnych
	cmp edi,0
	je koniec
	dec edi

	mov ebx,[ebp+8];adres na structa
	mov eax,[ebx];mlodsza
	mov edx,[ebx+4];starsza
	push dword ptr [a+4]
	push dword ptr a
	push edx
	push eax
	call _mul64
	;wynik poleci w miejsce parametrow ktore juz nie instnieja
	movups [esp],xmm0
	mov eax,[esp]
	mov edx,[esp+4]
	and edx,0FFFFh
	add esp,16;xmm juz useless
	mov ebx,[ebp+8];adres structa wrzuc liczbe
	mov [ebx],eax
	mov [ebx+4],edx
	push edi
	push ebx;parametry
	call _gen_xi
	add esp,8
koniec:
	pop edi
	pop esi
	pop ebx
	mov esp,ebp
	pop ebp
	ret 
	_gen_xi ENDP
	END