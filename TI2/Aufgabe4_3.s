/*
 * Aufgabe_4_3.S
 *
 * SoSe 2026
 *
 *  Created on: <$26.05.2026>
 *      Author: <$Julius Hecker und Kevin Dix>
 *
 *	Aufgabe : Ein- und Ausgabe über Taster und LEDs
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

.equ IOPIN0, 0xE0028000
.equ IOPIN1, 0xE0028010

.equ IOSET, 0x4
.equ IODIR, 0x8
.equ IOCLR, 0xC

.equ BUTTON_0_bm, (1<<10)
.equ BUTTON_1_bm, (1<<11)
.equ BUTTON_2_bm, (1<<12)
.equ BUTTON_3_bm, (1<<13)

.equ LED_0_bm, (1<<16)
.equ LED_1_bm, (1<<17)
.equ LED_2_bm, (1<<18)
.equ LED_3_bm, (1<<19)
.equ LED_4_bm, (1<<20)
.equ LED_5_bm, (1<<21)
.equ LED_6_bm, (1<<22)
.equ LED_7_bm, (1<<23)

.equ LED_0_and_2_bm, (LED_0_bm | LED_2_bm)
.equ LED_1_and_3_bm, (LED_1_bm | LED_3_bm)
.equ LED_4_and_6_bm, (LED_4_bm | LED_6_bm)
.equ LED_5_and_7_bm, (LED_5_bm | LED_7_bm)

.equ ALL_LED_bm, (LED_0_and_2_bm | LED_1_and_3_bm | LED_4_and_6_bm | LED_5_and_7_bm)

main:
      /* Output definieren */
      ldr r0, =(IOPIN1 + IODIR)
      ldr r1, =ALL_LED_bm
      ldr r2, [r0]
      orr r2, r1, r2
      str r2, [r0]

      ldr r2, =(IOPIN1 + IOSET)
      ldr r3, =(IOPIN1 + IOCLR)
      ldr r4, =IOPIN0
loop:

      ldr r5, =BUTTON_0_bm
      ldr r6, =LED_0_bm
      ldr r7, =LED_2_bm
      bl switch

      ldr r5, =BUTTON_1_bm
      ldr r6, =LED_1_bm
      ldr r7, =LED_3_bm
      bl switch

      ldr r5, =BUTTON_2_bm
      ldr r6, =LED_4_bm
      ldr r7, =LED_6_bm
      bl switch

      ldr r5, =BUTTON_3_bm
      ldr r6, =LED_5_bm
      ldr r7, =LED_7_bm
      bl switch
      
      b loop 


switch:
  push {lr}
  /* Check if button was pressed */
  ldr r0, [r4]
  ands r0, r5, r0
  bne no_switch

  /* Turn second LED on & first LED off*/
  ldr r8, [r2]
  orr r8, r8, r7
  str r8, [r2]

  ldr r8, [r3]
  orr r8, r8, r6
  str r8, [r3]
  
  pop {lr}
  bx lr

no_switch:
  /* Turn first LED on & second LED off*/
  ldr r8, [r2]
  orr r8, r8, r6
  str r8, [r2]

  ldr r8, [r3]
  orr r8, r8, r7
  str r8, [r3]

  pop {lr}
  bx lr

.end
    stop:
    nop
    bal stop