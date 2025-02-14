.686
.model flat

public _komunikat,_szyfruj,_kwadrat,_iteracja
extern _malloc :PROC

.code 
_komunikat PROC
	push ebp
	mov ebp,esp
	push esi
	mov esi,[ebp+8]
	xor eax,eax
	ptl:
		mov dl,[esi]
		inc esi
		inc eax
		cmp dl, 0
		jne ptl

	dec eax
	mov ebx,eax ; w ebx ile elementow
	push eax 
	call _malloc ; w eax adres
	add esp,4
	;dopisz kominikat
	mov esi,[ebp+8]
	mov ecx,0
	petla:
		mov dl,[esi]
		mov byte ptr[eax+ecx],dl
		inc esi
		inc ecx
		cmp ebx,ecx
		jne petla
	;dopisanie blad
	mov edx,eax
	lea eax,[eax+ebx];add eax, ebx
	mov byte ptr[eax],'B'
	inc eax
	mov byte ptr [eax],136
	inc eax
	mov byte ptr [eax], 165
	inc eax 
	mov byte ptr [eax], 'd'
	inc eax
	mov byte ptr [eax], '.'
	mov eax,edx
	pop esi
	pop ebp
	ret
_komunikat ENDP
_szyfruj PROC
	     push ebp
    mov ebp, esp
    push esi
    push ebx
    push edi
        mov ebx, [ebp + 8] ; adres slowa
        mov edi, 0 ;iterator
        mov eax, 52525252H ; current losowa
		mov ecx,5
        mov edx, 0 ;temp dl
        ptl:
            mov dl, [ebx][edi] ; obecny bajt w dl
            ;cmp dl, 0
            ;jz ending

            ;xor dl, cl ;szyfruj
            
             
            mov byte ptr [ebx][edi], dl ; wpisz zaszyfrowana

            inc edi
        loop ptl 

        ending:



    pop edi
    pop ebx
    pop esi
    pop ebp
    ret

_szyfruj ENDP

_kwadrat PROC
	push ebp
	mov ebp,esp
	push esi
	push edi
	mov esi,[ebp+8];liczba a
	cmp esi,1
	je koniec
	cmp esi,0
	je koniec

	mov eax,esi
	lea eax,[4*eax]
	mov edi,eax;wynik 4*a w edi
	sub esi,2
	push esi
	call _kwadrat
	add esp,4
	mov esi, eax ; wynik do esi
	add esi,edi
	sub esi,4

koniec:
	mov eax,esi
	pop edi
	pop esi
	pop ebp
	ret
_kwadrat ENDP

_iteracja PROC
		push ebp
		mov ebp, esp
		mov al, [ebp+8]
		sal al, 1
		jc zakoncz
		inc al
		push eax
		call _iteracja
		add esp, 4
		pop ebp
		ret
	zakoncz:
		rcr al, 1
		pop ebp
		ret
_iteracja ENDP
END