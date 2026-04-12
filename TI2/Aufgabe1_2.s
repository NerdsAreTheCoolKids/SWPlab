/*
 * Aufgabe_1_2.S
 *
 * SoSe 2026
 *
 *  Created on: <12.04.2026>
 *      Author: <Dix Kevin>
 *
 *	Aufgabe : 64 Bit AdditioAddition von Zahlen
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:
  /*Zwischenregister*/
  mov r6, #0
  mov r7, #0
  mov r8, #0

  /*erste Zahl*/
  mov r0, #0xFF000000
  mov r1, #0xFFFFFFFF
  
  /*zweite Zahl*/
  mov r2, #0xFF000000
  mov r3, #0xFFFFFFFF
  
  adds r4, r2, r0
  movcs r7, #1  /*Carry Bit speichern*/

  adds r5, r3, r1
  movcs r8, #1 

  adds r5, r5, r7
  movcs r6, #1
  
stop:
	nop
	bal stop

.end
