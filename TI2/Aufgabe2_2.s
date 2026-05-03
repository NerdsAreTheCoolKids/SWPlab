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
      push {r1}
      ldr r1, =time
      bl delay
      pop {r1}
      b stop
      
delay:
      push {r0}
      mov r0, r1

loop:
      subs r0, r0, #1
      bne loop
      pop {r0}
      mov pc, lr

stop:
	nop
	bal stop

.end
