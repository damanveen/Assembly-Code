; Lab5 - Subroutine to print a record from an array of structures

; Constant definitions
Display	.EQU 04E9h	; address of Libra display

.org 8800h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  START OF SUBROUTINES to COPY to lab5-P2.asm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;
; printStr: Subroutine to print a '$'-terminated string
; Input parameters:
; 	SI: Address of start of string to be printed
; Output parameters:
;	None.
printStr:
	; Save registers modified by this subroutine
	PUSH 	DX		; FIX ME
	PUSH 	BX		; FIX ME
	PUSH 	AX		; FIX ME

	MOV DX, Display
	MOV BX,0
LoopPS:
	MOV AL, [SI+BX]	; Load the next char to be printed - USING INPUT PARAMETER SI
	CMP AL, '$'		; Compare the char to '$'
	JE quitPS		; If it is equal, then quit subroutine and return to calling code
	OUT DX,AL		; If it is not equal to '$', then print it
	INC BX			; Point to the next char to be printed
	jmp LoopPS		; Jump back to the top of the loop
quitPS:
	; Restore registers
	POP 	AX		; FIX ME
	POP 	BX		; FIX ME
	POP 	DX		; FIX ME

	RET


;;;;;;;;;;;;;;;;;
; printDigit: Subroutine to print a single decimal digit
; Input parameters:
; 	AL: Unsigned decimal digit (between 0-9) to be printed
; Output parameters:
;	None.
printDigit:
	; Save registers modified by this subroutine
	PUSH 	AX		; FIX ME
	PUSH 	DX		; FIX ME
	
	MOV DX, Display
	ADD AL, '0'		; Convert number to ASCII code
	OUT DX,AL		; Print it
	
	; Restore registers
	POP 	DX		; FIX ME
	POP 	AX		; FIX ME
	
	RET
	
		
;;;;;;;;;;;;;;;;;
; printInt: Subroutine to print a 1-byte unsigned (short) integer between 0-255
; Input parameters:
; 	AL: Unsigned short int to be printed
; Output parameters:
;	None.
printInt:
	; Save registers modified by this subroutine
	PUSH 	DX		; FIX ME
	PUSH 	CX		; FIX ME
	PUSH 	AX		; FIX ME
	
	MOV DX, Display
	MOV CL, 10		; Will be dividing by 10...
	
LoopPI:
	CMP AL, 10		; Compare the number to 10
	JL printLast	; If it is less than 10, then print this digit
	; If it is greater than 10, divide by 10
	MOV AH, 0		; Clear AH
	DIV CL			; Divide number by 10
	CALL printDigit ; Print the quotient in AL
	MOV AL, AH		; Move remainder into AL to be printed
	jmp LoopPI		; Jump back to the top of the loop
printLast:
	CALL printDigit
	
	; Restore registers
	POP 	AX		; FIX ME
	POP 	CX		; FIX ME
	POP 	DX		; FIX ME
	
	RET


;;;;;;;;;;;;;;;;;
; printSalary: Subroutine to print employee salary
; Input parameters:
; 	AL: Unsigned short int (0-99) representing salary in 1000's of $
; Output parameters:
;	None.

; Constant strings for this subroutine:
s_thousands: .DB ',000$'
s_dollars: .DB '$'

printSalary:
	; Save registers modified by this subroutine
	PUSH 	DX		; FIX ME
	PUSH 	AX		; FIX ME
	PUSH 	SI		; FIX ME
	
	MOV DX, Display
	
	MOV AH,AL			; Keep a copy of the salary in AH (need AL for printing...)
	MOV AL, [s_dollars]	; Print '$' preceeding number
	OUT DX,AL			; Print it
	MOV AL,AH			; Move salary back into AL
	CALL printInt		; Print the salary (0-255)
	MOV SI, s_thousands	; Move the starting address of s_thousands string into BX
	CALL printStr 		; Print ',000'
	
	; Restore registers
	POP 	SI		; FIX ME
	POP 	AX		; FIX ME
	POP 	DX		; FIX ME
	
	RET


;;;;;;;;;;;;;;;;;
; newLine: Subroutine to print a newline and a linefeed character
; Input parameters:
; 	None.
; Output parameters:
;	None.

; Constants for this subroutine:
s_CR .EQU 0Dh		; ASCII value for Carriage return
s_LF .EQU 0Ah		; ASCII value for NewLine

newLine:
	; Save registers modified by this subroutine
	PUSH 	DX		; FIX ME
	PUSH 	AX		; FIX ME
	
	MOV DX, Display		; Initialize the output port number in DX
	MOV AL, s_LF		; Load line feed (LF) into AL
	out DX,AL			; print the char
	MOV AL, s_CR		; Load carriage return (CR) into AL
	out DX,AL			; print the char
	
	; Restore registers
	POP 	AX		; FIX ME
	POP 	DX		; FIX ME
	
	RET
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; END OF SUBROUTINES FOR lab5-P2.asm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Test data
;

.ORG 0A300h

str1: .DB 'Hello World!$'		; Should print as 'Hello World!'
num1: .DB 76					; Should print as decimal 76
sal1: .DB 52 					; Should print as '$52,000'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; main: Main function to test all subroutines
.ORG 0AB00h

main:

	; Initialize some registers to arbitrary values (no required)
	MOV CX,1234h
	MOV DX, 0ABCDh
	
	; Print a string. Use str1
	MOV  SI, str1					; FIX ME
	CALL printStr
	CALL newLine
	
	; Print a short unsigned int (0-99). Use num1
	MOV AL, [num1]	 					; FIX ME
	CALL printInt
	CALL newLine
	
	; Print a salary. Use sal1
	MOV AL, [sal1] 					; FIX ME
	CALL printSalary
	CALL newLine
	
	;Quit
	HLT
	
	

.END main		;Entry point of program is main()