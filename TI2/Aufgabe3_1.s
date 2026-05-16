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
  push {r1, r2, r3, fp, lr}
  add fp, sp, #8

  add r1, r2, r3
  mov r2, r1
  lsr r2, #10
  cmp r2, #0
  beq .no_saturation_add
  
.saturation_add:
  ldr r1, =0x3FF
  ldr r0, =ERROR_VALUE_OVERFLOW
  b .clean_up_add

.no_saturation_add:
  mov r0, #STATUS_OK

.clean_up_add:
  sub sp, fp, #8
  pop {r1, r2, r3, fp, pc}

_satMul10:
  sub sp, sp, #24 // 20
  str lr, [sp, #20] 
  str fp, [sp, #16]
  str r4, [sp, #12]
  str r3, [sp, #8]
  str r2, [sp, #4]
  add fp, sp, #20 // 40 
  
  mov r2, #0
  mov r3, #0

  ldrh r2, [fp, #6] // lese 46
  ldrh r3, [fp, #8] // lese 48

  mul r4, r2, r3
  mov r3, r4
  lsr r3, #10
  cmp r3, #0
  beq .no_saturation_mul

.saturation_mul:
  ldr r4, =0x3FF
  ldr r0, =ERROR_VALUE_OVERFLOW
  b .clean_up_mul

.no_saturation_mul:
  mov r0, #STATUS_OK

.clean_up_mul:
  strh r4, [fp, #4] // schreibe in 52
  sub sp, fp, #20     /* Setzen des Stack Pointers auf die erste Adresse im Stack Frame*/

  ldr r2, [sp, #4] 
  ldr r3, [sp, #8]       
  ldr r4, [sp, #12]     
  ldr fp, [sp, #16]       
  ldr lr, [sp, #20]      

  add sp, sp, #24         

  bx  lr

Pack10:
  sub sp, sp, #24
  str lr, [sp, #20]
  str fp, [sp, #16]
  str r5, [sp, #12]
  str r4, [sp, #8]
  str r3, [sp, #4]
  str r2, [sp, #0]
  
  add fp, sp, #20

  ldrh r2, [fp, #16]
  ldrh r3, [fp, #14]
  ldrh r4, [fp, #12]

  mov r5, #0
  lsl r3, #10
  lsl r4, #20

  orr r5, r5, r2
  orr r5, r5, r3
  orr r5, r5, r4

  str r5, [fp, #8]

  sub sp, fp, #12     /* Setzen des Stack Pointers auf die erste Adresse im Stack Frame*/
    
  ldr r2, [sp, #0]
  ldr r3, [sp, #4]
  ldr r4, [sp, #8]     
  ldr fp, [sp, #12]       
  ldr lr, [sp, #16]      
  add sp, sp, #24

  bx  lr

UnPack10:
  sub sp, sp, #32
  str lr, [sp, #24]
  str fp, [sp, #20]
  str r6, [sp, #16]
  str r5, [sp, #12]
  str r4, [sp, #8]
  str r3, [sp, #4]
  str r2, [sp, #0]
  add fp, sp, #28

  mov r2, #0

  ldr r2, [fp, #8]   // lesen bei 56
  str r2, [sp, #8]    /*Zwischenspeicherung der 32-Bit Zahl*/
  ldr r6, =0x3FF      /*Maske für die ersten 10 Bits*/

  mov r3, #0
  mov r4, #0
  mov r5, #0

  and r2, r2, r6
  orr r3, r3, r2
  
  ldr r2, [sp, #8]
  lsr r2, #10
  and r2, r2, r6
  orr r4, r4, r2

  ldr r2, [sp, #8]
  lsr r2, #20
  and r2, r2, r6
  orr r5, r5, r2

  strh r3, [fp, #16] // schreiben 60
  strh r4, [fp, #14] // 58
  strh r5, [fp, #12] // 56

  sub sp, fp, #28
  ldr r2, [sp, #0]
  ldr r3, [sp, #4]
  ldr r4, [sp, #8]
  ldr r5, [sp, #12]
  ldr r6, [sp, #16]
  ldr fp, [sp, #20]
  ldr lr, [sp, #24]
  add sp, sp, #32

  bx lr

_packMin:
  sub sp, sp, #32 //20
  str lr, [sp, #28]
  str fp, [sp, #24]
  str r7, [sp, #20]
  str r6, [sp, #16]
  str r5, [sp, #12]
  str r4, [sp, #8]
  add fp, sp, #28 //48
  
  ldr r7, [fp, #8]
  str r7, [sp, #4]
  
  bl UnPack10

  ldrh r4, [sp, #12]
  ldrh r5, [sp, #10]
  ldrh r6, [sp, #8]

  cmp r4, r5
  movlt r7, r4
  movge r7, r5

  cmp r7, r6
  movge r7, r6

  strh r7, [fp, #12]//60
  
  ldr r4, [sp, #8]
  ldr r5, [sp, #12]
  ldr r6, [sp, #16]
  ldr r7, [sp, #20]
  ldr fp, [sp, #24]
  ldr lr, [sp, #28]
  add sp, sp, #32
  bx lr

_packMax:
  sub sp, sp, #32
  str lr, [sp, #28]
  str fp, [sp, #24]
  str r7, [sp, #20]
  str r6, [sp, #16]
  str r5, [sp, #12]
  str r4, [sp, #8]
  add fp, sp, #28
  
  ldr r7, [fp, #8]
  str r7, [sp, #4]
  
  bl UnPack10

  ldrh r4, [sp, #12]
  ldrh r5, [sp, #10]
  ldrh r6, [sp, #8]

  cmp r4, r5
  movge r7, r4
  movlt r7, r5

  cmp r7, r6
  movlt r7, r6

  strh r7, [fp, #12]
  
  ldr r4, [sp, #8]
  ldr r5, [sp, #12]
  ldr r6, [sp, #16]
  ldr r7, [sp, #20]
  ldr fp, [sp, #24]
  ldr lr, [sp, #28]
  add sp, sp, #32
  bx lr

_packScale:
  sub sp, sp, #48 // 44
  str lr, [sp, #40]
  str fp, [sp, #36]
  str r7, [sp, #32]
  str r6, [sp, #28]
  str r5, [sp, #24]
  str r4, [sp, #20]
  str r3, [sp, #16]
  add fp, sp, #44 // 80
  
  ldr r7, [fp, #8]
  str r7, [sp, #20] // 56
  
  bl UnPack10  

  mov r7, #10       // Faktor zum Skalieren
  str r7, [sp, #16]

  mov r4, #0
  mov r6, #0
  mov r7, #2    // Zähler für Schleife
  mov r3, #16    // Indexe für Register

multLoop:
  ldrh r4, [sp, r3] 
  strh r4, [sp, #10] // Parameter setzen für satMul
  ldrh r5, [sp, #16] 
  strh r5, [sp, #12] // Parameter setzen für satMul

  bl _satMul10 

  ldrh r5, [sp, #8]
  
  orr r6, r6, r5

  cmp r7, #0
  subne r7, r7, #1
  lslne r6, #10
  bne multLoop
  
  str r6, [fp, #12]
  
  ldr r3, [sp, #16]
  ldr r4, [sp, #20]
  ldr r5, [sp, #24]
  ldr r6, [sp, #28]
  ldr r7, [sp, #32]
  ldr fp, [sp, #36]
  ldr lr, [sp, #40]
  add sp, sp, #48
  bx lr

_packRange:
  sub sp, sp, #32 //52
  str lr, [sp, #28]
  str fp, [sp, #24]
  str r7, [sp, #20]
  str r6, [sp, #16]
  str r5, [sp, #12]
  str r4, [sp, #8]
  add fp, sp, #28 //80
  
  ldr r7, [fp, #8] //88
  str r7, [sp, #4] //56
  
  bl _packMin

  ldrh r6, [sp, #8]

  ldr r7, [fp, #8]
  str r7, [sp, #4]

  bl _packMax

  ldrh r7, [sp, #8]

  sub r5, r7, r6

  strh r5, [fp, #12]
  
  ldr r4, [sp, #8]
  ldr r5, [sp, #12]
  ldr r6, [sp, #16]
  ldr r7, [sp, #20]
  ldr fp, [sp, #24]
  ldr lr, [sp, #28]
  add sp, sp, #32
  bx lr

main:
    sub sp, sp, #16
    
    ldr r3, =#0x3FF
    ldr r2, =#0x3FF
    
    bl _satAdd10
  
    strh r3, [sp, #4] // 88
    strh r2, [sp, #2] // 86
    bl _satMul10
    ldrh r1, [sp, #0]
  
    ldr r2, =0x3FF
    ldr r3, =0x3FF
    ldr r4, =0x3FF
    mov r1, #0
    
    strh r2, [sp, #12]
    strh r3, [sp, #10]
    strh r4, [sp, #8]
    str r1,  [sp, #4]

    bl Pack10

    ldr r1, [sp, #4]
    mov r6, #0
    strh r6, [sp, #12]
    strh r6, [sp, #10]
    strh r6, [sp, #8]
    str r1, [sp, #4]
      
    bl UnPack10

    ldrh r2, [sp, #12]
    ldrh r3, [sp, #10]
    ldrh r4, [sp, #8]

    ldr r2, =0x3FF
    ldr r3, =0x0
    ldr r4, =0x3FF

    lsl r2, #10
    orr r2, r2, r3
    lsl r2, #10
    orr r2, r2, r4 

    str r2, [sp, #4]
    mov r2, #0
    str r2, [sp, #8] 

    bl _packMin

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
    mov r2, #0
    str r2, [sp, #8] 

    bl _packScale

    ldr r2, [sp, #8]

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
