/*
 * Aufgabe_4_2.S
 *
 * SoSe 2026
 *
 *  Created on: <$26.052026>
 *      Author: <$Julius Hecker und Kevin Dix >
 *
 *	Aufgabe : Permanentes Lauflicht
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

.equ IODIR1, 0xE0028018
.equ IOSET1, 0xE0028014
.equ IOCLR1, 0xE002801C
.equ TIME_ON, 3333333
.equ TIME_OFF, 4166667

main:
  /* Output definieren */
  ldr r0, =IODIR1
  ldr r1, =0x00FF0000
  ldr r2, [r0]
  orr r2, r1, r2
  str r2, [r0]
  
  ldr r0, =IOSET1
  ldr r4, =IOCLR1
  ldr r1, = 0x00010000
  ldr r5, = 0x01000000 /*Obere Grenze für die Maske*/

walking_light:

  ldr r2, [r0]  
  orr r2, r2, r1
  str r2, [r0]
  ldr r3, =TIME_ON
  bl delay

  ldr r2, [r4]
  orr r2, r2, r1
  str r2, [r4]
  ldr r3, =TIME_OFF
  bl delay

  lsl r1, #1
  
  cmp r5, r1
  ldreq r1, = 0x00010000

  b walking_light
      
delay:
      subs r3, r3, #1
      bne delay
      bx lr

stop:
	nop
	bal stop

.end