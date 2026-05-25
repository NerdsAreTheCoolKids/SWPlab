/*
 * Aufgabe_3_1.S
 *
 * SoSe 2024
 *
 *  Created on: <08.05.2026>
 *      Author: <Kevin Dix>
 *
 *	Aufgabe : Stack, Heap, lokale Variablen sowie Modulare Programmierung
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

.equ ERROR_VALUE_OVERFLOW, -1

.equ STATUS_OK, 0

_satAdd10:
  push {r1-r3, fp, lr}
  add r2, r2, r3
  mov r1,r2
  ldr r3, =~0x3ff
  ands r1, r1, r3

  ldrne r1, =0x3FF
  ldrne r0, =ERROR_VALUE_OVERFLOW

  moveq r0, #STATUS_OK
  pop {r1-r3, fp, pc}

_satMul10:
  push {r2-r4} //12
  
  mov r2, #0
  mov r3, #0

  ldrh r2, [sp, #12] // lese 46
  ldrh r3, [sp, #14] // lese 48

  mul r4, r2, r3
  mov r3, r4
  ldr r2, =~0x3ff
  ands r3, r3, r2
  ldrne r4, =0x3FF
  ldrne r0, =ERROR_VALUE_OVERFLOW
  strh r4, [sp, #16]
  moveq r0, #STATUS_OK
  pop {r2-r4}      
  bx  lr

Pack10:
  push {r2-r5} // 4 + 4+4+4 =16

  ldrh r2, [sp, #28]
  ldrh r3, [sp, #26]
  ldrh r4, [sp, #24]

  mov r5, #0
  lsl r3, #10
  lsl r4, #20

  orr r5, r5, r2
  orr r5, r5, r3
  orr r5, r5, r4

  str r5, [sp, #16]
    
  pop {r2-r5}

  bx  lr

UnPack10:
  push {r2-r6, lr} //24

  mov r2, #0

  ldr r2, [sp, #24]   // lesen bei 56
  ldr r6, =0x3FF      /*Maske für die ersten 10 Bits*/

  mov r3, #0
  mov r4, #0
  mov r5, #0

  and r2, r2, r6
  orr r3, r3, r2
  
  ldr r2, [sp, #24]
  lsr r2, #10
  and r2, r2, r6
  orr r4, r4, r2

  ldr r2, [sp, #24]
  lsr r2, #20
  and r2, r2, r6
  orr r5, r5, r2

  strh r3, [sp, #36] // schreiben 60
  strh r4, [sp, #34] // 58
  strh r5, [sp, #30] // 56

  pop {r2-r6, lr}
  bx lr

_packMin:
  push {r4-r7, lr} // 20
  sub sp, sp, #12 // 32

  ldr r7, [sp, #40]
  str r7, [sp, #0]
  
  bl UnPack10

  ldrh r4, [sp, #12]
  ldrh r5, [sp, #10]
  ldrh r6, [sp, #8]

  cmp r4, r5
  movlt r7, r4
  movge r7, r5

  cmp r7, r6
  movge r7, r6

  strh r7, [sp, #40]
  
  pop {r4-r7, lr} 
  bx lr

_packMax:
  push {r4-r7, lr}
  sub sp, sp, #12
  
  ldr r7, [sp, #36]
  str r7, [sp, #8]
  
  bl UnPack10

  ldrh r4, [sp, #0]
  ldrh r5, [sp, #2]
  ldrh r6, [sp, #4]

  cmp r4, r5
  movge r7, r4
  movlt r7, r5

  cmp r7, r6
  movlt r7, r6

  strh r7, [sp, #32]
  
  pop {r4-r7, lr}
  bx lr

_packScale:
  push {r3-r7, lr}
  sub sp, sp, #12

  ldr r7, [sp, #40]
  str r7, [sp, #8] // 56
  
  bl UnPack10  

  ldrh r7, [sp, #48] // Faktor zum Skalieren

  mov r4, #0
  mov r6, #0
  mov r7, #2    // Zähler für Schleife
  mov r3, #0    // Indexe für Register

multLoop:
  ldrh r4, [sp, r3] 
  strh r4, [sp, #0] // Parameter setzen für satMul
  ldrh r5, [sp, #48] 
  strh r5, [sp, #2] // Parameter setzen für satMul

  bl _satMul10 

  ldrh r5, [sp, #8]
  orr r6, r6, r5

  cmp r7, #0
  subne r7, r7, #1
  lslne r6, #10
  addne r3, r3, #2
  bne multLoop
  
  str r6, [sp,#36]

  pop {r3-r7, lr}
  bx lr

_packRange:
  push {r4-r7, lr}
  sub sp, sp, #12

  ldr r7, [sp, #36] 
  str r7, [sp, #4] 
  
  bl _packMin

  ldrh r6, [sp, #8]

  ldr r7, [sp, #36]
  str r7, [sp, #4]

  bl _packMax

  ldrh r7, [sp, #8]

  sub r5, r7, r6

  strh r5, [sp, #28]
  
  pop {r4-r7, lr}
  bx lr

main:
    sub sp, sp, #16
    
    ldr r3, =#0x3FF
    ldr r2, =#0x3FF
    
    bl _satAdd10
  
    mov r3, #5
    mov r2, #3

    strh r3, [sp, #0]
    strh r2, [sp, #2]
    bl _satMul10
    ldrh r1, [sp, #4]
  
    ldr r2, =0xF
    ldr r3, =0xF
    ldr r4, =0xF
    
    strh r2, [sp, #12]
    strh r3, [sp, #10]
    strh r4, [sp, #8]

    bl Pack10

    mov r1, #0
    ldr r1, [sp, #0]
      
    bl UnPack10

    ldrh r2, [sp, #12]
    ldrh r3, [sp, #10]
    ldrh r4, [sp, #8]

    ldr r2, =0xF
    ldr r3, =0xE
    ldr r4, =0xF

    lsl r2, #10
    orr r2, r2, r3
    lsl r2, #10
    orr r2, r2, r4 

    str r2, [sp, #8] 

    bl _packMin


    mov r2, #0
    ldrh r2, [sp, #8]

    ldr r2, =0x3FF
    ldr r3, =0xA
    ldr r4, =0x3FF

    lsl r2, #10
    orr r2, r2, r3
    lsl r2, #10
    orr r2, r2, r4 

    str r2, [sp, #4]
    mov r2, #0
    str r2, [sp, #8] 

    bl _packMax

    ldrh r2, [sp, #8]

    ldr r2, =0x3FF
    ldr r3, =0x3AF
    ldr r4, =0xC0C

    lsl r2, #10
    orr r2, r2, r3
    lsl r2, #10
    orr r2, r2, r4 

    str r2, [sp, #4]
    mov r2, #3
    strh r2, [sp, #8] 

    bl _packScale

    ldr r2, [sp, #0]

    ldr r2, =0x3FF
    ldr r3, =0x0
    ldr r4, =0x123
    lsl r2, #10
    orr r2, r2, r3
    lsl r2, #10
    orr r2, r2, r4 

    str r2, [sp, #4]
    mov r2, #0
    str r2, [sp, #8] 

    bl _packRange

    ldrh r2, [sp, #8]


stop:
	nop
	bal stop

.end  
