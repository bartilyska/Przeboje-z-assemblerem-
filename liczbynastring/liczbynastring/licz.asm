.686
.model flat
public _tekst
extern _start : dword ;pointer na start obszaru\
extern _MessageBoxA@16 : PROC
.code
_tekst PROC
	push ebp
	mov ebp,esp
	push esi
	push ebx
	push edi
	mov ebx, _start
	mov esi,6
	mov ecx,4
	petla:
		mov eax,[ebp+4*esi]
		sub esi,1
		mov edi,32
		srodek:
			sal eax,1
			jc wstaw_jeden
			;wstaw zero
				mov byte ptr [ebx],'0'
				jmp koncz
			wstaw_jeden:
				mov byte ptr [ebx],'1'
			koncz:
			add ebx,1
			dec edi
			cmp edi,0
		jne srodek
	loop petla
	mov eax,_start
	push 0
	push eax
	push eax
	push 0
	call _MessageBoxA@16
	mov eax,_start
	pop edi
	pop ebx
	pop esi
	pop ebp
	ret
_tekst ENDP
END