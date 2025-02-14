.686
.model flat
public _moja
.code
_moja PROC
    push ebp
    mov ebp, esp
    push ebx
    push edx
    ; liczba1-[ebp+8], liczba2-[ebp+12]
    mov ebx, [ebp+8]
    mov edx, [ebp+12]
    cmp ebx, edx
    je rowne
    ja wieksze

    ; edx > ebx
    sub edx, ebx
    push edx
    push ebx
    call _moja
    add esp,8
    jmp koniec

wieksze:
    ; ebx > edx
    sub ebx, edx
    push ebx
    push edx
    call _moja
    add esp, 8
    jmp koniec

rowne:
    mov eax, ebx

koniec:
    pop edx
    pop ebx
    pop ebp
    ret
_moja ENDP
end