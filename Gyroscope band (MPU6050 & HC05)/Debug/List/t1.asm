
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8A
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _cnt1=R8
	.DEF _cnt1_msb=R9
	.DEF _x=R10
	.DEF _x_msb=R11
	.DEF _y=R12
	.DEF _y_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0

_0x0:
	.DB  0x58,0x3A,0x0,0x5F,0x59,0x3A,0x0,0x5F
	.DB  0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F
	.DB  0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x5F
	.DB  0x5F,0x5F,0x5F,0x5F,0x5F,0x5F,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x03
	.DW  _0x61
	.DW  _0x0*2

	.DW  0x04
	.DW  _0x61+3
	.DW  _0x0*2+3

	.DW  0x18
	.DW  _0x61+7
	.DW  _0x0*2+7

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 8/2/2018
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8A
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;
;// I2C Bus functions
;#include <i2c.h>
;
;// Declare your global variables here
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 003C {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 003D char status,data;
; 0000 003E status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 003F data=UDR;
	IN   R16,12
; 0000 0040 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0041    {
; 0000 0042    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0043 #if RX_BUFFER_SIZE == 256
; 0000 0044    // special case for receiver buffer size=256
; 0000 0045    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 0046 #else
; 0000 0047    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
; 0000 0048    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x5
; 0000 0049       {
; 0000 004A       rx_counter=0;
	CLR  R7
; 0000 004B       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 004C       }
; 0000 004D #endif
; 0000 004E 
; 0000 004F 
; 0000 0050     if(data=='o') PORTD.2=1;
_0x5:
	CPI  R16,111
	BRNE _0x6
	SBI  0x12,2
; 0000 0051     else       PORTD.2=0;
	RJMP _0x9
_0x6:
	CBI  0x12,2
; 0000 0052 
; 0000 0053    }
_0x9:
; 0000 0054 }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 005B {
; 0000 005C char data;
; 0000 005D while (rx_counter==0);
;	data -> R17
; 0000 005E data=rx_buffer[rx_rd_index++];
; 0000 005F #if RX_BUFFER_SIZE != 256
; 0000 0060 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 0061 #endif
; 0000 0062 #asm("cli")
; 0000 0063 --rx_counter;
; 0000 0064 #asm("sei")
; 0000 0065 return data;
; 0000 0066 }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;
;
;
;
;
;
;
;#include <stdlib.h>
;#include "LIB\MPU6050 LIB\MPU6050.h"
;#include "LIB\MPU6050 LIB\RA_MPU6050.h"
;#include "LIB\MPU6050 LIB\MPU6050_PR.h"
;
;float Accel_Raw_Val[3]={0,0,0};
;float AvrgAccel_Raw_Val[3]={0,0,0};
;float Accel_In_g[3]={0,0,0};
;float Accel_Offset_Val[3]={0,0,0};
;float Accel_Angle[3]={0,0,0};
;
;float Gyro_Raw_Val[3]={0,0,0};
;float AvrgGyro_Raw_Val[3]={0,0,0};
;float Gyro_Offset_Val[3]={0,0,0};
;float GyroRate_Val[3]={0,0,0};
;
;float Temp_Val;
;#pragma warn-
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;unsigned char read_i2c(unsigned char BusAddres , unsigned char Reg , unsigned char Ack )
; 0000 0088 {
_read_i2c:
; .FSTART _read_i2c
; 0000 0089 unsigned char Data;
; 0000 008A i2c_start();
	ST   -Y,R26
	ST   -Y,R17
;	BusAddres -> Y+3
;	Reg -> Y+2
;	Ack -> Y+1
;	Data -> R17
	RCALL _i2c_start
; 0000 008B i2c_write(BusAddres);
	LDD  R26,Y+3
	RCALL _i2c_write
; 0000 008C i2c_write(Reg);
	LDD  R26,Y+2
	RCALL _i2c_write
; 0000 008D i2c_start();
	RCALL _i2c_start
; 0000 008E i2c_write(BusAddres + 1);
	LDD  R26,Y+3
	SUBI R26,-LOW(1)
	RCALL _i2c_write
; 0000 008F delay_us(10);
	RCALL SUBOPT_0x0
; 0000 0090 Data=i2c_read(Ack);
	LDD  R26,Y+1
	RCALL _i2c_read
	MOV  R17,R30
; 0000 0091 i2c_stop();
	RCALL _i2c_stop
; 0000 0092 return Data;
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,4
	RET
; 0000 0093 }
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;void write_i2c(unsigned char BusAddres , unsigned char Reg , unsigned char Data)
; 0000 0096 {
_write_i2c:
; .FSTART _write_i2c
; 0000 0097 i2c_start();
	ST   -Y,R26
;	BusAddres -> Y+2
;	Reg -> Y+1
;	Data -> Y+0
	RCALL _i2c_start
; 0000 0098 i2c_write(BusAddres);
	LDD  R26,Y+2
	RCALL _i2c_write
; 0000 0099 i2c_write(Reg);
	LDD  R26,Y+1
	RCALL _i2c_write
; 0000 009A i2c_write(Data);
	LD   R26,Y
	RCALL _i2c_write
; 0000 009B i2c_stop();
	RCALL _i2c_stop
; 0000 009C }
	ADIW R28,3
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// This function can test i2c communication MPU6050
;unsigned char MPU6050_Test_I2C()
; 0000 00A0 {
; 0000 00A1     unsigned char Data = 0x00;
; 0000 00A2     Data=read_i2c(MPU6050_ADDRESS, RA_WHO_AM_I, 0);
;	Data -> R17
; 0000 00A3     if(Data == 0x68)
; 0000 00A4         return 1;       // Means Comunication With MPU6050 is Corect
; 0000 00A5     else
; 0000 00A6         return 0;       // Means ERROR, Stopping
; 0000 00A7 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// This function can move MPU6050 to sleep
;void MPU6050_Sleep(char ON_or_OFF)
; 0000 00AB {
; 0000 00AC     if(ON_or_OFF == on)
;	ON_or_OFF -> Y+0
; 0000 00AD         write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (1<<6)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
; 0000 00AE     else if(ON_or_OFF == off)
; 0000 00AF         write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (0)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
; 0000 00B0 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// This function can restor MPU6050 to default
;void MPU6050_Reset()
; 0000 00B4 {
; 0000 00B5     // When set to 1, DEVICE_RESET bit in RA_PWR_MGMT_1 resets all internal registers to their default values.
; 0000 00B6     // The bit automatically clears to 0 once the reset is done.
; 0000 00B7     // The default values for each register can be found in RA_MPU6050.h
; 0000 00B8     write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, 0x80);
; 0000 00B9     // Now all reg reset to default values
; 0000 00BA }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// MPU6050 sensor initialization
;void MPU6050_Init()
; 0000 00BE {
_MPU6050_Init:
; .FSTART _MPU6050_Init
; 0000 00BF     //Sets sample rate to 1000/1+4 = 200Hz
; 0000 00C0     write_i2c(MPU6050_ADDRESS, RA_SMPLRT_DIV, SampleRateDiv);
	RCALL SUBOPT_0x1
	LDI  R30,LOW(25)
	ST   -Y,R30
	LDI  R26,LOW(4)
	RCALL SUBOPT_0x2
; 0000 00C1     //Disable FSync, 42Hz DLPF
; 0000 00C2     write_i2c(MPU6050_ADDRESS, RA_CONFIG, (EXT_SYNC_SET<<3)|(DLPF_CFG));
	LDI  R30,LOW(26)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x2
; 0000 00C3     //Disable all axis gyro self tests, scale of 2000 degrees/s
; 0000 00C4     write_i2c(MPU6050_ADDRESS, RA_GYRO_CONFIG, ((XG_ST|YG_ST|ZG_ST)<<5)|GFS_SEL);
	LDI  R30,LOW(27)
	ST   -Y,R30
	LDI  R26,LOW(24)
	RCALL SUBOPT_0x2
; 0000 00C5     //Disable accel self tests, scale of +-16g, no DHPF
; 0000 00C6     write_i2c(MPU6050_ADDRESS, RA_ACCEL_CONFIG, ((XA_ST|YA_ST|ZA_ST)<<5)|AFS_SEL);
	LDI  R30,LOW(28)
	RCALL SUBOPT_0x3
; 0000 00C7     //Disable sensor output to FIFO buffer
; 0000 00C8     write_i2c(MPU6050_ADDRESS, RA_FIFO_EN, FIFO_En_Parameters);
	LDI  R30,LOW(35)
	RCALL SUBOPT_0x3
; 0000 00C9 
; 0000 00CA     //Freefall threshold of |0mg|
; 0000 00CB     write_i2c(MPU6050_ADDRESS, RA_FF_THR, 0x00);
	LDI  R30,LOW(29)
	RCALL SUBOPT_0x3
; 0000 00CC     //Freefall duration limit of 0
; 0000 00CD     write_i2c(MPU6050_ADDRESS, RA_FF_DUR, 0x00);
	LDI  R30,LOW(30)
	RCALL SUBOPT_0x3
; 0000 00CE     //Motion threshold of 0mg
; 0000 00CF     write_i2c(MPU6050_ADDRESS, RA_MOT_THR, 0x00);
	LDI  R30,LOW(31)
	RCALL SUBOPT_0x3
; 0000 00D0     //Motion duration of 0s
; 0000 00D1     write_i2c(MPU6050_ADDRESS, RA_MOT_DUR, 0x00);
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x3
; 0000 00D2     //Zero motion threshold
; 0000 00D3     write_i2c(MPU6050_ADDRESS, RA_ZRMOT_THR, 0x00);
	LDI  R30,LOW(33)
	RCALL SUBOPT_0x3
; 0000 00D4     //Zero motion duration threshold
; 0000 00D5     write_i2c(MPU6050_ADDRESS, RA_ZRMOT_DUR, 0x00);
	LDI  R30,LOW(34)
	RCALL SUBOPT_0x3
; 0000 00D6 
; 0000 00D7 //////////////////////////////////////////////////////////////
; 0000 00D8 //  AUX I2C setup
; 0000 00D9 //////////////////////////////////////////////////////////////
; 0000 00DA     //Sets AUX I2C to single master control, plus other config
; 0000 00DB     write_i2c(MPU6050_ADDRESS, RA_I2C_MST_CTRL, 0x00);
	LDI  R30,LOW(36)
	RCALL SUBOPT_0x3
; 0000 00DC     //Setup AUX I2C slaves
; 0000 00DD     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_ADDR, 0x00);
	LDI  R30,LOW(37)
	RCALL SUBOPT_0x3
; 0000 00DE     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_REG, 0x00);
	LDI  R30,LOW(38)
	RCALL SUBOPT_0x3
; 0000 00DF     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_CTRL, 0x00);
	LDI  R30,LOW(39)
	RCALL SUBOPT_0x3
; 0000 00E0 
; 0000 00E1     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_ADDR, 0x00);
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x3
; 0000 00E2     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_REG, 0x00);
	LDI  R30,LOW(41)
	RCALL SUBOPT_0x3
; 0000 00E3     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_CTRL, 0x00);
	LDI  R30,LOW(42)
	RCALL SUBOPT_0x3
; 0000 00E4 
; 0000 00E5     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_ADDR, 0x00);
	LDI  R30,LOW(43)
	RCALL SUBOPT_0x3
; 0000 00E6     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_REG, 0x00);
	LDI  R30,LOW(44)
	RCALL SUBOPT_0x3
; 0000 00E7     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_CTRL, 0x00);
	LDI  R30,LOW(45)
	RCALL SUBOPT_0x3
; 0000 00E8 
; 0000 00E9     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_ADDR, 0x00);
	LDI  R30,LOW(46)
	RCALL SUBOPT_0x3
; 0000 00EA     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_REG, 0x00);
	LDI  R30,LOW(47)
	RCALL SUBOPT_0x3
; 0000 00EB     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_CTRL, 0x00);
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x3
; 0000 00EC 
; 0000 00ED     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_ADDR, 0x00);
	LDI  R30,LOW(49)
	RCALL SUBOPT_0x3
; 0000 00EE     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_REG, 0x00);
	LDI  R30,LOW(50)
	RCALL SUBOPT_0x3
; 0000 00EF     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_DO, 0x00);
	LDI  R30,LOW(51)
	RCALL SUBOPT_0x3
; 0000 00F0     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_CTRL, 0x00);
	LDI  R30,LOW(52)
	RCALL SUBOPT_0x3
; 0000 00F1     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_DI, 0x00);
	LDI  R30,LOW(53)
	RCALL SUBOPT_0x3
; 0000 00F2 
; 0000 00F3     //Setup INT pin and AUX I2C pass through
; 0000 00F4     write_i2c(MPU6050_ADDRESS, RA_INT_PIN_CFG, 0x00);
	LDI  R30,LOW(55)
	RCALL SUBOPT_0x3
; 0000 00F5     //Enable data ready interrupt
; 0000 00F6     write_i2c(MPU6050_ADDRESS, RA_INT_ENABLE, 0x00);
	LDI  R30,LOW(56)
	RCALL SUBOPT_0x3
; 0000 00F7 
; 0000 00F8     //Slave out, dont care
; 0000 00F9     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_DO, 0x00);
	LDI  R30,LOW(99)
	RCALL SUBOPT_0x3
; 0000 00FA     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_DO, 0x00);
	LDI  R30,LOW(100)
	RCALL SUBOPT_0x3
; 0000 00FB     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_DO, 0x00);
	LDI  R30,LOW(101)
	RCALL SUBOPT_0x3
; 0000 00FC     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_DO, 0x00);
	LDI  R30,LOW(102)
	RCALL SUBOPT_0x3
; 0000 00FD     //More slave config
; 0000 00FE     write_i2c(MPU6050_ADDRESS, RA_I2C_MST_DELAY_CTRL, 0x00);
	LDI  R30,LOW(103)
	RCALL SUBOPT_0x3
; 0000 00FF 
; 0000 0100     //Reset sensor signal paths
; 0000 0101     write_i2c(MPU6050_ADDRESS, RA_SIGNAL_PATH_RESET, 0x00);
	LDI  R30,LOW(104)
	RCALL SUBOPT_0x3
; 0000 0102     //Motion detection control
; 0000 0103     write_i2c(MPU6050_ADDRESS, RA_MOT_DETECT_CTRL, 0x00);
	LDI  R30,LOW(105)
	RCALL SUBOPT_0x3
; 0000 0104     //Disables FIFO, AUX I2C, FIFO and I2C reset bits to 0
; 0000 0105     write_i2c(MPU6050_ADDRESS, RA_USER_CTRL, 0x00);
	LDI  R30,LOW(106)
	RCALL SUBOPT_0x3
; 0000 0106 
; 0000 0107     //Sets clock source to gyro reference w/ PLL
; 0000 0108     write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (SLEEP<<6)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
	LDI  R30,LOW(107)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x2
; 0000 0109     //Controls frequency of wakeups in accel low power mode plus the sensor standby modes
; 0000 010A     write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_2, (LP_WAKE_CTRL<<6)|(STBY_XA<<5)|(STBY_YA<<4)|(STBY_ZA<<3)|(STBY_XG<<2)|(STB ...
	LDI  R30,LOW(108)
	RCALL SUBOPT_0x3
; 0000 010B     //Data transfer to and from the FIFO buffer
; 0000 010C     write_i2c(MPU6050_ADDRESS, RA_FIFO_R_W, 0x00);
	LDI  R30,LOW(116)
	RCALL SUBOPT_0x4
	RCALL _write_i2c
; 0000 010D 
; 0000 010E //  MPU6050 Setup Complete
; 0000 010F }
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// get accel offset X,Y,Z
;void Get_Accel_Offset()
; 0000 0113 {
_Get_Accel_Offset:
; .FSTART _Get_Accel_Offset
; 0000 0114   #define    NumAve4AO      100
; 0000 0115   float Ave=0;
; 0000 0116   unsigned char i= NumAve4AO;
; 0000 0117   while(i--)
	RCALL SUBOPT_0x5
;	Ave -> Y+1
;	i -> R17
_0x15:
	RCALL SUBOPT_0x6
	BREQ _0x17
; 0000 0118   {
; 0000 0119     Accel_Offset_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
; 0000 011A                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)   );
	RCALL SUBOPT_0x1
	LDI  R30,LOW(59)
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x7
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1
	LDI  R30,LOW(60)
	RCALL SUBOPT_0x4
	RCALL _read_i2c
	POP  R26
	POP  R27
	RCALL SUBOPT_0x8
	LDI  R26,LOW(_Accel_Offset_Val)
	LDI  R27,HIGH(_Accel_Offset_Val)
	RCALL SUBOPT_0x9
; 0000 011B     Ave = (float) Ave + (Accel_Offset_Val[X] / NumAve4AO);
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
; 0000 011C     delay_us(10);
; 0000 011D   }
	RJMP _0x15
_0x17:
; 0000 011E   Accel_Offset_Val[X] = Ave;
	RCALL SUBOPT_0xC
	STS  _Accel_Offset_Val,R30
	STS  _Accel_Offset_Val+1,R31
	STS  _Accel_Offset_Val+2,R22
	STS  _Accel_Offset_Val+3,R23
; 0000 011F   Ave = 0;
	RCALL SUBOPT_0xD
; 0000 0120   i = NumAve4AO;
; 0000 0121   while(i--)
_0x18:
	RCALL SUBOPT_0x6
	BREQ _0x1A
; 0000 0122   {
; 0000 0123     Accel_Offset_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
; 0000 0124                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)   );
	RCALL SUBOPT_0x1
	LDI  R30,LOW(61)
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x7
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1
	LDI  R30,LOW(62)
	RCALL SUBOPT_0x4
	RCALL _read_i2c
	POP  R26
	POP  R27
	RCALL SUBOPT_0x8
	__POINTW2MN _Accel_Offset_Val,4
	RCALL SUBOPT_0x9
; 0000 0125     Ave = (float) Ave + (Accel_Offset_Val[Y] / NumAve4AO);
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xB
; 0000 0126     delay_us(10);
; 0000 0127   }
	RJMP _0x18
_0x1A:
; 0000 0128   Accel_Offset_Val[Y] = Ave;
	RCALL SUBOPT_0xC
	__PUTD1MN _Accel_Offset_Val,4
; 0000 0129   Ave = 0;
	RCALL SUBOPT_0xD
; 0000 012A   i = NumAve4AO;
; 0000 012B   while(i--)
_0x1B:
	RCALL SUBOPT_0x6
	BREQ _0x1D
; 0000 012C   {
; 0000 012D     Accel_Offset_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
; 0000 012E                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)   );
	RCALL SUBOPT_0x1
	LDI  R30,LOW(63)
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x7
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1
	LDI  R30,LOW(64)
	RCALL SUBOPT_0x4
	RCALL _read_i2c
	POP  R26
	POP  R27
	RCALL SUBOPT_0x8
	__POINTW2MN _Accel_Offset_Val,8
	RCALL SUBOPT_0x9
; 0000 012F     Ave = (float) Ave + (Accel_Offset_Val[Z] / NumAve4AO);
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xB
; 0000 0130     delay_us(10);
; 0000 0131   }
	RJMP _0x1B
_0x1D:
; 0000 0132   Accel_Offset_Val[Z] = Ave;
	RCALL SUBOPT_0xC
	__PUTD1MN _Accel_Offset_Val,8
; 0000 0133 }
	RJMP _0x20A0001
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Gets raw accelerometer data, performs no processing
;void Get_Accel_Val()
; 0000 0137 {
_Get_Accel_Val:
; .FSTART _Get_Accel_Val
; 0000 0138     Accel_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
; 0000 0139                          read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)    );
	RCALL SUBOPT_0x1
	LDI  R30,LOW(59)
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x7
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1
	LDI  R30,LOW(60)
	RCALL SUBOPT_0x4
	RCALL _read_i2c
	POP  R26
	POP  R27
	RCALL SUBOPT_0x8
	LDI  R26,LOW(_Accel_Raw_Val)
	LDI  R27,HIGH(_Accel_Raw_Val)
	RCALL SUBOPT_0x9
; 0000 013A     Accel_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
; 0000 013B                          read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)    );
	RCALL SUBOPT_0x1
	LDI  R30,LOW(61)
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x7
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1
	LDI  R30,LOW(62)
	RCALL SUBOPT_0x4
	RCALL _read_i2c
	POP  R26
	POP  R27
	RCALL SUBOPT_0x8
	__POINTW2MN _Accel_Raw_Val,4
	RCALL SUBOPT_0x9
; 0000 013C     Accel_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
; 0000 013D                          read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)    );
	RCALL SUBOPT_0x1
	LDI  R30,LOW(63)
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x7
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1
	LDI  R30,LOW(64)
	RCALL SUBOPT_0x4
	RCALL _read_i2c
	POP  R26
	POP  R27
	RCALL SUBOPT_0x8
	__POINTW2MN _Accel_Raw_Val,8
	RCALL SUBOPT_0x9
; 0000 013E 
; 0000 013F     Accel_In_g[X] = Accel_Raw_Val[X] - Accel_Offset_Val[X];
	RCALL SUBOPT_0xA
	LDS  R30,_Accel_Raw_Val
	LDS  R31,_Accel_Raw_Val+1
	LDS  R22,_Accel_Raw_Val+2
	LDS  R23,_Accel_Raw_Val+3
	RCALL __SUBF12
	RCALL SUBOPT_0x10
; 0000 0140     Accel_In_g[Y] = Accel_Raw_Val[Y] - Accel_Offset_Val[Y];
	__GETD1MN _Accel_Raw_Val,4
	RCALL SUBOPT_0xE
	RCALL __SUBF12
	RCALL SUBOPT_0x11
; 0000 0141     Accel_In_g[Z] = Accel_Raw_Val[Z] - Accel_Offset_Val[Z];
	__GETD1MN _Accel_Raw_Val,8
	RCALL SUBOPT_0xF
	RCALL __SUBF12
	RCALL SUBOPT_0x12
; 0000 0142 
; 0000 0143     Accel_In_g[X] = Accel_In_g[X] / ACCEL_Sensitivity;
	LDS  R26,_Accel_In_g
	LDS  R27,_Accel_In_g+1
	LDS  R24,_Accel_In_g+2
	LDS  R25,_Accel_In_g+3
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x10
; 0000 0144     Accel_In_g[Y] = Accel_In_g[Y] / ACCEL_Sensitivity;
	__GETD2MN _Accel_In_g,4
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x11
; 0000 0145     Accel_In_g[Z] = Accel_In_g[Z] / ACCEL_Sensitivity;
	__GETD2MN _Accel_In_g,8
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x12
; 0000 0146 }
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Gets n average raw accelerometer data, performs no processing
;void Get_AvrgAccel_Val()
; 0000 014A {
; 0000 014B   #define    NumAve4A      50
; 0000 014C   float Ave=0;
; 0000 014D   unsigned char i= NumAve4A;
; 0000 014E   while(i--)
;	Ave -> Y+1
;	i -> R17
; 0000 014F   {
; 0000 0150     AvrgAccel_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
; 0000 0151                              read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)   );
; 0000 0152     Ave = (float) Ave + (AvrgAccel_Raw_Val[X] / NumAve4A);
; 0000 0153     delay_us(10);
; 0000 0154   }
; 0000 0155   AvrgAccel_Raw_Val[X] = Ave;
; 0000 0156   Ave = 0;
; 0000 0157   i = NumAve4A;
; 0000 0158   while(i--)
; 0000 0159   {
; 0000 015A     AvrgAccel_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
; 0000 015B                              read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)   );
; 0000 015C     Ave = (float) Ave + (AvrgAccel_Raw_Val[Y] / NumAve4A);
; 0000 015D     delay_us(10);
; 0000 015E   }
; 0000 015F   AvrgAccel_Raw_Val[Y] = Ave;
; 0000 0160   Ave = 0;
; 0000 0161   i = NumAve4A;
; 0000 0162   while(i--)
; 0000 0163   {
; 0000 0164     AvrgAccel_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
; 0000 0165                              read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)   );
; 0000 0166     Ave = (float) Ave + (AvrgAccel_Raw_Val[Z] / NumAve4A);
; 0000 0167     delay_us(10);
; 0000 0168   }
; 0000 0169   AvrgAccel_Raw_Val[Z] = Ave;
; 0000 016A 
; 0000 016B   Accel_In_g[X] = AvrgAccel_Raw_Val[X] - Accel_Offset_Val[X];
; 0000 016C   Accel_In_g[Y] = AvrgAccel_Raw_Val[Y] - Accel_Offset_Val[Y];
; 0000 016D   Accel_In_g[Z] = AvrgAccel_Raw_Val[Z] - Accel_Offset_Val[Z];
; 0000 016E 
; 0000 016F   Accel_In_g[X] = Accel_In_g[X] / ACCEL_Sensitivity;  //  g/LSB
; 0000 0170   Accel_In_g[Y] = Accel_In_g[Y] / ACCEL_Sensitivity;  //  g/LSB
; 0000 0171   Accel_In_g[Z] = Accel_In_g[Z] / ACCEL_Sensitivity;  //  g/LSB
; 0000 0172 
; 0000 0173 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Gets angles from accelerometer data
;void Get_Accel_Angles()
; 0000 0177 {
; 0000 0178 // If you want be averaged of accelerometer data, write (on),else write (off)
; 0000 0179 #define  GetAvrg  on
; 0000 017A 
; 0000 017B #if GetAvrg == on
; 0000 017C     Get_AvrgAccel_Val();
; 0000 017D //  Calculate The Angle Of Each Axis
; 0000 017E     Accel_Angle[X] = 57.295*atan((float) AvrgAccel_Raw_Val[X] / sqrt(pow((float)AvrgAccel_Raw_Val[Z],2)+pow((float)AvrgA ...
; 0000 017F     Accel_Angle[Y] = 57.295*atan((float) AvrgAccel_Raw_Val[Y] / sqrt(pow((float)AvrgAccel_Raw_Val[Z],2)+pow((float)AvrgA ...
; 0000 0180     Accel_Angle[Z] = 57.295*atan((float) sqrt(pow((float)AvrgAccel_Raw_Val[X],2)+pow((float)AvrgAccel_Raw_Val[Y],2))/ Av ...
; 0000 0181 #else
; 0000 0182     Get_Accel_Val();
; 0000 0183 //  Calculate The Angle Of Each Axis
; 0000 0184     Accel_Angle[X] = 57.295*atan((float) Accel_Raw_Val[X] / sqrt(pow((float)Accel_Raw_Val[Z],2)+pow((float)Accel_Raw_Val ...
; 0000 0185     Accel_Angle[Y] = 57.295*atan((float) Accel_Raw_Val[Y] / sqrt(pow((float)Accel_Raw_Val[Z],2)+pow((float)Accel_Raw_Val ...
; 0000 0186     Accel_Angle[Z] = 57.295*atan((float) sqrt(pow((float)Accel_Raw_Val[X],2)+pow((float)Accel_Raw_Val[Y],2))/ Accel_Raw_ ...
; 0000 0187 #endif
; 0000 0188 
; 0000 0189 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// get gyro offset X,Y,Z
;void Get_Gyro_Offset()
; 0000 018D {
_Get_Gyro_Offset:
; .FSTART _Get_Gyro_Offset
; 0000 018E   #define    NumAve4GO      100
; 0000 018F 
; 0000 0190   float Ave = 0;
; 0000 0191   unsigned char i = NumAve4GO;
; 0000 0192   Gyro_Offset_Val[X] = Gyro_Offset_Val[Y] = Gyro_Offset_Val[Z] = 0;
	RCALL SUBOPT_0x5
;	Ave -> Y+1
;	i -> R17
	__GETD1N 0x0
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
; 0000 0193 
; 0000 0194   while(i--)
_0x27:
	RCALL SUBOPT_0x6
	BREQ _0x29
; 0000 0195   {
; 0000 0196     Gyro_Offset_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8)|
; 0000 0197                            read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0)   );
	RCALL SUBOPT_0x1
	LDI  R30,LOW(67)
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x7
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1
	LDI  R30,LOW(68)
	RCALL SUBOPT_0x4
	RCALL _read_i2c
	POP  R26
	POP  R27
	RCALL SUBOPT_0x8
	LDI  R26,LOW(_Gyro_Offset_Val)
	LDI  R27,HIGH(_Gyro_Offset_Val)
	RCALL SUBOPT_0x9
; 0000 0198     Ave = (float) Ave + (Gyro_Offset_Val[X] / NumAve4GO);
	LDS  R26,_Gyro_Offset_Val
	LDS  R27,_Gyro_Offset_Val+1
	LDS  R24,_Gyro_Offset_Val+2
	LDS  R25,_Gyro_Offset_Val+3
	RCALL SUBOPT_0x17
; 0000 0199     delay_us(1);
; 0000 019A   }
	RJMP _0x27
_0x29:
; 0000 019B   Gyro_Offset_Val[X] = Ave;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x16
; 0000 019C   Ave = 0;
	RCALL SUBOPT_0xD
; 0000 019D   i = NumAve4GO;
; 0000 019E   while(i--)
_0x2A:
	RCALL SUBOPT_0x6
	BREQ _0x2C
; 0000 019F   {
; 0000 01A0     Gyro_Offset_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8)|
; 0000 01A1                            read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0)   );
	RCALL SUBOPT_0x1
	LDI  R30,LOW(69)
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x7
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1
	LDI  R30,LOW(70)
	RCALL SUBOPT_0x4
	RCALL _read_i2c
	POP  R26
	POP  R27
	RCALL SUBOPT_0x8
	__POINTW2MN _Gyro_Offset_Val,4
	RCALL SUBOPT_0x9
; 0000 01A2     Ave = (float) Ave + (Gyro_Offset_Val[Y] / NumAve4GO);
	__GETD2MN _Gyro_Offset_Val,4
	RCALL SUBOPT_0x17
; 0000 01A3     delay_us(1);
; 0000 01A4   }
	RJMP _0x2A
_0x2C:
; 0000 01A5   Gyro_Offset_Val[Y] = Ave;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x15
; 0000 01A6   Ave = 0;
	RCALL SUBOPT_0xD
; 0000 01A7   i = NumAve4GO;
; 0000 01A8   while(i--)
_0x2D:
	RCALL SUBOPT_0x6
	BREQ _0x2F
; 0000 01A9   {
; 0000 01AA       Gyro_Offset_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8)|
; 0000 01AB                              read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0)   );
	RCALL SUBOPT_0x1
	LDI  R30,LOW(71)
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x7
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1
	LDI  R30,LOW(72)
	RCALL SUBOPT_0x4
	RCALL _read_i2c
	POP  R26
	POP  R27
	RCALL SUBOPT_0x8
	__POINTW2MN _Gyro_Offset_Val,8
	RCALL SUBOPT_0x9
; 0000 01AC     Ave = (float) Ave + (Gyro_Offset_Val[Z] / NumAve4GO);
	__GETD2MN _Gyro_Offset_Val,8
	RCALL SUBOPT_0x17
; 0000 01AD     delay_us(1);
; 0000 01AE   }
	RJMP _0x2D
_0x2F:
; 0000 01AF   Gyro_Offset_Val[Z] = Ave;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x14
; 0000 01B0 
; 0000 01B1 }
_0x20A0001:
	LDD  R17,Y+0
	ADIW R28,5
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Function to read the gyroscope rate data and convert it into degrees/s
;void Get_Gyro_Val()
; 0000 01B5 {
; 0000 01B6     Gyro_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8) |
; 0000 01B7                         read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0))    ;
; 0000 01B8     Gyro_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8) |
; 0000 01B9                         read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0))    ;
; 0000 01BA     Gyro_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8) |
; 0000 01BB                         read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0))    ;
; 0000 01BC 
; 0000 01BD     GyroRate_Val[X] = Gyro_Raw_Val[X] - Gyro_Offset_Val[X];
; 0000 01BE     GyroRate_Val[Y] = Gyro_Raw_Val[Y] - Gyro_Offset_Val[Y];
; 0000 01BF     GyroRate_Val[Z] = Gyro_Raw_Val[Z] - Gyro_Offset_Val[Z];
; 0000 01C0 
; 0000 01C1     GyroRate_Val[X] = GyroRate_Val[X] / GYRO_Sensitivity;
; 0000 01C2     GyroRate_Val[Y] = GyroRate_Val[Y] / GYRO_Sensitivity;
; 0000 01C3     GyroRate_Val[Z] = GyroRate_Val[Z] / GYRO_Sensitivity;
; 0000 01C4 
; 0000 01C5 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Function to read the Avrrage of gyroscope rate data and convert it into degrees/s
;void Get_AvrgGyro_Val()
; 0000 01C9 {
; 0000 01CA   #define    NumAve4G      50
; 0000 01CB 
; 0000 01CC   float Ave = 0;
; 0000 01CD   unsigned char i = NumAve4G;
; 0000 01CE   AvrgGyro_Raw_Val[X] = AvrgGyro_Raw_Val[Y] = AvrgGyro_Raw_Val[Z] = 0;
;	Ave -> Y+1
;	i -> R17
; 0000 01CF 
; 0000 01D0   while(i--)
; 0000 01D1   {
; 0000 01D2     AvrgGyro_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8)|
; 0000 01D3                             read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0)   );
; 0000 01D4     Ave = (float) Ave + (AvrgGyro_Raw_Val[X] / NumAve4G);
; 0000 01D5     delay_us(1);
; 0000 01D6   }
; 0000 01D7   AvrgGyro_Raw_Val[X] = Ave;
; 0000 01D8   Ave = 0;
; 0000 01D9   i = NumAve4G;
; 0000 01DA   while(i--)
; 0000 01DB   {
; 0000 01DC     AvrgGyro_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8)|
; 0000 01DD                             read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0)   );
; 0000 01DE     Ave = (float) Ave + (AvrgGyro_Raw_Val[Y] / NumAve4G);
; 0000 01DF     delay_us(1);
; 0000 01E0   }
; 0000 01E1   AvrgGyro_Raw_Val[Y] = Ave;
; 0000 01E2   Ave = 0;
; 0000 01E3   i = NumAve4G;
; 0000 01E4   while(i--)
; 0000 01E5   {
; 0000 01E6     AvrgGyro_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8)|
; 0000 01E7                             read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0)   );
; 0000 01E8     Ave = (float) Ave + (AvrgGyro_Raw_Val[Z] / NumAve4G);
; 0000 01E9     delay_us(1);
; 0000 01EA   }
; 0000 01EB   AvrgGyro_Raw_Val[Z] = Ave;
; 0000 01EC 
; 0000 01ED   GyroRate_Val[X] = AvrgGyro_Raw_Val[X] - Gyro_Offset_Val[X];
; 0000 01EE   GyroRate_Val[Y] = AvrgGyro_Raw_Val[Y] - Gyro_Offset_Val[Y];
; 0000 01EF   GyroRate_Val[Z] = AvrgGyro_Raw_Val[Z] - Gyro_Offset_Val[Z];
; 0000 01F0 
; 0000 01F1   GyroRate_Val[X] = GyroRate_Val[X] / GYRO_Sensitivity;   // (º/s)/LSB
; 0000 01F2   GyroRate_Val[Y] = GyroRate_Val[Y] / GYRO_Sensitivity;   // (º/s)/LSB
; 0000 01F3   GyroRate_Val[Z] = GyroRate_Val[Z] / GYRO_Sensitivity;   // (º/s)/LSB
; 0000 01F4 
; 0000 01F5 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Function to read the Temperature
;void Get_Temp_Val()
; 0000 01F9 {
; 0000 01FA     Temp_Val = ((read_i2c(MPU6050_ADDRESS, RA_TEMP_OUT_H, 0)<< 8)|
; 0000 01FB                   read_i2c(MPU6050_ADDRESS, RA_TEMP_OUT_L, 0)   );
; 0000 01FC // Compute the temperature in degrees
; 0000 01FD     Temp_Val = (Temp_Val /TEMP_Sensitivity) + 36.53;
; 0000 01FE }
;
;
;// Declare your global variables here
;void WaitInPrint()
; 0000 0203     {
; 0000 0204     getchar();
; 0000 0205     }
;
;
;
;
;
;
;void print();
;int cnt1,x,y;
;
;int action;
;void main(void)
; 0000 0211 {
_main:
; .FSTART _main
; 0000 0212 // Declare your local variables here
; 0000 0213 
; 0000 0214 // Input/Output Ports initialization
; 0000 0215 // Port B initialization
; 0000 0216 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0217 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 0218 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0219 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 021A 
; 0000 021B // Port C initialization
; 0000 021C // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 021D DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 021E // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 021F PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0220 
; 0000 0221 // Port D initialization
; 0000 0222 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=In Bit0=In
; 0000 0223 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (1<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(4)
	OUT  0x11,R30
; 0000 0224 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=T Bit0=T
; 0000 0225 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0226 
; 0000 0227 // Timer/Counter 0 initialization
; 0000 0228 // Clock source: System Clock
; 0000 0229 // Clock value: Timer 0 Stopped
; 0000 022A TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 022B TCNT0=0x00;
	OUT  0x32,R30
; 0000 022C 
; 0000 022D // Timer/Counter 1 initialization
; 0000 022E // Clock source: System Clock
; 0000 022F // Clock value: Timer1 Stopped
; 0000 0230 // Mode: Normal top=0xFFFF
; 0000 0231 // OC1A output: Disconnected
; 0000 0232 // OC1B output: Disconnected
; 0000 0233 // Noise Canceler: Off
; 0000 0234 // Input Capture on Falling Edge
; 0000 0235 // Timer1 Overflow Interrupt: Off
; 0000 0236 // Input Capture Interrupt: Off
; 0000 0237 // Compare A Match Interrupt: Off
; 0000 0238 // Compare B Match Interrupt: Off
; 0000 0239 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 023A TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 023B TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 023C TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 023D ICR1H=0x00;
	OUT  0x27,R30
; 0000 023E ICR1L=0x00;
	OUT  0x26,R30
; 0000 023F OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0240 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0241 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0242 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0243 
; 0000 0244 // Timer/Counter 2 initialization
; 0000 0245 // Clock source: System Clock
; 0000 0246 // Clock value: Timer2 Stopped
; 0000 0247 // Mode: Normal top=0xFF
; 0000 0248 // OC2 output: Disconnected
; 0000 0249 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 024A TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 024B TCNT2=0x00;
	OUT  0x24,R30
; 0000 024C OCR2=0x00;
	OUT  0x23,R30
; 0000 024D 
; 0000 024E // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 024F TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0250 
; 0000 0251 // External Interrupt(s) initialization
; 0000 0252 // INT0: Off
; 0000 0253 // INT1: Off
; 0000 0254 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0255 
; 0000 0256 // USART initialization
; 0000 0257 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0258 // USART Receiver: On
; 0000 0259 // USART Transmitter: On
; 0000 025A // USART Mode: Asynchronous
; 0000 025B // USART Baud Rate: 9600
; 0000 025C UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 025D UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 025E UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 025F UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0260 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0261 
; 0000 0262 // Analog Comparator initialization
; 0000 0263 // Analog Comparator: Off
; 0000 0264 // The Analog Comparator's positive input is
; 0000 0265 // connected to the AIN0 pin
; 0000 0266 // The Analog Comparator's negative input is
; 0000 0267 // connected to the AIN1 pin
; 0000 0268 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0269 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 026A 
; 0000 026B // ADC initialization
; 0000 026C // ADC disabled
; 0000 026D ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 026E 
; 0000 026F // SPI initialization
; 0000 0270 // SPI disabled
; 0000 0271 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0272 
; 0000 0273 // TWI initialization
; 0000 0274 // TWI disabled
; 0000 0275 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0276 
; 0000 0277 // Bit-Banged I2C Bus initialization
; 0000 0278 // I2C Port: PORTC
; 0000 0279 // I2C SDA bit: 3
; 0000 027A // I2C SCL bit: 2
; 0000 027B // Bit Rate: 100 kHz
; 0000 027C // Note: I2C settings are specified in the
; 0000 027D // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 027E i2c_init();
	RCALL _i2c_init
; 0000 027F 
; 0000 0280 // Global enable interrupts
; 0000 0281 #asm("sei")
	sei
; 0000 0282 PORTD.2=1;
	RCALL SUBOPT_0x18
; 0000 0283 delay_ms(100);
; 0000 0284 PORTD.2=0;
; 0000 0285 delay_ms(100);
; 0000 0286 PORTD.2=1;
	RCALL SUBOPT_0x18
; 0000 0287 delay_ms(100);
; 0000 0288 PORTD.2=0;
; 0000 0289 delay_ms(100);
; 0000 028A 
; 0000 028B MPU6050_Init();
	RCALL _MPU6050_Init
; 0000 028C Get_Accel_Offset();
	RCALL _Get_Accel_Offset
; 0000 028D Get_Gyro_Offset();
	RCALL _Get_Gyro_Offset
; 0000 028E 
; 0000 028F 
; 0000 0290 while (1)
_0x41:
; 0000 0291     {
; 0000 0292 
; 0000 0293     //Get_Temp_Val();
; 0000 0294 
; 0000 0295     //Get_Gyro_Val();
; 0000 0296     //Get_AvrgGyro_Val();
; 0000 0297     Get_Accel_Val();
	RCALL _Get_Accel_Val
; 0000 0298     //Get_AvrgAccel_Val();
; 0000 0299     //Get_Accel_Angles();
; 0000 029A 
; 0000 029B     x=Accel_Raw_Val[X]/100;
	LDS  R26,_Accel_Raw_Val
	LDS  R27,_Accel_Raw_Val+1
	LDS  R24,_Accel_Raw_Val+2
	LDS  R25,_Accel_Raw_Val+3
	RCALL SUBOPT_0x19
	MOVW R10,R30
; 0000 029C     y=Accel_Raw_Val[Y]/100;
	__GETD2MN _Accel_Raw_Val,4
	RCALL SUBOPT_0x19
	MOVW R12,R30
; 0000 029D 
; 0000 029E 
; 0000 029F     if(x>80)
	RCALL SUBOPT_0x1A
	CP   R30,R10
	CPC  R31,R11
	BRGE _0x44
; 0000 02A0         {
; 0000 02A1         if(y>=80)                 action='Q';
	RCALL SUBOPT_0x1B
	BRLT _0x45
	LDI  R30,LOW(81)
	LDI  R31,HIGH(81)
	RJMP _0x69
; 0000 02A2         else if(y<80 && y>=-80)   action='F';
_0x45:
	RCALL SUBOPT_0x1B
	BRGE _0x48
	RCALL SUBOPT_0x1C
	BRGE _0x49
_0x48:
	RJMP _0x47
_0x49:
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x69
; 0000 02A3         else if(y<-80)            action='E';
_0x47:
	RCALL SUBOPT_0x1C
	BRGE _0x4B
	LDI  R30,LOW(69)
	LDI  R31,HIGH(69)
_0x69:
	STS  _action,R30
	STS  _action+1,R31
; 0000 02A4         }
_0x4B:
; 0000 02A5     else if(x<80 && x>=-80)
	RJMP _0x4C
_0x44:
	RCALL SUBOPT_0x1A
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x4E
	RCALL SUBOPT_0x1D
	BRGE _0x4F
_0x4E:
	RJMP _0x4D
_0x4F:
; 0000 02A6         {
; 0000 02A7         if(y>=80)                 action='L';
	RCALL SUBOPT_0x1B
	BRLT _0x50
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	RJMP _0x6A
; 0000 02A8         else if(y<80 && y>=-80)  action='S';
_0x50:
	RCALL SUBOPT_0x1B
	BRGE _0x53
	RCALL SUBOPT_0x1C
	BRGE _0x54
_0x53:
	RJMP _0x52
_0x54:
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	RJMP _0x6A
; 0000 02A9         else if(y<-80)  action='R';
_0x52:
	RCALL SUBOPT_0x1C
	BRGE _0x56
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
_0x6A:
	STS  _action,R30
	STS  _action+1,R31
; 0000 02AA         }
_0x56:
; 0000 02AB     else if(x<-80)
	RJMP _0x57
_0x4D:
	RCALL SUBOPT_0x1D
	BRGE _0x58
; 0000 02AC         {
; 0000 02AD         if(y>=80)                action='Z';
	RCALL SUBOPT_0x1B
	BRLT _0x59
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	RJMP _0x6B
; 0000 02AE         else if(y<80 && y>=-80)  action='G';
_0x59:
	RCALL SUBOPT_0x1B
	BRGE _0x5C
	RCALL SUBOPT_0x1C
	BRGE _0x5D
_0x5C:
	RJMP _0x5B
_0x5D:
	LDI  R30,LOW(71)
	LDI  R31,HIGH(71)
	RJMP _0x6B
; 0000 02AF         else if(y<-80)           action='C';
_0x5B:
	RCALL SUBOPT_0x1C
	BRGE _0x5F
	LDI  R30,LOW(67)
	LDI  R31,HIGH(67)
_0x6B:
	STS  _action,R30
	STS  _action+1,R31
; 0000 02B0         }
_0x5F:
; 0000 02B1 
; 0000 02B2     putchar(action);
_0x58:
_0x57:
_0x4C:
	LDS  R26,_action
	RCALL _putchar
; 0000 02B3     }
	RJMP _0x41
; 0000 02B4 }
_0x60:
	RJMP _0x60
; .FEND
;
;void print()
; 0000 02B7     {
; 0000 02B8     puts("X:");
; 0000 02B9     if(x>=0)
; 0000 02BA         {
; 0000 02BB         putchar('+');
; 0000 02BC         putchar((x/100)%10+'0');
; 0000 02BD         putchar((x/10)%10+'0');
; 0000 02BE         putchar((x/1)%10+'0');
; 0000 02BF         }
; 0000 02C0     else if(x < 0)
; 0000 02C1         {
; 0000 02C2         putchar('-');
; 0000 02C3         putchar((-x/100)%10+'0');
; 0000 02C4         putchar((-x/10)%10+'0');
; 0000 02C5         putchar((-x/1)%10+'0');
; 0000 02C6         }
; 0000 02C7     puts("_Y:");
; 0000 02C8 
; 0000 02C9     if(y>=0)
; 0000 02CA         {
; 0000 02CB         putchar('+');
; 0000 02CC         putchar((y/100)%10+'0');
; 0000 02CD         putchar((y/10)%10+'0');
; 0000 02CE         putchar((y/1)%10+'0');
; 0000 02CF         }
; 0000 02D0     else if(y < 0)
; 0000 02D1         {
; 0000 02D2         putchar('-');
; 0000 02D3         putchar((-y/100)%10+'0');
; 0000 02D4         putchar((-y/10)%10+'0');
; 0000 02D5         putchar((-y/1)%10+'0');
; 0000 02D6         }
; 0000 02D7     puts("_______________________");
; 0000 02D8     delay_ms(10);
; 0000 02D9     }

	.DSEG
_0x61:
	.BYTE 0x1F
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x8
_Accel_Raw_Val:
	.BYTE 0xC
_AvrgAccel_Raw_Val:
	.BYTE 0xC
_Accel_In_g:
	.BYTE 0xC
_Accel_Offset_Val:
	.BYTE 0xC
_Accel_Angle:
	.BYTE 0xC
_Gyro_Raw_Val:
	.BYTE 0xC
_AvrgGyro_Raw_Val:
	.BYTE 0xC
_Gyro_Offset_Val:
	.BYTE 0xC
_GyroRate_Val:
	.BYTE 0xC
_Temp_Val:
	.BYTE 0x4
_action:
	.BYTE 0x2
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 60 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(208)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 41 TIMES, CODE SIZE REDUCTION:38 WORDS
SUBOPT_0x2:
	RCALL _write_i2c
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 37 TIMES, CODE SIZE REDUCTION:70 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x5:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	ST   -Y,R17
	LDI  R17,100
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x6:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x7:
	RCALL _read_i2c
	MOV  R31,R30
	LDI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x8:
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x9:
	RCALL __CWD1
	RCALL __CDF1
	RCALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	LDS  R26,_Accel_Offset_Val
	LDS  R27,_Accel_Offset_Val+1
	LDS  R24,_Accel_Offset_Val+2
	LDS  R25,_Accel_Offset_Val+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0xB:
	__GETD1N 0x42C80000
	RCALL __DIVF21
	__GETD2S 1
	RCALL __ADDF12
	__PUTD1S 1
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	__CLRD1S 1
	LDI  R17,LOW(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	__GETD2MN _Accel_Offset_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	__GETD2MN _Accel_Offset_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	STS  _Accel_In_g,R30
	STS  _Accel_In_g+1,R31
	STS  _Accel_In_g+2,R22
	STS  _Accel_In_g+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	__PUTD1MN _Accel_In_g,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	__PUTD1MN _Accel_In_g,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	__GETD1N 0x46800000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	__PUTD1MN _Gyro_Offset_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	__PUTD1MN _Gyro_Offset_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	STS  _Gyro_Offset_Val,R30
	STS  _Gyro_Offset_Val+1,R31
	STS  _Gyro_Offset_Val+2,R22
	STS  _Gyro_Offset_Val+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x17:
	__GETD1N 0x42C80000
	RCALL __DIVF21
	__GETD2S 1
	RCALL __ADDF12
	__PUTD1S 1
	__DELAY_USB 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	SBI  0x12,2
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
	CBI  0x12,2
	LDI  R26,LOW(100)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	__GETD1N 0x42C80000
	RCALL __DIVF21
	RCALL __CFD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1B:
	RCALL SUBOPT_0x1A
	CP   R12,R30
	CPC  R13,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(65456)
	LDI  R31,HIGH(65456)
	CP   R12,R30
	CPC  R13,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(65456)
	LDI  R31,HIGH(65456)
	CP   R10,R30
	CPC  R11,R31
	RET


	.CSEG
	.equ __sda_bit=3
	.equ __scl_bit=2
	.equ __i2c_port=0x15 ;PORTC
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

;END OF CODE MARKER
__END_OF_CODE:
