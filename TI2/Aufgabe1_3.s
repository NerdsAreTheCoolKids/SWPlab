/*
 * Aufgabe_1_3.S
 *
 * SoSe 2026
 *
 *  Created on: <16.04.2026>
 *      Author: <Dix Kevin>
 *
 *	Aufgabe : 64 Bit Addition mit Sättigung
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
  mov r0, #0xF0000000
  mov r1, #0xF0000000
  
  /*zweite Zahl*/
  mov r2, #0xF0000000
  mov r3, #0xF0000000
  
  adds r4, r2, r0

  adcs r5, r3, r1 

  mvncs r4, #0
  mvncs r5, #0
  movcs r6, #1
  
stop:
	nop
	bal stop

.end
