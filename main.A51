
;-----------------------------------------------
; I2C Interface
;-----------------------------------------------
I2C_Start:
      setb SDA	; ensure SDA is high
      setb SCL	; ensure SCL is high
      clr SDA	; Pull SDA to low
      ret
I2C_Send_Byte:
      mov R7, #8;				(1 cycle)
      send_loop:
      clr SCL	; ready for data transfer 	(1 cycle)
      rlc A ; 					(1 cycle)
      mov SDA, C ; 				(2 cycles)
      acall delay_3us ;				(6 cycles)
      setb SCL  ; 				(1 cycle)
      acall delay_3us;				(6 cycles)
      nop	; 				(1 cycle)
      DJNZ R7, send_loop ;			(2 cycles)
      clr SCL	;				(1 cycle)
      ret;					(2 cycles)
I2C_Read_ACK:
      acall delay_2us;				(4 cycles)
      setb SDA	; 				(1 cycle)
      setb SCL ;				(1 cycles)
      mov C, SDA;				(1 cycle)
      nop;					(1 cycle)
      nop;					(1 cycle)
      ret ; 					(2 cycles)
I2C_Read_Byte:
      mov R7, #8; counter			(1 cycle)
      read_loop:
      setb SCL;					(1 cycle)
      mov C, SDA; read SDA's state		(1 cycle)
      rlc A;	shift read bit to A register	(1 cycle)
      acall delay_3us;				(6 cycles)
      nop;					(1 cycle)
      clr SCL;					(1 cycle)
      acall delay_3us;				(6 cycles)
      nop;					(1 cycle)
      DJNZ R7, read_loop;			(2 cycles)
      setb SCL;					(1 cycle) 
      ret;					(2 cycles)
I2C_Send_Ack:
      clr SDA;					(1 cycle)
      acall delay_2us;				(4 cycles)
      setb SCL;					(1 cycle)
      ret;					(2 cycles)
I2C_Send_NoAck:
      nop;					(1 cycle)
      acall delay_2us;				(4 cycles)
      clr SCL;					(1 cycle)
      acall delay_4us;				(8 cycles)
      setb SDA;					(1 cycle)
      setb SCL;					(1 cycle)
      ret;					(2 cycles)
I2C_Stop:
      nop ;					(1 cycle)
      nop ;					(1 cycle)
      clr SCL	; Push SCL to high		(1 cycle)
      clr SDA;					(1 cycle)
      acall delay_4us;				(8 cycles)
      setb SCL;					(1 cycle)
      setb SDA	;stop condition			(1 cycle)
      ret;					(2 cycle)
delay_5us:
      nop ; 					(1 cycle)
      nop ; 					(1 cycle)
      nop ; 					(1 cycle)
      nop ; 					(1 cycle)
      nop ; 					(1 cycle)
      nop ; 					(1 cycle)
      ret	;				(2 cycles)
delay_4us:
      nop ; 					(1 cycle)
      nop ; 					(1 cycle)
      nop ; 					(1 cycle)
      nop ; 					(1 cycle)
      ret	;				(2 cycles)
delay_3us:
      nop ; 					(1 cycle)
      nop ; 					(1 cycle)
      ret	;				(2 cycles)
delay_2us:
      ret	;				(2 cycles)
delay_1ms:
      mov R1, #166;				(1 cycle)
      delay_loop:
      acall delay_5us;				(10 cycles)
      djnz R1, delay_loop;			(2 cycles)
      nop
      nop
      nop
      ret;					(2 cycles)
; su dung thanh ghi R2 lam tham so (ms > 1)
; todo: chua chinh xac
delay_ms:
      ;dec R2;					(1 cycle)
      delay_ms_loop:
      acall delay_1ms;				(2000 cycles)
      djnz R2, delay_ms_loop;			(2 cycle)
      ret;					(2 cycle)
      





;-----------------------------------------------;
;lcd 8-bit paralel 
;-----------------------------------------------;