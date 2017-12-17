%ifndef __IOSTR_INC__
%define __IOSTR_INC__

; C-s (bináris 0-ban végződő) stringbeolvasó eljárás, <Enter>-ig olvas
; In: EDI vagy ESI, ECX max. hossz
extern  ReadStr

;  mint a ReadStr() csak újsorba is lép
; In: EDI vagy ESI, ECX max. hossz
extern ReadLnStr

; stringkiíró eljárás
; In: ESI
extern WriteStr

; mint a WriteStr() csak újsorba is lép
; In: ESI
extern WriteLnStr

; újsor elejére lépteti a kurzort
extern NewLine

%endif