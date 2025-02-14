public suma_siedmiu_liczb
.code
suma_siedmiu_liczb PROC
	mov rax,0 ;tu bedzie wynik
	add rax,rcx
	add rax,rdx
	add rax,r8
	add rax,r9
	add rax,[rsp+40];call w rsp shadow  space +32 to kolejny w 40
	add rax,[rsp+48]
	add rax,[rsp+56]
	ret
suma_siedmiu_liczb ENDP
END
