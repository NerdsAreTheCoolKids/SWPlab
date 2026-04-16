/*
 * Aufgabe_1_4.S
 *
 * SoSe 2026
 *
 *  Created on: <16.04.2026>
 *      Author: <Dix Kevin>
 *
 *	Aufgabe : Maskenoperationen
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:
  /* Nibble 0 */
  .equ BREAD_bm,      (1 << 0)
  .equ BUTTER_bm,     (1 << 1)
  .equ CHEESE_bm,     (1 << 2)
  .equ JAM_bm,        (1 << 3)
  
  /* Byte 1 */
  .equ TEQUILA_bm,   (1 << 8)
  .equ MILK_bm,      (1 << 9)
  .equ RUM_bm,       (1 << 10)
  .equ VINE_bm,      (1 << 11)
  .equ VODKA_bm,     (1 << 12)

  /* Nibble 4 */
  .equ ALMOND_bm,    (1 << 16)
  .equ PEANUT_bm,    (1 << 17)
  .equ CHESTNUTS_bm, (1 << 18)

  /* Nibble 5 */
  .equ ANANAS_bm,    (1 << 20)
  .equ BANANA_bm,    (1 << 21)
  .equ LEMON_bm,     (1 << 22)

  /* Zwischenmaske für Rekursion :D */
  .equ FRUITS_bm, ( ANANAS_bm | BANANA_bm | LEMON_bm )
  
  /* Tagesfrühstück */
  .equ BREAKFAST_bm, (BREAD_bm | BUTTER_bm | CHEESE_bm | MILK_bm | PEANUT_bm | LEMON_bm)
  ldr r0, =BREAKFAST_bm

  /* Tagesfrühstück MIT FRÜCHTE */
  .equ BREAKFAST_WITH_FRUITS_bm, ( BREAKFAST_bm | FRUITS_bm )
  ldr r1, =BREAKFAST_WITH_FRUITS_bm

  /* Opfer Kunde */
  .equ WITHOUT_LACTOSE_bm, ( (BREAKFAST_bm & (~MILK_bm)) | VODKA_bm )
  ldr r2, =WITHOUT_LACTOSE_bm

  /* Stabile Ernährung */
  .equ DOUBLE_FRUITS_bm, ( (FRUITS_bm << 8) | FRUITS_bm )
  ldr r3, =DOUBLE_FRUITS_bm

  /* VEGANER GRRRR */
  .equ VEGAN_bm, ( (WITHOUT_LACTOSE_bm & (~BUTTER_bm) & (~CHEESE_bm)) | JAM_bm | VINE_bm )
  ldr r4, =VEGAN_bm

  /* PEANUTBUTTTEEEEER */
  .equ NO_PEANUT_bm, ( BREAKFAST_bm & (~PEANUT_bm))
  ldr r5, =NO_PEANUT_bm

stop:
	nop
	bal stop

.end
