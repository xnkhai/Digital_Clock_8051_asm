
; definition
LCD1602_RS_Pin equ P0.0
LCD1602_RW_Pin equ P0.1
LCD1602_EN_Pin equ P0.2
LCD1602_Data_Port equ P1
DS1307_Address equ 0d0h
SDA equ P3.6
SCL equ P3.7
DS1307_Second_Reg equ 00h
DS1307_Minutes_Reg equ 01h
DS1307_Hours_Reg equ 02h
DS1307_Day_Reg equ 03h
DS1307_Date_Reg equ 04h
DS1307_Month_Reg equ 05h
DS1307_Year_Reg equ 06h
DS1307_Control_Reg equ 07h
DS1307_Ram equ 08h
LCD_Clear_Screen equ 01h
LCD_Reset_Cursor equ 02h
LCD_Input_Set equ 04h
LCD_Display_Switch equ 08h
LCD_Shift equ 10h
LCD_Function_Set equ 20h
LCD_Set_CGRAM_Addr equ 40h
LCD_Set_DDRAM_Addr equ 80h



org 0000h
	jmp Start

org 0030h
    monday: db "MON", 0 
    tuesday: db "TUE", 0
    wednesday: db "WED", 0
    thursday: db "THU", 0
    friday: db "FRI", 0
    saturday: db "SAT", 0 
    sunday: db "SUN", 0

org 0100h
Start:
	acall LCD_INIT			; Khởi tạo LCD

MainLoop:
	acall DS1307_GET_TIME		; Đọc giờ từ DS1307, lưu vào R2, R3, R4
	
	acall DISPLAY_TIME_TO_LCD	; Hiển thị lên LCD

	mov R2, #5			; Delay 5 lần * 200ms = khoảng 1 giây
Delay1s:
	mov R1, #200
	acall delay_ms
	djnz R2, Delay1s

	sjmp MainLoop			; Lặp lại


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
;-----------------------------------------------;
;delay functions
;-----------------------------------------------;
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
;lcd 8-bit parallel 
;-----------------------------------------------;
; brief: send instuction code to lcd 1602
; use register A as instruction code byte to be sent
LCD1602_Send_Ins:
	setb LCD1602_EN_Pin
	clr LCD1602_RW_Pin
	clr LCD1602_RS_Pin
	mov LCD1602_Data_Port, A
	acall delay_3us
	clr LCD1602_EN_Pin
	mov R2, #2d
	acall delay_ms
	ret
	
; brief: send data to lcd 1602's RAM (DDRAM, CGRAM)
; use register A as data byte to be sent
LCD1602_Send_Data:
	setb LCD1602_EN_Pin
	clr LCD1602_RW_Pin
	setb LCD1602_RS_Pin
	mov LCD1602_Data_Port, A
	acall delay_3us
	clr LCD1602_EN_Pin
	mov R2, #2d
	acall delay_ms
	ret

;-----------------------------------------------
; LCD_INIT
; Khởi tạo LCD1602 chế độ 8-bit
;-----------------------------------------------
LCD_INIT:
	; initialize lcd 1602
	mov R2, #15d
	acall delay_ms
	mov A, #30h
	acall LCD1602_Send_Ins
	mov R2, #5d
	acall delay_ms
	mov A, #30h
	acall LCD1602_Send_Ins
	acall delay_2us
	mov A, #30h
	acall LCD1602_Send_Ins
	mov R2, #10d
	acall delay_ms
	
	;setup lcd 1602
	mov A, #38h ; function set -> DL = 1 (8 bit mode), N = 1 (2 line), F = 0 (5 x 8 characters)
	acall LCD1602_Send_Ins
	mov A, #08h ; turn the display, cursor, blinking off (D = 0, C = 0, B = 0)
	acall LCD1602_Send_Ins
	mov A, #01h ; screen clear instruction code
	acall LCD1602_Send_Ins
	mov A, #06h ; input set -> I/D = 1 (Increment mode), S = 0 (no shift)
	acall LCD1602_Send_Ins
	mov A, #0Ch ; turn the dislay on, D = 1
	acall LCD1602_Send_Ins    
    ret 

;-----------------------------------------------
; LCD_CLEAR
; Gửi lệnh 0x01 để xóa toàn bộ nội dung LCD
; Gọi LCD1602_Send_Ins, không cần thay đổi gì thêm
;-----------------------------------------------
LCD_Clear:
    mov A, #01h            ; Lệnh 0x01 clear
    acall LCD1602_Send_Ins ; 
    ret


;-----------------------------------------------
; LCD_SETCURSOR
; Đặt vị trí con trỏ tại (row, col)
; - Input: R0 = row (0 hoặc 1), R1 = col (0..15)
; - Tính địa chỉ DDRAM:
;     row = 0 → addr = 0x80 + col
;     row = 1 → addr = 0xC0 + col
; - Gán addr vào A, rồi gọi LCD1602_Send_Ins
;-----------------------------------------------
;Đặt vị trí con trỏ tại (row, col)
LCD_SETCURSOR:
    mov A, R0           ; Kiểm tra hàng (row)
    cjne A, #0, Row1    ; Nếu R0 ≠ 0 → row 1
; Row = 0
    mov A, #80h         ; 
    add A, R1           ; A = 0x80 + col
    sjmp SetCursor

Row1:
    mov A, #0C0h        ; Base address for row 1
    add A, R1           ; A = 0xC0 + col

SetCursor:
    acall LCD1602_Send_Ins
    ret

;-----------------------------------------------
;LCD_Send_Char
;-----------------------------------------------
; Gửi một ký tự đến LCD
; A = ký tự ASCII cần hiển thị
LCD_Send_Char:
    acall LCD1602_Send_Data
    ret


;-----------------------------------------------
; LCD_SEND_STRING
; Gửi chuỗi ký tự đến LCD
; - DPTR trỏ đến chuỗi kết thúc bằng 0 (null-terminated)
;-----------------------------------------------
LCD_SEND_STRING:
    clr A                    ; Đặt offset ban đầu = 0
Next_Char:
    push ACC
    movc A, @A+DPTR          ; Đọc ký tự từ ROM (DPTR + offset A)
    jz Done                  ; Nếu A == 0 (kết thúc chuỗi), thoát
    acall LCD1602_Send_Data  ; Gửi ký tự ra LCD
    pop ACC 
    inc A                    ; Tăng offset
    sjmp Next_Char           ; Lặp lại
Done:
    ret
;-----------------------------------------------
;-----------------------------------------------
; DS1307_WRITE_BYTE
; Ghi 1 byte dữ liệu vào DS1307 tại địa chỉ reg
; Tham số: A chứa địa chỉ thanh ghi (reg)
; 	   B chứa dữ liệu cần ghi (data)		
;-----------------------------------------------
DS1307_WRITE_BYTE:
	push ACC
	mov A, #DS1307_Adress
	acall I2C_Start
	acall I2C_Send_Byte
	acall I2C_Read_ACK
    pop ACC
	acall I2C_Send_Byte
	acall I2C_Read_ACK
	mov A, B
	acall I2C_Send_Byte
	acall I2C_Read_ACK
	acall I2C_Stop
	ret

;-----------------------------------------------
; DS1307_READ_BYTE
; Đọc 1 byte dữ liệu từ DS1307 tại địa chỉ reg
; Tham số: R0 chứa địa chỉ thanh ghi (reg)
; Trả về: A chứa dữ liệu đọc được từ DS1307
;huy
;-----------------------------------------------
DS1307_READ_BYTE:
	PUSH Acc
	mov A, #DS1307_Address
      	acall I2C_Start
      	acall I2C_Send_Byte
     	acall I2C_Read_ACK
     	pop Acc
      	acall I2C_Send_Byte
     	acall I2C_Read_ACK
     	acall I2C_Stop
    	mov A, #DS1307_Address
    	orl A, #1
   	acall I2C_Start
     	acall I2C_Send_Byte
     	acall I2C_Read_ACK
      	acall I2C_Read_Byte
      	acall I2C_Send_NoAck
      	acall I2C_Stop
	RET


;-----------------------------------------------
; DS1307_SET_SQW_FREQ
; Cài đặt tần số xung output của DS1307
; Tham số: 	A = 0x00 -> 1Hz
;	    	A = 0x01 -> 4kHz
;	    	A = 0x02 -> 8kHz
;	    	A = 0x03 -> 32kHz 
;-----------------------------------------------
DS1307_SET_SQW_FREQ:
    push ACC
    mov A, #DS1307_Control_Reg
    acall DS1307_READ_BYTE
    mov B, A 
    pop ACC

	sqw_1hz:
	cjne A, #00h, sqw_4kHz
    mov A, B
	anl A, #0fch
    sjmp final_set_freq
	
	sqw_4kHz:
	cjne A, #01h, sqw_8kHz
    mov A, B
    orl A, #1
    anl A, #0fdh
    sjmp final_set_freq

	sqw_8kHz:
	cjne A, #02h, sqw_32kHz
    mov A, B
    orl A, #2 
    anl A, #0feh
    sjmp final_set_freq

	sqw_32kHz:
    mov A, B
    orl A, #3
	
    final_set_freq:
	mov B, A
	mov A, #DS1307_Control_Reg
	acall DS1307_WRITE_BYTE
    ret 


;-----------------------------------------------
; DS1307_SET_SQW
; Bật tắt xung output của DS1307
; Tham số: 	C = 0 -> off
;           C = 1 -> on
;-----------------------------------------------
DS1307_SET_SQW:
    mov A, #DS1307_Control_Reg 
    acall DS1307_READ_BYTE
    jnc off
    on:
    orl A, #1
    sjmp final_set_sqw
    off:
    anl A, #0efh
    final_set_sqw:
    mov B, A 
    mov A, #DS1307_Control_Reg
    acall DS1307_WRITE_BYTE
    ret

;-----------------------------------------------
; DS1307_GET: Các hàm để lấy thông tin từ DS1307
;-----------------------------------------------

;-----------------------------------------------
DS1307_GET_SECOND:
	MOV A, #DS1307_Second_Reg
	ACALL DS1307_READ_BYTE
	MOV 30H, A
	RET
;-----------------------------------------------
DS1307_GET_MINUTES:
	MOV A, #DS1307_Minutes_Reg
	ACALL DS1307_READ_BYTE
	MOV 31H, A
	RET
;-----------------------------------------------
DS1307_GET_HOURS:	
	MOV A, #DS1307_Hours_Reg
	ACALL DS1307_READ_BYTE
	MOV 32H, A
	RET
;-----------------------------------------------
DS1307_GET_DAY:	
	MOV A, #DS1307_Day_Reg
	ACALL DS1307_READ_BYTE
	MOV 33H, A
	RET
;-----------------------------------------------
DS1307_GET_DATE:	
	MOV A, #DS1307_Date_Reg
	ACALL DS1307_READ_BYTE
	MOV 34H, A
	RET
	
;-----------------------------------------------
DS1307_GET_MONTH:	
	MOV A, #DS1307_Month_Reg
	ACALL DS1307_READ_BYTE
	MOV 35H, A
	RET
	
;-----------------------------------------------
DS1307_GET_YEAR:	
	MOV A, #DS1307_Year_Reg
	ACALL DS1307_READ_BYTE
	MOV 36H, A
	RET	

;-----------------------------------------------
;HÀM SET_TIME
;HI?N TRUY?N GIÁ TR? C? Ð?NH VÔ 
;-----------------------------------------------
DS1307_SET_SECOND:
	mov B , A
	mov A, #DS1307_Second_Reg
	acall DS1307_WRITE_BYTE
	RET
	
;;-----------------------------------------------
DS1307_SET_MINUTES:
	mov B , A
	mov A, #DS1307_Minutes_Reg
	acall DS1307_WRITE_BYTE
	RET
	
;;-----------------------------------------------
DS1307_SET_HOURS:
	mov B , A
	mov A, #DS1307_Hours_Reg
	acall DS1307_WRITE_BYTE
	RET

;;-----------------------------------------------
DS1307_SET_DAY:
	mov B , A
	mov A, #DS1307_Day_Reg
	acall DS1307_WRITE_BYTE
	RET

;;-----------------------------------------------
DS1307_SET_DATE:
	mov B , A
	mov A, #DS1307_Date_Reg
	acall DS1307_WRITE_BYTE
	RET
	
;;-----------------------------------------------
DS1307_SET_MONTH:
	mov B , A
	mov A, #DS1307_Month_Reg
	acall DS1307_WRITE_BYTE
	RET	
	
;;-----------------------------------------------
DS1307_SET_YEAR:
	mov B , A
	mov A, #DS1307_Year_Reg
	acall DS1307_WRITE_BYTE
	RET
	
;-----------------------------------------------
; CONVERT_BCD_TO_ASCII
; Chuyển 1 byte BCD sang 2 ký tự ASCII (ví dụ: 0x45 -> '4', '5')
; Đầu vào: A chứa giá trị BCD
; Đầu ra: R5 = ASCII hàng chục, R6 = ASCII hàng đơn vị
;-----------------------------------------------
CONVERT_BCD_TO_ASCII:
    mov R5, A 
    anl A, #0fh
    mov R6, #30h
    orl A, R6
    mov R6, A 
    mov A, R5 
    swap A          ; swap nibbles
    anl A, #0fh 
    mov R5, #30h
    orl A, R5 
    mov R5, A 
    ret 

;-----------------------------------------------
; DISPLAY_TIME_TO_LCD
; Hiển thị thời gian hiện tại lên LCD1602 ở hàng 1, cột 0
; Định dạng: HH:MM:SS
; mục đích của hàm này là sao? là dùng để gọi các hàm đã viết phía trên để trong hàm main chỉ cần gọi hàm DISPLAY_TIME_TO_LCD
; và thêm một số cái delay thì sẽ hiện giờ 
;-----------------------------------------------
DISPLAY_TIME_TO_LCD:
	MOV A, 0X30  ; hours
	ACALL CONVERT_BCD_TO_ASCII 
	MOV A, R5
	ACALL LCD1602_Send_Data	
	MOV A, R6
	ACALL LCD1602_Send_Data
	MOV A, #03Ah ; hienthi dau :
	ACALL LCD1602_Send_Data
	
	MOV A, 0X31  ; minutes
	ACALL CONVERT_BCD_TO_ASCII 
	MOV A, R5
	ACALL LCD1602_Send_Data
	MOV A, R6
	ACALL LCD1602_Send_Data
	MOV A, #03Ah
	ACALL LCD1602_Send_Data
	
	MOV A, 32H ; seconds
	ACALL CONVERT_BCD_TO_ASCII 
	MOV A, R5
	ACALL LCD1602_Send_Data
	MOV A, R6
	ACALL LCD1602_Send_Data
	MOV A, #03Ah
	ACALL LCD1602_Send_Data
	
	RET 


