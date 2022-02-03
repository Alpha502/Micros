ORG 0000H
MOV R2, #20H
MOV R1, #10H
MOV A, R2
MOV R1, A


MOV A, #00H
MOV DPTR, #0050H
MOVC A, @ A+DPTR
MOV R0,  #50H
MOVX @ R0, A
MOV DPTR, #100H
MOVX @ DPTR, A
END 
	
	
MOV A, #0E1H
ADD A, #5CH //                                                              1 0011 1101        <¬
MOV R0, A //                                                                                     |     
MOV A, #42H //                                                                                   |    
ADDC A, #25H //ADDC ES UNA SUMA DE AMBOS VALÓRES TOMANDO EN CUENTA EL CARRY, EL CARRY SE PRENDIÓ |