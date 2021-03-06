/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include <stdio.h>
#include "xil_io.h"
#include "sleep.h"

#define CHAR_SEL_REG_ADDR 0x43C00000
#define NET_OUT_REG_ADDR 0x43C00004
#define DIRECT_CTRL_REG_ADDR 0x43C00008
#define DEBUG_REG_ADDR 0x43C0000C
#define AUX0_REG_ADDR 0x43C00010
#define AUX1_REG_ADDR 0x43C00014
#define AUX2_REG_ADDR 0x43C00018
#define AUX3_REG_ADDR 0x43C0001C

#define PWM_CLK_DIV_REG_ADDR 0x43C00020
#define PWM_CLK_DUTY_CYCLE_REG_ADDR 0x43C00024
#define PWM_CLK_CNTR_REG_ADDR 0x43C00028

#define PMOD_DAC_REG_ADDR 0x43C0002C

int main()
{
    init_platform();

    printf("Test Project\n\r");
	printf("Writing to a custom IP register...\n\r");

	Xil_Out32(CHAR_SEL_REG_ADDR, 0xBEEF);
	printf("Done\n\r");

	printf("Writing to a custom IP register...\n\r");
	Xil_Out32(NET_OUT_REG_ADDR, 0xBEEF);
	printf("Done\n\r");

	printf("Writing to a custom IP register...\n\r");
	// enable slow clock
	Xil_Out32(DIRECT_CTRL_REG_ADDR, 0xBEEF);
	printf("Done\n\r");

	int value = 0;

	printf("Reading from a custom IP register...\n\r");
	value = Xil_In32(CHAR_SEL_REG_ADDR);
	printf("Read: %x\n\r",value);

	printf("Reading from a custom IP register...\n\r");
	value = Xil_In32(NET_OUT_REG_ADDR);
	printf("Read: %x\n\r",value);

	printf("Reading from a custom IP register...\n\r");
	value = Xil_In32(DIRECT_CTRL_REG_ADDR);
	printf("Read: %x\n\r",value);

	// Slow Mode
	// LED Controls
	// BIT 0: IF ACTIVE, then display char information on LEDs, ELSE display network output on LEDS
	// BIT 1: IF ACTIVE, then display direct_ctrl_reg values on LEDS, ELSE display char_pwm_gen outputs on LEDS 
	// Output Controls
	// BIT 2: Use direct_ctrl_reg value as digit outputs ELSE use char_pwm_gen
	// BIT 3: Use slow 1HZ Clock
	// BIT 4: Use One-Hot Encoding for ADC_MUXADDR
	//Xil_Out32(DEBUG_REG_ADDR, 0x18);
	
	// continuously read network output
	long iterations = 0;

	while(1){
		/*
		int mode = 0;
		int output_char = 0;

		for (output_char = 0; output_char < 4; output_char++){
			printf("Displaying output for character %d...\n\r",output_char);
			Xil_Out32(0x43C00000, output_char);
			// use fast mode and slow mode for 5 secs each
			for(mode = 0; mode < 2; mode++){
				printf("Writing to debug register...\n\r");
				Xil_Out32(0x43C00008, mode);
				sleep(2);
			}
		}
		*/
		
		/*
		// printf("Reading from a network output register...\n\r");
		print("========================================\n\r");
		value = Xil_In32(NET_OUT_REG_ADDR);
		printf("[%d] Read %x from network output register.\n\r",iterations,value);
		print("----------------------------------------\n\r");

		value = Xil_In32(AUX0_REG_ADDR);
		printf("[%d] Read %x from MEASURED_AUX0 register.\n\r",iterations,value);

		value = Xil_In32(AUX1_REG_ADDR);
		printf("[%d] Read %x from MEASURED_AUX1 register.\n\r",iterations,value);
		
		value = Xil_In32(AUX2_REG_ADDR);
		printf("[%d] Read %x from MEASURED_AUX2 register.\n\r",iterations,value);

		value = Xil_In32(AUX3_REG_ADDR);
		printf("[%d] Read %x from MEASURED_AUX3 register.\n\r",iterations,value);
		
		iterations++;

		sleep(2);
		*/

		/*
		printf("=========================================\n\r",value);

		// Test Slow Mode Config
		// PWM BLK Clock Out, Slow Clock Enable, Display Digits on LEDs
		Xil_Out32(DEBUG_REG_ADDR,0x49);
		value = Xil_In32(DEBUG_REG_ADDR);
		printf("Read %x from DEBUG_REG_ADDR register.\n\r",value);

		// PWM CLK Divider = ~1.3s
		Xil_Out32(PWM_CLK_DIV_REG_ADDR,0x14);
		value = Xil_In32(PWM_CLK_DIV_REG_ADDR);
		printf("Read %x from PWM_CLK_DIV_REG_ADDR register.\n\r",value);

		// PWM Duty Cycle = 50%
		Xil_Out32(PWM_CLK_DUTY_CYCLE_REG_ADDR,0x00080000);
		value = Xil_In32(PWM_CLK_DUTY_CYCLE_REG_ADDR);
		printf("Read %x from PWM_CLK_DUTY_CYCLE_REG_ADDR register.\n\r",value);
		
		// Read PWM_CLK_CNTR Value
		value = Xil_In32(PWM_CLK_CNTR_REG_ADDR);
		printf("Read %x from PWM CLK CNTR register.\n\r",value);

		sleep(5);

		
		
		int dc = 0;
		int step_size = 0x00100000 / 10;
		for(i = 0; i <= step_size * 10; i += step_size){
			printf("DUTY CYCLE = %d%%\n\r",dc);
			printf("DUTY CYCLE REG = %x\n\r",i);
			Xil_Out32(PWM_CLK_DUTY_CYCLE_REG_ADDR,i);

			// Read PWM_CLK_CNTR Value
			value = Xil_In32(PWM_CLK_CNTR_REG_ADDR);
			printf("Read %x from PWM CLK CNTR register.\n\r",value);
			sleep(3);
			dc += 10;
		}
		*/

		int i = 0;
		// Configure Outputs
		Xil_Out32(DEBUG_REG_ADDR,0x100);		
		for(i = 0; i <= 0xFFFF; i++){
			// Write Voltage to DAC
			Xil_Out32(PMOD_DAC_REG_ADDR,0xFFFF);
			printf("Wrote %x to PMOD_DAC_REG_ADDR register.\n\r",0xFFFF);
		}
		
	}


    cleanup_platform();
    return 0;
}
