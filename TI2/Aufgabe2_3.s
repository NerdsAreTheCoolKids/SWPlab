/*
 * Aufgabe_2_1.S
 *
 * SoSe 2026
 *
 *  Created on: <03.05.2026>
 *      Author: <Kevin Dix>
 *
 *	Aufgabe : Unterprogrammaufruf (activ waiting delay)
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
.equ time, 10

main:

      ldr r6, =time
      push {r6}
      bl delay
      add sp, sp, #4
      b stop
      
delay:
      push {r0}
      ldr r0, [sp, #4]

loop:
      subs r0, r0, #1
      bne loop
      pop {r0}
      bx lr

stop:
	nop
	bal stop

.end
