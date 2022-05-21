ORG 0000H
	LCALL WAIT // initialization of LCD by software
	LCALL WAIT // this part of program is not mandatory but
	MOV A, #38H // recommended to use because it will
	LCALL COMMAND // guarantee proper initialization even when
	LCALL WAIT // power supply reset timings are not met
	MOV A, #38H
	LCALL COMMAND
	LCALL WAIT
	MOV A, #38H
	LCALL COMMAND // initialization complete
	MOV A, #38H // initialize LCD, 8-bit interface, 5X7 dots/character
	LCALL COMMAND // send command to LCD
	MOV A, #0FH // display on, cursor on with blinking
	LCALL COMMAND // send command to LCD
	MOV A, #06 // shift cursor right
	LCALL COMMAND // send command to LCD
	MOV A, #01H // clear LCD screen and memory
	LCALL COMMAND // send command to LCD
	MOV A, #80H // set cursor at line 1, first position
	LCALL COMMAND // send command to LCD
	MOV A, #'H' // H to be displayed
	LCALL DISPLAY // send data to LCD for display
	MOV A, #'I' // I to be displayed
	LCALL DISPLAY // send data to LCD for display
HERE: SJMP HERE // wait indefinitely
COMMAND: // command write subroutine
	MOV P1, A // place command on P1
	CLR P0.2 // RS = 0 for command
	CLR P0.1 // R/W = 0 for write operation
	SETB P0.0 // E = 1 for high pulse
	LCALL WAIT // wait for some time
	CLR P0.0 // E = 0 for H-to-L pulse
	LCALL WAIT // wait for LCD to complete the given command
	RET
DISPLAY: // data write subroutine
	MOV P1, A // send data to port 1
	SETB P0.2 // RS = 1 for data
	CLR P0.1 // R/W = 0 for write operation
	SETB P0.0 // E = 1 for high pulse
	LCALL WAIT // wait for some time
	CLR P0.0 // E = 0 for H-to-L pulse
	LCALL WAIT // wait for LCD to write the given data
	RET
WAIT: MOV R6, #30H // delay subroutine
THERE:  MOV R5, #0FFH //
HERE1:  DJNZ R5, HERE1 //
	DJNZ R6, THERE
	RET
END