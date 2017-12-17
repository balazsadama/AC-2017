%ifndef __IONUM_INC__
%define __IONUM_INC__

; 32 bites előjeles egész beolvasása
; Out: EAX
extern ReadInt

; 32 bites előjeles egész kiírása
; In: EAX
extern WriteInt

; 64 bites előjeles egész beolvasása
; Out: EDX:EAX
extern ReadInt64

; 64 bites előjeles egész kiírása
; In: EDX:EAX
extern WriteInt64


; 32 bites bináris pozitív egész beolvasása
; Out: EAX
extern ReadBin

; 32 bites bináris pozitív egész kiírása
; In: EAX
extern WriteBin

; 64 bites bináris pozitív egész beolvasása
; Out: EDX:EAX
extern ReadBin64

; 64 bites bináris pozitív egész kiírása
; In: EDX:EAX
extern WriteBin64


; 32 bites pozitív hexa beolvasása
; Out: EAX
extern ReadHex

; 32 bites pozitív hexa kiírása
; In: EAX
extern WriteHex

; 64 bites pozitív hexa beolvasása
; Out: EDX:EAX
extern ReadHex64

; 64 bites pozitív hexa kiírása
; In: EDX:EAX
extern WriteHex64

%endif