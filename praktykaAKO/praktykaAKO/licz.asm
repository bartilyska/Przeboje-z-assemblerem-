.686
.model flat
	extern __write :PROC
	extern _malloc: PROC
.data 
 tmp db 0
 ciag dd 0
 Xa EQU  5
 Ya EQU 6
 Xb EQU 7
 Yb EQU 8
 .code
  _czy_pierwsza PROC
	push ebp
	mov ebp, esp
	mov eax, [ebp+8];liczba pierwsza do sprawdzenia
	cmp eax,2
	jb nie_pierwsza
	cmp eax,2
	je et
	mov ecx, 2;ecx - dzielnik
petla:
	mov eax, [ebp+8]
	xor edx, edx
	div ecx
	cmp edx, 0
	je nie_pierwsza
	inc ecx; ecx 2,3...eax-1 dla dwojki to 1
	cmp ecx, eax
	jb petla
et:
	mov eax, 1
	jmp koniec
nie_pierwsza:
	mov eax, 0
	jmp koniec
koniec:
	pop ebp
	ret
  _czy_pierwsza ENDP


  _wypisz_pierwsze_asm PROC
	push ebp
	mov ebp, esp
	push ebx
	mov ecx, [ebp+8];do ilu liczb sprawdzic
	mov ebx, 2;liczba 
petla:
	push ecx
	push ebx
	call _czy_pierwsza
	add esp, 4
	pop ecx

	cmp eax, 1 ; jesli jest pierwsza
	jne skip
	push ecx
	push ebx
	call _wypisz
	add esp, 4
	pop ecx
skip:
	inc ebx
	cmp ebx,ecx
	jbe petla
	pop ebx
	pop ebp
	ret
  _wypisz_pierwsze_asm ENDP
  _wypisz PROC
	push ebp
	mov ebp,esp
	sub esp,12 ;obszar
	push esi
	push ebx 
	push edi
	mov eax,[ebp+8];w eax liczba do wypisania ;12345 - 5 4 3 2 1
	
	lea esi, [ebp-12] ;wskaznik

	mov ebx, 10 ; dzielnik równy 10
	mov edi,0 ; ileznakow
	konwersja:
	mov edx, 0 ; zerowanie starszej czêœci dzielnej
	div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX
	add dl, 30H ; zamiana reszty z dzielenia na kod ASCII
	mov [esi], dl; zapisanie cyfry w kodzie ASCII
	inc edi
	dec esi ; zmniejszenie indeksu
	cmp eax, 0 ; sprawdzenie czy iloraz = 0
	jne konwersja ; skok, gdy iloraz niezerowy
	inc esi
	push dword ptr edi ;ilosc znakow
	push dword ptr esi 
	push dword ptr 1
	call __write
	add esp,12

	push dword ptr 20h ;00000020 2000000
	push 1
	lea esi,[esp+4];adres spacji
	push esi
	push 1
	call __write
	add esp,16

	pop edi
	pop ebx
	pop esi
	mov esp,ebp
	pop ebp
	ret
  _wypisz ENDP
  _ilosc_liczb_pierwszych PROC
	push ebp 
	mov ebp,esp
	sub esp,8 ;wynik->[ebp-8],ilosc elementow->[ebp-4]
	push esi
	push edi
	push ebx
	mov ecx,[ebp+8]
	mov [ebp-4],ecx;w [ebp-4] ilosc elementow
	mov ecx,0
	mov [ebp-8],ecx;wyzerowany wynik
	mov esi,[ebp+12];w esi wskaznik na tablice liczb 
	mov edi,[ebp+16]; w edi wskaznik na dostepy
	mov ebx,0;indeks w tablicy
petla:
	mov edx,[esi+4*ebx];liczba w tablicy liczb
	push edx
	call _czy_pierwsza
	add esp,4
	cmp eax,0; jest nie pierwsza
	je skip
	;jest pierwsza
	mov edx,[edi+4*ebx]; liczba w dostep
	cmp edx,0;jesli nie ma dostepu skip
	je skip
	add dword ptr [ebp-8],1;zwiekszenie wyniku
skip:
	inc ebx
	;jesli ebx=ilosc elementow to przerwij petle
	cmp ebx,[ebp-4]
	jb petla
	mov eax,[ebp-8]
	push eax
	call _wypisz
	add esp,4
	pop ebx
	pop edi
	pop esi
	mov esp,ebp
	;add esp,8
	pop ebp
	ret
  _ilosc_liczb_pierwszych ENDP
  _liczba_pi PROC
	push ebp
	mov ebp,esp
	mov ecx,[ebp+8];ilosc n
	finit
	push dword ptr 2 ;poczatkowy wynik
	fild dword ptr [esp]
	fild dword ptr [esp];licznik
	fld1;mian,licz,wynik
	fld1;mian,mian,licz,wynik
	fild dword ptr [esp] ;licz,mian,mian,licz,wynik
	mov eax,0;
petla:
	;dzielenie
	fdiv st(0),st(1);posr,mian,mian,licz,wynik
	fmulp st(4),st(0)
	bt eax,0;sprawdzamy czy parzysty
	jc zwieksz_licznik
	;zwieksz mianownik
	fiadd  dword ptr[esp];mian(nowy),mian(stary),licz,wynik
	fst st(1);mian,mian,licz,wynik
	jmp dalej
zwieksz_licznik:
	fild dword ptr[esp];2,mian,mian,licz,wynik
	faddp st(3),st(0);mian,mian,licz,wynik
dalej:
	inc eax
	dec ecx
	cmp ecx,0
	fldz;0, mian,mian,licz,wynik
	fadd st(0),st(3);licz,mian,mian,licz,wynik
	jne petla
	fstp st(0)
	fstp st(0)
	fstp st(0)
	fstp st(0)
	add esp,4 ; wywal dwojke
	pop ebp
	ret
  _liczba_pi ENDP
  ;10/3= 10-3-3-3... = 3 reszta 1 do koprocesora wjebac 3 + reszta/3
  _dzielenie PROC
  push ebp
  mov ebp,esp
  push ebx
  mov ebx,[ebp+8];licznik
  mov edx,[ebp+12];mianownik
  ;wynik w eax , w ebx reszta
  xor eax,eax
  cmp ebx,edx
  jb dalej
petla: ;licznik >mianownik
  sub ebx,edx
  inc eax ; raz odejmiemy
  cmp ebx,edx
  jae petla  
dalej: ;licznik<mianownik
  ;eax=3
  ;ebx=1
  finit 
  push eax
  fild dword ptr [esp]
  push ebx
  fild dword ptr [esp]
  push edx 
  fild dword ptr [esp]
  add esp,12 ; usunac
  ;mianownik,licznik,wynik
  fdivp st(1),st(0)
  faddp st(1),st(0)
  pop ebx
  pop ebp
  ret
  _dzielenie ENDP
  _wystapienia PROC
  push ebp
  mov ebp,esp
  push ebx
  push esi
  push edi
  sub esp,256*4;[]->

  mov esi, [ebp+8];wskaznik na obszar
  mov ecx,256
  cld
  mov edi,esp
  mov eax,0
  rep stosd
  mov ecx,[ebp+12];ilosc elementow
  xor ebx,ebx;ilosc elementow niezerowy
petla:
  mov al,[esi]
  inc esi
  lea edx,[esp+4*eax]
  cmp dword ptr [edx],0
  jnz dalej
  inc ebx
dalej:
  inc dword ptr [edx]
  loop petla

  lea ebx,[ebx*4+ebx]
  push ebx 
  call _malloc
  add esp,4 ; adres w eax
  ;przejdz przez 256 indeksow 0,0,0,0,1,0,0,0
  mov ecx,0;indekser
  mov edi,eax
ptl:
  lea edx,[esp+4*ecx]
  cmp dword ptr [edx],0
  jz dalejj
  mov [eax],cl
  lea eax,[eax+1];adres ruszam
  mov ebx,dword ptr[edx]
  mov [eax],ebx
  lea eax,[eax+4];adres ruszam
dalejj:
  inc ecx
  cmp ecx,256
  jb ptl
  mov eax,edi

  add esp,4*256
  pop edi
  pop esi
  pop ebx
  pop ebp
  ret
  _wystapienia ENDP
  _walec PROC
  push ebp
  mov ebp,esp
  xor eax,eax
  fld dword ptr [ebp+16] ;ladowanie wysokosci
  push dword ptr 10 ;wrzucamy 10
  fild dword ptr [esp]
  add esp,4 ;st0 ->10 st1->cos 
  fcomip st(0),st(1); 10 porownuje z liczba
  jb koniec
  fldz
  fcomip st(0),st(1) ; 0 porownuje z liczba
  ja koniec

  fld dword ptr [ebp+8]
  fmul st(0),st(0)
  fld dword ptr [ebp+12]
  fmul st(0),st(0)
  faddp
  push dword ptr 5
  fild dword ptr [esp]
  fmul st(0),st(0)
  fcomip st(0),st(1) ;r^2 
  fstp st(0)
  jb koniec
  mov eax,1
koniec:
  fstp st(0)
  pop ebp
  ret
  _walec ENDP
  _sekwencja PROC
    push ebp
	mov ebp,esp
	mov al,[ebp+8]
	sub al,30h
	bt eax,0 ; w cf jest 0 lub 1
	rcl tmp,1
	mov al, tmp
	xor ecx,ecx
	and al,00011011b
	cmp al,27
	sete cl
	add ciag,ecx
	mov esp,ebp
	pop ebp
	ret
  _sekwencja ENDP

  _okresl_blad PROC
	push ebp
	mov ebp,esp
	push ebx
	finit
	mov eax,[ebp+12]
	mov ebx, Xa
	sub eax,ebx
	mul eax
	mov ecx,eax ; w ecx pierwsza czesc
	mov eax,[ebp+16]
	mov ebx,Ya
	sub eax, ebx
	mul eax;druga czesc w eax
	;dodaj i spierwiastkuj
	add eax,ecx
	push eax
	fild dword ptr [esp]
	fsqrt
	add esp,4

	mov eax,[ebp+12] ;druga polowka wzoru
	mov ebx, Xb
	sub eax,ebx
	mul eax
	mov ecx,eax ; w ecx pierwsza czesc
	mov eax,[ebp+16]
	mov ebx,Yb
	sub eax,ebx
	mul eax;druga czesc w eax
	;dodaj i spierwiastkuj
	add eax,ecx
	push eax
	fild dword ptr [esp]
	fsqrt
	add esp,4
	fsubp

	fld dword ptr [ebp+8]
	fsubp 

	fabs

	fld dword ptr [ebp+20]
	xor eax,eax
	fcomip st(0),st(1) ; porownaj epsilon z funkcja 
	seta al; jesli wiekszy to ustaw al
	fstp st(0)
	pop ebx
	pop ebp
	ret
  _okresl_blad ENDP
  _rysuj_hiperbole PROC
    push ebp
	mov ebp, esp
	push ebx
	push esi 
	push edi

	mov ebx, 0 ; ebx do [ebp+16] zewn
	mov esi, 0 ; ecx do [ebp+20] wewnetrzna
	mov edi, dword ptr [ebp+12] ; adres na tablice
	;esi i ebx zeby funkcja nie popsula
	petla:
		druga:
		push dword ptr [ebp+24] ;d
		push esi ;x
		push ebx ;y
		push dword ptr [ebp+8] ;eps
		call _okresl_blad ;wynik w eax
		add esp,16 ; pozbadz sie paramtetro
		cmp eax,1
		je wpisz
		mov [edi],dword ptr 0
		jmp dalej
		wpisz:
		mov [edi], dword ptr 1
		dalej:
		inc esi
		add edi , 4 ; zwieksz adres o 4 bo zrobilem int
		cmp esi, dword ptr [ebp+20]
		jb druga
    xor esi,esi ; wuzeruj ecx by na nowo lecialo 
	inc ebx
    cmp ebx,dword ptr [ebp+16]
	jb petla
	

	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
  _rysuj_hiperbole ENDP
 _minus_dwojkowy PROC
    push ebp
    mov ebp, esp
    mov eax, [ebp+8] ; Pobranie liczby wejœciowej

    mov edx, 0       ; Bufor wynikowy
    mov ecx, 0       ; Licznik bitów

petla:
    cmp eax, 0       ; Sprawdzenie, czy liczba wynosi zero
    je koniec        ; Jeœli tak, zakoñcz pêtlê
    mov ebx, eax     ; Kopia liczby do sprawdzenia parzystoœci
    sar eax, 1       ; Podzia³ przez 2 (uwzglêdnia znak)
    adc edx, 0       ; Dodanie przeniesienia do bufora
    ror edx, 1       ; Obrót bufora wynikowego
    inc ecx          ; Zwiêkszenie licznika bitów
dalej:
    neg eax          ; Negacja wartoœci (symulacja dzielenia przez -2)
    jmp petla        ; Powtórzenie pêtli

koniec:
    rol edx, cl      ; Odtworzenie kolejnoœci bitów
    mov eax, edx     ; Wynik w eax
    pop ebp
    ret
_minus_dwojkowy ENDP
_razy_dziesiec PROC
    push ebp
    mov ebp, esp
    push ebx
    push esi

    mov ebx, [ebp+8]  ; Wczytaj float (IEEE-754)

    ; ====== EKSTRAKCJA WYK£ADNIKA ======
    mov ecx, ebx
    shr ecx, 23       ; Wyci¹gnij wyk³adnik (bity 23-30)
    add ecx, 3        ; Dodaj 3 (bo 8 = 2^3) -> dla mno¿enia x8
    cmp ecx, 255
    jge overflow      ; Jeœli przekroczy 255, zwróæ INF

    ; ====== EKSTRAKCJA MANTYSY ======
    mov edx, ebx
    shl edx, 9        ; Usuñ wyk³adnik
    shr edx, 9
    bts edx, 23       ; Przywróæ niejawne 1

    ; ====== MNO¯ENIE PRZEZ 10 JAKO (x8 + x2) ======
    mov eax, edx      ; Kopia mantysy
    shl eax, 3        ; *8 (przesuniêcie w lewo o 3)
    mov esi, edx
    shl esi, 1        ; *2 (przesuniêcie w lewo o 1)
    add eax, esi      ; (arg * 8) + (arg * 2) = arg * 10

    ; ====== OBS£UGA PRZEPE£NIENIA ======
    bt eax, 28        ; SprawdŸ czy bit 24 zapalony
    adc ecx, 0        ; Jeœli tak, dodaj do wyk³adnika

    ; Usuñ niejawne 1 w mantysie
    btr eax, 27      

    ; ====== PONOWNE USTAWIENIE WYK£ADNIKA ======
    shl ecx, 23
    or eax, ecx       ; Po³¹cz nowy wyk³adnik i mantysê

    ; ====== PRZYGOTOWANIE DO ZWROTU ======
    push eax
    fld dword ptr [esp] ; Za³aduj jako float
    add esp, 4

    pop esi
    pop ebx
    pop ebp
    ret

overflow:
    mov eax, 7F800000h  ; Zwróæ +INF
    ret

_razy_dziesiec ENDP

_minus_osemkowy PROC
    push ebp
    mov ebp, esp
    mov eax, [ebp+8] 

	cli
	push -2
	fild dword ptr [esp]
	add esp,4
	fsqrt

    mov edx, 0       ; wynik
    mov ecx, 0       ; licznik zeby potem odwrocic

petla:
    cmp eax, 0      
    je koniec       
    sar eax, 1      ;dzielenie przez 2 i reszta 
    adc edx, 0       ;reszta do edx
    ror edx, 1       ;obroc zeby zachowac kolejnosc potem
    inc ecx
	 sar eax, 1     
    adc edx, 0     
    ror edx, 1      
    inc ecx         
	 sar eax, 1      
    adc edx, 0      
    ror edx, 1      
    inc ecx          
dalej:
    neg eax      ;zaneguj zeby bylo jako (-8)  
    jmp petla       

koniec:
    rol edx, cl      ; poprawna kolejnosc
    mov eax, edx    
    pop ebp
    ret
_minus_osemkowy ENDP
_oblicz_mex PROC
	push ebp
	mov ebp,esp
	push ebx
	push edi
	push esi
	mov ebx,[ebp+8];wskaznik na tablice (nie zniknie)
	mov ecx,[ebp+12];ilosc
	;stworz tablice na n elementow

	push ecx
	call _malloc
	pop ecx
	lea ecx,[ecx-2]
	;w eax adres na tablice (wyzeruj j¹)
	mov edi,eax ; adres do edi
	push edi
	mov eax,0
	rep stosb
	pop edi
	mov eax, edi ; znowu adres w eax

	mov ecx,[ebp+12];znowu ilosc w ecx
	xor edi, edi
ptl:
	mov edx,[ebx+4*edi];element tablicy
	cmp edx,ecx;jesli wieksza lub rowna niz ilosc to nic nie wstawiaj
	jae dalej1
	cmp edx,0; jesli ujemna to nie wpisuj w jakis ujemny indeks
	jb dalej1
	mov byte ptr [eax+edx],1
dalej1:
	inc edi
	cmp edi,ecx
	jb ptl
	
	; znajdz pierwsze miejsce gdzie nie ma jedynki w tablicy wystapien
	mov ecx,[ebp+12];znowu ilosc w ecx
	mov edi,eax;adres do edi
	mov eax,1
	push edi ; zapamietaj indeks startowy
	repe scasb
	pop eax; poczatkowy
	sub edi,eax;odp
	mov eax,edi
	dec eax; bo jest indeks o 1 dalej przez scasa

	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
_oblicz_mex ENDP
END