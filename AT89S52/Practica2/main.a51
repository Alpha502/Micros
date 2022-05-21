ORG 0000h
here:   MOV DPTR, #0100H
        MOV P2, #0FFH
		MOV R0, #14H
		MOV R1, #00H	// second 
		MOV R2, #00H	// second 2
		MOV R3, #00H	// first digit
		MOV R4, #00H	// second digit
		MOV R5, #02H	// thrid digit
		MOV R6, #01H	// fourth digit 
		MOV R7, #04H
		MOV 30H, #01H	//EMPEZAMOS A GUARDAR LOS VALORES DE LA ALARMA
		MOV 31H, #00H
		MOV 32H, #02H
		MOV 33H, #01H
		MOV 34H, #00H	//MEMORIA PARA COMPARACIONES DE ALARMA VS RELOJ
        MOV TMOD, #11H // configure Timer 0 and Timer 1 as a timer in Mode 1
		MOV TH0, #03CH // load count in timer registers TH0-TL0
        MOV TL0, #0B0H
		MOV TH1, #0FCH
		MOV TL1, #018H
        SETB TR0 // start Timer 0
		SETB TR1
		SETB P1.0	//bocina
		CLR P3.1

/*ESPERAR: 	JNB P3.1, LIMPIAR
			JMP VAL_ALARMA
LIMPIAR: 	
			MOV 30H, #00H	//EMPEZAMOS A GUARDAR LOS VALORES DE LA ALARMA
			MOV 31H, #00H
			MOV 32H, #00H
			MOV 33H, #00H*/
VAL_ALARMA: 				//Comparamos unidad de minuto
			CLR A
			MOV A, R3
			CJNE A, 30H, VAL_ALARMA2
			INC 34H
VAL_ALARMA2: 				//Comparamos unidad de minuto
			CLR A
			MOV A, R4
			CJNE A, 31H, VAL_ALARMA3
			INC 34H
VAL_ALARMA3: 				//Comparamos unidad de minuto
			CLR A
			MOV A, R5
			CJNE A, 32H, VAL_ALARMA4
			INC 34H
VAL_ALARMA4: 				//Comparamos unidad de minuto
			CLR A
			MOV A, R6
			CJNE A, 33H, VAL_ALARMA5
			INC 34H
VAL_ALARMA5: 				//Comparamos unidad de minuto
			CLR A
			MOV A, 34H
			CJNE A, #00H, RUIDITO
			MOV 34H, #00H
			CLR P1.0
RUIDITO:	
			MOV 34H, #00H
			SETB P1.0

MAIN:	JNB TF0, NEXT1
			CLR TR0
			CLR TF0
			MOV TH0, #03CH // load count in timer registers TH0-TL0
			MOV TL0, #0B0H
			SETB TR0
			//JNB P3.1, HERE
			DJNZ R0, NEXT1
			MOV R0, #14H
			INC R1
			CJNE R1, #0AH, NEXT1 //unidades :0X SEGUNDOS
			MOV R1, #00H
			INC R2
			CJNE R2, #06H, NEXT1 //decenas :X0 SEGUNDOS
			MOV R2, #00H
			INC R3
			CJNE R3, #0AH, NEXT1 //unidades 0X:00 MINUTOS
			MOV R3, #00H
			INC R4
			CJNE R4, #06H, NEXT1 //decenas X0:00 MINUTOS
			MOV R4, #00H
			INC R5
			CJNE R5, #0AH, NEXT1 //unidades 0X:00 HORAS
			MOV R5, #00H
			INC R6
			//CJNE R6, #02H, HORAS24 //decenas X0:00 HORAS
			CJNE R6, #02H, NEXT1 //decenas X0:00 HORAS
			HORAS:MOV R6, #00H
NEXT1:  JNB TF1, NEXT2
			JNB P3.4, ALARMA
			CLR TR1
			CLR TF1
			MOV TH1, #0FCH
			MOV TL1, #018H
			SETB TR1
			SETB P1.1
DIGIT1:		CJNE R7, #04H, DIGIT2
				MOV P2, #00H
				MOV A, R3
				MOVC A, @A+DPTR
				MOV P0, A
				MOV P2, #01H
				SJMP UPDATE
			DIGIT2: CJNE R7, #03H, DIGIT3
						MOV P2, #00H
						MOV A, R4
						MOVC A, @A+DPTR
						MOV P0, A
						MOV P2, #02H
						SJMP UPDATE
			DIGIT3: CJNE R7, #02H, DIGIT4
						MOV P2, #00H
						MOV A, R5
						MOVC A, @A+DPTR
						MOV P0, A
						MOV P2, #04H
						SJMP UPDATE
			DIGIT4: CJNE R7, #01H, UPDATE
						MOV P2, #00H
						MOV A, R6
						MOVC A, @A+DPTR
						MOV P0, A
						MOV P2, #08H
						MOV R7, #05H
			UPDATE: DEC R7
NEXT2:	AJMP VAL_ALARMA

ALARMA:			
				CLR TR1
				CLR TF1
				MOV TH1, #0FCH
				MOV TL1, #018H
				SETB TR1
				CLR P1.1
				CJNE R7, #04H, DIGIT2ALARMA
					MOV P2, #00H
					MOV A, 30H
					MOVC A, @A+DPTR
					MOV P0, A
					MOV P2, #01H
					SJMP UPDATE
			DIGIT2ALARMA: CJNE R7, #03H, DIGIT3ALARMA
						MOV P2, #00H
						MOV A, 31H
						MOVC A, @A+DPTR
						MOV P0, A
						MOV P2, #02H
						SJMP UPDATE
			DIGIT3ALARMA: CJNE R7, #02H, DIGIT4ALARMA
						MOV P2, #00H
						MOV A, 32H
						MOVC A, @A+DPTR
						MOV P0, A
						MOV P2, #04H
						SJMP UPDATE
			DIGIT4ALARMA: CJNE R7, #01H, UPDATEALARMA
						MOV P2, #00H
						MOV A, 33H
						MOVC A, @A+DPTR
						MOV P0, A
						MOV P2, #08H
						MOV R7, #05H
			UPDATEALARMA: DEC R7			
						SJMP NEXT2
			
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