;.model flat

public  wyswietl_128, _funkcja

extern MessageBoxA : PROC


.data

	
.code
_funkcja PROC
ret
_funkcja ENDP

; liczba 128 bitów  340*10^36

wyswietl_128 PROC
	push rbp
	mov rbp,rsp
	sub rsp,40   ; zmienna lokalna output
	push rdi
	push rsi
	push rbx


	movups [rbp-40] ,xmm0
	mov rax,[rbp-40]  ; L
	mov w0,rax

	mov rax,[rbp-32] ; H
	mov w1,rax

; wypisanie przy u¿yciu zmiennej dynamicznej
	mov rbx,10	
	;mov rax,0
	mov rcx,0
powt2:
	mov rax,w1
	mov a1,rax
	mov rax,w0
	mov a0,rax

	mov rdx,0
	mov rax,a1
	div rbx
	mov w1,rax
	; w rdx r1
	mov rax,a0
	div rbx
	mov w0,rax
	; rdx = r0
	add rdx,30h   ; '0'
	push rdx
	inc rcx
	; rax - w0

	or  rax,w1
	jnz powt2




	lea rdi,[rbp-40]
	;mov rdi,rbp
	;sub rdi,12
powt3:
	pop rdx
	mov [rdi],dl
	inc rdi
	loop powt3

	mov [rdi], byte ptr 0 
	;mov rbx,offset output
	;add rbx,rdi
	;add rdi,1




	lea rbx,[rbp-40]


	;push 4  ; utype
	;push rbx
	;push rbx
	;push 0   ;h wnd
	mov rcx,0
	mov rdx,rbx
	mov r8,rbx
	mov r9,4
	; push pi¹typarametr
	sub rsp,32
	; ????
	call MessageBoxA
	add rsp,32  ; usuniêcie shadow space


	pop rbx
	pop rsi
	pop rdi
	add rsp,40  ; likwidacja zmiennej lokalnej
	pop rbp
	ret
wyswietl_128 ENDP



.data
tekst db '12345',0
output db 10 dup (' '),0
a1 dq 0
a0 dq 0
w1  dq 0
w0 dq 0
 END
