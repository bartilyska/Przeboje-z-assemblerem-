.686
  .model flat
  public _reverse_string@4
  extern _wcslen : PROC
  .code
  _reverse_string@4 PROC
    push ebp			
	mov ebp,esp
	push ebx
	mov edx,[ebp+8]		
	push edx          
	call _wcslen
	pop edx	;add esp+4 no i sie nadpisze wtedy
	cmp eax,1	  
	jbe koniec
	mov bx,[edx]       
	mov cx,[edx+2*eax-2]   ; -2 chuj skleroza
	mov [edx+2*eax-2], word ptr 0 
	pusha
	lea edx,[edx+2]   ; chuj skleroza
	push edx		  
	call _reverse_string@4
	;add esp, 4 skleroza
	popa
	mov [edx],cx
	mov [edx+2*eax-2],bx
koniec:
	pop ebx
	pop ebp
	ret 4
  _reverse_string@4 ENDP
  END