.686
.model flat
public _srednia_harm
.data 
	jeden dd 1.0
.code
_srednia_harm PROC
	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp,esp ; kopiowanie zawartoœci ESP do EBP
	mov ecx,[ebp+12] ; wczytanie pierwszego argumentu]
	mov edx,[ebp+8] ; wczytanie drugiego argumentu
	finit
	fldz;zero zeby sie dalo z pierwszym popem
	et:
	fld jeden
	fld dword PTR [edx]
	fdivp ;dzieli st1/st0 
	faddp ;dodaje do poprzedniego rezultatu
	add edx,4 ;przesuniecie po tablicy
	loop et
	fild dword PTR [ebp+12] ;zaladowanie n
	fxch ;odwrocenie kolejnosci by moc skorzystac z fdivp
	fdivp 
	pop ebp
	ret
_srednia_harm ENDP
 END