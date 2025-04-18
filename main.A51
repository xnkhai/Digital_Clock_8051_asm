<<<<<<< HEAD
; definition
LCD1602_RS_Pin equ P0.0
LCD1602_RW_Pin equ P0.1
LCD1602_EN_Pin equ P0.2
LCD1602_Data_Port equ P1
DS1307_Address equ #4eh
SDA equ P3.6
SCL equ P3.7

org 0000h
	jmp Start

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

end
=======
;-----------------------------------------------
; LCD_INIT
; Khởi tạo LCD1602 chế độ 8-bit
; Gửi các lệnh sau (dùng thanh ghi A + gọi LCD1602_Send_Ins):
; - 0x38: chế độ 8-bit, 2 dòng
; - 0x0C: hiển thị, tắt con trỏ
; - 0x01: xóa màn hình
; - 0x06: tự động tăng địa chỉ, không dịch màn hình
;-----------------------------------------------


;-----------------------------------------------
; LCD_CLEAR
; Gửi lệnh 0x01 để xóa toàn bộ nội dung LCD
; Gọi LCD1602_Send_Ins, không cần thay đổi gì thêm
;-----------------------------------------------


;-----------------------------------------------
; LCD_SETCURSOR
; Đặt vị trí con trỏ tại (row, col)
; - Input: R0 = row (0 hoặc 1), R1 = col (0..15)
; - Tính địa chỉ DDRAM:
;     row = 0 → addr = 0x80 + col
;     row = 1 → addr = 0xC0 + col
; - Gán addr vào A, rồi gọi LCD1602_Send_Ins
;-----------------------------------------------


;-----------------------------------------------
; LCD_SEND_STRING
; LCD_Send_String
; Gửi chuỗi ký tự đến LCD
; - DPTR trỏ đến chuỗi kết thúc bằng 0 (null-terminated)
; - Duyệt từng ký tự:
;     + MOVX A, @DPTR
;     + CJNE A, #0, tiếp tục
;     + Gọi LCD1602_Send_Data
;-----------------------------------------------


;-----------------------------------------------
; DS1307_READ_BYTE
; Đọc 1 byte dữ liệu từ DS1307 tại địa chỉ reg
; Tham số: R0 chứa địa chỉ thanh ghi (reg)
; Trả về: A chứa dữ liệu đọc được từ DS1307
;-----------------------------------------------


;-----------------------------------------------
; DS1307_GET_TIME
; Đọc thời gian hiện tại từ DS1307 (giây, phút, giờ)
; Trả về: R2 = giây, R3 = phút, R4 = giờ
;-----------------------------------------------


;-----------------------------------------------
; CONVERT_BCD_TO_ASCII
; Chuyển 1 byte BCD sang 2 ký tự ASCII (ví dụ: 0x45 -> '4', '5')
; Đầu vào: A chứa giá trị BCD
; Đầu ra: R5 = ASCII hàng chục, R6 = ASCII hàng đơn vị
;-----------------------------------------------
xuan khai was here gay ????


;-----------------------------------------------
; DISPLAY_TIME_TO_LCD
; Hiển thị thời gian hiện tại lên LCD1602 ở hàng 1, cột 0
; Định dạng: HH:MM:SS
; mục đích của hàm này là sao? là dùng để gọi các hàm đã viết phía trên để trong hàm main chỉ cần gọi hàm DISPLAY_TIME_TO_LCD
; và thêm một số cái delay thì sẽ hiện giờ 
;-----------------------------------------------



