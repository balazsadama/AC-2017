%ifndef __STRINGS_INC__
%define __STRINGS_INC__

; EAX-ben visszatéríiti az ESI által jelölt string hosszát, kivéve a bináris 0-t
; In: ESI - a string címe aminek kell a hossza
; Out: EAX - az ESI által jelölt string hossza
extern  StrLen

; összefűzi az ESI és EDI által jelölt stringeket (azaz az ESI által jelöltet az EDI után másolja)
; In: ESI, EDI
extern StrCat

; nagybetűssé konvertálja az ESI stringet
; In: ESI
extern StrUpper

; kisbetűssé konvertálja az ESI stringet
; In: ESI
extern StrLower

; EDI-be másolja át az ESI stringet, kivéve a szóköz, tabulátor (9), kocsivissza (13) és soremelés (10) karaktereket
; In: ESI
; Out: EDI
extern StrCompact

%endif