
# DS1307 Real-Time Clock with 8051 and LCD1602

##  Overview
This project demonstrates how to interface the DS1307 Real-Time Clock (RTC) module with an 8051 microcontroller and display the time on an LCD1602. It includes:

- LCD display control
- DS1307 I2C communication
- Time reading and ASCII conversion
- Final time formatting and display

##  Functions and Descriptions

### 📺 LCD Control Functions
| Function | Description |
|----------|-------------|
| `LCD_INIT` | Initializes the LCD1602 (8-bit mode, 2 lines). Sends commands: 0x38, 0x0C, 0x01, 0x06. |
| `LCD_CLEAR` | Clears the display with command 0x01. |
| `LCD_SETCURSOR` | Sets cursor at specified row (R0) and column (R1) by calculating DDRAM address. |
| `LCD_SEND_STRING` | Sends a null-terminated string to the LCD character by character. |
| `LCD_SEND_CHAR` | Sends a single character from the Microcontroller Unit (MCU) to the LCD display. |

### 🕰️ DS1307 Communication Functions
| Function | Description |
|----------|-------------|
| `DS1307_WRITE_BYTE` | Writes one byte to a DS1307 register via I2C. Input: R0 = address, A = data. |
| `DS1307_READ_BYTE` | Reads one byte from DS1307 register via I2C. Input: R0 = address, Output: A = data. |
| `DS1307_GET_SECOND`  | Retrieves the current seconds value from the DS1307 RTC.               |
| `DS1307_GET_MINUTES` | Retrieves the current minutes value from the DS1307 RTC.               |
| `DS1307_GET_HOURS`   | Retrieves the current hours value from the DS1307 RTC.                 |
| `DS1307_GET_DAY`     | Retrieves the current day of the week from the DS1307 RTC.             |
| `DS1307_GET_DATE`    | Retrieves the current date from the DS1307 RTC.                        |
| `DS1307_GET_MONTH`   | Retrieves the current month from the DS1307 RTC.                       |
| `DS1307_GET_YEAR`    | Retrieves the current year from the DS1307 RTC.                        |
| `DS1307_SET_SECOND`  | Sets the seconds value in the DS1307 RTC. Input: A = seconds in BCD.   |
| `DS1307_SET_MINUTES` | Sets the minutes value in the DS1307 RTC. Input: A = minutes in BCD.   |
| `DS1307_SET_HOURS`   | Sets the hours value in the DS1307 RTC. Input: A = hours in BCD.       |
| `DS1307_SET_DAY`     | Sets the day of the week in the DS1307 RTC. Input: A = day (1-7).      |
| `DS1307_SET_DATE`    | Sets the date in the DS1307 RTC. Input: A = date in BCD.               |
| `DS1307_SET_MONTH`   | Sets the month in the DS1307 RTC. Input: A = month in BCD.             |
| `DS1307_SET_YEAR`    | Sets the year in the DS1307 RTC. Input: A = year in BCD.               |
| `DS1307_CHANGE_CLOCK_FORMAT` | Changes the clock format of the DS1307 RTC. Input: C (bit). If C == 0, 24h format is selected; otherwise, 12h format is selected. |
| `DS1307_SET_SQW_FREQ`  | Sets the frequency of the DS1307 SQW (Square Wave) output pin. Input: A = frequency selection (0x00 = 1Hz, 0x01 = 4kHz, 0x02 = 8kHz, 0x03 = 32kHz). |
| `DS1307_SET_SQW`    | Enables or disables the Square Wave (SQW) output pin on the DS1307 RTC. Input: C (bit). If C == 1, the SQW output is enabled; otherwise, it is disabled. |

### Internal RAM Address Mapping for DS1307 Data

| DS1307 Information | Internal RAM Address |
|---------------------|----------------------|
| Second             | 0x30                |
| Minutes            | 0x31                |
| Hours              | 0x32                |
| Day                | 0x33                |
| Date               | 0x34                |
| Month              | 0x35                |
| Year               | 0x36                |

### 🟢 Time Conversion & Display Functions
| Function | Description |
|----------|-------------|
| `CONVERT_BCD_TO_ASCII` | Converts a BCD byte (in A) to ASCII digits. Output: R5 = tens, R6 = units. |
| `DISPLAY_TIME_TO_LCD` | Combines hours (R4), minutes (R3), seconds (R2) into formatted time "HH:MM:SS" and sends to LCD. |

##  Task Assignment (5 members)
| Member | Responsibility |
|--------|----------------|
| **Task 1** | Time display function `DISPLAY_TIME_TO_LCD`, overall integration, testing, report |
| **Task 2** | LCD initialization and clearing: `LCD_INIT`, `LCD_CLEAR` |
| **Task 3** | Cursor positioning and string output: `LCD_SETCURSOR`, `LCD_SEND_STRING`, `LCD_SEND_CHAR`|
| **Task 4** | DS1307 register read and time retrieval: `DS1307_READ_BYTE`, `DS1307_GET_TIME` |
| **Task 5** | BCD to ASCII conversion: `CONVERT_BCD_TO_ASCII` |

## 📎 Notes
- DS1307 uses **I2C** protocol.
- Time values are stored in **BCD** format.
- LCD1602 is used in **8-bit mode**.
- Conversion is needed before displaying to LCD.
- When changing the clock format using `DS1307_CHANGE_CLOCK_FORMAT`, the value of the hours register in the DS1307 RTC must be manually re-entered to ensure proper formatting.
---

>  Group Leader: **Khang Huynh**  
>  Project: Real-Time Clock using DS1307 + 8051 + LCD1602
