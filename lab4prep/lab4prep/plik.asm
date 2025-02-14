.686
.model flat
public _wariancja
.data
 licz db 61h,8h
.code
_wariancja PROC
	push ebp
	mov ebp,esp
	mov ebx,[ebp+8]; wskaznik na tablice liczby
	mov ecx,[ebp+12];ilosc elementow
	finit
	fldz
	et:
		fadd qword ptr [ebx] ;sumuj
		add ebx,8
	loop et
	fild dword ptr [ebp+12]
	fdivp;srednia arytm
	fmul st(0),st(0) ;kwadrat sredniej
	mov ebx,[ebp+8]; wskaznik na tablice liczby
	mov ecx,[ebp+12];ilosc elementow
	fldz 
	fldz; st(0)=temp st(1)=suma kwadratow st(2)=kwadrat sredniej
	ety:
		fadd qword ptr [ebx]
		fmul qword ptr [ebx] ;do kwadratu
		fadd st(1),st(0)
		fstp st(0)
		fldz ; wyzeruj tempa
		add ebx,8
	loop ety
	fstp st(0) ;wywal tempa
	fild dword ptr [ebp+12]
	fdivp ;podziel przez n
	fsub st(0),st(1) ;roznica tych wyrazen do st0 
	pop ebp
	ret
_wariancja ENDP
END