; SYSC2001 - Lab 3
; Program to complete 8-bit unsigned shift & add multiplication
; AH = A; CH = Q; BH = M; Final 16-bit result in AX

.ORG 0000h
Data:
	Y:	.DB	15		; Multiplicand
	X: 	.DB	73		; Multiplier
	
.ORG 0010h
Init:
	mov AX, 0h 				; Initialize AX to zero. AH serves as accumulator and AX will hold product
	mov CH, [X]				; Initialize CH (Q) = X
	mov BH, [Y]				; Init BH (M) = Y
	mov DL, 8h				; Init DL as a loop counter with number of iterations required
	
mainLoop:
	ROR CH, 1h				; Shift out the lsb of the multiplier (Q[0]) into the carry flag
	JNC shift				; Check the carry flag: If Q[0] was not set, skip over Add and just shift
AddM:
	ADD AH, BH				; A = A + M
shift:
	RCR AH, 1h				; Shift AH and AL (16-bit result will be here eventually). Also need to shift CF into MSb of AH...
	RCR AL, 1h				; Decrement loop counter
	DEC DL				; If loop counter reaches zero, quit, else, loop back
	CMP DL, 0h
	JG mainLoop
	
quit:
	HLT
.END	Init