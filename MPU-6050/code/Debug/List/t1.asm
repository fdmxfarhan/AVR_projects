
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16A
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

	#pragma AVRPART ADMIN PART_NAME ATmega16A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _cnt1=R4
	.DEF _cnt1_msb=R5
	.DEF _a1=R6
	.DEF _a1_msb=R7
	.DEF _a2=R8
	.DEF _a2_msb=R9
	.DEF _a3=R10
	.DEF _a3_msb=R11
	.DEF _a4=R12
	.DEF _a4_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

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

	JMP  _main

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
;Date    : 1/14/2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16A
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// I2C Bus functions
;#include <i2c.h>
;// Graphic Display functions
;#include <glcd.h>
;
;// Font used for displaying text
;// on the graphic display
;#include <font5x7.h>
;
;
;#include <delay.h>
;#include <stdio.h>
;#include <stdlib.h>
;#include "LIB\MPU6050 LIB\MPU6050.h"
;
;
;
;
;
;
;
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
; 0000 0041 {

	.CSEG
_read_i2c:
; .FSTART _read_i2c
; 0000 0042 unsigned char Data;
; 0000 0043 i2c_start();
	ST   -Y,R26
	ST   -Y,R17
;	BusAddres -> Y+3
;	Reg -> Y+2
;	Ack -> Y+1
;	Data -> R17
	CALL _i2c_start
; 0000 0044 i2c_write(BusAddres);
	LDD  R26,Y+3
	CALL _i2c_write
; 0000 0045 i2c_write(Reg);
	LDD  R26,Y+2
	CALL _i2c_write
; 0000 0046 i2c_start();
	CALL _i2c_start
; 0000 0047 i2c_write(BusAddres + 1);
	LDD  R26,Y+3
	SUBI R26,-LOW(1)
	CALL _i2c_write
; 0000 0048 delay_us(10);
	__DELAY_USB 27
; 0000 0049 Data=i2c_read(Ack);
	LDD  R26,Y+1
	CALL _i2c_read
	MOV  R17,R30
; 0000 004A i2c_stop();
	CALL _i2c_stop
; 0000 004B return Data;
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,4
	RET
; 0000 004C }
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;void write_i2c(unsigned char BusAddres , unsigned char Reg , unsigned char Data)
; 0000 004F {
_write_i2c:
; .FSTART _write_i2c
; 0000 0050 i2c_start();
	ST   -Y,R26
;	BusAddres -> Y+2
;	Reg -> Y+1
;	Data -> Y+0
	CALL _i2c_start
; 0000 0051 i2c_write(BusAddres);
	LDD  R26,Y+2
	CALL _i2c_write
; 0000 0052 i2c_write(Reg);
	LDD  R26,Y+1
	CALL _i2c_write
; 0000 0053 i2c_write(Data);
	LD   R26,Y
	CALL _i2c_write
; 0000 0054 i2c_stop();
	CALL _i2c_stop
; 0000 0055 }
	ADIW R28,3
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// This function can test i2c communication MPU6050
;unsigned char MPU6050_Test_I2C()
; 0000 0059 {
; 0000 005A     unsigned char Data = 0x00;
; 0000 005B     Data=read_i2c(MPU6050_ADDRESS, RA_WHO_AM_I, 0);
;	Data -> R17
; 0000 005C     if(Data == 0x68)
; 0000 005D         return 1;       // Means Comunication With MPU6050 is Corect
; 0000 005E     else
; 0000 005F         return 0;       // Means ERROR, Stopping
; 0000 0060 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// This function can move MPU6050 to sleep
;void MPU6050_Sleep(char ON_or_OFF)
; 0000 0064 {
; 0000 0065     if(ON_or_OFF == on)
;	ON_or_OFF -> Y+0
; 0000 0066         write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (1<<6)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
; 0000 0067     else if(ON_or_OFF == off)
; 0000 0068         write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (0)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
; 0000 0069 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// This function can restor MPU6050 to default
;void MPU6050_Reset()
; 0000 006D {
; 0000 006E     // When set to 1, DEVICE_RESET bit in RA_PWR_MGMT_1 resets all internal registers to their default values.
; 0000 006F     // The bit automatically clears to 0 once the reset is done.
; 0000 0070     // The default values for each register can be found in RA_MPU6050.h
; 0000 0071     write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, 0x80);
; 0000 0072     // Now all reg reset to default values
; 0000 0073 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// MPU6050 sensor initialization
;void MPU6050_Init()
; 0000 0077 {
_MPU6050_Init:
; .FSTART _MPU6050_Init
; 0000 0078     //Sets sample rate to 1000/1+4 = 200Hz
; 0000 0079     write_i2c(MPU6050_ADDRESS, RA_SMPLRT_DIV, SampleRateDiv);
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	LDI  R26,LOW(4)
	CALL SUBOPT_0x0
; 0000 007A     //Disable FSync, 42Hz DLPF
; 0000 007B     write_i2c(MPU6050_ADDRESS, RA_CONFIG, (EXT_SYNC_SET<<3)|(DLPF_CFG));
	LDI  R30,LOW(26)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL SUBOPT_0x0
; 0000 007C     //Disable all axis gyro self tests, scale of 2000 degrees/s
; 0000 007D     write_i2c(MPU6050_ADDRESS, RA_GYRO_CONFIG, ((XG_ST|YG_ST|ZG_ST)<<5)|GFS_SEL);
	LDI  R30,LOW(27)
	ST   -Y,R30
	LDI  R26,LOW(24)
	CALL SUBOPT_0x0
; 0000 007E     //Disable accel self tests, scale of +-16g, no DHPF
; 0000 007F     write_i2c(MPU6050_ADDRESS, RA_ACCEL_CONFIG, ((XA_ST|YA_ST|ZA_ST)<<5)|AFS_SEL);
	LDI  R30,LOW(28)
	CALL SUBOPT_0x1
; 0000 0080     //Disable sensor output to FIFO buffer
; 0000 0081     write_i2c(MPU6050_ADDRESS, RA_FIFO_EN, FIFO_En_Parameters);
	LDI  R30,LOW(35)
	CALL SUBOPT_0x1
; 0000 0082 
; 0000 0083     //Freefall threshold of |0mg|
; 0000 0084     write_i2c(MPU6050_ADDRESS, RA_FF_THR, 0x00);
	LDI  R30,LOW(29)
	CALL SUBOPT_0x1
; 0000 0085     //Freefall duration limit of 0
; 0000 0086     write_i2c(MPU6050_ADDRESS, RA_FF_DUR, 0x00);
	LDI  R30,LOW(30)
	CALL SUBOPT_0x1
; 0000 0087     //Motion threshold of 0mg
; 0000 0088     write_i2c(MPU6050_ADDRESS, RA_MOT_THR, 0x00);
	LDI  R30,LOW(31)
	CALL SUBOPT_0x1
; 0000 0089     //Motion duration of 0s
; 0000 008A     write_i2c(MPU6050_ADDRESS, RA_MOT_DUR, 0x00);
	LDI  R30,LOW(32)
	CALL SUBOPT_0x1
; 0000 008B     //Zero motion threshold
; 0000 008C     write_i2c(MPU6050_ADDRESS, RA_ZRMOT_THR, 0x00);
	LDI  R30,LOW(33)
	CALL SUBOPT_0x1
; 0000 008D     //Zero motion duration threshold
; 0000 008E     write_i2c(MPU6050_ADDRESS, RA_ZRMOT_DUR, 0x00);
	LDI  R30,LOW(34)
	CALL SUBOPT_0x1
; 0000 008F 
; 0000 0090 //////////////////////////////////////////////////////////////
; 0000 0091 //  AUX I2C setup
; 0000 0092 //////////////////////////////////////////////////////////////
; 0000 0093     //Sets AUX I2C to single master control, plus other config
; 0000 0094     write_i2c(MPU6050_ADDRESS, RA_I2C_MST_CTRL, 0x00);
	LDI  R30,LOW(36)
	CALL SUBOPT_0x1
; 0000 0095     //Setup AUX I2C slaves
; 0000 0096     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_ADDR, 0x00);
	LDI  R30,LOW(37)
	CALL SUBOPT_0x1
; 0000 0097     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_REG, 0x00);
	LDI  R30,LOW(38)
	CALL SUBOPT_0x1
; 0000 0098     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_CTRL, 0x00);
	LDI  R30,LOW(39)
	CALL SUBOPT_0x1
; 0000 0099 
; 0000 009A     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_ADDR, 0x00);
	LDI  R30,LOW(40)
	CALL SUBOPT_0x1
; 0000 009B     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_REG, 0x00);
	LDI  R30,LOW(41)
	CALL SUBOPT_0x1
; 0000 009C     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_CTRL, 0x00);
	LDI  R30,LOW(42)
	CALL SUBOPT_0x1
; 0000 009D 
; 0000 009E     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_ADDR, 0x00);
	LDI  R30,LOW(43)
	CALL SUBOPT_0x1
; 0000 009F     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_REG, 0x00);
	LDI  R30,LOW(44)
	CALL SUBOPT_0x1
; 0000 00A0     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_CTRL, 0x00);
	LDI  R30,LOW(45)
	CALL SUBOPT_0x1
; 0000 00A1 
; 0000 00A2     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_ADDR, 0x00);
	LDI  R30,LOW(46)
	CALL SUBOPT_0x1
; 0000 00A3     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_REG, 0x00);
	LDI  R30,LOW(47)
	CALL SUBOPT_0x1
; 0000 00A4     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_CTRL, 0x00);
	LDI  R30,LOW(48)
	CALL SUBOPT_0x1
; 0000 00A5 
; 0000 00A6     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_ADDR, 0x00);
	LDI  R30,LOW(49)
	CALL SUBOPT_0x1
; 0000 00A7     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_REG, 0x00);
	LDI  R30,LOW(50)
	CALL SUBOPT_0x1
; 0000 00A8     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_DO, 0x00);
	LDI  R30,LOW(51)
	CALL SUBOPT_0x1
; 0000 00A9     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_CTRL, 0x00);
	LDI  R30,LOW(52)
	CALL SUBOPT_0x1
; 0000 00AA     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_DI, 0x00);
	LDI  R30,LOW(53)
	CALL SUBOPT_0x1
; 0000 00AB 
; 0000 00AC     //Setup INT pin and AUX I2C pass through
; 0000 00AD     write_i2c(MPU6050_ADDRESS, RA_INT_PIN_CFG, 0x00);
	LDI  R30,LOW(55)
	CALL SUBOPT_0x1
; 0000 00AE     //Enable data ready interrupt
; 0000 00AF     write_i2c(MPU6050_ADDRESS, RA_INT_ENABLE, 0x00);
	LDI  R30,LOW(56)
	CALL SUBOPT_0x1
; 0000 00B0 
; 0000 00B1     //Slave out, dont care
; 0000 00B2     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_DO, 0x00);
	LDI  R30,LOW(99)
	CALL SUBOPT_0x1
; 0000 00B3     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_DO, 0x00);
	LDI  R30,LOW(100)
	CALL SUBOPT_0x1
; 0000 00B4     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_DO, 0x00);
	LDI  R30,LOW(101)
	CALL SUBOPT_0x1
; 0000 00B5     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_DO, 0x00);
	LDI  R30,LOW(102)
	CALL SUBOPT_0x1
; 0000 00B6     //More slave config
; 0000 00B7     write_i2c(MPU6050_ADDRESS, RA_I2C_MST_DELAY_CTRL, 0x00);
	LDI  R30,LOW(103)
	CALL SUBOPT_0x1
; 0000 00B8 
; 0000 00B9     //Reset sensor signal paths
; 0000 00BA     write_i2c(MPU6050_ADDRESS, RA_SIGNAL_PATH_RESET, 0x00);
	LDI  R30,LOW(104)
	CALL SUBOPT_0x1
; 0000 00BB     //Motion detection control
; 0000 00BC     write_i2c(MPU6050_ADDRESS, RA_MOT_DETECT_CTRL, 0x00);
	LDI  R30,LOW(105)
	CALL SUBOPT_0x1
; 0000 00BD     //Disables FIFO, AUX I2C, FIFO and I2C reset bits to 0
; 0000 00BE     write_i2c(MPU6050_ADDRESS, RA_USER_CTRL, 0x00);
	LDI  R30,LOW(106)
	CALL SUBOPT_0x1
; 0000 00BF 
; 0000 00C0     //Sets clock source to gyro reference w/ PLL
; 0000 00C1     write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (SLEEP<<6)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
	LDI  R30,LOW(107)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL SUBOPT_0x0
; 0000 00C2     //Controls frequency of wakeups in accel low power mode plus the sensor standby modes
; 0000 00C3     write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_2, (LP_WAKE_CTRL<<6)|(STBY_XA<<5)|(STBY_YA<<4)|(STBY_ZA<<3)|(STBY_XG<<2)|(STB ...
	LDI  R30,LOW(108)
	CALL SUBOPT_0x1
; 0000 00C4     //Data transfer to and from the FIFO buffer
; 0000 00C5     write_i2c(MPU6050_ADDRESS, RA_FIFO_R_W, 0x00);
	LDI  R30,LOW(116)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _write_i2c
; 0000 00C6 
; 0000 00C7 //  MPU6050 Setup Complete
; 0000 00C8 }
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// get accel offset X,Y,Z
;void Get_Accel_Offset()
; 0000 00CC {
_Get_Accel_Offset:
; .FSTART _Get_Accel_Offset
; 0000 00CD   #define    NumAve4AO      100
; 0000 00CE   float Ave=0;
; 0000 00CF   unsigned char i= NumAve4AO;
; 0000 00D0   while(i--)
	CALL SUBOPT_0x2
;	Ave -> Y+1
;	i -> R17
_0x8:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0xA
; 0000 00D1   {
; 0000 00D2     Accel_Offset_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
; 0000 00D3                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)   );
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(59)
	CALL SUBOPT_0x3
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(60)
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_Accel_Offset_Val)
	LDI  R27,HIGH(_Accel_Offset_Val)
	CALL SUBOPT_0x4
; 0000 00D4     Ave = (float) Ave + (Accel_Offset_Val[X] / NumAve4AO);
	LDS  R26,_Accel_Offset_Val
	LDS  R27,_Accel_Offset_Val+1
	LDS  R24,_Accel_Offset_Val+2
	LDS  R25,_Accel_Offset_Val+3
	CALL SUBOPT_0x5
; 0000 00D5     delay_us(10);
; 0000 00D6   }
	RJMP _0x8
_0xA:
; 0000 00D7   Accel_Offset_Val[X] = Ave;
	CALL SUBOPT_0x6
	STS  _Accel_Offset_Val,R30
	STS  _Accel_Offset_Val+1,R31
	STS  _Accel_Offset_Val+2,R22
	STS  _Accel_Offset_Val+3,R23
; 0000 00D8   Ave = 0;
	CALL SUBOPT_0x7
; 0000 00D9   i = NumAve4AO;
; 0000 00DA   while(i--)
_0xB:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0xD
; 0000 00DB   {
; 0000 00DC     Accel_Offset_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
; 0000 00DD                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)   );
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(61)
	CALL SUBOPT_0x3
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(62)
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Accel_Offset_Val,4
	CALL SUBOPT_0x4
; 0000 00DE     Ave = (float) Ave + (Accel_Offset_Val[Y] / NumAve4AO);
	__GETD2MN _Accel_Offset_Val,4
	CALL SUBOPT_0x5
; 0000 00DF     delay_us(10);
; 0000 00E0   }
	RJMP _0xB
_0xD:
; 0000 00E1   Accel_Offset_Val[Y] = Ave;
	CALL SUBOPT_0x6
	__PUTD1MN _Accel_Offset_Val,4
; 0000 00E2   Ave = 0;
	CALL SUBOPT_0x7
; 0000 00E3   i = NumAve4AO;
; 0000 00E4   while(i--)
_0xE:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x10
; 0000 00E5   {
; 0000 00E6     Accel_Offset_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
; 0000 00E7                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)   );
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(63)
	CALL SUBOPT_0x3
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(64)
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Accel_Offset_Val,8
	CALL SUBOPT_0x4
; 0000 00E8     Ave = (float) Ave + (Accel_Offset_Val[Z] / NumAve4AO);
	__GETD2MN _Accel_Offset_Val,8
	CALL SUBOPT_0x5
; 0000 00E9     delay_us(10);
; 0000 00EA   }
	RJMP _0xE
_0x10:
; 0000 00EB   Accel_Offset_Val[Z] = Ave;
	CALL SUBOPT_0x6
	__PUTD1MN _Accel_Offset_Val,8
; 0000 00EC }
	RJMP _0x2120009
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Gets raw accelerometer data, performs no processing
;void Get_Accel_Val()
; 0000 00F0 {
; 0000 00F1     Accel_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
; 0000 00F2                          read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)    );
; 0000 00F3     Accel_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
; 0000 00F4                          read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)    );
; 0000 00F5     Accel_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
; 0000 00F6                          read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)    );
; 0000 00F7 
; 0000 00F8     Accel_In_g[X] = Accel_Raw_Val[X] - Accel_Offset_Val[X];
; 0000 00F9     Accel_In_g[Y] = Accel_Raw_Val[Y] - Accel_Offset_Val[Y];
; 0000 00FA     Accel_In_g[Z] = Accel_Raw_Val[Z] - Accel_Offset_Val[Z];
; 0000 00FB 
; 0000 00FC     Accel_In_g[X] = Accel_In_g[X] / ACCEL_Sensitivity;
; 0000 00FD     Accel_In_g[Y] = Accel_In_g[Y] / ACCEL_Sensitivity;
; 0000 00FE     Accel_In_g[Z] = Accel_In_g[Z] / ACCEL_Sensitivity;
; 0000 00FF }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Gets n average raw accelerometer data, performs no processing
;void Get_AvrgAccel_Val()
; 0000 0103 {
; 0000 0104   #define    NumAve4A      50
; 0000 0105   float Ave=0;
; 0000 0106   unsigned char i= NumAve4A;
; 0000 0107   while(i--)
;	Ave -> Y+1
;	i -> R17
; 0000 0108   {
; 0000 0109     AvrgAccel_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
; 0000 010A                              read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)   );
; 0000 010B     Ave = (float) Ave + (AvrgAccel_Raw_Val[X] / NumAve4A);
; 0000 010C     delay_us(10);
; 0000 010D   }
; 0000 010E   AvrgAccel_Raw_Val[X] = Ave;
; 0000 010F   Ave = 0;
; 0000 0110   i = NumAve4A;
; 0000 0111   while(i--)
; 0000 0112   {
; 0000 0113     AvrgAccel_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
; 0000 0114                              read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)   );
; 0000 0115     Ave = (float) Ave + (AvrgAccel_Raw_Val[Y] / NumAve4A);
; 0000 0116     delay_us(10);
; 0000 0117   }
; 0000 0118   AvrgAccel_Raw_Val[Y] = Ave;
; 0000 0119   Ave = 0;
; 0000 011A   i = NumAve4A;
; 0000 011B   while(i--)
; 0000 011C   {
; 0000 011D     AvrgAccel_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
; 0000 011E                              read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)   );
; 0000 011F     Ave = (float) Ave + (AvrgAccel_Raw_Val[Z] / NumAve4A);
; 0000 0120     delay_us(10);
; 0000 0121   }
; 0000 0122   AvrgAccel_Raw_Val[Z] = Ave;
; 0000 0123 
; 0000 0124   Accel_In_g[X] = AvrgAccel_Raw_Val[X] - Accel_Offset_Val[X];
; 0000 0125   Accel_In_g[Y] = AvrgAccel_Raw_Val[Y] - Accel_Offset_Val[Y];
; 0000 0126   Accel_In_g[Z] = AvrgAccel_Raw_Val[Z] - Accel_Offset_Val[Z];
; 0000 0127 
; 0000 0128   Accel_In_g[X] = Accel_In_g[X] / ACCEL_Sensitivity;  //  g/LSB
; 0000 0129   Accel_In_g[Y] = Accel_In_g[Y] / ACCEL_Sensitivity;  //  g/LSB
; 0000 012A   Accel_In_g[Z] = Accel_In_g[Z] / ACCEL_Sensitivity;  //  g/LSB
; 0000 012B 
; 0000 012C }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Gets angles from accelerometer data
;void Get_Accel_Angles()
; 0000 0130 {
; 0000 0131 // If you want be averaged of accelerometer data, write (on),else write (off)
; 0000 0132 #define  GetAvrg  on
; 0000 0133 
; 0000 0134 #if GetAvrg == on
; 0000 0135     Get_AvrgAccel_Val();
; 0000 0136 //  Calculate The Angle Of Each Axis
; 0000 0137     Accel_Angle[X] = 57.295*atan((float) AvrgAccel_Raw_Val[X] / sqrt(pow((float)AvrgAccel_Raw_Val[Z],2)+pow((float)AvrgA ...
; 0000 0138     Accel_Angle[Y] = 57.295*atan((float) AvrgAccel_Raw_Val[Y] / sqrt(pow((float)AvrgAccel_Raw_Val[Z],2)+pow((float)AvrgA ...
; 0000 0139     Accel_Angle[Z] = 57.295*atan((float) sqrt(pow((float)AvrgAccel_Raw_Val[X],2)+pow((float)AvrgAccel_Raw_Val[Y],2))/ Av ...
; 0000 013A #else
; 0000 013B     Get_Accel_Val();
; 0000 013C //  Calculate The Angle Of Each Axis
; 0000 013D     Accel_Angle[X] = 57.295*atan((float) Accel_Raw_Val[X] / sqrt(pow((float)Accel_Raw_Val[Z],2)+pow((float)Accel_Raw_Val ...
; 0000 013E     Accel_Angle[Y] = 57.295*atan((float) Accel_Raw_Val[Y] / sqrt(pow((float)Accel_Raw_Val[Z],2)+pow((float)Accel_Raw_Val ...
; 0000 013F     Accel_Angle[Z] = 57.295*atan((float) sqrt(pow((float)Accel_Raw_Val[X],2)+pow((float)Accel_Raw_Val[Y],2))/ Accel_Raw_ ...
; 0000 0140 #endif
; 0000 0141 
; 0000 0142 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// get gyro offset X,Y,Z
;void Get_Gyro_Offset()
; 0000 0146 {
_Get_Gyro_Offset:
; .FSTART _Get_Gyro_Offset
; 0000 0147   #define    NumAve4GO      100
; 0000 0148 
; 0000 0149   float Ave = 0;
; 0000 014A   unsigned char i = NumAve4GO;
; 0000 014B   Gyro_Offset_Val[X] = Gyro_Offset_Val[Y] = Gyro_Offset_Val[Z] = 0;
	CALL SUBOPT_0x2
;	Ave -> Y+1
;	i -> R17
	__GETD1N 0x0
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 014C 
; 0000 014D   while(i--)
_0x1A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x1C
; 0000 014E   {
; 0000 014F     Gyro_Offset_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8)|
; 0000 0150                            read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0)   );
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(67)
	CALL SUBOPT_0x3
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(68)
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_Gyro_Offset_Val)
	LDI  R27,HIGH(_Gyro_Offset_Val)
	CALL SUBOPT_0x4
; 0000 0151     Ave = (float) Ave + (Gyro_Offset_Val[X] / NumAve4GO);
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
; 0000 0152     delay_us(1);
; 0000 0153   }
	RJMP _0x1A
_0x1C:
; 0000 0154   Gyro_Offset_Val[X] = Ave;
	CALL SUBOPT_0x6
	CALL SUBOPT_0xA
; 0000 0155   Ave = 0;
	CALL SUBOPT_0x7
; 0000 0156   i = NumAve4GO;
; 0000 0157   while(i--)
_0x1D:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x1F
; 0000 0158   {
; 0000 0159     Gyro_Offset_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8)|
; 0000 015A                            read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0)   );
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(69)
	CALL SUBOPT_0x3
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(70)
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Gyro_Offset_Val,4
	CALL SUBOPT_0x4
; 0000 015B     Ave = (float) Ave + (Gyro_Offset_Val[Y] / NumAve4GO);
	CALL SUBOPT_0xD
	CALL SUBOPT_0xC
; 0000 015C     delay_us(1);
; 0000 015D   }
	RJMP _0x1D
_0x1F:
; 0000 015E   Gyro_Offset_Val[Y] = Ave;
	CALL SUBOPT_0x6
	CALL SUBOPT_0x9
; 0000 015F   Ave = 0;
	CALL SUBOPT_0x7
; 0000 0160   i = NumAve4GO;
; 0000 0161   while(i--)
_0x20:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x22
; 0000 0162   {
; 0000 0163       Gyro_Offset_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8)|
; 0000 0164                              read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0)   );
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(71)
	CALL SUBOPT_0x3
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(72)
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Gyro_Offset_Val,8
	CALL SUBOPT_0x4
; 0000 0165     Ave = (float) Ave + (Gyro_Offset_Val[Z] / NumAve4GO);
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC
; 0000 0166     delay_us(1);
; 0000 0167   }
	RJMP _0x20
_0x22:
; 0000 0168   Gyro_Offset_Val[Z] = Ave;
	CALL SUBOPT_0x6
	CALL SUBOPT_0x8
; 0000 0169 
; 0000 016A }
_0x2120009:
	LDD  R17,Y+0
	ADIW R28,5
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Function to read the gyroscope rate data and convert it into degrees/s
;void Get_Gyro_Val()
; 0000 016E {
_Get_Gyro_Val:
; .FSTART _Get_Gyro_Val
; 0000 016F     Gyro_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8) |
; 0000 0170                         read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0))    ;
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(67)
	CALL SUBOPT_0x3
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(68)
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_Gyro_Raw_Val)
	LDI  R27,HIGH(_Gyro_Raw_Val)
	CALL SUBOPT_0x4
; 0000 0171     Gyro_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8) |
; 0000 0172                         read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0))    ;
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(69)
	CALL SUBOPT_0x3
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(70)
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Gyro_Raw_Val,4
	CALL SUBOPT_0x4
; 0000 0173     Gyro_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8) |
; 0000 0174                         read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0))    ;
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(71)
	CALL SUBOPT_0x3
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(72)
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Gyro_Raw_Val,8
	CALL SUBOPT_0x4
; 0000 0175 
; 0000 0176     GyroRate_Val[X] = Gyro_Raw_Val[X] - Gyro_Offset_Val[X];
	CALL SUBOPT_0xB
	CALL SUBOPT_0xF
	CALL __SUBF12
	CALL SUBOPT_0x10
; 0000 0177     GyroRate_Val[Y] = Gyro_Raw_Val[Y] - Gyro_Offset_Val[Y];
	CALL SUBOPT_0x11
	CALL SUBOPT_0xD
	CALL __SUBF12
	CALL SUBOPT_0x12
; 0000 0178     GyroRate_Val[Z] = Gyro_Raw_Val[Z] - Gyro_Offset_Val[Z];
	CALL SUBOPT_0x13
	CALL SUBOPT_0xE
	CALL __SUBF12
	CALL SUBOPT_0x14
; 0000 0179 
; 0000 017A     GyroRate_Val[X] = GyroRate_Val[X] / GYRO_Sensitivity;
	LDS  R26,_GyroRate_Val
	LDS  R27,_GyroRate_Val+1
	LDS  R24,_GyroRate_Val+2
	LDS  R25,_GyroRate_Val+3
	CALL SUBOPT_0x15
	CALL SUBOPT_0x10
; 0000 017B     GyroRate_Val[Y] = GyroRate_Val[Y] / GYRO_Sensitivity;
	__GETD2MN _GyroRate_Val,4
	CALL SUBOPT_0x15
	CALL SUBOPT_0x12
; 0000 017C     GyroRate_Val[Z] = GyroRate_Val[Z] / GYRO_Sensitivity;
	__GETD2MN _GyroRate_Val,8
	CALL SUBOPT_0x15
	CALL SUBOPT_0x14
; 0000 017D 
; 0000 017E }
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Function to read the Avrrage of gyroscope rate data and convert it into degrees/s
;void Get_AvrgGyro_Val()
; 0000 0182 {
; 0000 0183   #define    NumAve4G      50
; 0000 0184 
; 0000 0185   float Ave = 0;
; 0000 0186   unsigned char i = NumAve4G;
; 0000 0187   AvrgGyro_Raw_Val[X] = AvrgGyro_Raw_Val[Y] = AvrgGyro_Raw_Val[Z] = 0;
;	Ave -> Y+1
;	i -> R17
; 0000 0188 
; 0000 0189   while(i--)
; 0000 018A   {
; 0000 018B     AvrgGyro_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8)|
; 0000 018C                             read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0)   );
; 0000 018D     Ave = (float) Ave + (AvrgGyro_Raw_Val[X] / NumAve4G);
; 0000 018E     delay_us(1);
; 0000 018F   }
; 0000 0190   AvrgGyro_Raw_Val[X] = Ave;
; 0000 0191   Ave = 0;
; 0000 0192   i = NumAve4G;
; 0000 0193   while(i--)
; 0000 0194   {
; 0000 0195     AvrgGyro_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8)|
; 0000 0196                             read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0)   );
; 0000 0197     Ave = (float) Ave + (AvrgGyro_Raw_Val[Y] / NumAve4G);
; 0000 0198     delay_us(1);
; 0000 0199   }
; 0000 019A   AvrgGyro_Raw_Val[Y] = Ave;
; 0000 019B   Ave = 0;
; 0000 019C   i = NumAve4G;
; 0000 019D   while(i--)
; 0000 019E   {
; 0000 019F     AvrgGyro_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8)|
; 0000 01A0                             read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0)   );
; 0000 01A1     Ave = (float) Ave + (AvrgGyro_Raw_Val[Z] / NumAve4G);
; 0000 01A2     delay_us(1);
; 0000 01A3   }
; 0000 01A4   AvrgGyro_Raw_Val[Z] = Ave;
; 0000 01A5 
; 0000 01A6   GyroRate_Val[X] = AvrgGyro_Raw_Val[X] - Gyro_Offset_Val[X];
; 0000 01A7   GyroRate_Val[Y] = AvrgGyro_Raw_Val[Y] - Gyro_Offset_Val[Y];
; 0000 01A8   GyroRate_Val[Z] = AvrgGyro_Raw_Val[Z] - Gyro_Offset_Val[Z];
; 0000 01A9 
; 0000 01AA   GyroRate_Val[X] = GyroRate_Val[X] / GYRO_Sensitivity;   // (º/s)/LSB
; 0000 01AB   GyroRate_Val[Y] = GyroRate_Val[Y] / GYRO_Sensitivity;   // (º/s)/LSB
; 0000 01AC   GyroRate_Val[Z] = GyroRate_Val[Z] / GYRO_Sensitivity;   // (º/s)/LSB
; 0000 01AD 
; 0000 01AE }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Function to read the Temperature
;void Get_Temp_Val()
; 0000 01B2 {
; 0000 01B3     Temp_Val = ((read_i2c(MPU6050_ADDRESS, RA_TEMP_OUT_H, 0)<< 8)|
; 0000 01B4                   read_i2c(MPU6050_ADDRESS, RA_TEMP_OUT_L, 0)   );
; 0000 01B5 // Compute the temperature in degrees
; 0000 01B6     Temp_Val = (Temp_Val /TEMP_Sensitivity) + 36.53;
; 0000 01B7 }
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;// Declare your global variables here
;int cnt1,a1,a2,a3,a4,a5,a6;
;void WaitInPrint()
; 0000 01D0     {
; 0000 01D1     getchar();
; 0000 01D2     }
;
;void main(void)
; 0000 01D5 {
_main:
; .FSTART _main
; 0000 01D6 // Declare your local variables here
; 0000 01D7 // Variable used to store graphic display
; 0000 01D8 // controller initialization data
; 0000 01D9 GLCDINIT_t glcd_init_data;
; 0000 01DA 
; 0000 01DB // Input/Output Ports initialization
; 0000 01DC // Port A initialization
; 0000 01DD // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 01DE DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,8
;	glcd_init_data -> Y+0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 01DF // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01E0 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 01E1 
; 0000 01E2 // Port B initialization
; 0000 01E3 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 01E4 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 01E5 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 01E6 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 01E7 
; 0000 01E8 // Port C initialization
; 0000 01E9 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 01EA DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 01EB // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01EC PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 01ED 
; 0000 01EE // Port D initialization
; 0000 01EF // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 01F0 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 01F1 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 01F2 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 01F3 
; 0000 01F4 // Timer/Counter 0 initialization
; 0000 01F5 // Clock source: System Clock
; 0000 01F6 // Clock value: Timer 0 Stopped
; 0000 01F7 // Mode: Normal top=0xFF
; 0000 01F8 // OC0 output: Disconnected
; 0000 01F9 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 01FA TCNT0=0x00;
	OUT  0x32,R30
; 0000 01FB OCR0=0x00;
	OUT  0x3C,R30
; 0000 01FC 
; 0000 01FD // Timer/Counter 1 initialization
; 0000 01FE // Clock source: System Clock
; 0000 01FF // Clock value: Timer1 Stopped
; 0000 0200 // Mode: Normal top=0xFFFF
; 0000 0201 // OC1A output: Disconnected
; 0000 0202 // OC1B output: Disconnected
; 0000 0203 // Noise Canceler: Off
; 0000 0204 // Input Capture on Falling Edge
; 0000 0205 // Timer1 Overflow Interrupt: Off
; 0000 0206 // Input Capture Interrupt: Off
; 0000 0207 // Compare A Match Interrupt: Off
; 0000 0208 // Compare B Match Interrupt: Off
; 0000 0209 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 020A TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 020B TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 020C TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 020D ICR1H=0x00;
	OUT  0x27,R30
; 0000 020E ICR1L=0x00;
	OUT  0x26,R30
; 0000 020F OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0210 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0211 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0212 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0213 
; 0000 0214 // Timer/Counter 2 initialization
; 0000 0215 // Clock source: System Clock
; 0000 0216 // Clock value: Timer2 Stopped
; 0000 0217 // Mode: Normal top=0xFF
; 0000 0218 // OC2 output: Disconnected
; 0000 0219 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 021A TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 021B TCNT2=0x00;
	OUT  0x24,R30
; 0000 021C OCR2=0x00;
	OUT  0x23,R30
; 0000 021D 
; 0000 021E // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 021F TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0220 
; 0000 0221 // External Interrupt(s) initialization
; 0000 0222 // INT0: Off
; 0000 0223 // INT1: Off
; 0000 0224 // INT2: Off
; 0000 0225 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0226 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 0227 
; 0000 0228 // USART initialization
; 0000 0229 // USART disabled
; 0000 022A UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 022B 
; 0000 022C // Analog Comparator initialization
; 0000 022D // Analog Comparator: Off
; 0000 022E // The Analog Comparator's positive input is
; 0000 022F // connected to the AIN0 pin
; 0000 0230 // The Analog Comparator's negative input is
; 0000 0231 // connected to the AIN1 pin
; 0000 0232 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0233 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0234 
; 0000 0235 // ADC initialization
; 0000 0236 // ADC disabled
; 0000 0237 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0238 
; 0000 0239 // SPI initialization
; 0000 023A // SPI disabled
; 0000 023B SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 023C 
; 0000 023D // TWI initialization
; 0000 023E // TWI disabled
; 0000 023F TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0240 
; 0000 0241 // Bit-Banged I2C Bus initialization
; 0000 0242 // I2C Port: PORTB
; 0000 0243 // I2C SDA bit: 2
; 0000 0244 // I2C SCL bit: 1
; 0000 0245 // Bit Rate: 100 kHz
; 0000 0246 // Note: I2C settings are specified in the
; 0000 0247 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 0248 i2c_init();
	CALL _i2c_init
; 0000 0249 
; 0000 024A // Graphic Display Controller initialization
; 0000 024B // The PCD8544 connections are specified in the
; 0000 024C // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 024D // SDIN - PORTC Bit 0
; 0000 024E // SCLK - PORTC Bit 1
; 0000 024F // D /C - PORTC Bit 2
; 0000 0250 // /SCE - PORTC Bit 3
; 0000 0251 // /RES - PORTC Bit 4
; 0000 0252 
; 0000 0253 // Specify the current font for displaying text
; 0000 0254 glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0255 // No function is used for reading
; 0000 0256 // image data from external memory
; 0000 0257 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 0258 // No function is used for writing
; 0000 0259 // image data to external memory
; 0000 025A glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 025B // Set the LCD temperature coefficient
; 0000 025C glcd_init_data.temp_coef=PCD8544_DEFAULT_TEMP_COEF;
	LDD  R30,Y+6
	ANDI R30,LOW(0xFC)
	STD  Y+6,R30
; 0000 025D // Set the LCD bias
; 0000 025E glcd_init_data.bias=PCD8544_DEFAULT_BIAS;
	ANDI R30,LOW(0xE3)
	ORI  R30,LOW(0xC)
	STD  Y+6,R30
; 0000 025F // Set the LCD contrast control voltage VLCD
; 0000 0260 glcd_init_data.vlcd=PCD8544_DEFAULT_VLCD;
	LDD  R30,Y+7
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x32)
	STD  Y+7,R30
; 0000 0261 
; 0000 0262 glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 0263 
; 0000 0264 
; 0000 0265 //printf("\n\rwww.RoboticNGO.com\n\rwww.ECA.ir\n\r\n\r");
; 0000 0266 //WaitInPrint();
; 0000 0267 
; 0000 0268 
; 0000 0269 MPU6050_Init();
	RCALL _MPU6050_Init
; 0000 026A Get_Accel_Offset();
	RCALL _Get_Accel_Offset
; 0000 026B Get_Gyro_Offset();
	RCALL _Get_Gyro_Offset
; 0000 026C 
; 0000 026D 
; 0000 026E //printf("Accel Offset Val: %.2f , %.2f , %.2f \n\r",Accel_Offset_Val[X],Accel_Offset_Val[Y],Accel_Offset_Val[Z]);
; 0000 026F //printf("Gyro  Offset Val: %.2f , %.2f , %.2f \n\r",Gyro_Offset_Val[X],Gyro_Offset_Val[Y],Gyro_Offset_Val[Z]);
; 0000 0270 //WaitInPrint();
; 0000 0271 
; 0000 0272 
; 0000 0273 while (1)
_0x2C:
; 0000 0274     {
; 0000 0275     // Place your code here
; 0000 0276     //WaitInPrint();
; 0000 0277     //puts("\n");
; 0000 0278 
; 0000 0279     //Get_Temp_Val();
; 0000 027A 
; 0000 027B     Get_Gyro_Val();
	RCALL _Get_Gyro_Val
; 0000 027C     //Get_AvrgGyro_Val();
; 0000 027D 
; 0000 027E     //Get_Accel_Val();
; 0000 027F     //Get_AvrgAccel_Val();
; 0000 0280     //Get_Accel_Angles();
; 0000 0281 
; 0000 0282     a1=Gyro_Raw_Val[X];
	CALL SUBOPT_0xF
	CALL SUBOPT_0x16
; 0000 0283     if(a1>=0)
	BRLT _0x2F
; 0000 0284         {
; 0000 0285         glcd_putcharxy(13,0,((a1/100)%10+'0'));
	LDI  R30,LOW(13)
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
; 0000 0286         glcd_putcharxy(20,0,((a1/10)%10+'0'));
	CALL SUBOPT_0x17
	CALL SUBOPT_0x19
; 0000 0287         glcd_putcharxy(27,0,((a1/1)%10+'0'));
	CALL SUBOPT_0x17
	RJMP _0x3A
; 0000 0288         }
; 0000 0289     else if(a1 < 0)
_0x2F:
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRGE _0x31
; 0000 028A         {
; 0000 028B         glcd_putcharxy(7,0,'-');
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
; 0000 028C         glcd_putcharxy(13,0,((-a1/100)%10+'0'));
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x18
; 0000 028D         glcd_putcharxy(20,0,((-a1/10)%10+'0'));
	ST   -Y,R30
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x19
; 0000 028E         glcd_putcharxy(27,0,((-a1/1)%10+'0'));
	ST   -Y,R30
	CALL SUBOPT_0x1B
_0x3A:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x1C
; 0000 028F         }
; 0000 0290 
; 0000 0291 
; 0000 0292 
; 0000 0293     a1=Gyro_Raw_Val[Y];
_0x31:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x16
; 0000 0294     if(a1>=0)
	BRLT _0x32
; 0000 0295         {
; 0000 0296         glcd_putcharxy(13,10,((a1/100)%10+'0'));
	LDI  R30,LOW(13)
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x18
; 0000 0297         glcd_putcharxy(20,10,((a1/10)%10+'0'));
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x19
; 0000 0298         glcd_putcharxy(27,10,((a1/1)%10+'0'));
	CALL SUBOPT_0x1D
	RJMP _0x3B
; 0000 0299         }
; 0000 029A     else if(a1 < 0)
_0x32:
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRGE _0x34
; 0000 029B         {
; 0000 029C         glcd_putcharxy(7,10,'-');
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(10)
	CALL SUBOPT_0x1A
; 0000 029D         glcd_putcharxy(13,10,((-a1/100)%10+'0'));
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x18
; 0000 029E         glcd_putcharxy(20,10,((-a1/10)%10+'0'));
	ST   -Y,R30
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x19
; 0000 029F         glcd_putcharxy(27,10,((-a1/1)%10+'0'));
	ST   -Y,R30
	CALL SUBOPT_0x1E
_0x3B:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x1C
; 0000 02A0         }
; 0000 02A1 
; 0000 02A2 
; 0000 02A3 
; 0000 02A4     a1=Gyro_Raw_Val[Z];
_0x34:
	CALL SUBOPT_0x13
	CALL SUBOPT_0x16
; 0000 02A5     if(a1>=0)
	BRLT _0x35
; 0000 02A6         {
; 0000 02A7         glcd_putcharxy(13,20,((a1/100)%10+'0'));
	LDI  R30,LOW(13)
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x18
; 0000 02A8         glcd_putcharxy(20,20,((a1/10)%10+'0'));
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x19
; 0000 02A9         glcd_putcharxy(27,20,((a1/1)%10+'0'));
	CALL SUBOPT_0x1F
	RJMP _0x3C
; 0000 02AA         }
; 0000 02AB     else if(a1 < 0)
_0x35:
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRGE _0x37
; 0000 02AC         {
; 0000 02AD         glcd_putcharxy(7,20,'-');
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(20)
	CALL SUBOPT_0x1A
; 0000 02AE         glcd_putcharxy(13,20,((-a1/100)%10+'0'));
	CALL SUBOPT_0x20
	CALL SUBOPT_0x18
; 0000 02AF         glcd_putcharxy(20,20,((-a1/10)%10+'0'));
	ST   -Y,R30
	CALL SUBOPT_0x20
	CALL SUBOPT_0x19
; 0000 02B0         glcd_putcharxy(27,20,((-a1/1)%10+'0'));
	ST   -Y,R30
	CALL SUBOPT_0x20
_0x3C:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x1C
; 0000 02B1         }
; 0000 02B2 //    printf("Temp Val is: %.1f degree Celsius \n\r",Temp_Val);
; 0000 02B3 //
; 0000 02B4 //    printf("\n");
; 0000 02B5 //
; 0000 02B6 //    printf("    Gyro Raw  Val: %.0f , %.0f , %.0f \n\r",Gyro_Raw_Val[X],Gyro_Raw_Val[Y],Gyro_Raw_Val[Z]);
; 0000 02B7 //    printf("AvrgGyro Raw  Val: %.0f , %.0f , %.0f \n\r",AvrgGyro_Raw_Val[X],AvrgGyro_Raw_Val[Y],AvrgGyro_Raw_Val[Z]);
; 0000 02B8 //    printf("    Gyro Rate Val: %.1f , %.1f , %.1f \n\r",GyroRate_Val[X],GyroRate_Val[Y],GyroRate_Val[Z]);
; 0000 02B9 //
; 0000 02BA //    printf("\n");
; 0000 02BB //
; 0000 02BC //    printf("    Accel Raw Val: %.1f , %.1f , %.1f \n\r",Accel_Raw_Val[X],Accel_Raw_Val[Y],Accel_Raw_Val[Z]);
; 0000 02BD //    printf("AvrgAccel Raw Val: %.1f , %.1f , %.1f \n\r",AvrgAccel_Raw_Val[X],AvrgAccel_Raw_Val[Y],AvrgAccel_Raw_Val[Z] ...
; 0000 02BE //    printf("  Accel In 1G Val: %.1f , %.1f , %.1f \n\r",Accel_In_g[X],Accel_In_g[Y],Accel_In_g[Z]);
; 0000 02BF //    printf("Accel  Angle  Val: %.1f , %.1f , %.1f \n\r",Accel_Angle[X],Accel_Angle[Y],Accel_Angle[Z]);
; 0000 02C0     }
_0x37:
	RJMP _0x2C
; 0000 02C1 }
_0x38:
	RJMP _0x38
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_pcd8544_delay_G100:
; .FSTART _pcd8544_delay_G100
	RET
; .FEND
_pcd8544_wrbus_G100:
; .FSTART _pcd8544_wrbus_G100
	ST   -Y,R26
	ST   -Y,R17
	CBI  0x15,3
	LDI  R17,LOW(8)
_0x2000004:
	RCALL _pcd8544_delay_G100
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BREQ _0x2000006
	SBI  0x15,0
	RJMP _0x2000007
_0x2000006:
	CBI  0x15,0
_0x2000007:
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
	RCALL _pcd8544_delay_G100
	SBI  0x15,1
	RCALL _pcd8544_delay_G100
	CBI  0x15,1
	SUBI R17,LOW(1)
	BRNE _0x2000004
	SBI  0x15,3
	LDD  R17,Y+0
	JMP  _0x2120003
; .FEND
_pcd8544_wrcmd:
; .FSTART _pcd8544_wrcmd
	ST   -Y,R26
	CBI  0x15,2
	LD   R26,Y
	RCALL _pcd8544_wrbus_G100
	RJMP _0x2120008
; .FEND
_pcd8544_wrdata_G100:
; .FSTART _pcd8544_wrdata_G100
	ST   -Y,R26
	SBI  0x15,2
	LD   R26,Y
	RCALL _pcd8544_wrbus_G100
	RJMP _0x2120008
; .FEND
_pcd8544_setaddr_G100:
; .FSTART _pcd8544_setaddr_G100
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R17,R30
	LDI  R30,LOW(84)
	MUL  R30,R17
	MOVW R30,R0
	MOVW R26,R30
	LDD  R30,Y+2
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STS  _gfx_addr_G100,R30
	STS  _gfx_addr_G100+1,R31
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x2120002
; .FEND
_pcd8544_gotoxy:
; .FSTART _pcd8544_gotoxy
	ST   -Y,R26
	LDD  R30,Y+1
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_setaddr_G100
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	JMP  _0x2120003
; .FEND
_pcd8544_rdbyte:
; .FSTART _pcd8544_rdbyte
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_gotoxy
	LDS  R30,_gfx_addr_G100
	LDS  R31,_gfx_addr_G100+1
	SUBI R30,LOW(-_gfx_buffer_G100)
	SBCI R31,HIGH(-_gfx_buffer_G100)
	LD   R30,Z
	JMP  _0x2120003
; .FEND
_pcd8544_wrbyte:
; .FSTART _pcd8544_wrbyte
	ST   -Y,R26
	CALL SUBOPT_0x21
	LD   R26,Y
	STD  Z+0,R26
	RCALL _pcd8544_wrdata_G100
	RJMP _0x2120008
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	SBI  0x14,3
	SBI  0x15,3
	SBI  0x14,1
	CBI  0x15,1
	SBI  0x14,0
	SBI  0x14,2
	SBI  0x14,4
	CBI  0x15,4
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x15,4
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BREQ _0x2000008
	LDD  R30,Z+6
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+6
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x7)
	MOV  R16,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+7
	ANDI R30,0x7F
	MOV  R19,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20000A0
_0x2000008:
	LDI  R17,LOW(0)
	LDI  R16,LOW(3)
	LDI  R19,LOW(50)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20000A0:
	__PUTW1MN _glcd_state,27
	LDI  R26,LOW(33)
	RCALL _pcd8544_wrcmd
	MOV  R30,R17
	ORI  R30,4
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	MOV  R30,R16
	ORI  R30,0x10
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	MOV  R30,R19
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	LDI  R26,LOW(32)
	RCALL _pcd8544_wrcmd
	LDI  R26,LOW(1)
	RCALL _glcd_display
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	CALL __LOADLOCR4
	RJMP _0x2120007
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	LD   R30,Y
	CPI  R30,0
	BREQ _0x200000A
	LDI  R30,LOW(12)
	RJMP _0x200000B
_0x200000A:
	LDI  R30,LOW(8)
_0x200000B:
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
_0x2120008:
	ADIW R28,1
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x200000D
	LDI  R19,LOW(255)
_0x200000D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _pcd8544_gotoxy
	__GETWRN 16,17,504
_0x200000E:
	MOVW R30,R16
	__SUBWRN 16,17,1
	SBIW R30,0
	BREQ _0x2000010
	MOV  R26,R19
	RCALL _pcd8544_wrbyte
	RJMP _0x200000E
_0x2000010:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
	JMP  _0x2120001
; .FEND
_pcd8544_wrmasked_G100:
; .FSTART _pcd8544_wrmasked_G100
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2000020
	CPI  R30,LOW(0x8)
	BRNE _0x2000021
_0x2000020:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x2000022
_0x2000021:
	CPI  R30,LOW(0x3)
	BRNE _0x2000024
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2000025
_0x2000024:
	CPI  R30,0
	BRNE _0x2000026
_0x2000025:
_0x2000022:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2000027
_0x2000026:
	CPI  R30,LOW(0x2)
	BRNE _0x2000028
_0x2000027:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x200001E
_0x2000028:
	CPI  R30,LOW(0x1)
	BRNE _0x2000029
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x200001E
_0x2000029:
	CPI  R30,LOW(0x4)
	BRNE _0x200001E
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x200001E:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
	LDD  R17,Y+0
_0x2120007:
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x54)
	BRSH _0x200002C
	LDD  R26,Y+15
	CPI  R26,LOW(0x30)
	BRSH _0x200002C
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x200002C
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x200002B
_0x200002C:
	RJMP _0x2120006
_0x200002B:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x55)
	LDI  R30,HIGH(0x55)
	CPC  R27,R30
	BRLO _0x200002E
	LDD  R26,Y+16
	LDI  R30,LOW(84)
	SUB  R30,R26
	STD  Y+14,R30
_0x200002E:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,49
	BRLO _0x200002F
	LDD  R26,Y+15
	LDI  R30,LOW(48)
	SUB  R30,R26
	STD  Y+13,R30
_0x200002F:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x2000030
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x2000034
	RJMP _0x2120006
_0x2000034:
	CPI  R30,LOW(0x3)
	BRNE _0x2000037
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000036
	RJMP _0x2120006
_0x2000036:
_0x2000037:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2000039
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2000038
_0x2000039:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x22
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x200003B:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x200003D
	MOV  R17,R16
_0x200003E:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000040
	CALL SUBOPT_0x23
	RJMP _0x200003E
_0x2000040:
	RJMP _0x200003B
_0x200003D:
_0x2000038:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x2000041
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0x22
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x2000042
	SUBI R19,-LOW(1)
_0x2000042:
	LDI  R18,LOW(0)
_0x2000043:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2000045
	LDD  R17,Y+14
_0x2000046:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2000048
	CALL SUBOPT_0x23
	RJMP _0x2000046
_0x2000048:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x22
	RJMP _0x2000043
_0x2000045:
_0x2000041:
_0x2000030:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2000049:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x200004B
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x200004C
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x200004D
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x2000052
	CPI  R30,LOW(0x3)
	BRNE _0x2000053
_0x2000052:
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x7)
	BRNE _0x2000055
_0x2000054:
	RJMP _0x2000056
_0x2000055:
	CPI  R30,LOW(0x8)
	BRNE _0x2000057
_0x2000056:
	RJMP _0x2000058
_0x2000057:
	CPI  R30,LOW(0x9)
	BRNE _0x2000059
_0x2000058:
	RJMP _0x200005A
_0x2000059:
	CPI  R30,LOW(0xA)
	BRNE _0x200005B
_0x200005A:
	ST   -Y,R16
	LDD  R26,Y+16
	RCALL _pcd8544_gotoxy
	RJMP _0x2000050
_0x200005B:
	CPI  R30,LOW(0x6)
	BRNE _0x2000050
	CALL SUBOPT_0x24
_0x2000050:
_0x200005D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200005F
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x2000060
	CALL SUBOPT_0x25
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x21
	LD   R26,Z
	CALL _glcd_writemem
	RJMP _0x2000061
_0x2000060:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2000065
	LDI  R21,LOW(0)
	RJMP _0x2000066
_0x2000065:
	CPI  R30,LOW(0xA)
	BRNE _0x2000064
	LDI  R21,LOW(255)
	RJMP _0x2000066
_0x2000064:
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x200006D
	CPI  R30,LOW(0x8)
	BRNE _0x200006E
_0x200006D:
_0x2000066:
	CALL SUBOPT_0x27
	MOV  R21,R30
	RJMP _0x200006F
_0x200006E:
	CPI  R30,LOW(0x3)
	BRNE _0x2000071
	COM  R21
	RJMP _0x2000072
_0x2000071:
	CPI  R30,0
	BRNE _0x2000074
_0x2000072:
_0x200006F:
	MOV  R26,R21
	RCALL _pcd8544_wrdata_G100
	RJMP _0x200006B
_0x2000074:
	CALL SUBOPT_0x28
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G100
_0x200006B:
_0x2000061:
	RJMP _0x200005D
_0x200005F:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2000075
_0x200004D:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000076
_0x200004C:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2000077
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000078
_0x2000077:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2000078:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x200007C
	CALL SUBOPT_0x24
_0x200007D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200007F
	CALL SUBOPT_0x21
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x29
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x25
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x200007D
_0x200007F:
	RJMP _0x200007B
_0x200007C:
	CPI  R30,LOW(0x9)
	BRNE _0x2000080
	LDI  R21,LOW(0)
	RJMP _0x2000081
_0x2000080:
	CPI  R30,LOW(0xA)
	BRNE _0x2000087
	LDI  R21,LOW(255)
_0x2000081:
	CALL SUBOPT_0x27
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2000084:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000086
	CALL SUBOPT_0x28
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x2000084
_0x2000086:
	RJMP _0x200007B
_0x2000087:
_0x2000088:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200008A
	CALL SUBOPT_0x2A
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x2000088
_0x200008A:
_0x200007B:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x200008B
	RJMP _0x200004B
_0x200008B:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x200008C
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20000A1
_0x200008C:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20000A1:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2000076:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2000091
	CALL SUBOPT_0x24
_0x2000092:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000094
	CALL SUBOPT_0x21
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x29
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x25
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2000092
_0x2000094:
	RJMP _0x2000090
_0x2000091:
	CPI  R30,LOW(0x9)
	BRNE _0x2000095
	LDI  R21,LOW(0)
	RJMP _0x2000096
_0x2000095:
	CPI  R30,LOW(0xA)
	BRNE _0x200009C
	LDI  R21,LOW(255)
_0x2000096:
	CALL SUBOPT_0x27
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x2000099:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200009B
	CALL SUBOPT_0x28
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x2000099
_0x200009B:
	RJMP _0x2000090
_0x200009C:
_0x200009D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200009F
	CALL SUBOPT_0x2A
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x200009D
_0x200009F:
_0x2000090:
_0x2000075:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000049
_0x200004B:
_0x2120006:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x2B
	BRLT _0x2020003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2120003
_0x2020003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x54)
	LDI  R30,HIGH(0x54)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	JMP  _0x2120003
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2120003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x2B
	BRLT _0x2020005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2120003
_0x2020005:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,48
	BRLT _0x2020006
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	JMP  _0x2120003
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2120003
; .FEND
_glcd_getcharw_G101:
; .FSTART _glcd_getcharw_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x2C
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120005
_0x202000B:
	CALL SUBOPT_0x2D
	STD  Y+7,R0
	CALL SUBOPT_0x2D
	STD  Y+6,R0
	CALL SUBOPT_0x2D
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120005
_0x202000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x202000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120005
_0x202000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x202000E
	SUBI R20,-LOW(1)
_0x202000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x202000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2120005
_0x202000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2020010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2020012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2020010
_0x2020012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2120005:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G101:
; .FSTART _glcd_new_line_G101
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x2E
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x2C
	SBIW R30,0
	BRNE PC+2
	RJMP _0x202001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2020020
	RJMP _0x2020021
_0x2020020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G101
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2020022
	RJMP _0x2120004
_0x2020022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	__CPWRN 16,17,85
	BRLO _0x2020023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G101
_0x2020023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x2E
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x2E
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x2F
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020024
_0x2020021:
	RCALL _glcd_new_line_G101
	RJMP _0x2120004
_0x2020024:
_0x202001F:
	__PUTBMRN _glcd_state,2,16
_0x2120004:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
_glcd_putcharxy:
; .FSTART _glcd_putcharxy
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _glcd_moveto
	LD   R26,Y
	RCALL _glcd_putchar
	JMP  _0x2120002
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	JMP  _0x2120003
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	ADIW R28,5
	RET
; .FEND

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
_0x2120003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x20E0007
	CPI  R30,LOW(0xA)
	BRNE _0x20E0008
_0x20E0007:
	LDS  R17,_glcd_state
	RJMP _0x20E0009
_0x20E0008:
	CPI  R30,LOW(0x9)
	BRNE _0x20E000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x20E0009
_0x20E000B:
	CPI  R30,LOW(0x8)
	BRNE _0x20E0005
	__GETBRMN 17,_glcd_state,16
_0x20E0009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x20E000E
	CPI  R17,0
	BREQ _0x20E000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20E000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20E000E:
	CPI  R17,0
	BRNE _0x20E0011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20E0011:
_0x20E0005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2120002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x20E0015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2120002
_0x20E0015:
	CPI  R30,LOW(0x2)
	BRNE _0x20E0016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2120002
_0x20E0016:
	CPI  R30,LOW(0x3)
	BRNE _0x20E0018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2120002
_0x20E0018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2120002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x20E001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x20E001B
_0x20E001C:
	CPI  R30,LOW(0x2)
	BRNE _0x20E001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x20E001B
_0x20E001D:
	CPI  R30,LOW(0x3)
	BRNE _0x20E001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x20E001B:
_0x2120001:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
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
_gfx_addr_G100:
	.BYTE 0x2
_gfx_buffer_G100:
	.BYTE 0x1F8
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 41 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0x0:
	CALL _write_i2c
	LDI  R30,LOW(208)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 37 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	ST   -Y,R17
	LDI  R17,100
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _read_i2c

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x4:
	CALL __CWD1
	CALL __CDF1
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x5:
	__GETD1N 0x42C80000
	CALL __DIVF21
	__GETD2S 1
	CALL __ADDF12
	__PUTD1S 1
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	__CLRD1S 1
	LDI  R17,LOW(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	__PUTD1MN _Gyro_Offset_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	__PUTD1MN _Gyro_Offset_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	STS  _Gyro_Offset_Val,R30
	STS  _Gyro_Offset_Val+1,R31
	STS  _Gyro_Offset_Val+2,R22
	STS  _Gyro_Offset_Val+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDS  R26,_Gyro_Offset_Val
	LDS  R27,_Gyro_Offset_Val+1
	LDS  R24,_Gyro_Offset_Val+2
	LDS  R25,_Gyro_Offset_Val+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0xC:
	__GETD1N 0x42C80000
	CALL __DIVF21
	__GETD2S 1
	CALL __ADDF12
	__PUTD1S 1
	__DELAY_USB 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	__GETD2MN _Gyro_Offset_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	__GETD2MN _Gyro_Offset_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDS  R30,_Gyro_Raw_Val
	LDS  R31,_Gyro_Raw_Val+1
	LDS  R22,_Gyro_Raw_Val+2
	LDS  R23,_Gyro_Raw_Val+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	STS  _GyroRate_Val,R30
	STS  _GyroRate_Val+1,R31
	STS  _GyroRate_Val+2,R22
	STS  _GyroRate_Val+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	__GETD1MN _Gyro_Raw_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	__PUTD1MN _GyroRate_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	__GETD1MN _Gyro_Raw_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	__PUTD1MN _GyroRate_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	__GETD1N 0x41833333
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	CALL __CFD1
	MOVW R6,R30
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R26,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _glcd_putcharxy
	LDI  R30,LOW(20)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _glcd_putcharxy
	LDI  R30,LOW(27)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	ST   -Y,R30
	LDI  R26,LOW(45)
	CALL _glcd_putcharxy
	LDI  R30,LOW(13)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R30,R6
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _glcd_putcharxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	MOVW R26,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(10)
	ST   -Y,R30
	MOVW R30,R6
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	MOVW R26,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(20)
	ST   -Y,R30
	MOVW R30,R6
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(_gfx_addr_G100)
	LDI  R27,HIGH(_gfx_addr_G100)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G100)
	SBCI R31,HIGH(-_gfx_buffer_G100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x23:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	ST   -Y,R16
	LDD  R26,Y+16
	JMP  _pcd8544_setaddr_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x25:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	CALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2E:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block


	.CSEG
	.equ __sda_bit=2
	.equ __scl_bit=1
	.equ __i2c_port=0x18 ;PORTB
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

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
