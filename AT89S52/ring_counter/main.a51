ORG 0000h
        MOV DPTR, #0100H
        MOV P2, #0FFH
REPEAT: MOV R0, #00H
NEXT:   MOV A, R0// display 0 first
        MOVC A, @A+DPTR
        MOV P0, A // send BCD code to 7448
        MOV R5, #200 // delay
THERE2: MOV R6, #255
THERE1: NOP
        NOP
        NOP
        NOP
        DJNZ R6,THERE1
        DJNZ R5,THERE2
        INC R0
        CJNE R0, #0AH, NEXT // display up to 9 only
        SJMP REPEAT // repeat the sequence
ORG 0100h
                DB 0C0H
                DB 0F9H
                DB 0A4H
                DB 0B0H
                DB 099H
                DB 092H
                DB 082H
                DB 0F8H
                DB 080H
                DB 090H
                END
					
					
/*

*/