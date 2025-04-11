# DS1307 Real-Time Clock with 8051 and LCD1602

## Overview
This project demonstrates how to interface the DS1307 Real-Time Clock (RTC) module with an 8051 microcontroller and display the time on an LCD1602 module. The project is divided into three main parts:
- LCD control
- DS1307 communication
- Time processing and display

## Functions and Responsibilities

### 🟡 LCD Control Functions
| Function | Description |
|----------|-------------|
| `LCD_INIT` | Initializes the LCD1602 module (8-bit mode, 2-line display). Sends command codes: 0x38, 0x0C, 0x01, 0x06. |
| `LCD_CLEAR` | Clears the LCD display by sending command 0x01. |
| `LCD_SETCURSOR` | Sets the LCD cursor to a specific row and column by calculating the DDRAM address. Inputs: R0 = row, R1 = column. |
| `LCD_SEND_STRING` | Sends a null-terminated string to the LCD by iterating over each character and calling `LCD1602_Send_Data`. |

### 🔵 DS1307 Communication Functions
| Function | Description |
|----------|-------------|
| `DS1307_READ_BYTE` | Reads a byte from a register of the DS1307 via I2C. Input: R0 = register address. Output: A = byte value. |
| `DS1307_GET_TIME` | Reads the seconds, minutes, and hours from DS1307 registers. Outputs: R2 = seconds, R3 = minutes, R4 = hours. |

### 🟢 Time Processing Functions
| Function | Description |
|----------|-------------|
| `CONVERT_BCD_TO_ASCII` | Converts a BCD-encoded byte in A to two ASCII digits. Outputs: R5 = tens digit (ASCII), R6 = units digit (ASCII). |
| `DISPLAY_TIME_TO_LCD` | Converts hour (R4), minute (R3), and second (R2) to ASCII and formats as "HH:MM:SS". Uses `CONVERT_BCD_TO_ASCII` and sends string to LCD. |

## Task Assignment Suggestion
- **Member 1:** LCD functions (`LCD_INIT`, `LCD_CLEAR`, `LCD_SETCURSOR`, `LCD_SEND_STRING`)
- **Member 2:** DS1307 communication (`DS1307_READ_BYTE`, `DS1307_GET_TIME`)
- **Member 3:** Time processing and display (`CONVERT_BCD_TO_ASCII`, `DISPLAY_TIME_TO_LCD`)

## Notes
- The DS1307 communicates using the I2C protocol.
- The LCD1602 is connected in 8-bit mode.
- Time is stored in BCD format and must be converted before display.

---

> Group leader: Khang Huynh  
> Project: Real-Time Clock with DS1307 + 8051 + LCD1602

