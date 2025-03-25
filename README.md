# Lab 2: Hexadecimal Up/Down Counter with ATmega328P

## Overview

This project implements a hexadecimal up/down counter using the ATmega328P microcontroller, an 8-bit shift register, a 7-segment LED display, and a pushbutton. All software is written in Assembly language and interfaces directly with the hardware components.

The project satisfies all functionality requirements defined in the Lab 2 assignment for the Embedded Systems course.

## Features

- **Hexadecimal Counter (0–F)**
- **Increment/Decrement Mode Toggle**
- **Counter Reset**
- **Shift Register Output to 7-Segment Display**
- **Hardware Debounce Implementation**
- **Decimal Point Indicator for Decrement Mode**

## How It Works

### Power-On Behavior

- On startup, the display shows `0`, and the counter is in **increment** mode (DP off).

### Pushbutton Functions

| Button Press Duration | Mode                        | Action                              |
|-----------------------|-----------------------------|-------------------------------------|
| < 1 second            | Increment                   | Increase counter (0 → F, wraps to 0)|
| < 1 second            | Decrement                   | Decrease counter (F → 0, wraps to F)|
| 1–2 seconds           | Any                         | Toggle between increment/decrement mode |
| ≥ 2 seconds           | Any                         | Reset counter to `0` (increment mode) |

> All button actions are triggered **on release**, and debouncing is handled via a hardware-based approach.

### Display

- Counter value is shown on the 7-segment display.
- Decimal Point (DP) indicates current mode:
  - **OFF** → Increment Mode
  - **ON** → Decrement Mode

## Hardware Components

- ATmega328P Microcontroller
- 8-bit Shift Register (e.g., 74HC595)
- 7-Segment Common Cathode LED Display
- Pushbutton Switch
- Resistors (to limit current to ≤ 6 mA per segment)
- Breadboard and connecting wires

## Code Functionality

- Outputs binary values to shift register to light up the correct segments of the display.
- Tracks elapsed time using timer/counter to distinguish between short, medium, and long button presses.
- Manages current state (increment/decrement/reset) and counter value in registers.
- Updates display and DP according to current mode and counter value.

## Setup Instructions

1. Connect the ATmega328P to the 74HC595 shift register and 7-segment display following the lab schematic.
2. Wire the pushbutton with hardware debounce (capacitor + resistor circuit).
3. Assemble and upload the Assembly code to the microcontroller.
4. Power the board and test all counter functionalities per the lab instructions.

## Mid-Lab Review Expectations

- **February 12:** Show interaction between MCU and both pushbutton and display. Debouncing should work.
- **February 19:** Demonstrate increment functionality including wrap-around from `F` to `0`.

## Final Submission Requirements

- One `.asm` source file (this code)
- One lab report per group
- Submit via ICON by **February 26**
- Checkoff required if being graded in person

## Authors

- [Your Name]
- [Teammate's Name]

## License

This project is part of an academic course. Use is restricted to educational purposes.
