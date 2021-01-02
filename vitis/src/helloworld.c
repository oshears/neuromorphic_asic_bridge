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


int main()
{
    init_platform();

    print("Hello World\n\r");
    print("Successfully ran Hello World application");

    printf("Test Project\n\r");
	printf("Writing to a custom IP register...\n\r");

	Xil_Out32(0x43C00000, 0xBEEF);
	printf("Done\n\r");

	printf("Writing to a custom IP register...\n\r");
	Xil_Out32(0x43C00004, 0xBEEF);
	printf("Done\n\r");

	printf("Writing to a custom IP register...\n\r");
	// enable slow clock
	Xil_Out32(0x43C00008, 0xBEEF);
	printf("Done\n\r");

	int value = 0;

	printf("Reading from a custom IP register...\n\r");
	value = Xil_In32(0x43C00000);
	printf("Read: %x\n\r",value);

	printf("Reading from a custom IP register...\n\r");
	value = Xil_In32(0x43C00004);
	printf("Read: %x\n\r",value);

	printf("Reading from a custom IP register...\n\r");
	value = Xil_In32(0x43C00008);
	printf("Read: %x\n\r",value);
	
	// continuously read network output
	while(1){

		int mode = 0;
		int output_char = 0;

		for (output_char = 0; output_char < 4; output_char++){
			printf("Displaying output for character %d...\n\r",output_char);
			Xil_Out32(0x43C00000, output_char);
			// use fast mode and slow mode for 5 secs each
			for(mode = 0; mode < 2; mode++){
				printf("Writing to debug register...\n\r");
				Xil_Out32(0x43C00008, mode);
				sleep(5);
			}
		}
		

		printf("Reading from a network output register...\n\r");
		value = Xil_In32(0x43C00004);
		printf("Read %x from network output register.\n\r",value);
	}


    cleanup_platform();
    return 0;
}
