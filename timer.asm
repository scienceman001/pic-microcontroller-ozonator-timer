list P=16f84a
include "p16f84a.inc"
__config _RC_OSC & _WDT_OFF & _CP_OFF
 STATUS		    equ       03h                 ;Address of the STATUS register
 TRISA              equ       85h                 ;Address of the tristate register for port A
 PORTA              equ       05h                 ;Address of Port A
 OPTION_REG          equ       81h	
	  
 COUNTER             equ       08h                  ;First counter for our delay loops
 
 

;****Set up the port**** 
org 0

bsf                   STATUS,5       ;Switch to Bank 1

;set up timer to 65.5 each tick	      
;seting option register PSA=0 PS2-P21-PS0=111  prescaler set to 256	      
movlw                   b'0000111'
movwf                   OPTION_REG
	      

 
;set output pis on PORTA	      
movlw             b'00000000'                 
movwf             TRISA              ;to output.    
	      
                    

                        
bcf                  STATUS,5       ;Switch back to Bank 0 
;turn let on and of

LED_ON               movlw               02h                   
		     movwf               PORTA  
		     ;reseting counter
		     movlw                d'16'
		     movwf                COUNTER
		     goto                 Loop_ON
		     
LED_OFF              movlw               00h                   
		     movwf               PORTA 
		     ;reseting counter
		     movlw                d'16'
		     movwf                COUNTER
	     	     goto                 Loop_OFF  		     
		     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		     

Loop_ON              decfsz               COUNTER,1           ;Subtract 1 from 16
		     goto                 TIMER_CIRCLE_ON          
                     goto                 LED_OFF             ;If COUNTER is equal to 0 it will jump here
                    
Loop_OFF             decfsz               COUNTER,1           ;Subtract 1 from 16
		     goto                 TIMER_CIRCLE          
                     goto                 LED_ON            ;If COUNTER is equal to 0 it will jump here
                    		     
		     
TIMER_CIRCLE_ON      clrf TMR0 ;clearing timer
       
	CHECKER_ON   movf TMR0,w         ;mooves TMR0 value into W register
		     xorlw  .255         ;check if w register is equal to 255
		     btfss  STATUS,Z	 ;if its true jump over
		     goto  CHECKER_ON
		     goto  Loop_ON          ;if its true go to Loop
	
		     
TIMER_CIRCLE_OFF     clrf TMR0

 	CHECKER_OFF  movf TMR0,w         ;mooves TMR0 value into W register
		     xorlw  .255         ;check if w register is equal to 255
		     btfsc  STATUS,Z	 ;if its true jump over
		     goto  CHECKER_OFF
		     goto  Loop_OFF          ;if its true go to Loop
		     		     
	
 
end


                                                                           


        