ORG 000H
	DISPLAY_INIT:
        LCALL DELAY         
        LCALL DELAY
        MOV A, #38H
        LCALL COMMAND
        LCALL DELAY
        MOV A, #38H
        LCALL COMMAND
        LCALL DELAY
        MOV A, #38H
        LCALL COMMAND    
        MOV A, #38H        
        LCALL COMMAND//configuramos LCD desde aqui
        MOV A, #0FH        
        LCALL COMMAND
        MOV A, #06        
        LCALL COMMAND
        MOV A, #01H        
        LCALL COMMAND
        MOV A, #80H
        LCALL COMMAND

COMMAND:
        MOV P1, A
        CLR P0.2        // RS = 0 for command
        SETB P0.0        // E = 1 for high pulse
        LCALL DELAY
        CLR P0.0        // E = 0 for H-to-L pulse
        LCALL DELAY
        RET

DISPLAY:
        MOV P1, A        
        SETB P0.2         
        SETB P0.0        // E = 1 for high pulse
        LCALL DELAY
        CLR P0.0        // E = 0 for H-to-L pulse
        LCALL DELAY

        MOV R0, #40H    
        SETB P0.5        
        MOV P2, #0FFH    
        MOV TMOD, #20H    
        MOV SCON, #4CH    
        MOV TH1, #0FDH    
        SETB TR1         
NEXT:
        CLR P0.4		// Hacemos WR low 
		LCALL DELAY  //ESPERAMOS UN SEGUNDO ENTRE CONVERSIONES
        SETB P0.4        // WR = 1

HERE:
        JB P0.5, HERE    // esperamos la conversion
        CLR P0.3        // Hacemos RD low 
        MOV A, P2        // Leemos datos
        MOV R0, A        // Guardamos el dato
        SETB P0.3         


CALCULATE_SPEED:        //Velocidad = RPM * diametro, donde diametro = 3.14 REDONDEAMOS A 3 POR FACILIDAD.
        MOV A, R0
		MOV B, #3H
		MUL AB
		MOV R3, A
		MOV R4, B
		
REPEAT:
		// enviamos datos a LCD Y por TXD
		
		SJMP LCD_SEND_DATA
        MOV A, R3        // Enviamos MSB
        ACALL SEND		
		MOV A, R4		//Enviamos LSB
		ACALL SEND
		MOV R3, #00H
		MOV R4, #00H
		AJMP NEXT
		
SEND:
        MOV SBUF, A        // Serial data transfer subroutine
		JNB TI, $
		CLR TI
		RET

DELAY:     MOV R5, #10H    // Esperar 1s
THR3:    MOV R6, #100
THR2:    MOV R7, #250
THR1:    NOP
        NOP
        DJNZ R7, THR1
        DJNZ R6, THR2
        DJNZ R5, THR3
        RET
//enviamos a la pantalla dato
LCD_SEND_DATA:
	SETB P0.2 
	MOV P1, R3 //FALTO MANIPULAR MSB Y LSB PARA ENVIARSE AQUI
	SETB P0.0
	NOP //Con este NOP de buffer aseguramos que se tarde los 500ns necesarios.
	CLR P0.0
	
	//Hacemos una pausa corta para darle tiempo a la pantalla de procesar.
	ACALL DELAY
	
	RET
END