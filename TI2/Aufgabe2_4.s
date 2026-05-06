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
        .code 16
        .global main
        .thumb_func

main:

        LDR     r0, =918273
        MOV     r1, r0

        MOV     r6, #11

loop:

        MOV     r2, r1
        MOV     r5, #1

        @ --- bit0 ---
        MOV     r3, r2
        AND     r3, r5

        @ --- bit8 ---
        MOV     r4, r2
        MOV     r7, #8
shift8:
        LSR     r4, r4, #1
        SUB     r7, r7, #1
        CMP     r7, #0
        BNE     shift8
        AND     r4, r5
        EOR     r3, r4

        @ --- bit22 ---
        MOV     r4, r2
        MOV     r7, #22
shift22:
        LSR     r4, r4, #1
        SUB     r7, r7, #1
        CMP     r7, #0
        BNE     shift22
        AND     r4, r5
        EOR     r3, r4

        @ --- bit30 ---
        MOV     r4, r2
        MOV     r7, #30
shift30:
        LSR     r4, r4, #1
        SUB     r7, r7, #1
        CMP     r7, #0
        BNE     shift30
        AND     r4, r5
        EOR     r3, r4

        @ --- shift state ---
        LSR     r1, r1, #1

        @ --- feedback ins MSB ---
        MOV     r7, #31
shiftfb:
        LSL     r3, r3, #1
        SUB     r7, r7, #1
        CMP     r7, #0
        BNE     shiftfb

        ORR     r1, r3

        MOV     r0, r1

        @ --- STACK (FILO) ---
        PUSH    {r0}

        @ --- loop counter ---
        SUB     r6, r6, #1
        CMP     r6, #0
        BNE     loop

stop:
        B       stop