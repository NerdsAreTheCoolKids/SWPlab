/*
 * Aufgabe_1_1.S
 *
 * SoSe 2026
 *
 *  Created on: <$Date>
 *      Author: <$Name>
 *
 *	Aufgabe :  Flags und bedingte Ausführung
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:
  
  .equ y, 120

  mov r0, #y //threshold
  
  mov r12, #y-1
  bl comparison
  mov r12, #y
  bl comparison
  mov r12, #y+1
  bl comparison
  mov r12, #0
  bl comparison
  ldr r12, =0xFFFF
  bl comparison
  
  mov r12, #y-1
  cmp r12, r0
  movls r12, #0
  movhi r12, #255
  
  mov r12, #y
  cmp r12, r0
  movls r12, #0
  movhi r12, #255

  mov r12, #y+1
  cmp r12, r0
  movls r12, #0
  movhi r12, #255
  
  mov r12, #0
  cmp r12, r0
  movls r12, #0
  movhi r12, #255

  ldr r12, =0xFFFF
  cmp r12, r0
  movls r12, #0
  movhi r12, #255
  b stop

comparison:
  push {lr}
  cmp r12, r0
  blgt bigger
  bllt smaller
  bleq smaller
  pop {lr}
  mov pc, lr

smaller:
  mov r12, #0
  mov pc, lr

bigger:
  mov r12, #255
  mov pc, lr  

stop:
  nop
  bal stop

.end
