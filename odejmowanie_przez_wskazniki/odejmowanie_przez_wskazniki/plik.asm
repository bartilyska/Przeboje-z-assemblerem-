.686
.model flat
public _odejmowanie
public _sum
public _reduction 
public _merge
.data 
	obszar dd 16 dup(0)
.code
_odejmowanie PROC
	push ebp
	mov ebp,esp
	;ebp+8 **odjemna ebp+12 *odjemnik
	mov ecx,[ebp+8]
	mov ecx,[ecx] ; w ecx pointer
	mov edx,[ebp+12];w edx pointer
	mov eax,[ecx];w eax odjemna
	sub eax,[edx]
	pop ebp
	ret
_odejmowanie ENDP
_sum PROC
	push ebp
	mov ebp,esp
	push esi
	mov esi,3
	mov ecx,[ebp+8]
	xor eax,eax
	cmp ecx,0
	je koniec
	petla:
		mov edx,[ebp+4*esi]
		inc esi
		add eax,edx
	loop petla
	koniec:
	pop esi
	pop ebp
	ret
_sum ENDP
_reduction PROC
	push ebp
	mov ebp,esp
	push ebx
	push esi
	mov ebx,[ebp+16]
	mov ecx,[ebp+12]
	mov esi,[ebp+8]
	xor eax,eax
	cmp ebx,0
	jne maxmin
	suma:
		add eax,[esi]
		add esi,4
	loop suma
	jmp koniec
	maxmin:
	cmp ebx,1
	jne min

	max:
		mov eax,[esi]
		add esi,4
		dec ecx
		cmp ecx,0
		je koniec
		ptl:
			cmp eax,[esi]
			jge kptli
			mov eax,[esi]
		kptli:
			add esi,4
		loop ptl
		jmp koniec

	min:
		mov eax,[esi]
		add esi,4
		dec ecx
		cmp ecx,0
		je koniec
		pt:
			cmp eax,[esi]
			jle kpetli
			mov eax,[esi]
		kpetli:
			add esi,4
		loop pt
	koniec:
	pop esi
	pop ebx
	pop ebp
	ret
_reduction ENDP
_merge PROC
	push ebp
	mov ebp,esp
	push esi
	push ebx
	push edi
	mov esi,[ebp+8]
	mov ebx,[ebp+12]
	mov ecx,[ebp+16]
	mov edi,0
	pl:
		mov eax,[esi]
		mov [obszar+edi],eax
		add edi,4
		mov eax,[ebx]
		mov [obszar+edi],eax
		add edi,4
		add ebx,4
		add esi,4
	loop pl
	mov eax, OFFSET	obszar
	pop edi
	pop ebx
	pop esi
	pop ebp
	ret
_merge ENDP
END