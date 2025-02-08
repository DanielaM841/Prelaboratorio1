;
; Prelab1.asm
;
; Created: 6/02/2025 15:58:47
; Author : Daniela Moreira 23841
; Descripcion: Creaci�n de contador binario de 4 bitscon un boton de incremento y un boton de decremento 
;
// Encabezado
.include "M328PDEF.inc"
.cseg
.org 0x0000
	// Configurar la pila
	LDI		R16, LOW(RAMEND)
	OUT		SPL, R16
	LDI		R16, HIGH(RAMEND)
	OUT		SPH, R16
	// Configurar el MCU
SETUP:
	// Configuracion de pines de entrada y salida (DDRx, PORTx, PINx)
	// PORTC como entrada con pull-up habilitado
	LDI		R16, 0x00
	OUT		DDRC, R16 // Puerto D como entrada al ingresar bit como 0
	LDI		R16, 0xFF
	OUT		PORTC, R16 // Habilitar pull-ups en puerto C

	//Configurar el puerto B como salidas, estabecerlo en apagado
	LDI		R16, 0xFF
	OUT		DDRB, R16 // Setear puerto B como salida
	LDI		R16, 0x00
	OUT		PORTB, R16 //Todos los bits en apagado 
	LDI		R17, 0xFF // Variable para guardar estado de botones
					// se usa como comparacion 
	LDI		R18, 0X00

// Loop infinito para anti rebote 
MAIN:
	IN		R16, PINC // Guardando el estado de PORTC en R16 0xFF
	CP		R17, R16 // Comparamos estado "viejo" con estado "nuevo"
	BREQ	MAIN
	CALL	DELAY
	IN		R16, PINC
	CP		R17, R16
	BREQ	MAIN
	// Volver a leer PIND
	MOV		R17, R16 //copia el estado actual del pin en R17
	SBRS	R16, 2 // Salta si el bit 2 del PIND es 1 (no apachado)
	CALL	SUMA //si el bot�n esta presionado suma
	SBRS	R16, 3 //Si el bit 3 de PIND es 1 (bot�n NO presionado), salta la siguiente instrucci�n
	CALL	RESTA // Si el boton 2 est� presionado, llama a RESTA
	RJMP	MAIN


SUMA: 
	INC		R18
	CPI		R18, 0x10 //comparar con 16
	BREQ	OF1 //si es 16 ejecutar el break 
	OUT		PORTB, R18 //si no es 16 cargar el valor 
	RJMP	MAIN 
OF1:
	OUT		PORTB, R18
	RJMP	MAIN
UF2:
	LDI		R18, 0x0F
	OUT		PORTB, R18
	RJMP	MAIN
RESTA:
	CPI		R18, 0x00
	BREQ	UF2 // si es 0 ir a under flow 
	DEC		R18 // si no es 0 restar y luego dar el resultado
	OUT		PORTB, R18 
	RJMP	MAIN

// Sub-rutina 
DELAY:
	LDI		R19, 0xFF
SUB_DELAY1:
	DEC		R19
	CPI		R19, 0
	BRNE	SUB_DELAY1
	LDI		R19, 0xFF
SUB_DELAY2:
	DEC		R19
	CPI		R19, 0
	BRNE	SUB_DELAY2
	LDI		R19, 0xFF
SUB_DELAY3:
	DEC		R19
	CPI		R19, 0
	BRNE	SUB_DELAY3
	RET
