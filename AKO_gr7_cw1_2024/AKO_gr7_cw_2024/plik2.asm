.686
.model flat

extern _MessageBoxA@16 : PROC
.code 
 _main PROC
 push 4
 push OFFSET caption
 push OFFSET tekst
 push 0   ; NULL  
 call _MessageBoxA@16

 _main ENDP

.data
a  dd ? 
tekst   db "Czy lubisz  AKO?",0
caption   db "Pytanie",0

END





