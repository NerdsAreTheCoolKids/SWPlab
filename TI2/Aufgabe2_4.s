/*
 * Aufgabe_2_3.S
 *
 * SoSe 2026
 *
 *  Created on: <03.05.2026>
 *      Author: <Kevin Dix>
 *
 *	Aufgabe : Vibe Coding (mit ChatGpt Free)
 */
.text
.code 32
.global main

/* r0 = aktueller Zustand (seed / state) */
/* r1 = temporär (feedback) */
/* r2 = counter */

main:
    /* Seed laden */
    ldr r0, =918273      /* Initial seed */

    mov r2, #11          /* 11 Iterationen */

loop:
    bl lfsr_step         /* nächsten Zufallswert berechnen */

    /* Wert auf Stack legen (FILO) */
    push {r0}

    subs r2, r2, #1
    bne loop

    b stop


/* ---------------------------------- */
/* LFSR Funktion */
/* Input:  r0 = aktueller Zustand */
/* Output: r0 = neuer Zustand */
/* ---------------------------------- */
lfsr_step:
    push {r4, lr}

    /* Bits extrahieren und XOR bilden */

    /* Bit 30 */
    mov r1, r0
    lsr r1, r1, #30
    and r1, r1, #1

    /* Bit 22 */
    mov r3, r0
    lsr r3, r3, #22
    and r3, r3, #1
    eor r1, r1, r3

    /* Bit 8 */
    mov r3, r0
    lsr r3, r3, #8
    and r3, r3, #1
    eor r1, r1, r3

    /* Bit 0 */
    and r3, r0, #1
    eor r1, r1, r3

    /* Shift nach rechts */
    lsr r0, r0, #1

    /* Feedback in MSB (Bit 31) */
    lsl r1, r1, #31
    orr r0, r0, r1

    pop {r4, lr}
    bx lr


stop:
    nop
    bal stop

.end