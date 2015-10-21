DisplayPort .EQU 04E9h 


.ORG 0010h
	
	
AppNums:
	.DB 85
	.DB 28
	.DB 8
	.DB 91
	.DB 2
	.DB 53
	.DB 61
	
MyNum: .DB 53	
sentVar: .DB 0FFh
counter: .DB 30h


.ORG 0100h



SadMsg: 
	.DB 'Darn. You are grounded!!$'
	
FoundItMsg: 
	.DB 'Booyah!! Im going to Mars! I found my application number at position: $'
	
.ORG 0200h	

Main: 
	mov DX, DisplayPort
	mov SI, AppNums
	mov AL, [MyNum]
	mov CL, [counter]
	
MainLoop:
	
	
	inc CL
	cmp AL, [SI]
	JE foundIt
	
	cmp SI, sentVar
	JE Nope
	
	inc SI
	jmp MainLoop

Nope: 

MOV BX, SadMsg
jmp prtChar

foundIt:

MOV BX,FoundItMsg
jmp prtChar


prtChar:
	
		
	mov AL, [BX]
	cmp AL, '$'
	JE number
	out DX,AL
	inc BX
	
	
	
	jmp prtChar
	

	
number: 
	
	mov AL, CL
	out DX, AL
	
quit:
	HLT 
	.END Main