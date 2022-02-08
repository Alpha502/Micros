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
	
//SUMA ADD
MOV A, #0E1H
ADD A, #5CH //                                                              1 0011 1101        <¬
MOV R0, A //                                                                                     |     
MOV A, #42H //                                                                                   |    
ADDC A, #25H //ADDC ES UNA SUMA DE AMBOS VALÓRES TOMANDO EN CUENTA EL CARRY, EL CARRY SE PRENDIÓ |

//RESTA SUBSTRACTION SUBB
//SUBB A, SOURCE//A-SOURCE-CY
CLR C
MOV A, #30H  //A=30H
SUBB A, #10H //A=A-10H-C = 30-10H-0 = 20H

//MULTIPLICACION
//MULL AB
//DIVISION
//DIV AB
MOV A, R0
MOV B, R1
MUL AB
DIV AB
