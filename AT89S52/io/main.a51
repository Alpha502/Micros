ORG 0000h
        MOV DPTR, #0100H
        MOV P2, #0FFH
		MOV R0, #14H
		MOV R1, #00H	// first digit
		MOV R2, #00H	// second digit
		MOV R3, #02H	// third digit
		MOV R4, #01H	// fourth digit
		MOV R5, #04H
        MOV TMOD, #11H // configure Timer 0 and Timer 1 as a timer in Mode 1
		MOV TH0, #03CH // load count in timer registers TH0-TL0
        MOV TL0, #0B0H
		MOV TH1, #0FCH
		MOV TL1, #018H
        SETB TR0 // start Timer 0
		SETB TR1
MAIN:	JNB TF0, NEXT1
			CLR TR0
			CLR TF0
			MOV TH0, #03CH // load count in timer registers TH0-TL0
			MOV TL0, #0B0H
			SETB TR0
			DJNZ R0, NEXT1
			MOV R0, #14H
			INC R1
			CJNE R1, #0AH, NEXT1
			MOV R1, #00H
			INC R2
			CJNE R2, #06H, NEXT1
			MOV R2, #00H
			INC R3
			CJNE R3, #0AH, NEXT1
			MOV R3, #00H
			INC R4
			CJNE R4, #0AH, NEXT1
			MOV R4, #00H
NEXT1:  JNB TF1, NEXT2
			CLR TR1
			CLR TF1
			MOV TH1, #0FCH
			MOV TL1, #018H
			SETB TR1
			CJNE R5, #04H, DIGIT2
				MOV P2, #00H
				MOV A, R1
				MOVC A, @A+DPTR
				MOV P0, A
				MOV P2, #01H
				SJMP UPDATE
			DIGIT2: CJNE R5, #03H, DIGIT3
						MOV P2, #00H
						MOV A, R2
						MOVC A, @A+DPTR
						MOV P0, A
						MOV P2, #02H
						SJMP UPDATE
			DIGIT3: CJNE R5, #02H, DIGIT4
						MOV P2, #00H
						MOV A, R3
						MOVC A, @A+DPTR
						MOV P0, A
						MOV P2, #04H
						SJMP UPDATE
			DIGIT4: CJNE R5, #01H, UPDATE
						MOV P2, #00H
						MOV A, R4
						MOVC A, @A+DPTR
						MOV P0, A
						MOV P2, #08H
						MOV R5, #05H
			UPDATE: DEC R5
NEXT2:	SJMP MAIN

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