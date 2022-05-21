	ORG 0000H
	LJMP INICIO // Salto subrutina de inicio
	
	ORG 000BH
	LJMP RTT0 // Interrupción timer 0
	
	ORG 001BH
	LJMP RTT1 // Interrupción timer 1
	
	ORG 0003H
	LJMP EXT0 // Interrupción externa 0
	
	ORG 0013H
	LJMP EXT1 // Interrupción externa 1
	
	ORG 0030H
		
INICIO:

		MOV IE,#10001111B // Activación de interrupciones
		MOV IP,#00001010B // Configuración prioridad de interrupciones
		// Reloj - Empezar el reloj en 12:00
		MOV 32H,#0H // Unidad de segundo
		MOV 33H,#0H // Decena de segundo
		MOV 34H,#0H // Unidad de minuto
		MOV 35H,#0H // Decena de minuto
		MOV 36H,#2H // Unidad de hora
		MOV 37H,#1H // Decena de hora
		// Alarma - Empezar la alarma en 00:00
		MOV 52H,#0H // Unidad de minuto
		MOV 53H,#0H // Decena de minuto
		MOV 54H,#2H // Unidad de hora
		MOV 55H,#1H // Decena de hora
		MOV 48H,#0H // Debouncer
		// hgfedcba Decodificador 7 segmentos
		MOV 3CH,#01000000b // 0
		MOV 3DH,#01111001b // 1
		MOV 3EH,#00100100b // 2
		MOV 3FH,#00110000b // 3
		MOV 40H,#00011001b // 4
		MOV 41H,#00010010b // 5
		MOV 42H,#00000010b // 6
		MOV 43H,#01111000b // 7
		MOV 44H,#00000000b // 8
		MOV 45H,#00011000b // 9
		
		MOV P2, #11011111B // Inicialización del puerto 0 - displays
		MOV P0, #11111111B // Inicialización del puerto 2 - transistores
		MOV TMOD,#00010001B // Configuración de timers
		MOV TH0,#HIGH(-1926) // Inicialización conteo inicial HIGH TIMER 0
		MOV TL0,#LOW(-1926) // Inicialización conteo inicial LOW TIMER 0
		MOV TH1,#HIGH(-500) // Inicialización conteo inicial HIGH TIMER 1
		MOV TL1,#LOW(-500) // Inicialización conteo inicial LOW TIMER 1
		SETB TR0 // Inicia conteo timer 0
		MOV R2,#0H
		MOV R6,#0H
	SETB P1.0 // Buzzer

ESPERA: JNB P3.1, LIMPIAR // Botón para reiniciar la alarma
		JMP ALARM_1
LIMPIAR: MOV 52H,#0H // Unidad de minuto
		MOV 53H,#0H // Decena de minuto
		MOV 54H,#0H // Unidad de hora
		MOV 55H,#0H // Decena de hora
	ALARM_1: // Comparar unidad de minuto de alarma contra unidad de minuto de reloj, si es lo mismo, incrementar R6
		CLR A
		MOV A, 34H
		CJNE A, 52H, ALARM_2
		INC R6
	ALARM_2: // Comparar decena de minuto de alarma contra decena de minuto de reloj, si es lo mismo, incrementar R6
		CLR A
		MOV A, 35H
		CJNE A, 53H, ALARM_3
		INC R6
	ALARM_3: // Comparar unidad de hora de alarma contra decena de hora de reloj, si es lo mismo, incrementar R6
		CLR A
		MOV A, 36H
		CJNE A, 54H, ALARM_4
		INC R6
	ALARM_4: // Comparar decena de hora de alarma contra decena de hora de reloj, si es lo mismo, incrementar R6
		CLR A
		MOV A, 37H
		CJNE A, 55H, ALARM_5
		INC R6
	ALARM_5: // Si R6 es igual a 4, significa que la hora de alarma y la hora del reloj es la misma, por lo tanto hacemos sonar la alarma
		CLR A
		CJNE R6, #04H, SONIDO
		MOV R6, #0
		CLR P1.0
	SONIDO:
		MOV R6, #0
		SETB P1.0
		JMP ESPERA

RTT0:
		SETB TR1 // Subrutina de interrupción time 0 (Se activa timer 1)
		CLR TR1 // Se desactiva timer 1
		MOV TH0,#HIGH(-1991) // Se actualizan valores high de cuenta timer 0
		MOV TL0,#LOW(-1991) // Se actualizan valores low de cuenta timer 0
		INC 48H
		MOV P2,#0H
		JNB P3.4, ALARMA // Leer el pin 3.4 para la alarma
		SETB P1.1 // Pin 1.1 para el reinicio del reloj
	// Mandar a los displays el reloj
	DISPLAY_1:
		MOV R1,#00000001B
		MOV A,34H
		CJNE R2,#0H,DISPLAY_2
		JMP DISPLAYS
	DISPLAY_2:
		MOV R1,#00000010B
		MOV A,35H
		CJNE R2,#1H,DISPLAY_3
		JMP DISPLAYS
	DISPLAY_3:
		MOV R1,#00000100B
		MOV A,36H
		CJNE R2,#2H,DISPLAY_4
		JMP DISPLAYS
	DISPLAY_4:
		MOV R1,#00001000B
		MOV A,37H
		MOV R2,#0H
		CJNE R2,#3H,RESTART_DISPLAY
		JMP DISPLAYS
	RESTART_DISPLAY:
		MOV R2,#0
		DEC R2
	DISPLAYS:
		INC R2
		MOV P2,R1
		ADD A,#3CH
		MOV R0,A
		MOV P0,@R0
		RETI // Salir de la subrutina
	// Mandar a los displays la alarma
	ALARMA: CLR P1.1
	AL_DISPLAY_1: MOV R1,#00000001B
			MOV A,52H
			CJNE R2,#0H,AL_DISPLAY_2
			JMP AL_DISPLAYS
		AL_DISPLAY_2: MOV R1,#00000010B
			MOV A,53H
			CJNE R2,#1H,AL_DISPLAY_3
			JMP AL_DISPLAYS
		AL_DISPLAY_3: MOV R1,#00000100B
			MOV A,54H
			CJNE R2,#2H,AL_DISPLAY_4
			JMP AL_DISPLAYS
		AL_DISPLAY_4: MOV R1,#00001000B
			MOV A,55H
			MOV R2,#0H
			CJNE R2,#3H,AL_RESTART_DISPLAY
			JMP AL_DISPLAYS
		AL_RESTART_DISPLAY:
			MOV R2,#0
			DEC R2
		AL_DISPLAYS:
			INC R2
			MOV P2,R1
			ADD A,#3CH
			MOV R0,A
			MOV P0,@R0
			RETI // Salir de la subrutina
RTT1:
		MOV TH1,#HIGH(-500) // Subrutina interrupción del timer1, 1s
		MOV TL1,#LOW(-500)
	SEG1:
		INC 32H // Aumenta la localidad de unidad de segundo
		MOV R3,32H // Mueve a R3 la unidad de segundo
		CJNE R3,#0AH,RETURNCLOCK
		MOV 32H,#0H // Mueve a unidad de segundo el valor de 0H
	SEG2:
		INC 33H // Aumenta la localidad de decena de segundo
		MOV R3,33H // Mueve a R3 la decena de segundo
		CJNE R3,#06H,RETURNCLOCK
		MOV 33H,#0H // Mueve a decena de segundo el valor de 0H
	MIN1:
		INC 34H // Aumenta la localidad de unidad de minuto
		MOV R3,34H // Mueve a R3 la unidad de minuto
		CJNE R3,#0AH,RETURNCLOCK
		MOV 34H,#0H // Mueve a unidad de minuto el valor de 0H
	MIN2:
		INC 35H // Aumenta la localidad de decena de minuto
		MOV R3,35H // Mueve a R3 la decena de minuto
		CJNE R3,#06H,RETURNCLOCK
		MOV 35H,#0H // Mueve a decena de minuto el valor de 0H
	HORA1:
		INC 36H // Aumenta la localidad de unidad de hora
		MOV R3,36H // Mueve a R3 la unidad de hora
		CJNE R3,#0AH,RETURNCLOCK
		MOV 36H,#0H // Mueve a unidad de hora el valor de 0H
	HORA2:
		INC 37H // Aumenta la localidad de decena de hora
		MOV R3,37H // Mueve a R3 la decena de hora
		CJNE R3,#03H,RETURNCLOCK
		MOV 37H,#0H // Mueve a decena de hora el valor de 0H
	RETURNCLOCK:
		RETI // Salir de la subrutina
EXT0:
		MOV 48H,#0H
	ADDMIN: // Agregar minuto
		MOV R4,48H // Debouncer para tener un tiempo de espera entre cada agregar minuto
		CJNE R4,#50H,ADDMIN
		JNB P3.4, ADDMINALARMA // Si está el switch en alarma, agregar minuto a la alarma
		JMP MIN1
		RETI
	ADDMINALARMA:
		ADDMIN_MIN1:
			INC 52H // Aumenta la localidad de unidad de minuto
			MOV R3,52H // Mueve a R3 la unidad de minuto
			CJNE R3,#0AH,ADDMIN_RETURNCLOCK
			MOV 52H,#0H // Mueve a unidad de minuto el valor 0H
		ADDMIN_MIN2:
			INC 53H // Aumenta la localidad de decena de minuto
			MOV R3,53H // Mueve a R3 la decena de minuto
			CJNE R3,#06H,ADDMIN_RETURNCLOCK
			MOV 53H,#0H // Mueve a decena de minuto el valor 0H
		ADDMIN_HORA1:
			INC 54H // Aumenta la localidad de unidad de hora
			MOV R3,54H // Mueve a R3 la unidad de hora
			CJNE R3,#0AH,ADDMIN_RETURNCLOCK
			MOV 54H,#0H // Mueve a unidad de hora el valor de 0H
		ADDMIN_HORA2:
			INC 55H // Aumenta la localidad de decena de hora
			MOV R3,55H // Mueve a R3 la decena de hora
			CJNE R3,#03H,ADDMIN_RETURNCLOCK
			MOV 55H,#0H // Mueve a decena de hora el valor de 0H
		ADDMIN_RETURNCLOCK:
			RETI
EXT1:
	MOV 32H,#0H // Unidad de segundo
	MOV 33H,#0H // Decena de segundo
	MOV 34H,#0H // Unidad de minuto
	MOV 35H,#0H // Decena de minuto
	MOV 36H,#2H // Unidad de hora
	MOV 37H,#1H // Decena de hora
	RETI
END
