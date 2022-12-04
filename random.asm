.MODEL SMALL
.STACK 100H
.DATA
	WELCOME DB 0AH, ' 		 --------------------------------------', 0AH, '		| G U E S S  M Y  N U M B E R  G A M E |', 0AH, ' 		 --------------------------------------','$'
	INSTRUCTIONS DB 0AH,'		1) YOUR INPUT SHOULD BE FROM 0 TO 9',0AH, '		2) EACH WRONG CHOICE WILL DECREMENT YOUR 10 MARKS OUT OF 50',0AH,'$' 
	GUESS DB 0AH, 0DH,'ENTER YOUR GUESS : $'
	EQUALN DB 0AH, 0DH,'		HURRAH! YOU GUSSED THE HIDDEN NUMBER :)$'
	LESSN DB 0AH, 0DH,'		HIDDEN NUMBER IS GREATER THAN YOUR NUMBER $'
	GREATERN DB 0AH, 0DH,'		HIDDEN NUMBER IS LESS THAN YOUR NUMBER  $'
	PLAYAGAIN DB 0AH, 0DH, '		WANT TO PLAY AGAIN Y/N: $'
	TRIES DB 0AH, 0DH, '		YOUR LEFT TRIES ARE $'
	SCOREE DB 0AH, 0DH, '		        YOUR SCORE: $'
	KEY DB 0AH,'		PRESS ANY KEY TO CONTINUE....$'
	VALIDINPUT DB 0AH,'		PLEASE ENTER VALID INPUT...$'
	RANDOM DB ?    ;VARIABLE 'RANDOM' STORES THE RANDOM VALUE
	COUNT DB ? 		; COUNTER
.CODE 
MAIN PROC
	MOV AX,@DATA				;MOVING DATA 
    MOV DS,AX					;MOVING DATA FROM REGISTER TO DATA SEGMENT 
	CALL CLEAR
	;TILL THIS LINE	
	
	MOV AH,9
	MOV DX,OFFSET WELCOME			 ;DISPLAYING PROMPT
	INT 21H
	MOV AH,9
	MOV DX,OFFSET INSTRUCTIONS			 ;DISPLAYING PROMPT
	INT 21H
	
	MOV AH,9
	MOV DX,OFFSET KEY			 ;DISPLAYING PROMPT
	INT 21H
	
	MOV AH,01 
	INT 21H
	START:
	
	CALL CLEAR
	
	CALL GENERATE
	
	MOV COUNT, 5
	MOV AH,9
	MOV DX,OFFSET WELCOME			 ;DISPLAYING PROMPT
	INT 21H
	
	MOV AH,9

	TRY:
	    ;TO REMOVE THESE LINES AS THESE ARE JUST FOR TESTING
	    MOV AH,2
	    MOV DL,0AH					; FOR LINE BREAK
	    INT 21H

		MOV AH,9
		MOV DX,OFFSET GUESS			 ;DISPLAYING PROMPT
		INT 21H
		
WINPUT: MOV AH,1
		INT 21H						; TAKING INPUT OF GUESS NUMBER
		MOV BL,AL
		CMP AL,'0'
		JAE NEXT
		JMP WINPUT
		MOV AH,9
		MOV DX,OFFSET VALIDINPUT			 ;DISPLAYING PROMPT
		INT 21H
		NEXT :CMP AL,'9'
		JNA THEEKINPUT
		MOV AH,9
		MOV DX,OFFSET VALIDINPUT			 ;DISPLAYING PROMPT
		INT 21H
		JMP WINPUT	
		THEEKINPUT:SUB COUNT, 1				;SUBTRACTING 1 TO GIVE 5 TRIES TO USER

		;TO REMOVE THESE LINES AS THESE ARE JUST FOR TESTING
	    MOV AH,2
	    MOV DL,0AH					; FOR LINE BREAK
	    INT 21H

		MOV AH, 9
		MOV DX, OFFSET TRIES		;DISPLAYING TRIES STRING
		INT 21H
		
		ADD COUNT, 30H				;ADDING 30H TO DISPLAY VALUE IN NUMBER

		MOV AH, 2
		MOV DL, COUNT				; DISPLAYING NUMBER OF TRIES LEFT
		INT 21H
		
		MOV AH,2
		MOV DL,0AH					; FOR LINE BREAK
		INT 21H
		
		SUB COUNT, 30H				;SUBTRACTING 30H TO AGAIN CONVERT NUMBER TO ASCII

		CMP COUNT, 0				; COMPARING COUNT WITH 0
		JE  AGAIN					; IF COUNT ARE 0 THEN JUMP TO AGAIN
		

		
		CMP BL, RANDOM				; COMPARING RANDOM NUMBER WITH GUESSED NUMBER
		JE EQUAL
		JL LESS
		JA GREATER
		
	
	GREATER:
		MOV AH,9
		MOV DX,OFFSET GREATERN			 ;DISPLAYING NUMBER GREATER
		INT 21H
		JMP TRY
	LESS:
		MOV AH,9
		MOV DX,OFFSET LESSN				 ;DISPLAYING NUMBER IS LESS
		INT 21H
		JMP TRY
	
	
	EQUAL:

		AGAIN:
		CALL CLEAR
		MOV AH,9
		MOV DX,OFFSET WELCOME			 ;DISPLAYING PROMPT
		INT 21H
		MOV AH,9
		CMP BL, RANDOM				; COMPARING RANDOM NUMBER WITH GUESSED NUMBER
		JNE WIN
		MOV AH,9
		MOV DX,OFFSET EQUALN			 ;DISPLAYING NUMBER MATCHED
		INT 21H
		WIN:
	
		MOV AH,9
		MOV DX,OFFSET SCOREE			 ;DISPLAYING SCORE
		INT 21H
			
		CMP RANDOM,BL
		JNE  LOSS
		INC COUNT
		ADD COUNT,30H
		MOV AH,02
		MOV DL,COUNT
		INT 21H
		LOSS:MOV AH,02
		MOV DL,'0'
		INT 21H
			;TO REMOVE THESE LINES AS THESE ARE JUST FOR TESTING
		MOV AH,2
		MOV DL,0AH					; FOR LINE BREAK
		INT 21H

		MOV AH,9
		MOV DX,OFFSET PLAYAGAIN			 ;DISPLAYING WANT TO PLAY AGAIN
		INT 21H
		
		ONION:MOV AH, 1
		INT 21H
		
		CMP AL, 'Y'
		JE START
		
		CMP AL, 'y'
		JE START
		CMP AL, 'n'
		JE EXIT
		CMP AL, 'N'
		JE EXIT	
		MOV AH,9
		MOV DX,OFFSET VALIDINPUT			 ;DISPLAYING PROMPT
		INT 21H
		JMP ONION
		JMP AGAIN
			
	
	EXIT:
		MOV AH,4CH
		INT 21H
		 
MAIN ENDP


CLEAR PROC
    MOV AX,0B800H
    MOV ES,AX
    MOV DI,0
    MOV AL,' '
    MOV AH,07D
    LOOP_CLEAR_12:
	MOV WORD PTR ES:[DI],AX
    INC DI
    INC DI
    CMP DI,4000
    JLE LOOP_CLEAR_12
    RET
CLEAR ENDP

GENERATE PROC
   MOV AH, 00H  ; INTERRUPTS TO GET SYSTEM TIME        
   INT 1AH      ; CX:DX NOW HOLD NUMBER OF CLOCK TICKS SINCE MIDNIGHT      
   MOV  AX, DX
   XOR  DX, DX
   MOV  CX, 10    
   DIV  CX       ; HERE DX CONTAINS THE REMAINDER OF THE DIVISION - FROM 0 TO 9
   ADD  DL, '0'  ; TO ASCII FROM '0' TO '9'
   MOV RANDOM,DL   
 RET
GENERATE ENDP

END MAIN