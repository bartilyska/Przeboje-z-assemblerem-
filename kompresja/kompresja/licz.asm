.686
.model flat
extern _malloc : PROC
extern _Compress@24 : PROC
public _kompresuj
.data
    compressSize dd 100
.code

_kompresuj PROC
mov eax, [ebp + 12] ; address of input data
xor ecx, ecx
ptl_liczenia_rozmiaru:
    mov dx, [eax + ecx]
    add ecx, 2
    cmp dx, 0
    jne ptl_liczenia_rozmiaru

mov eax, ecx
mov ebx, 2
mul ebx ; calculate size of input data

mov ebx, eax ; store size of input data in ebx
push ecx
push ebx
call _malloc ; allocate memory for output buffer
add esp, 4
pop ecx

mov edi, eax ; store address of output buffer in edi

push offset compressSize ; pointer to variable to receive size of compressed data
push ecx ; size of output buffer (this might need to be adjusted)
push edi ; address of output buffer
push ebx ; size of input data
push [ebp + 12] ; address of input data
push [ebp + 8] ; additional parameter (verify its purpose)
call _Compress@24 
cmp eax, 0
je koniec

mov eax, edi ; store address of compressed data in eax

koniec:
pop edi
pop ebx
pop edx
pop ebp

ret
_kompresuj ENDP
END
