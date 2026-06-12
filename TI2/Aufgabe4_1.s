/*
 * Aufgabe_4_1.S
 *
 * SoSe 2026
 *
 *  Created on: <$26.05.2026>
 *      Author: <$Julius Hecker und Kevin Dix>
 *
 *	Aufgabe : Fortschrittsanzeige
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

.equ IODIR1, 0xE0028018
.equ IOSET1, 0xE0028014
.equ TIME, 7500000

main:
  ldr r0, =IODIR1
  ldr r1, =0x00FF0000
  ldr r2, [r0]

  orr r2, r1, r2

  str r2, [r0]

  ldr r0, =IOSET1
  ldr r1, = 0x00800000
  mov r4, #8

loop:
  ldr r2, [r0]  
  orr r2, r2, r1
  str r2, [r0]
  lsr r1, #1

  ldr r3, =TIME
  bl delay
  subs r4, #1
  bne loop
  b stop
      
delay:
      subs r3, r3, #1
      bne delay
      bx lr

stop:
	nop
	bal stop

.end