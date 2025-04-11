
# DS1307 Real-Time Clock with 8051 and LCD1602

##  Overview
This project demonstrates how to interface the DS1307 Real-Time Clock (RTC) module with an 8051 microcontroller and display the time on an LCD1602. It includes:

- LCD display control
- DS1307 I2C communication
- Time reading and ASCII conversion
- Final time formatting and display

## ⚙️ Functions and Descriptions

### 🟡 LCD Control Functions
| Function | Description |
|----------|-------------|
| `LCD_INIT` | Initializes the LCD1602 (8-bit mode, 2 lines). Sends commands: 0x38, 0x0C, 0x01, 0x06. |
| `LCD_CLEAR` | Clears the display with command 0x01. |
| `LCD_SETCURSOR` | Sets cursor at specified row (R0) and column (R1) by calculating DDRAM address. |
| `LCD_SEND_STRING` | Sends a null-terminated string to the LCD character by character. |

### 🔵 DS1307 Communication Functions
| Function | Description |
|----------|-------------|
| `DS1307_READ_BYTE` | Reads one byte from DS1307 register via I2C. Input: R0 = address, Output: A = data. |
| `DS1307_GET_TIME` | Reads seconds, minutes, and hours into R2, R3, and R4. |

### 🟢 Time Conversion & Display Functions
| Function | Description |
|----------|-------------|
| `CONVERT_BCD_TO_ASCII` | Converts a BCD byte (in A) to ASCII digits. Output: R5 = tens, R6 = units. |
| `DISPLAY_TIME_TO_LCD` | Combines hours (R4), minutes (R3), seconds (R2) into formatted time "HH:MM:SS" and sends to LCD. |

## 👥 Task Assignment (5 members)
| Member | Responsibility |
|--------|----------------|
| **Task 1** | Time display function `DISPLAY_TIME_TO_LCD`, overall integration, testing, report |
| **Task 2** | LCD initialization and clearing: `LCD_INIT`, `LCD_CLEAR` |
| **Task 3** | Cursor positioning and string output: `LCD_SETCURSOR`, `LCD_SEND_STRING` |
| **Task 4** | DS1307 register read and time retrieval: `DS1307_READ_BYTE`, `DS1307_GET_TIME` |
| **Task 5** | BCD to ASCII conversion: `CONVERT_BCD_TO_ASCII` |

## 📎 Notes
- DS1307 uses **I2C** protocol.
- Time values are stored in **BCD** format.
- LCD1602 is used in **8-bit mode**.
- Conversion is needed before displaying to LCD.

---

>  Group Leader: **Khang Huynh**  
>  Project: Real-Time Clock using DS1307 + 8051 + LCD1602
