    .syntax unified
    .arch armv7-a
    .text
    .global main
	.extern wiringPiSetupGpio
	.extern pinMode
	.extern digitalWrite

.equ INPUT,   0
.equ OUTPUT,  1
.equ LOW,     0
.equ HIGH,    1

//gpio
.equ LED0, 17
.equ LED1, 18
.equ LED2, 27
.equ LED3, 22

main:
	push {r4, lr}
	bl wiringPiSetupGpio
    //set led pins as outputs
    mov r0, #LED0
    mov r1, #OUTPUT
    bl pinMode

    mov r0, #LED1
    mov r1, #OUTPUT
    bl pinMode

    mov r0, #LED2
    mov r1, #OUTPUT
    bl pinMode

    mov r0, #LED3
    mov r1, #OUTPUT
    bl pinMode

    //RNG seed
    ldr r4, =0x12345678

loop:
    //Xorshift
    mov r0, r4, lsl #13
    eor r4, r4, r0

    mov r0, r4, lsr #17
    eor r4, r4, r0

    mov r0, r4, lsl #5
    eor r4, r4, r0

    //displays the low 4 bits on LEDS

    //LED0 (bit 0)
    mov r0, #LED0
    tst r4, #1
    moveq r1, #LOW
    movne r1, #HIGH
    bl digitalWrite

    //LED1 (bit 1)
    mov r0, #LED1
    tst r4, #2
    moveq r1, #LOW
    movne r1, #HIGH
    bl digitalWrite

    //LED2 (bit 2)
    mov r0, #LED2
    tst r4, #4
    moveq r1, #LOW
    movne r1, #HIGH
    bl digitalWrite

    //LED3 (bit 3)
    mov r0, #LED3
    tst r4, #8
    moveq r1, #LOW
    movne r1, #HIGH
    bl digitalWrite

    //delay code
    ldr r2, =600000000
delay_loop:
    subs r2, r2, #1
    bgt delay_loop

    b loop
