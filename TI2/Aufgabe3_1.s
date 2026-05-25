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
  push {r1-r3, lr}
  add r2, r2, r3
  mov r1,r2
  ldr r3, =~0x3ff
  ands r1, r1, r3

  ldrne r1, =0x3FF
  ldrne r0, =ERROR_VALUE_OVERFLOW

  moveq r0, #STATUS_OK
  pop {r1-r3, pc}

_satMul10:
  push {r2-r4, lr} // 68
  
  mov r2, #0
  mov r3, #0

  ldrh r2, [sp, #22] // lese 42
  ldrh r3, [sp, #16] // lese 36

  mul r4, r2, r3
  mov r3, r4
  ldr r2, =~0x3ff
  ands r3, r3, r2
  ldrne r4, =0x3FF
  ldrne r0, =ERROR_VALUE_OVERFLOW
  strh r4, [sp, #20] // 40
  moveq r0, #STATUS_OK
  pop {r2-r4, lr}      
  bx  lr

_packScale:
  push {r3-r7, lr} // 60
  sub sp, sp, #24  // 36
  mov r4, #0xFF
  mov r0, #0

  ldr r7, [sp, #52]
  str r7, [sp, #8] // 44
  
  bl UnPack10 
  cmp r0, #0
  bmi _packScaleError

  ldrh r7, [sp, #56] // Faktor zum Skalieren
  cmp r7, r4
  bhi _packScaleError
  
  strh r7, [sp, #6] // 48

  mov r6, #0
  mov r7, #2    // Zähler für Schleife
  mov r3, #8    // Indexe für Register

multLoop:
  ldrh r4, [sp, r3] 
  strh r4, [sp, #0] 
  bl _satMul10 
  ldrh r5, [sp, #4]
  strh r5, [sp, r3]

  cmp r7, #0
  subne r7, r7, #1
  addne r3, r3, #2
  bne multLoop

  bl Pack10
  ldr r6, [sp, #0]
  str r6, [sp, #48]

_packScaleExit:
  add sp, sp, #24
  pop {r3-r7, lr}
  bx lr

_packScaleError:
  ldr r0, =ERROR_VALUE_OVERFLOW
  mov r3, #0
  str r3, [sp, #48]
  b _packScaleExit

Pack10_overflow:
  mov r2, #0
  str r2, [sp, #20]
  ldr r0, =ERROR_VALUE_OVERFLOW
  pop {r2-r5}
  bx lr

Pack10:
  push {r1-r5} // 64
  
  mov r1, #0xFF

  ldrh r2, [sp, #32] // 48
  cmp r2, r1
  bhi Pack10_overflow

  ldrh r3, [sp, #30] // 46
  cmp r2, r1
  bhi Pack10_overflow

  ldrh r4, [sp, #28] // 44
  cmp r2, r1
  bhi Pack10_overflow

  mov r5, #0
  lsl r3, #10
  lsl r4, #20

  orr r5, r5, r2
  orr r5, r5, r3
  orr r5, r5, r4

  str r5, [sp, #20]
  pop {r1-r5}
  bx  lr

UnPack10_overflow:
  mov r2, #0
  strh r2, [sp, #36] // schreiben 60
  strh r2, [sp, #34] // 58
  strh r2, [sp, #32]
  ldr r0, =ERROR_VALUE_OVERFLOW
  pop {r2-r6, lr}
  bx lr

UnPack10:
  push {r2-r6, lr} // 60

  ldr r2, [sp, #32]   // lesen bei 92
  lsr r2, #30
  cmp r2, #0
  bne UnPack10_overflow
  
  ldr r6, =0x3FF      /*Maske für die ersten 10 Bits*/

  mov r3, #0
  mov r4, #0
  mov r5, #0
  
  ldr r2, [sp, #32]
  and r2, r2, r6
  orr r3, r3, r2
  
  ldr r2, [sp, #32]
  lsr r2, #10
  and r2, r2, r6
  orr r4, r4, r2

  ldr r2, [sp, #32]
  lsr r2, #20
  and r2, r2, r6
  orr r5, r5, r2

  strh r3, [sp, #36] // schreiben 96
  strh r4, [sp, #34] // 94
  strh r5, [sp, #32] // 92

  pop {r2-r6, lr}
  bx lr


_packMin:
  push {r4-r7, lr} // 20
  sub sp, sp, #16 // 4

  ldr r7, [sp, #44]
  str r7, [sp, #8]
  
  bl UnPack10

  cmp r0, #0
  bmi _packminError

  ldrh r4, [sp, #8]
  ldrh r5, [sp, #10]
  ldrh r6, [sp, #12]

  cmp r4, r5
  movlt r7, r4
  movge r7, r5

  cmp r7, r6
  movge r7, r6

  strh r7, [sp, #44]
  
_packminExit:
  add sp, sp, #16
  pop {r4-r7, lr} 
  bx lr

_packminError:
  mov r4, #0
  strh r4, [sp, #44]
  b _packminExit

_packMax:
  push {r4-r7, lr} //24
  sub sp, sp, #24 // -4
  
  ldr r7, [sp, #44]
  str r7, [sp, #8]
  
  bl UnPack10

  cmp r0, #0
  bmi _packMaxError

  ldrh r4, [sp, #12]
  ldrh r5, [sp, #10]
  ldrh r6, [sp, #8]

  cmp r4, r5
  movge r7, r4
  movlt r7, r5

  cmp r7, r6
  movlt r7, r6

  strh r7, [sp, #44]
  

_packMaxExit:
  add sp, sp, #24
  pop {r4-r7, lr}
  bx lr
  
_packMaxError:
  mov r4, #0
  strh r4, [sp, #44]
  b _packMaxExit

  
_packRange:
  push {r4-r7, lr} // 64
  sub sp, sp, #24 // 40

  ldr r7, [sp, #44]  
  str r7, [sp, #8] 
  
  bl _packMin

  ldrh r6, [sp, #8]

  ldr r7, [sp, #44]
  str r7, [sp, #0]

  bl _packMax

  ldrh r7, [sp, #0]

  sub r5, r7, r6

  strh r5, [sp, #44]
  
_packRangeExit:
  add sp, sp, #24
  pop {r4-r7, lr}
  bx lr

_packRangeError:
  mov r4, #0
  strh r4, [sp, #28]
  b _packRangeExit


main:
    sub sp, sp, #16 //84
    
    ldr r3, =#0x3FF
    ldr r2, =#0x3FF
    
    bl _satAdd10
  
    mov r3, #5
    mov r2, #3

    strh r3, [sp, #0]
    strh r2, [sp, #6]
    bl _satMul10
    ldrh r1, [sp, #4]
  
    ldr r2, =0xF
    ldr r3, =0xF
    ldr r4, =0xF
    
    strh r2, [sp, #12]
    strh r3, [sp, #10]
    strh r4, [sp, #8]

    bl Pack10

    ldr r1, [sp, #0]
    str r1, [sp, #8]
      
    bl UnPack10

    ldrh r2, [sp, #12]
    ldrh r3, [sp, #10]
    ldrh r4, [sp, #8]

    ldr r2, =0xFE
    ldr r3, =0xE
    ldr r4, =0xFF

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

    str r2, [sp, #0]

    bl _packMax

    ldrh r2, [sp, #0]

    ldr r2, =0xA
    ldr r3, =0xA
    ldr r4, =0XA

    lsl r2, #10
    orr r2, r2, r3
    lsl r2, #10
    orr r2, r2, r4 

    str r2, [sp, #4] /* Gepackte Zahl zum skalieren bei 88 */
    mov r2, #3
    strh r2, [sp, #8] /* Faktor bei 92 */

    bl _packScale

    ldr r2, [sp, #0]

    ldr r2, =0x3FF
    ldr r3, =0x0
    ldr r4, =0x123
    lsl r2, #10
    orr r2, r2, r3
    lsl r2, #10
    orr r2, r2, r4 

    str r2, [sp, #0]

    bl _packRange

    ldrh r2, [sp, #0]


stop:
	nop
	bal stop

.end  
