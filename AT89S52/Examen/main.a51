org 0000H
		MOV 70H, #05H
		MOV 71H, #01H
		MOV 72H, #04H
		MOV 73H, #02H
		MOV 74H, #08H
REPEAT: MOV R2, #04H
		CLR 00H
		MOV R0, #71H
		MOV R1, #70H
LOOP:   MOV 02H, @R1
		MOV A, @R0
		SUBB A, 02H
		JNC OTRA
		MOV A, @R0
		XCH A, @R1
		XCH A, @R0
		SETB 00H
OTRA:	INC R0
		INC R1
		DJNZ R2, LOOP
		JB 00H, REPEAT
END