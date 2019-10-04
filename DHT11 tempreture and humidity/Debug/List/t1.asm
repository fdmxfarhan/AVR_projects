
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16A
;Program type           : Application
;Clock frequency        : 8/000000 MHz
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
	.DEF _t=R4
	.DEF _t_msb=R5
	.DEF _h=R6
	.DEF _h_msb=R7

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
;Date    : 17/08/2019
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16A
;Program type            : Application
;AVR Core Clock frequency: 8/000000 MHz
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
;#include <DHT.h>
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
;// Declare your global variables here
;
;float hum;
;float temp;
;char buffer[17];
;int t , h;
;void seg1(int num)
; 0000 0022     {

	.CSEG
_seg1:
; .FSTART _seg1
; 0000 0023     if(num == 0)    PORTC = 0b00111111;
	ST   -Y,R27
	ST   -Y,R26
;	num -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x3
	LDI  R30,LOW(63)
	RJMP _0x2D
; 0000 0024     else if(num == 1)    PORTC = 0b00000011;
_0x3:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x5
	LDI  R30,LOW(3)
	RJMP _0x2D
; 0000 0025     else if(num == 2)    PORTC = 0b01101101;
_0x5:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,2
	BRNE _0x7
	LDI  R30,LOW(109)
	RJMP _0x2D
; 0000 0026     else if(num == 3)    PORTC = 0b01100111;
_0x7:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,3
	BRNE _0x9
	LDI  R30,LOW(103)
	RJMP _0x2D
; 0000 0027     else if(num == 4)    PORTC = 0b01010011;
_0x9:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRNE _0xB
	LDI  R30,LOW(83)
	RJMP _0x2D
; 0000 0028     else if(num == 5)    PORTC = 0b01110110;
_0xB:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,5
	BRNE _0xD
	LDI  R30,LOW(118)
	RJMP _0x2D
; 0000 0029     else if(num == 6)    PORTC = 0b01111110;
_0xD:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,6
	BRNE _0xF
	LDI  R30,LOW(126)
	RJMP _0x2D
; 0000 002A     else if(num == 7)    PORTC = 0b00100011;
_0xF:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,7
	BRNE _0x11
	LDI  R30,LOW(35)
	RJMP _0x2D
; 0000 002B     else if(num == 8)    PORTC = 0b01111111;
_0x11:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,8
	BRNE _0x13
	LDI  R30,LOW(127)
	RJMP _0x2D
; 0000 002C     else if(num == 9)    PORTC = 0b01110111;
_0x13:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,9
	BRNE _0x15
	LDI  R30,LOW(119)
_0x2D:
	OUT  0x15,R30
; 0000 002D     }
_0x15:
	RJMP _0x2000002
; .FEND
;
;void seg2(int num)
; 0000 0030     {
_seg2:
; .FSTART _seg2
; 0000 0031     if(num == 0)    PORTD = 0b00111111;
	ST   -Y,R27
	ST   -Y,R26
;	num -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x16
	LDI  R30,LOW(63)
	RJMP _0x2E
; 0000 0032     else if(num == 1)    PORTD = 0b00000011;
_0x16:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x18
	LDI  R30,LOW(3)
	RJMP _0x2E
; 0000 0033     else if(num == 2)    PORTD = 0b01101101;
_0x18:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,2
	BRNE _0x1A
	LDI  R30,LOW(109)
	RJMP _0x2E
; 0000 0034     else if(num == 3)    PORTD = 0b01100111;
_0x1A:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,3
	BRNE _0x1C
	LDI  R30,LOW(103)
	RJMP _0x2E
; 0000 0035     else if(num == 4)    PORTD = 0b01010011;
_0x1C:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRNE _0x1E
	LDI  R30,LOW(83)
	RJMP _0x2E
; 0000 0036     else if(num == 5)    PORTD = 0b01110110;
_0x1E:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,5
	BRNE _0x20
	LDI  R30,LOW(118)
	RJMP _0x2E
; 0000 0037     else if(num == 6)    PORTD = 0b01111110;
_0x20:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,6
	BRNE _0x22
	LDI  R30,LOW(126)
	RJMP _0x2E
; 0000 0038     else if(num == 7)    PORTD = 0b00100011;
_0x22:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,7
	BRNE _0x24
	LDI  R30,LOW(35)
	RJMP _0x2E
; 0000 0039     else if(num == 8)    PORTD = 0b01111111;
_0x24:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,8
	BRNE _0x26
	LDI  R30,LOW(127)
	RJMP _0x2E
; 0000 003A     else if(num == 9)    PORTD = 0b01110111;
_0x26:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,9
	BRNE _0x28
	LDI  R30,LOW(119)
_0x2E:
	OUT  0x12,R30
; 0000 003B     }
_0x28:
_0x2000002:
	ADIW R28,2
	RET
; .FEND
;
;void main(void)
; 0000 003E {
_main:
; .FSTART _main
; 0000 003F // Declare your local variables here
; 0000 0040 
; 0000 0041 // Input/Output Ports initialization
; 0000 0042 // Port A initialization
; 0000 0043 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0044 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0045 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0046 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0047 
; 0000 0048 // Port B initialization
; 0000 0049 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 004A DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 004B // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 004C PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 004D 
; 0000 004E // Port C initialization
; 0000 004F // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0050 DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0051 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0052 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0053 
; 0000 0054 // Port D initialization
; 0000 0055 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0056 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0057 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0058 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0059 
; 0000 005A // Timer/Counter 0 initialization
; 0000 005B // Clock source: System Clock
; 0000 005C // Clock value: Timer 0 Stopped
; 0000 005D // Mode: Normal top=0xFF
; 0000 005E // OC0 output: Disconnected
; 0000 005F TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0060 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0061 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0062 
; 0000 0063 // Timer/Counter 1 initialization
; 0000 0064 // Clock source: System Clock
; 0000 0065 // Clock value: Timer1 Stopped
; 0000 0066 // Mode: Normal top=0xFFFF
; 0000 0067 // OC1A output: Disconnected
; 0000 0068 // OC1B output: Disconnected
; 0000 0069 // Noise Canceler: Off
; 0000 006A // Input Capture on Falling Edge
; 0000 006B // Timer1 Overflow Interrupt: Off
; 0000 006C // Input Capture Interrupt: Off
; 0000 006D // Compare A Match Interrupt: Off
; 0000 006E // Compare B Match Interrupt: Off
; 0000 006F TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0070 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0071 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0072 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0073 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0074 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0075 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0076 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0077 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0078 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0079 
; 0000 007A // Timer/Counter 2 initialization
; 0000 007B // Clock source: System Clock
; 0000 007C // Clock value: Timer2 Stopped
; 0000 007D // Mode: Normal top=0xFF
; 0000 007E // OC2 output: Disconnected
; 0000 007F ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0080 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0081 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0082 OCR2=0x00;
	OUT  0x23,R30
; 0000 0083 
; 0000 0084 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0085 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0086 
; 0000 0087 // External Interrupt(s) initialization
; 0000 0088 // INT0: Off
; 0000 0089 // INT1: Off
; 0000 008A // INT2: Off
; 0000 008B MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 008C MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 008D 
; 0000 008E // USART initialization
; 0000 008F // USART disabled
; 0000 0090 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0091 
; 0000 0092 // Analog Comparator initialization
; 0000 0093 // Analog Comparator: Off
; 0000 0094 // The Analog Comparator's positive input is
; 0000 0095 // connected to the AIN0 pin
; 0000 0096 // The Analog Comparator's negative input is
; 0000 0097 // connected to the AIN1 pin
; 0000 0098 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0099 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 009A 
; 0000 009B // ADC initialization
; 0000 009C // ADC disabled
; 0000 009D ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 009E 
; 0000 009F // SPI initialization
; 0000 00A0 // SPI disabled
; 0000 00A1 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00A2 
; 0000 00A3 // TWI initialization
; 0000 00A4 // TWI disabled
; 0000 00A5 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00A6 DHT_setup();
	RCALL _DHT_setup
; 0000 00A7 
; 0000 00A8 while (1)
_0x29:
; 0000 00A9     {
; 0000 00AA     DHT_read(&temp,&hum);
	LDI  R30,LOW(_temp)
	LDI  R31,HIGH(_temp)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_hum)
	LDI  R27,HIGH(_hum)
	RCALL _DHT_read
; 0000 00AB     t = temp;
	LDS  R30,_temp
	LDS  R31,_temp+1
	LDS  R22,_temp+2
	LDS  R23,_temp+3
	CALL __CFD1
	MOVW R4,R30
; 0000 00AC     h = hum / 20;
	LDS  R26,_hum
	LDS  R27,_hum+1
	LDS  R24,_hum+2
	LDS  R25,_hum+3
	__GETD1N 0x41A00000
	CALL __DIVF21
	CALL __CFD1
	MOVW R6,R30
; 0000 00AD     seg1((h/10)%10);
	MOVW R26,R6
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOVW R26,R30
	RCALL _seg1
; 0000 00AE     seg2((h/1)%10);
	MOVW R26,R6
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOVW R26,R30
	RCALL _seg2
; 0000 00AF 
; 0000 00B0     delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 00B1     }
	RJMP _0x29
; 0000 00B2 }
_0x2C:
	RJMP _0x2C
; .FEND
;#include "DHT.h"
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
;//----- Auxiliary data ----------//
;enum DHT_STATUS_t DHT_STATUS = DHT_OK;
;
;#if (DHT_TYPE == DHT11)
;    #define _DHT_TEMP_MIN    0
;    #define _DHT_TEMP_MAX    50
;    #define _DHT_HUM_MIN    20
;    #define _DHT_HUM_MAX    90
;    #define _DHT_DELAY_READ    50
;#elif (DHT_TYPE == DHT22)
;    #define _DHT_TEMP_MIN    -40
;    #define _DHT_TEMP_MAX    80
;    #define _DHT_HUM_MIN    0
;    #define _DHT_HUM_MAX    100
;    #define _DHT_DELAY_READ    20
;#endif
;//-------------------------------//
;
;//----- Prototypes ----------------------------//
;static float dataToTemp(uint8_t x1, uint8_t x2);
;static float dataToHum(uint8_t x1, uint8_t x2);
;//---------------------------------------------//
;
;//----- Functions -----------------------------//
;void DHT_setup(void)
; 0001 001C {

	.CSEG
_DHT_setup:
; .FSTART _DHT_setup
; 0001 001D     delay_ms(_DHT_DELAY_SETUP);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0001 001E     DHT_STATUS = DHT_OK;
	LDI  R30,LOW(0)
	STS  _DHT_STATUS,R30
; 0001 001F }
	RET
; .FEND
;
;void DHT_readRaw(uint8_t arr[4])
; 0001 0022 {
_DHT_readRaw:
; .FSTART _DHT_readRaw
; 0001 0023     uint8_t data[5] = {0, 0, 0, 0, 0};
; 0001 0024     uint8_t retries, i;
; 0001 0025     int8_t j;
; 0001 0026     DHT_STATUS = DHT_OK;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,5
	RCALL SUBOPT_0x0
	LDI  R30,LOW(0)
	STD  Y+4,R30
	CALL __SAVELOCR4
;	arr -> Y+9
;	data -> Y+4
;	retries -> R17
;	i -> R16
;	j -> R19
	STS  _DHT_STATUS,R30
; 0001 0027     retries = i = j = 0;
	MOV  R19,R30
	MOV  R16,R30
	MOV  R17,R30
; 0001 0028 
; 0001 0029     //----- Step 1 - Start communication -----
; 0001 002A     if (DHT_STATUS == DHT_OK)
	CPI  R30,0
	BRNE _0x20003
; 0001 002B     {
; 0001 002C         //Request data
; 0001 002D         digitalWrite(DHT_PIN, LOW);            //DHT_PIN = 0
	CBI  0x1B,1
; 0001 002E         pinMode(DHT_PIN, OUTPUT);            //DHT_PIN = Output
	SBI  0x1A,1
; 0001 002F         delay_ms(_DHT_DELAY_READ);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 0030 
; 0001 0031         //Setup DHT_PIN as input with pull-up resistor so as to read data
; 0001 0032         digitalWrite(DHT_PIN, HIGH);        //DHT_PIN = 1 (Pull-up resistor)
	SBI  0x1B,1
; 0001 0033         pinMode(DHT_PIN, INPUT);            //DHT_PIN = Input
	CBI  0x1A,1
; 0001 0034 
; 0001 0035         //Wait for response for 20-40us
; 0001 0036         retries = 0;
	LDI  R17,LOW(0)
; 0001 0037         while (digitalRead(DHT_PIN))
_0x20004:
	SBIS 0x19,1
	RJMP _0x20007
	LDI  R30,LOW(1)
	RJMP _0x20008
_0x20007:
	LDI  R30,LOW(0)
_0x20008:
	CPI  R30,0
	BREQ _0x20006
; 0001 0038         {
; 0001 0039             delay_us(2);
	RCALL SUBOPT_0x1
; 0001 003A             retries += 2;
; 0001 003B             if (retries > 60)
	CPI  R17,61
	BRLO _0x2000A
; 0001 003C             {
; 0001 003D                 DHT_STATUS = DHT_ERROR_TIMEOUT;    //Timeout error
	LDI  R30,LOW(4)
	STS  _DHT_STATUS,R30
; 0001 003E                 break;
	RJMP _0x20006
; 0001 003F             }
; 0001 0040         }
_0x2000A:
	RJMP _0x20004
_0x20006:
; 0001 0041     }
; 0001 0042     //----------------------------------------
; 0001 0043 
; 0001 0044     //----- Step 2 - Wait for response -----
; 0001 0045     if (DHT_STATUS == DHT_OK)
_0x20003:
	LDS  R30,_DHT_STATUS
	CPI  R30,0
	BRNE _0x2000B
; 0001 0046     {
; 0001 0047         //Response sequence began
; 0001 0048         //Wait for the first response to finish (low for ~80us)
; 0001 0049         retries = 0;
	LDI  R17,LOW(0)
; 0001 004A         while (!digitalRead(DHT_PIN))
_0x2000C:
	SBIS 0x19,1
	RJMP _0x2000F
	LDI  R30,LOW(1)
	RJMP _0x20010
_0x2000F:
	LDI  R30,LOW(0)
_0x20010:
	CPI  R30,0
	BRNE _0x2000E
; 0001 004B         {
; 0001 004C             delay_us(2);
	RCALL SUBOPT_0x1
; 0001 004D             retries += 2;
; 0001 004E             if (retries > 100)
	CPI  R17,101
	BRLO _0x20012
; 0001 004F             {
; 0001 0050                 DHT_STATUS = DHT_ERROR_TIMEOUT;    //Timeout error
	LDI  R30,LOW(4)
	STS  _DHT_STATUS,R30
; 0001 0051                 break;
	RJMP _0x2000E
; 0001 0052             }
; 0001 0053         }
_0x20012:
	RJMP _0x2000C
_0x2000E:
; 0001 0054         //Wait for the last response to finish (high for ~80us)
; 0001 0055         retries = 0;
	LDI  R17,LOW(0)
; 0001 0056         while(digitalRead(DHT_PIN))
_0x20013:
	SBIS 0x19,1
	RJMP _0x20016
	LDI  R30,LOW(1)
	RJMP _0x20017
_0x20016:
	LDI  R30,LOW(0)
_0x20017:
	CPI  R30,0
	BREQ _0x20015
; 0001 0057         {
; 0001 0058             delay_us(2);
	RCALL SUBOPT_0x1
; 0001 0059             retries += 2;
; 0001 005A             if (retries > 100)
	CPI  R17,101
	BRLO _0x20019
; 0001 005B             {
; 0001 005C                 DHT_STATUS = DHT_ERROR_TIMEOUT;    //Timeout error
	LDI  R30,LOW(4)
	STS  _DHT_STATUS,R30
; 0001 005D                 break;
	RJMP _0x20015
; 0001 005E             }
; 0001 005F         }
_0x20019:
	RJMP _0x20013
_0x20015:
; 0001 0060     }
; 0001 0061     //--------------------------------------
; 0001 0062 
; 0001 0063     //----- Step 3 - Data transmission -----
; 0001 0064     if (DHT_STATUS == DHT_OK)
_0x2000B:
	LDS  R30,_DHT_STATUS
	CPI  R30,0
	BREQ PC+2
	RJMP _0x2001A
; 0001 0065     {
; 0001 0066         //Reading 5 bytes, bit by bit
; 0001 0067         for (i = 0 ; i < 5 ; i++)
	LDI  R16,LOW(0)
_0x2001C:
	CPI  R16,5
	BRLO PC+2
	RJMP _0x2001D
; 0001 0068             for (j = 7 ; j >= 0 ; j--)
	LDI  R19,LOW(7)
_0x2001F:
	CPI  R19,0
	BRGE PC+2
	RJMP _0x20020
; 0001 0069             {
; 0001 006A                 //There is always a leading low level of 50 us
; 0001 006B                 retries = 0;
	LDI  R17,LOW(0)
; 0001 006C                 while(!digitalRead(DHT_PIN))
_0x20021:
	SBIS 0x19,1
	RJMP _0x20024
	LDI  R30,LOW(1)
	RJMP _0x20025
_0x20024:
	LDI  R30,LOW(0)
_0x20025:
	CPI  R30,0
	BRNE _0x20023
; 0001 006D                 {
; 0001 006E                     delay_us(2);
	RCALL SUBOPT_0x1
; 0001 006F                     retries += 2;
; 0001 0070                     if (retries > 70)
	CPI  R17,71
	BRLO _0x20027
; 0001 0071                     {
; 0001 0072                         DHT_STATUS = DHT_ERROR_TIMEOUT;    //Timeout error
	LDI  R30,LOW(4)
	STS  _DHT_STATUS,R30
; 0001 0073                         j = -1;                                //Break inner for-loop
	LDI  R19,LOW(255)
; 0001 0074                         i = 5;                                //Break outer for-loop
	LDI  R16,LOW(5)
; 0001 0075                         break;                                //Break while loop
	RJMP _0x20023
; 0001 0076                     }
; 0001 0077                 }
_0x20027:
	RJMP _0x20021
_0x20023:
; 0001 0078 
; 0001 0079                 if (DHT_STATUS == DHT_OK)
	LDS  R30,_DHT_STATUS
	CPI  R30,0
	BRNE _0x20028
; 0001 007A                 {
; 0001 007B                     //We read data bit || 26-28us means '0' || 70us means '1'
; 0001 007C                     delay_us(35);                            //Wait for more than 28us
	__DELAY_USB 93
; 0001 007D                     if (digitalRead(DHT_PIN))                //If HIGH
	SBIS 0x19,1
	RJMP _0x2002A
	LDI  R30,LOW(1)
	RJMP _0x2002B
_0x2002A:
	LDI  R30,LOW(0)
_0x2002B:
	CPI  R30,0
	BREQ _0x20029
; 0001 007E                         bitSet(data[i], j);                    //bit = '1'
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LD   R1,Z
	MOV  R30,R19
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R1
	MOVW R26,R22
	ST   X,R30
; 0001 007F 
; 0001 0080                     retries = 0;
_0x20029:
	LDI  R17,LOW(0)
; 0001 0081                     while(digitalRead(DHT_PIN))
_0x2002D:
	SBIS 0x19,1
	RJMP _0x20030
	LDI  R30,LOW(1)
	RJMP _0x20031
_0x20030:
	LDI  R30,LOW(0)
_0x20031:
	CPI  R30,0
	BREQ _0x2002F
; 0001 0082                     {
; 0001 0083                         delay_us(2);
	RCALL SUBOPT_0x1
; 0001 0084                         retries += 2;
; 0001 0085                         if (retries > 100)
	CPI  R17,101
	BRLO _0x20033
; 0001 0086                         {
; 0001 0087                             DHT_STATUS = DHT_ERROR_TIMEOUT;    //Timeout error
	LDI  R30,LOW(4)
	STS  _DHT_STATUS,R30
; 0001 0088                             break;
	RJMP _0x2002F
; 0001 0089                         }
; 0001 008A                     }
_0x20033:
	RJMP _0x2002D
_0x2002F:
; 0001 008B                 }
; 0001 008C             }
_0x20028:
	SUBI R19,1
	RJMP _0x2001F
_0x20020:
	SUBI R16,-1
	RJMP _0x2001C
_0x2001D:
; 0001 008D     }
; 0001 008E     //--------------------------------------
; 0001 008F 
; 0001 0090 
; 0001 0091     //----- Step 4 - Check checksum and return data -----
; 0001 0092     if (DHT_STATUS == DHT_OK)
_0x2001A:
	LDS  R30,_DHT_STATUS
	CPI  R30,0
	BRNE _0x20034
; 0001 0093     {
; 0001 0094         if (((uint8_t)(data[0] + data[1] + data[2] + data[3])) != data[4])
	LDD  R26,Y+4
	CLR  R27
	LDD  R30,Y+5
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+6
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+7
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOV  R26,R30
	LDD  R30,Y+8
	CP   R30,R26
	BREQ _0x20035
; 0001 0095         {
; 0001 0096             DHT_STATUS = DHT_ERROR_CHECKSUM;    //Checksum error
	LDI  R30,LOW(3)
	STS  _DHT_STATUS,R30
; 0001 0097         }
; 0001 0098         else
	RJMP _0x20036
_0x20035:
; 0001 0099         {
; 0001 009A             //Build returning array
; 0001 009B             //data[0] = Humidity        (int)
; 0001 009C             //data[1] = Humidity        (dec)
; 0001 009D             //data[2] = Temperature        (int)
; 0001 009E             //data[3] = Temperature        (dec)
; 0001 009F             //data[4] = Checksum
; 0001 00A0             for (i = 0 ; i < 4 ; i++)
	LDI  R16,LOW(0)
_0x20038:
	CPI  R16,4
	BRSH _0x20039
; 0001 00A1                 arr[i] = data[i];
	MOV  R30,R16
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	SUBI R16,-1
	RJMP _0x20038
_0x20039:
; 0001 00A2 }
_0x20036:
; 0001 00A3     }
; 0001 00A4     //---------------------------------------------------
; 0001 00A5 }
_0x20034:
	CALL __LOADLOCR4
	ADIW R28,11
	RET
; .FEND
;
;void DHT_readTemperature(float *temp)
; 0001 00A8 {
; 0001 00A9     float waste[1];
; 0001 00AA     DHT_read(temp, waste);
;	*temp -> Y+4
;	waste -> Y+0
; 0001 00AB }
;
;void DHT_readHumidity(float *hum)
; 0001 00AE {
; 0001 00AF     float waste[1];
; 0001 00B0     DHT_read(waste, hum);
;	*hum -> Y+4
;	waste -> Y+0
; 0001 00B1 }
;
;void DHT_read(float *temp, float *hum)
; 0001 00B4 {
_DHT_read:
; .FSTART _DHT_read
; 0001 00B5     uint8_t data[4] = {0, 0, 0, 0};
; 0001 00B6 
; 0001 00B7     //Read data
; 0001 00B8     DHT_readRaw(data);
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	RCALL SUBOPT_0x0
;	*temp -> Y+6
;	*hum -> Y+4
;	data -> Y+0
	MOVW R26,R28
	RCALL _DHT_readRaw
; 0001 00B9 
; 0001 00BA     //If read successfully
; 0001 00BB     if (DHT_STATUS == DHT_OK)
	LDS  R30,_DHT_STATUS
	CPI  R30,0
	BRNE _0x2003A
; 0001 00BC     {
; 0001 00BD         //Calculate values
; 0001 00BE         *temp = dataToTemp(data[2], data[3]);
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _dataToTemp_G001
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __PUTDP1
; 0001 00BF         *hum = dataToHum(data[0], data[1]);
	LD   R30,Y
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _dataToHum_G001
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __PUTDP1
; 0001 00C0 
; 0001 00C1         //Check values
; 0001 00C2         if ((*temp < _DHT_TEMP_MIN) || (*temp > _DHT_TEMP_MAX))
	RCALL SUBOPT_0x2
	__GETD1N 0xC2200000
	CALL __CMPF12
	BRLO _0x2003C
	RCALL SUBOPT_0x2
	__GETD1N 0x42A00000
	CALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x2003C
	RJMP _0x2003B
_0x2003C:
; 0001 00C3             DHT_STATUS = DHT_ERROR_TEMPERATURE;
	LDI  R30,LOW(2)
	RJMP _0x20048
; 0001 00C4         else if ((*hum < _DHT_HUM_MIN) || (*hum > _DHT_HUM_MAX))
_0x2003B:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETD1P
	TST  R23
	BRMI _0x20040
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42C80000
	CALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x20040
	RJMP _0x2003F
_0x20040:
; 0001 00C5             DHT_STATUS = DHT_ERROR_HUMIDITY;
	LDI  R30,LOW(1)
_0x20048:
	STS  _DHT_STATUS,R30
; 0001 00C6     }
_0x2003F:
; 0001 00C7 }
_0x2003A:
	ADIW R28,8
	RET
; .FEND
;
;float DHT_convertToFahrenheit(float temp)
; 0001 00CA {
; 0001 00CB     return (temp * 1.8 + 32);
;	temp -> Y+0
; 0001 00CC }
;
;float DHT_convertToKelvin(float temp)
; 0001 00CF {
; 0001 00D0     return (temp + 273.15);
;	temp -> Y+0
; 0001 00D1 }
;
;static float dataToTemp(uint8_t x1, uint8_t x2)
; 0001 00D4 {
_dataToTemp_G001:
; .FSTART _dataToTemp_G001
; 0001 00D5     float temp = 0.0;
; 0001 00D6 
; 0001 00D7     #if (DHT_TYPE == DHT11)
; 0001 00D8         temp = x1;
; 0001 00D9     #elif (DHT_TYPE == DHT22)
; 0001 00DA         //(Integral<<8 + Decimal) / 10
; 0001 00DB         temp = (bitCheck(x1, 7) ? ((((x1 & 0x7F) << 8) | x2) / (-10.0)) : (((x1 << 8) | x2) / 10.0));
	ST   -Y,R26
	SBIW R28,4
	RCALL SUBOPT_0x0
;	x1 -> Y+5
;	x2 -> Y+4
;	temp -> Y+0
	LDD  R30,Y+5
	ANDI R30,LOW(0x80)
	BREQ _0x20042
	__GETD1N 0x3F800000
	RJMP _0x20043
_0x20042:
	__GETD1N 0x0
_0x20043:
	CALL __CPD10
	BREQ _0x20045
	LDD  R30,Y+5
	ANDI R30,0x7F
	MOV  R31,R30
	LDI  R30,0
	RCALL SUBOPT_0x3
	__GETD1N 0xC1200000
	RJMP _0x20049
_0x20045:
	LDI  R30,0
	LDD  R31,Y+5
	RCALL SUBOPT_0x3
	__GETD1N 0x41200000
_0x20049:
	CALL __DIVF21
	RJMP _0x2000001
; 0001 00DC     #endif
; 0001 00DD 
; 0001 00DE     return temp;
; 0001 00DF }
; .FEND
;
;static float dataToHum(uint8_t x1, uint8_t x2)
; 0001 00E2 {
_dataToHum_G001:
; .FSTART _dataToHum_G001
; 0001 00E3     float hum = 0.0;
; 0001 00E4 
; 0001 00E5     #if (DHT_TYPE == DHT11)
; 0001 00E6         hum = x1;
; 0001 00E7     #elif (DHT_TYPE == DHT22)
; 0001 00E8         //(Integral<<8 + Decimal) / 10
; 0001 00E9         hum = ((x1<<8) | x2) / 10.0;
	ST   -Y,R26
	SBIW R28,4
	RCALL SUBOPT_0x0
;	x1 -> Y+5
;	x2 -> Y+4
;	hum -> Y+0
	LDI  R30,0
	LDD  R31,Y+5
	RCALL SUBOPT_0x3
	__GETD1N 0x41200000
	CALL __DIVF21
_0x2000001:
	CALL __PUTD1S0
; 0001 00EA     #endif
; 0001 00EB 
; 0001 00EC     return hum;
	ADIW R28,6
	RET
; 0001 00ED }
; .FEND

	.DSEG
_DHT_STATUS:
	.BYTE 0x1
_hum:
	.BYTE 0x4
_temp:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	__DELAY_USB 5
	SUBI R17,-LOW(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3:
	MOVW R26,R30
	LDD  R30,Y+4
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RET


	.CSEG
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

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

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

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
