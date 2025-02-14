.686
.model flat
extern _fopen : PROC 
extern _fread : PROC 
extern _fclose : PROC
extern _MessageBoxA@16 :PROC
public _readmsg
.data 
	param db 'r'
	obszar db 1000 dup(0)
.code
_readmsg PROC
	 push ebp 
	 mov ebp,esp
	 mov edx, [ebp+8]
	 push OFFSET param
	 push edx
	 call _fopen
	 ;wskaznik na plik w eax przerzuc do edx
	 mov esi,eax
	 add esp,8
	 push eax
	 push dword ptr 100
	 push dword ptr 1 
	 push OFFSET obszar
	 call _fread
	 ; w eax ilosc znakow a w obszarze znaki
	 mov ebx,eax;odp przenies by nie zginela
	 add esp,16
	 push esi
	 call _fclose
	 add esp, 4
	 push 0
	 push OFFSET obszar
	 push OFFSET obszar
	 push 0
	 call _MessageBoxA@16
	 mov eax,ebx
	 pop ebp
	 ret
_readmsg ENDP
END