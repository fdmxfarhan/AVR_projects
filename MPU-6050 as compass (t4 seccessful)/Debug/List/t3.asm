
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

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x2000003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

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
;Date    : 24/02/2017
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
;
;// I2C Bus functions
;#include <i2c.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;
;
;
;
;
;
;
;
;
;#include <delay.h>
;#include <stdio.h>
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
; 0000 0040 {

	.CSEG
_read_i2c:
; .FSTART _read_i2c
; 0000 0041 unsigned char Data;
; 0000 0042 i2c_start();
	ST   -Y,R26
	ST   -Y,R17
;	BusAddres -> Y+3
;	Reg -> Y+2
;	Ack -> Y+1
;	Data -> R17
	CALL _i2c_start
; 0000 0043 i2c_write(BusAddres);
	LDD  R26,Y+3
	CALL _i2c_write
; 0000 0044 i2c_write(Reg);
	LDD  R26,Y+2
	CALL _i2c_write
; 0000 0045 i2c_start();
	CALL _i2c_start
; 0000 0046 i2c_write(BusAddres + 1);
	LDD  R26,Y+3
	SUBI R26,-LOW(1)
	CALL _i2c_write
; 0000 0047 delay_us(10);
	__DELAY_USB 27
; 0000 0048 Data=i2c_read(Ack);
	LDD  R26,Y+1
	CALL _i2c_read
	MOV  R17,R30
; 0000 0049 i2c_stop();
	CALL _i2c_stop
; 0000 004A return Data;
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,4
	RET
; 0000 004B }
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;void write_i2c(unsigned char BusAddres , unsigned char Reg , unsigned char Data)
; 0000 004E {
_write_i2c:
; .FSTART _write_i2c
; 0000 004F i2c_start();
	ST   -Y,R26
;	BusAddres -> Y+2
;	Reg -> Y+1
;	Data -> Y+0
	CALL _i2c_start
; 0000 0050 i2c_write(BusAddres);
	LDD  R26,Y+2
	CALL _i2c_write
; 0000 0051 i2c_write(Reg);
	LDD  R26,Y+1
	CALL _i2c_write
; 0000 0052 i2c_write(Data);
	LD   R26,Y
	CALL _i2c_write
; 0000 0053 i2c_stop();
	CALL _i2c_stop
; 0000 0054 }
	ADIW R28,3
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// This function can test i2c communication MPU6050
;unsigned char MPU6050_Test_I2C()
; 0000 0058 {
; 0000 0059     unsigned char Data = 0x00;
; 0000 005A     Data=read_i2c(MPU6050_ADDRESS, RA_WHO_AM_I, 0);
;	Data -> R17
; 0000 005B     if(Data == 0x68)
; 0000 005C         return 1;       // Means Comunication With MPU6050 is Corect
; 0000 005D     else
; 0000 005E         return 0;       // Means ERROR, Stopping
; 0000 005F }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// This function can move MPU6050 to sleep
;void MPU6050_Sleep(char ON_or_OFF)
; 0000 0063 {
; 0000 0064     if(ON_or_OFF == on)
;	ON_or_OFF -> Y+0
; 0000 0065         write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (1<<6)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
; 0000 0066     else if(ON_or_OFF == off)
; 0000 0067         write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (0)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
; 0000 0068 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// This function can restor MPU6050 to default
;void MPU6050_Reset()
; 0000 006C {
; 0000 006D     // When set to 1, DEVICE_RESET bit in RA_PWR_MGMT_1 resets all internal registers to their default values.
; 0000 006E     // The bit automatically clears to 0 once the reset is done.
; 0000 006F     // The default values for each register can be found in RA_MPU6050.h
; 0000 0070     write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, 0x80);
; 0000 0071     // Now all reg reset to default values
; 0000 0072 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// MPU6050 sensor initialization
;void MPU6050_Init()
; 0000 0076 {
_MPU6050_Init:
; .FSTART _MPU6050_Init
; 0000 0077     //Sets sample rate to 1000/1+4 = 200Hz
; 0000 0078     write_i2c(MPU6050_ADDRESS, RA_SMPLRT_DIV, SampleRateDiv);
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	LDI  R26,LOW(4)
	CALL SUBOPT_0x0
; 0000 0079     //Disable FSync, 42Hz DLPF
; 0000 007A     write_i2c(MPU6050_ADDRESS, RA_CONFIG, (EXT_SYNC_SET<<3)|(DLPF_CFG));
	LDI  R30,LOW(26)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL SUBOPT_0x0
; 0000 007B     //Disable all axis gyro self tests, scale of 2000 degrees/s
; 0000 007C     write_i2c(MPU6050_ADDRESS, RA_GYRO_CONFIG, ((XG_ST|YG_ST|ZG_ST)<<5)|GFS_SEL);
	LDI  R30,LOW(27)
	ST   -Y,R30
	LDI  R26,LOW(24)
	CALL SUBOPT_0x0
; 0000 007D     //Disable accel self tests, scale of +-16g, no DHPF
; 0000 007E     write_i2c(MPU6050_ADDRESS, RA_ACCEL_CONFIG, ((XA_ST|YA_ST|ZA_ST)<<5)|AFS_SEL);
	LDI  R30,LOW(28)
	CALL SUBOPT_0x1
; 0000 007F     //Disable sensor output to FIFO buffer
; 0000 0080     write_i2c(MPU6050_ADDRESS, RA_FIFO_EN, FIFO_En_Parameters);
	LDI  R30,LOW(35)
	CALL SUBOPT_0x1
; 0000 0081 
; 0000 0082     //Freefall threshold of |0mg|
; 0000 0083     write_i2c(MPU6050_ADDRESS, RA_FF_THR, 0x00);
	LDI  R30,LOW(29)
	CALL SUBOPT_0x1
; 0000 0084     //Freefall duration limit of 0
; 0000 0085     write_i2c(MPU6050_ADDRESS, RA_FF_DUR, 0x00);
	LDI  R30,LOW(30)
	CALL SUBOPT_0x1
; 0000 0086     //Motion threshold of 0mg
; 0000 0087     write_i2c(MPU6050_ADDRESS, RA_MOT_THR, 0x00);
	LDI  R30,LOW(31)
	CALL SUBOPT_0x1
; 0000 0088     //Motion duration of 0s
; 0000 0089     write_i2c(MPU6050_ADDRESS, RA_MOT_DUR, 0x00);
	LDI  R30,LOW(32)
	CALL SUBOPT_0x1
; 0000 008A     //Zero motion threshold
; 0000 008B     write_i2c(MPU6050_ADDRESS, RA_ZRMOT_THR, 0x00);
	LDI  R30,LOW(33)
	CALL SUBOPT_0x1
; 0000 008C     //Zero motion duration threshold
; 0000 008D     write_i2c(MPU6050_ADDRESS, RA_ZRMOT_DUR, 0x00);
	LDI  R30,LOW(34)
	CALL SUBOPT_0x1
; 0000 008E 
; 0000 008F //////////////////////////////////////////////////////////////
; 0000 0090 //  AUX I2C setup
; 0000 0091 //////////////////////////////////////////////////////////////
; 0000 0092     //Sets AUX I2C to single master control, plus other config
; 0000 0093     write_i2c(MPU6050_ADDRESS, RA_I2C_MST_CTRL, 0x00);
	LDI  R30,LOW(36)
	CALL SUBOPT_0x1
; 0000 0094     //Setup AUX I2C slaves
; 0000 0095     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_ADDR, 0x00);
	LDI  R30,LOW(37)
	CALL SUBOPT_0x1
; 0000 0096     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_REG, 0x00);
	LDI  R30,LOW(38)
	CALL SUBOPT_0x1
; 0000 0097     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_CTRL, 0x00);
	LDI  R30,LOW(39)
	CALL SUBOPT_0x1
; 0000 0098 
; 0000 0099     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_ADDR, 0x00);
	LDI  R30,LOW(40)
	CALL SUBOPT_0x1
; 0000 009A     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_REG, 0x00);
	LDI  R30,LOW(41)
	CALL SUBOPT_0x1
; 0000 009B     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_CTRL, 0x00);
	LDI  R30,LOW(42)
	CALL SUBOPT_0x1
; 0000 009C 
; 0000 009D     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_ADDR, 0x00);
	LDI  R30,LOW(43)
	CALL SUBOPT_0x1
; 0000 009E     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_REG, 0x00);
	LDI  R30,LOW(44)
	CALL SUBOPT_0x1
; 0000 009F     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_CTRL, 0x00);
	LDI  R30,LOW(45)
	CALL SUBOPT_0x1
; 0000 00A0 
; 0000 00A1     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_ADDR, 0x00);
	LDI  R30,LOW(46)
	CALL SUBOPT_0x1
; 0000 00A2     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_REG, 0x00);
	LDI  R30,LOW(47)
	CALL SUBOPT_0x1
; 0000 00A3     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_CTRL, 0x00);
	LDI  R30,LOW(48)
	CALL SUBOPT_0x1
; 0000 00A4 
; 0000 00A5     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_ADDR, 0x00);
	LDI  R30,LOW(49)
	CALL SUBOPT_0x1
; 0000 00A6     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_REG, 0x00);
	LDI  R30,LOW(50)
	CALL SUBOPT_0x1
; 0000 00A7     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_DO, 0x00);
	LDI  R30,LOW(51)
	CALL SUBOPT_0x1
; 0000 00A8     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_CTRL, 0x00);
	LDI  R30,LOW(52)
	CALL SUBOPT_0x1
; 0000 00A9     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_DI, 0x00);
	LDI  R30,LOW(53)
	CALL SUBOPT_0x1
; 0000 00AA 
; 0000 00AB     //Setup INT pin and AUX I2C pass through
; 0000 00AC     write_i2c(MPU6050_ADDRESS, RA_INT_PIN_CFG, 0x00);
	LDI  R30,LOW(55)
	CALL SUBOPT_0x1
; 0000 00AD     //Enable data ready interrupt
; 0000 00AE     write_i2c(MPU6050_ADDRESS, RA_INT_ENABLE, 0x00);
	LDI  R30,LOW(56)
	CALL SUBOPT_0x1
; 0000 00AF 
; 0000 00B0     //Slave out, dont care
; 0000 00B1     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_DO, 0x00);
	LDI  R30,LOW(99)
	CALL SUBOPT_0x1
; 0000 00B2     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_DO, 0x00);
	LDI  R30,LOW(100)
	CALL SUBOPT_0x1
; 0000 00B3     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_DO, 0x00);
	LDI  R30,LOW(101)
	CALL SUBOPT_0x1
; 0000 00B4     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_DO, 0x00);
	LDI  R30,LOW(102)
	CALL SUBOPT_0x1
; 0000 00B5     //More slave config
; 0000 00B6     write_i2c(MPU6050_ADDRESS, RA_I2C_MST_DELAY_CTRL, 0x00);
	LDI  R30,LOW(103)
	CALL SUBOPT_0x1
; 0000 00B7 
; 0000 00B8     //Reset sensor signal paths
; 0000 00B9     write_i2c(MPU6050_ADDRESS, RA_SIGNAL_PATH_RESET, 0x00);
	LDI  R30,LOW(104)
	CALL SUBOPT_0x1
; 0000 00BA     //Motion detection control
; 0000 00BB     write_i2c(MPU6050_ADDRESS, RA_MOT_DETECT_CTRL, 0x00);
	LDI  R30,LOW(105)
	CALL SUBOPT_0x1
; 0000 00BC     //Disables FIFO, AUX I2C, FIFO and I2C reset bits to 0
; 0000 00BD     write_i2c(MPU6050_ADDRESS, RA_USER_CTRL, 0x00);
	LDI  R30,LOW(106)
	CALL SUBOPT_0x1
; 0000 00BE 
; 0000 00BF     //Sets clock source to gyro reference w/ PLL
; 0000 00C0     write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (SLEEP<<6)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
	LDI  R30,LOW(107)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL SUBOPT_0x0
; 0000 00C1     //Controls frequency of wakeups in accel low power mode plus the sensor standby modes
; 0000 00C2     write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_2, (LP_WAKE_CTRL<<6)|(STBY_XA<<5)|(STBY_YA<<4)|(STBY_ZA<<3)|(STBY_XG<<2)|(STB ...
	LDI  R30,LOW(108)
	CALL SUBOPT_0x1
; 0000 00C3     //Data transfer to and from the FIFO buffer
; 0000 00C4     write_i2c(MPU6050_ADDRESS, RA_FIFO_R_W, 0x00);
	LDI  R30,LOW(116)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _write_i2c
; 0000 00C5 
; 0000 00C6 //  MPU6050 Setup Complete
; 0000 00C7 }
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// get accel offset X,Y,Z
;void Get_Accel_Offset()
; 0000 00CB {
_Get_Accel_Offset:
; .FSTART _Get_Accel_Offset
; 0000 00CC   #define    NumAve4AO      100
; 0000 00CD   float Ave=0;
; 0000 00CE   unsigned char i= NumAve4AO;
; 0000 00CF   while(i--)
	CALL SUBOPT_0x2
;	Ave -> Y+1
;	i -> R17
	LDI  R17,100
_0x8:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0xA
; 0000 00D0   {
; 0000 00D1     Accel_Offset_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
; 0000 00D2                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)   );
	CALL SUBOPT_0x3
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_Accel_Offset_Val)
	LDI  R27,HIGH(_Accel_Offset_Val)
	CALL SUBOPT_0x5
; 0000 00D3     Ave = (float) Ave + (Accel_Offset_Val[X] / NumAve4AO);
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
; 0000 00D4     delay_us(10);
; 0000 00D5   }
	RJMP _0x8
_0xA:
; 0000 00D6   Accel_Offset_Val[X] = Ave;
	CALL SUBOPT_0x8
	STS  _Accel_Offset_Val,R30
	STS  _Accel_Offset_Val+1,R31
	STS  _Accel_Offset_Val+2,R22
	STS  _Accel_Offset_Val+3,R23
; 0000 00D7   Ave = 0;
	CALL SUBOPT_0x9
; 0000 00D8   i = NumAve4AO;
; 0000 00D9   while(i--)
_0xB:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0xD
; 0000 00DA   {
; 0000 00DB     Accel_Offset_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
; 0000 00DC                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)   );
	CALL SUBOPT_0xA
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Accel_Offset_Val,4
	CALL SUBOPT_0x5
; 0000 00DD     Ave = (float) Ave + (Accel_Offset_Val[Y] / NumAve4AO);
	CALL SUBOPT_0xC
	CALL SUBOPT_0x7
; 0000 00DE     delay_us(10);
; 0000 00DF   }
	RJMP _0xB
_0xD:
; 0000 00E0   Accel_Offset_Val[Y] = Ave;
	CALL SUBOPT_0x8
	__PUTD1MN _Accel_Offset_Val,4
; 0000 00E1   Ave = 0;
	CALL SUBOPT_0x9
; 0000 00E2   i = NumAve4AO;
; 0000 00E3   while(i--)
_0xE:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x10
; 0000 00E4   {
; 0000 00E5     Accel_Offset_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
; 0000 00E6                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)   );
	CALL SUBOPT_0xD
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xE
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Accel_Offset_Val,8
	CALL SUBOPT_0x5
; 0000 00E7     Ave = (float) Ave + (Accel_Offset_Val[Z] / NumAve4AO);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x7
; 0000 00E8     delay_us(10);
; 0000 00E9   }
	RJMP _0xE
_0x10:
; 0000 00EA   Accel_Offset_Val[Z] = Ave;
	CALL SUBOPT_0x8
	__PUTD1MN _Accel_Offset_Val,8
; 0000 00EB }
	RJMP _0x20C0006
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Gets raw accelerometer data, performs no processing
;void Get_Accel_Val()
; 0000 00EF {
; 0000 00F0     Accel_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
; 0000 00F1                          read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)    );
; 0000 00F2     Accel_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
; 0000 00F3                          read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)    );
; 0000 00F4     Accel_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
; 0000 00F5                          read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)    );
; 0000 00F6 
; 0000 00F7     Accel_In_g[X] = Accel_Raw_Val[X] - Accel_Offset_Val[X];
; 0000 00F8     Accel_In_g[Y] = Accel_Raw_Val[Y] - Accel_Offset_Val[Y];
; 0000 00F9     Accel_In_g[Z] = Accel_Raw_Val[Z] - Accel_Offset_Val[Z];
; 0000 00FA 
; 0000 00FB     Accel_In_g[X] = Accel_In_g[X] / ACCEL_Sensitivity;
; 0000 00FC     Accel_In_g[Y] = Accel_In_g[Y] / ACCEL_Sensitivity;
; 0000 00FD     Accel_In_g[Z] = Accel_In_g[Z] / ACCEL_Sensitivity;
; 0000 00FE }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Gets n average raw accelerometer data, performs no processing
;void Get_AvrgAccel_Val()
; 0000 0102 {
_Get_AvrgAccel_Val:
; .FSTART _Get_AvrgAccel_Val
; 0000 0103   #define    NumAve4A      50
; 0000 0104   float Ave=0;
; 0000 0105   unsigned char i= NumAve4A;
; 0000 0106   while(i--)
	CALL SUBOPT_0x2
;	Ave -> Y+1
;	i -> R17
	LDI  R17,50
_0x11:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x13
; 0000 0107   {
; 0000 0108     AvrgAccel_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
; 0000 0109                              read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)   );
	CALL SUBOPT_0x3
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_AvrgAccel_Raw_Val)
	LDI  R27,HIGH(_AvrgAccel_Raw_Val)
	CALL SUBOPT_0x5
; 0000 010A     Ave = (float) Ave + (AvrgAccel_Raw_Val[X] / NumAve4A);
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0000 010B     delay_us(10);
; 0000 010C   }
	RJMP _0x11
_0x13:
; 0000 010D   AvrgAccel_Raw_Val[X] = Ave;
	CALL SUBOPT_0x8
	STS  _AvrgAccel_Raw_Val,R30
	STS  _AvrgAccel_Raw_Val+1,R31
	STS  _AvrgAccel_Raw_Val+2,R22
	STS  _AvrgAccel_Raw_Val+3,R23
; 0000 010E   Ave = 0;
	CALL SUBOPT_0x12
; 0000 010F   i = NumAve4A;
; 0000 0110   while(i--)
_0x14:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x16
; 0000 0111   {
; 0000 0112     AvrgAccel_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
; 0000 0113                              read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)   );
	CALL SUBOPT_0xA
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _AvrgAccel_Raw_Val,4
	CALL SUBOPT_0x5
; 0000 0114     Ave = (float) Ave + (AvrgAccel_Raw_Val[Y] / NumAve4A);
	__GETD2MN _AvrgAccel_Raw_Val,4
	CALL SUBOPT_0x11
; 0000 0115     delay_us(10);
; 0000 0116   }
	RJMP _0x14
_0x16:
; 0000 0117   AvrgAccel_Raw_Val[Y] = Ave;
	CALL SUBOPT_0x8
	__PUTD1MN _AvrgAccel_Raw_Val,4
; 0000 0118   Ave = 0;
	CALL SUBOPT_0x12
; 0000 0119   i = NumAve4A;
; 0000 011A   while(i--)
_0x17:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x19
; 0000 011B   {
; 0000 011C     AvrgAccel_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
; 0000 011D                              read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)   );
	CALL SUBOPT_0xD
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xE
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _AvrgAccel_Raw_Val,8
	CALL SUBOPT_0x5
; 0000 011E     Ave = (float) Ave + (AvrgAccel_Raw_Val[Z] / NumAve4A);
	__GETD2MN _AvrgAccel_Raw_Val,8
	CALL SUBOPT_0x11
; 0000 011F     delay_us(10);
; 0000 0120   }
	RJMP _0x17
_0x19:
; 0000 0121   AvrgAccel_Raw_Val[Z] = Ave;
	CALL SUBOPT_0x8
	__PUTD1MN _AvrgAccel_Raw_Val,8
; 0000 0122 
; 0000 0123   Accel_In_g[X] = AvrgAccel_Raw_Val[X] - Accel_Offset_Val[X];
	CALL SUBOPT_0x6
	CALL SUBOPT_0x13
	CALL __SUBF12
	CALL SUBOPT_0x14
; 0000 0124   Accel_In_g[Y] = AvrgAccel_Raw_Val[Y] - Accel_Offset_Val[Y];
	CALL SUBOPT_0x15
	CALL SUBOPT_0xC
	CALL __SUBF12
	CALL SUBOPT_0x16
; 0000 0125   Accel_In_g[Z] = AvrgAccel_Raw_Val[Z] - Accel_Offset_Val[Z];
	CALL SUBOPT_0x17
	CALL SUBOPT_0xF
	CALL __SUBF12
	CALL SUBOPT_0x18
; 0000 0126 
; 0000 0127   Accel_In_g[X] = Accel_In_g[X] / ACCEL_Sensitivity;  //  g/LSB
	LDS  R26,_Accel_In_g
	LDS  R27,_Accel_In_g+1
	LDS  R24,_Accel_In_g+2
	LDS  R25,_Accel_In_g+3
	CALL SUBOPT_0x19
	CALL SUBOPT_0x14
; 0000 0128   Accel_In_g[Y] = Accel_In_g[Y] / ACCEL_Sensitivity;  //  g/LSB
	__GETD2MN _Accel_In_g,4
	CALL SUBOPT_0x19
	CALL SUBOPT_0x16
; 0000 0129   Accel_In_g[Z] = Accel_In_g[Z] / ACCEL_Sensitivity;  //  g/LSB
	__GETD2MN _Accel_In_g,8
	CALL SUBOPT_0x19
	CALL SUBOPT_0x18
; 0000 012A 
; 0000 012B }
	RJMP _0x20C0006
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Gets angles from accelerometer data
;void Get_Accel_Angles()
; 0000 012F {
_Get_Accel_Angles:
; .FSTART _Get_Accel_Angles
; 0000 0130 // If you want be averaged of accelerometer data, write (on),else write (off)
; 0000 0131 #define  GetAvrg  on
; 0000 0132 
; 0000 0133 #if GetAvrg == on
; 0000 0134     Get_AvrgAccel_Val();
	RCALL _Get_AvrgAccel_Val
; 0000 0135 //  Calculate The Angle Of Each Axis
; 0000 0136     Accel_Angle[X] = 57.295*atan((float) AvrgAccel_Raw_Val[X] / sqrt(pow((float)AvrgAccel_Raw_Val[Z],2)+pow((float)AvrgA ...
	CALL SUBOPT_0x17
	CALL SUBOPT_0x1A
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1A
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x10
	CALL SUBOPT_0x1C
	STS  _Accel_Angle,R30
	STS  _Accel_Angle+1,R31
	STS  _Accel_Angle+2,R22
	STS  _Accel_Angle+3,R23
; 0000 0137     Accel_Angle[Y] = 57.295*atan((float) AvrgAccel_Raw_Val[Y] / sqrt(pow((float)AvrgAccel_Raw_Val[Z],2)+pow((float)AvrgA ...
	CALL SUBOPT_0x15
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x17
	CALL SUBOPT_0x1A
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x13
	CALL SUBOPT_0x1A
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x1B
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x1C
	__PUTD1MN _Accel_Angle,4
; 0000 0138     Accel_Angle[Z] = 57.295*atan((float) sqrt(pow((float)AvrgAccel_Raw_Val[X],2)+pow((float)AvrgAccel_Raw_Val[Y],2))/ Av ...
	CALL SUBOPT_0x13
	CALL SUBOPT_0x1A
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1A
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x1B
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x17
	CALL SUBOPT_0x1C
	__PUTD1MN _Accel_Angle,8
; 0000 0139 #else
; 0000 013A     Get_Accel_Val();
; 0000 013B //  Calculate The Angle Of Each Axis
; 0000 013C     Accel_Angle[X] = 57.295*atan((float) Accel_Raw_Val[X] / sqrt(pow((float)Accel_Raw_Val[Z],2)+pow((float)Accel_Raw_Val ...
; 0000 013D     Accel_Angle[Y] = 57.295*atan((float) Accel_Raw_Val[Y] / sqrt(pow((float)Accel_Raw_Val[Z],2)+pow((float)Accel_Raw_Val ...
; 0000 013E     Accel_Angle[Z] = 57.295*atan((float) sqrt(pow((float)Accel_Raw_Val[X],2)+pow((float)Accel_Raw_Val[Y],2))/ Accel_Raw_ ...
; 0000 013F #endif
; 0000 0140 
; 0000 0141 }
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// get gyro offset X,Y,Z
;void Get_Gyro_Offset()
; 0000 0145 {
_Get_Gyro_Offset:
; .FSTART _Get_Gyro_Offset
; 0000 0146   #define    NumAve4GO      100
; 0000 0147 
; 0000 0148   float Ave = 0;
; 0000 0149   unsigned char i = NumAve4GO;
; 0000 014A   Gyro_Offset_Val[X] = Gyro_Offset_Val[Y] = Gyro_Offset_Val[Z] = 0;
	CALL SUBOPT_0x2
;	Ave -> Y+1
;	i -> R17
	LDI  R17,100
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
; 0000 014B 
; 0000 014C   while(i--)
_0x1A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x1C
; 0000 014D   {
; 0000 014E     Gyro_Offset_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8)|
; 0000 014F                            read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0)   );
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(67)
	CALL SUBOPT_0x21
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(68)
	CALL SUBOPT_0x21
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_Gyro_Offset_Val)
	LDI  R27,HIGH(_Gyro_Offset_Val)
	CALL SUBOPT_0x5
; 0000 0150     Ave = (float) Ave + (Gyro_Offset_Val[X] / NumAve4GO);
	LDS  R26,_Gyro_Offset_Val
	LDS  R27,_Gyro_Offset_Val+1
	LDS  R24,_Gyro_Offset_Val+2
	LDS  R25,_Gyro_Offset_Val+3
	CALL SUBOPT_0x22
; 0000 0151     delay_us(1);
; 0000 0152   }
	RJMP _0x1A
_0x1C:
; 0000 0153   Gyro_Offset_Val[X] = Ave;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x20
; 0000 0154   Ave = 0;
	CALL SUBOPT_0x9
; 0000 0155   i = NumAve4GO;
; 0000 0156   while(i--)
_0x1D:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x1F
; 0000 0157   {
; 0000 0158     Gyro_Offset_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8)|
; 0000 0159                            read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0)   );
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(69)
	CALL SUBOPT_0x21
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(70)
	CALL SUBOPT_0x21
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Gyro_Offset_Val,4
	CALL SUBOPT_0x5
; 0000 015A     Ave = (float) Ave + (Gyro_Offset_Val[Y] / NumAve4GO);
	__GETD2MN _Gyro_Offset_Val,4
	CALL SUBOPT_0x22
; 0000 015B     delay_us(1);
; 0000 015C   }
	RJMP _0x1D
_0x1F:
; 0000 015D   Gyro_Offset_Val[Y] = Ave;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1F
; 0000 015E   Ave = 0;
	CALL SUBOPT_0x9
; 0000 015F   i = NumAve4GO;
; 0000 0160   while(i--)
_0x20:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x22
; 0000 0161   {
; 0000 0162       Gyro_Offset_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8)|
; 0000 0163                              read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0)   );
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(71)
	CALL SUBOPT_0x21
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(72)
	CALL SUBOPT_0x21
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Gyro_Offset_Val,8
	CALL SUBOPT_0x5
; 0000 0164     Ave = (float) Ave + (Gyro_Offset_Val[Z] / NumAve4GO);
	__GETD2MN _Gyro_Offset_Val,8
	CALL SUBOPT_0x22
; 0000 0165     delay_us(1);
; 0000 0166   }
	RJMP _0x20
_0x22:
; 0000 0167   Gyro_Offset_Val[Z] = Ave;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1E
; 0000 0168 
; 0000 0169 }
_0x20C0006:
	LDD  R17,Y+0
	ADIW R28,5
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Function to read the gyroscope rate data and convert it into degrees/s
;void Get_Gyro_Val()
; 0000 016D {
; 0000 016E     Gyro_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8) |
; 0000 016F                         read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0))    ;
; 0000 0170     Gyro_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8) |
; 0000 0171                         read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0))    ;
; 0000 0172     Gyro_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8) |
; 0000 0173                         read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0))    ;
; 0000 0174 
; 0000 0175     GyroRate_Val[X] = Gyro_Raw_Val[X] - Gyro_Offset_Val[X];
; 0000 0176     GyroRate_Val[Y] = Gyro_Raw_Val[Y] - Gyro_Offset_Val[Y];
; 0000 0177     GyroRate_Val[Z] = Gyro_Raw_Val[Z] - Gyro_Offset_Val[Z];
; 0000 0178 
; 0000 0179     GyroRate_Val[X] = GyroRate_Val[X] / GYRO_Sensitivity;
; 0000 017A     GyroRate_Val[Y] = GyroRate_Val[Y] / GYRO_Sensitivity;
; 0000 017B     GyroRate_Val[Z] = GyroRate_Val[Z] / GYRO_Sensitivity;
; 0000 017C 
; 0000 017D }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Function to read the Avrrage of gyroscope rate data and convert it into degrees/s
;void Get_AvrgGyro_Val()
; 0000 0181 {
; 0000 0182   #define    NumAve4G      50
; 0000 0183 
; 0000 0184   float Ave = 0;
; 0000 0185   unsigned char i = NumAve4G;
; 0000 0186   AvrgGyro_Raw_Val[X] = AvrgGyro_Raw_Val[Y] = AvrgGyro_Raw_Val[Z] = 0;
;	Ave -> Y+1
;	i -> R17
; 0000 0187 
; 0000 0188   while(i--)
; 0000 0189   {
; 0000 018A     AvrgGyro_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8)|
; 0000 018B                             read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0)   );
; 0000 018C     Ave = (float) Ave + (AvrgGyro_Raw_Val[X] / NumAve4G);
; 0000 018D     delay_us(1);
; 0000 018E   }
; 0000 018F   AvrgGyro_Raw_Val[X] = Ave;
; 0000 0190   Ave = 0;
; 0000 0191   i = NumAve4G;
; 0000 0192   while(i--)
; 0000 0193   {
; 0000 0194     AvrgGyro_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8)|
; 0000 0195                             read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0)   );
; 0000 0196     Ave = (float) Ave + (AvrgGyro_Raw_Val[Y] / NumAve4G);
; 0000 0197     delay_us(1);
; 0000 0198   }
; 0000 0199   AvrgGyro_Raw_Val[Y] = Ave;
; 0000 019A   Ave = 0;
; 0000 019B   i = NumAve4G;
; 0000 019C   while(i--)
; 0000 019D   {
; 0000 019E     AvrgGyro_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8)|
; 0000 019F                             read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0)   );
; 0000 01A0     Ave = (float) Ave + (AvrgGyro_Raw_Val[Z] / NumAve4G);
; 0000 01A1     delay_us(1);
; 0000 01A2   }
; 0000 01A3   AvrgGyro_Raw_Val[Z] = Ave;
; 0000 01A4 
; 0000 01A5   GyroRate_Val[X] = AvrgGyro_Raw_Val[X] - Gyro_Offset_Val[X];
; 0000 01A6   GyroRate_Val[Y] = AvrgGyro_Raw_Val[Y] - Gyro_Offset_Val[Y];
; 0000 01A7   GyroRate_Val[Z] = AvrgGyro_Raw_Val[Z] - Gyro_Offset_Val[Z];
; 0000 01A8 
; 0000 01A9   GyroRate_Val[X] = GyroRate_Val[X] / GYRO_Sensitivity;   // (º/s)/LSB
; 0000 01AA   GyroRate_Val[Y] = GyroRate_Val[Y] / GYRO_Sensitivity;   // (º/s)/LSB
; 0000 01AB   GyroRate_Val[Z] = GyroRate_Val[Z] / GYRO_Sensitivity;   // (º/s)/LSB
; 0000 01AC 
; 0000 01AD }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Function to read the Temperature
;void Get_Temp_Val()
; 0000 01B1 {
; 0000 01B2     Temp_Val = ((read_i2c(MPU6050_ADDRESS, RA_TEMP_OUT_H, 0)<< 8)|
; 0000 01B3                   read_i2c(MPU6050_ADDRESS, RA_TEMP_OUT_L, 0)   );
; 0000 01B4 // Compute the temperature in degrees
; 0000 01B5     Temp_Val = (Temp_Val /TEMP_Sensitivity) + 36.53;
; 0000 01B6 }
;
;
;// Declare your global variables here
;int cnt1,a1,a2,a3,a4,a5,a6;
;void WaitInPrint()
; 0000 01BC     {
; 0000 01BD     getchar();
; 0000 01BE     }
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
;void main(void)
; 0000 01CB {
_main:
; .FSTART _main
; 0000 01CC // Declare your local variables here
; 0000 01CD 
; 0000 01CE // Input/Output Ports initialization
; 0000 01CF // Port A initialization
; 0000 01D0 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 01D1 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 01D2 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01D3 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 01D4 
; 0000 01D5 // Port B initialization
; 0000 01D6 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 01D7 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 01D8 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01D9 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 01DA 
; 0000 01DB // Port C initialization
; 0000 01DC // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 01DD DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 01DE // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01DF PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 01E0 
; 0000 01E1 // Port D initialization
; 0000 01E2 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 01E3 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 01E4 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 01E5 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 01E6 
; 0000 01E7 // Timer/Counter 0 initialization
; 0000 01E8 // Clock source: System Clock
; 0000 01E9 // Clock value: Timer 0 Stopped
; 0000 01EA // Mode: Normal top=0xFF
; 0000 01EB // OC0 output: Disconnected
; 0000 01EC TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 01ED TCNT0=0x00;
	OUT  0x32,R30
; 0000 01EE OCR0=0x00;
	OUT  0x3C,R30
; 0000 01EF 
; 0000 01F0 // Timer/Counter 1 initialization
; 0000 01F1 // Clock source: System Clock
; 0000 01F2 // Clock value: Timer1 Stopped
; 0000 01F3 // Mode: Normal top=0xFFFF
; 0000 01F4 // OC1A output: Disconnected
; 0000 01F5 // OC1B output: Disconnected
; 0000 01F6 // Noise Canceler: Off
; 0000 01F7 // Input Capture on Falling Edge
; 0000 01F8 // Timer1 Overflow Interrupt: Off
; 0000 01F9 // Input Capture Interrupt: Off
; 0000 01FA // Compare A Match Interrupt: Off
; 0000 01FB // Compare B Match Interrupt: Off
; 0000 01FC TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 01FD TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 01FE TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 01FF TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0200 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0201 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0202 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0203 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0204 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0205 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0206 
; 0000 0207 // Timer/Counter 2 initialization
; 0000 0208 // Clock source: System Clock
; 0000 0209 // Clock value: Timer2 Stopped
; 0000 020A // Mode: Normal top=0xFF
; 0000 020B // OC2 output: Disconnected
; 0000 020C ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 020D TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 020E TCNT2=0x00;
	OUT  0x24,R30
; 0000 020F OCR2=0x00;
	OUT  0x23,R30
; 0000 0210 
; 0000 0211 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0212 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0213 
; 0000 0214 // External Interrupt(s) initialization
; 0000 0215 // INT0: Off
; 0000 0216 // INT1: Off
; 0000 0217 // INT2: Off
; 0000 0218 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0219 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 021A 
; 0000 021B // USART initialization
; 0000 021C // USART disabled
; 0000 021D UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 021E 
; 0000 021F // Analog Comparator initialization
; 0000 0220 // Analog Comparator: Off
; 0000 0221 // The Analog Comparator's positive input is
; 0000 0222 // connected to the AIN0 pin
; 0000 0223 // The Analog Comparator's negative input is
; 0000 0224 // connected to the AIN1 pin
; 0000 0225 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0226 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0227 
; 0000 0228 // ADC initialization
; 0000 0229 // ADC disabled
; 0000 022A ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 022B 
; 0000 022C // SPI initialization
; 0000 022D // SPI disabled
; 0000 022E SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 022F 
; 0000 0230 // TWI initialization
; 0000 0231 // TWI disabled
; 0000 0232 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0233 
; 0000 0234 // Bit-Banged I2C Bus initialization
; 0000 0235 // I2C Port: PORTB
; 0000 0236 // I2C SDA bit: 1
; 0000 0237 // I2C SCL bit: 0
; 0000 0238 // Bit Rate: 100 kHz
; 0000 0239 // Note: I2C settings are specified in the
; 0000 023A // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 023B i2c_init();
	CALL _i2c_init
; 0000 023C 
; 0000 023D // Alphanumeric LCD initialization
; 0000 023E // Connections are specified in the
; 0000 023F // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0240 // RS - PORTC Bit 0
; 0000 0241 // RD - PORTC Bit 1
; 0000 0242 // EN - PORTC Bit 2
; 0000 0243 // D4 - PORTC Bit 4
; 0000 0244 // D5 - PORTC Bit 5
; 0000 0245 // D6 - PORTC Bit 6
; 0000 0246 // D7 - PORTC Bit 7
; 0000 0247 // Characters/line: 16
; 0000 0248 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0249 
; 0000 024A MPU6050_Init();
	RCALL _MPU6050_Init
; 0000 024B Get_Accel_Offset();
	RCALL _Get_Accel_Offset
; 0000 024C Get_Gyro_Offset();
	RCALL _Get_Gyro_Offset
; 0000 024D 
; 0000 024E while (1)
_0x2C:
; 0000 024F       {
; 0000 0250       //WaitInPrint();
; 0000 0251       //puts("\n");
; 0000 0252 
; 0000 0253       //Get_Temp_Val();
; 0000 0254 
; 0000 0255       //Get_Gyro_Val();
; 0000 0256       //Get_AvrgGyro_Val();
; 0000 0257       //Get_Accel_Val();
; 0000 0258       //Get_AvrgAccel_Val();
; 0000 0259       Get_Accel_Angles();
	RCALL _Get_Accel_Angles
; 0000 025A 
; 0000 025B       a1=Accel_Angle[X];
	LDS  R30,_Accel_Angle
	LDS  R31,_Accel_Angle+1
	LDS  R22,_Accel_Angle+2
	LDS  R23,_Accel_Angle+3
	CALL __CFD1
	MOVW R6,R30
; 0000 025C       lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x23
; 0000 025D       if(a1>=0)
	BRLT _0x2F
; 0000 025E         {
; 0000 025F         lcd_putchar('+');
	CALL SUBOPT_0x24
; 0000 0260         lcd_putchar((a1/100)%10+'0');
; 0000 0261         lcd_putchar((a1/10)%10+'0');
; 0000 0262         lcd_putchar((a1/1)%10+'0');
	RJMP _0x40
; 0000 0263         }
; 0000 0264       else if(a1 < 0)
_0x2F:
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRGE _0x31
; 0000 0265         {
; 0000 0266         lcd_putchar('-');
	CALL SUBOPT_0x25
; 0000 0267         lcd_putchar((-a1/100)%10+'0');
; 0000 0268         lcd_putchar((-a1/10)%10+'0');
; 0000 0269         lcd_putchar((-a1/1)%10+'0');
_0x40:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x26
; 0000 026A         }
; 0000 026B       if(a1>0) PORTD.2=1;
_0x31:
	CLR  R0
	CP   R0,R6
	CPC  R0,R7
	BRGE _0x32
	SBI  0x12,2
; 0000 026C       else     PORTD.2=0;
	RJMP _0x35
_0x32:
	CBI  0x12,2
; 0000 026D 
; 0000 026E       a1=Accel_Angle[Y];
_0x35:
	__GETD1MN _Accel_Angle,4
	CALL __CFD1
	MOVW R6,R30
; 0000 026F       lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x23
; 0000 0270       if(a1>=0)
	BRLT _0x38
; 0000 0271         {
; 0000 0272         lcd_putchar('+');
	CALL SUBOPT_0x24
; 0000 0273         lcd_putchar((a1/100)%10+'0');
; 0000 0274         lcd_putchar((a1/10)%10+'0');
; 0000 0275         lcd_putchar((a1/1)%10+'0');
	RJMP _0x41
; 0000 0276         }
; 0000 0277       else if(a1 < 0)
_0x38:
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRGE _0x3A
; 0000 0278         {
; 0000 0279         lcd_putchar('-');
	CALL SUBOPT_0x25
; 0000 027A         lcd_putchar((-a1/100)%10+'0');
; 0000 027B         lcd_putchar((-a1/10)%10+'0');
; 0000 027C         lcd_putchar((-a1/1)%10+'0');
_0x41:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x26
; 0000 027D         }
; 0000 027E 
; 0000 027F 
; 0000 0280       a1=Accel_Angle[Z];
_0x3A:
	__GETD1MN _Accel_Angle,8
	CALL __CFD1
	MOVW R6,R30
; 0000 0281       lcd_gotoxy(10,0);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x23
; 0000 0282       if(a1>=0)
	BRLT _0x3B
; 0000 0283         {
; 0000 0284         lcd_putchar('+');
	CALL SUBOPT_0x24
; 0000 0285         lcd_putchar((a1/100)%10+'0');
; 0000 0286         lcd_putchar((a1/10)%10+'0');
; 0000 0287         lcd_putchar((a1/1)%10+'0');
	RJMP _0x42
; 0000 0288         }
; 0000 0289       else if(a1 < 0)
_0x3B:
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRGE _0x3D
; 0000 028A         {
; 0000 028B         lcd_putchar('-');
	CALL SUBOPT_0x25
; 0000 028C         lcd_putchar((-a1/100)%10+'0');
; 0000 028D         lcd_putchar((-a1/10)%10+'0');
; 0000 028E         lcd_putchar((-a1/1)%10+'0');
_0x42:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x26
; 0000 028F         }
; 0000 0290 
; 0000 0291       //delay_ms(100);
; 0000 0292       }
_0x3D:
	RJMP _0x2C
; 0000 0293 }
_0x3E:
	RJMP _0x3E
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

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 13
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	RJMP _0x20C0005
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x20C0005
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x27
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x27
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x20C0005
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x20C0005
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x28
	CALL SUBOPT_0x28
	CALL SUBOPT_0x28
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0005:
	ADIW R28,1
	RET
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
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL SUBOPT_0x29
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x2A
	RJMP _0x20C0001
__floor1:
    brtc __floor0
	CALL SUBOPT_0x2B
	CALL __SUBF12
	RJMP _0x20C0001
; .FEND
_log:
; .FSTART _log
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x2C
	CALL __CPD02
	BRLT _0x206000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20C0004
_0x206000C:
	CALL SUBOPT_0x2D
	CALL __PUTPARD1
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2C
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x206000D
	CALL SUBOPT_0x2F
	CALL __ADDF12
	CALL SUBOPT_0x2E
	__SUBWRN 16,17,1
_0x206000D:
	CALL SUBOPT_0x30
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x30
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x31
	__GETD2N 0x3F654226
	CALL SUBOPT_0x32
	__GETD1N 0x4054114E
	CALL SUBOPT_0x33
	CALL SUBOPT_0x2C
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x34
	__GETD2N 0x3FD4114D
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3F317218
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x20C0004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
; .FEND
_exp:
; .FSTART _exp
	CALL __PUTPARD2
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x35
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x206000F
	CALL SUBOPT_0x1D
	RJMP _0x20C0003
_0x206000F:
	__GETD1S 10
	CALL __CPD10
	BRNE _0x2060010
	__GETD1N 0x3F800000
	RJMP _0x20C0003
_0x2060010:
	CALL SUBOPT_0x35
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2060011
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0003
_0x2060011:
	CALL SUBOPT_0x35
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	__PUTD1S 10
	CALL SUBOPT_0x35
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	CALL SUBOPT_0x35
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x33
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0x33
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x31
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0x2C
	CALL __MULF12
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x34
	__GETD2N 0x41A68D28
	CALL __ADDF12
	__PUTD1S 2
	CALL SUBOPT_0x2D
	__GETD2S 2
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x34
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL __PUTPARD1
	MOVW R26,R16
	CALL _ldexp
_0x20C0003:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
; .FEND
_pow:
; .FSTART _pow
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x36
	CALL __CPD10
	BRNE _0x2060012
	CALL SUBOPT_0x1D
	RJMP _0x20C0002
_0x2060012:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x2060013
	CALL SUBOPT_0x37
	CALL __CPD10
	BRNE _0x2060014
	__GETD1N 0x3F800000
	RJMP _0x20C0002
_0x2060014:
	__GETD2S 8
	CALL SUBOPT_0x38
	RCALL _exp
	RJMP _0x20C0002
_0x2060013:
	CALL SUBOPT_0x37
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0x2A
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x37
	CALL __CPD12
	BREQ _0x2060015
	CALL SUBOPT_0x1D
	RJMP _0x20C0002
_0x2060015:
	CALL SUBOPT_0x36
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x38
	RCALL _exp
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x2060016
	CALL SUBOPT_0x36
	RJMP _0x20C0002
_0x2060016:
	CALL SUBOPT_0x36
	CALL __ANEGF1
_0x20C0002:
	ADIW R28,12
	RET
; .FEND
_xatan:
; .FSTART _xatan
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x37
	CALL SUBOPT_0x39
	CALL __PUTD1S0
	CALL SUBOPT_0x2A
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x39
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2A
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3A
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	ADIW R28,8
	RET
; .FEND
_yatan:
; .FSTART _yatan
	CALL SUBOPT_0x29
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2060020
	CALL SUBOPT_0x3B
	RCALL _xatan
	RJMP _0x20C0001
_0x2060020:
	CALL SUBOPT_0x3B
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2060021
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x3C
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0x33
	RJMP _0x20C0001
_0x2060021:
	CALL SUBOPT_0x2B
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2B
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3C
	__GETD2N 0x3F490FDB
	CALL __ADDF12
	RJMP _0x20C0001
; .FEND
_atan:
; .FSTART _atan
	CALL __PUTPARD2
	LDD  R26,Y+3
	TST  R26
	BRMI _0x206002C
	CALL SUBOPT_0x3B
	RCALL _yatan
	RJMP _0x20C0001
_0x206002C:
	CALL SUBOPT_0x2A
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	RCALL _yatan
	CALL __ANEGF1
_0x20C0001:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
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
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G102:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	ST   -Y,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(59)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _read_i2c
	MOV  R31,R30
	LDI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(60)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _read_i2c

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x5:
	CALL __CWD1
	CALL __CDF1
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDS  R26,_Accel_Offset_Val
	LDS  R27,_Accel_Offset_Val+1
	LDS  R24,_Accel_Offset_Val+2
	LDS  R25,_Accel_Offset_Val+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x7:
	__GETD1N 0x42C80000
	CALL __DIVF21
	__GETD2S 1
	CALL __ADDF12
	__PUTD1S 1
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x8:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	__CLRD1S 1
	LDI  R17,LOW(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(61)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _read_i2c
	MOV  R31,R30
	LDI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(62)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _read_i2c

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	__GETD2MN _Accel_Offset_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(63)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _read_i2c
	MOV  R31,R30
	LDI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(64)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _read_i2c

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	__GETD2MN _Accel_Offset_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDS  R26,_AvrgAccel_Raw_Val
	LDS  R27,_AvrgAccel_Raw_Val+1
	LDS  R24,_AvrgAccel_Raw_Val+2
	LDS  R25,_AvrgAccel_Raw_Val+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x11:
	__GETD1N 0x42480000
	CALL __DIVF21
	__GETD2S 1
	CALL __ADDF12
	__PUTD1S 1
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(0)
	__CLRD1S 1
	LDI  R17,LOW(50)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	LDS  R30,_AvrgAccel_Raw_Val
	LDS  R31,_AvrgAccel_Raw_Val+1
	LDS  R22,_AvrgAccel_Raw_Val+2
	LDS  R23,_AvrgAccel_Raw_Val+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	STS  _Accel_In_g,R30
	STS  _Accel_In_g+1,R31
	STS  _Accel_In_g+2,R22
	STS  _Accel_In_g+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x15:
	__GETD1MN _AvrgAccel_Raw_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	__PUTD1MN _Accel_In_g,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x17:
	__GETD1MN _AvrgAccel_Raw_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	__PUTD1MN _Accel_In_g,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	__GETD1N 0x46800000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1A:
	CALL __PUTPARD1
	__GETD2N 0x40000000
	JMP  _pow

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	JMP  _sqrt

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1C:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	CALL _atan
	__GETD2N 0x42652E14
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	__PUTD1MN _Gyro_Offset_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	__PUTD1MN _Gyro_Offset_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	STS  _Gyro_Offset_Val,R30
	STS  _Gyro_Offset_Val+1,R31
	STS  _Gyro_Offset_Val+2,R22
	STS  _Gyro_Offset_Val+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _read_i2c

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x22:
	__GETD1N 0x42C80000
	CALL __DIVF21
	__GETD2S 1
	CALL __ADDF12
	__PUTD1S 1
	__DELAY_USB 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x23:
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(43)
	CALL _lcd_putchar
	MOVW R26,R6
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _lcd_putchar
	MOVW R26,R6
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _lcd_putchar
	MOVW R26,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x25:
	LDI  R26,LOW(45)
	CALL _lcd_putchar
	MOVW R30,R6
	CALL __ANEGW1
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _lcd_putchar
	MOVW R30,R6
	CALL __ANEGW1
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _lcd_putchar
	MOVW R30,R6
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	CALL __PUTPARD2
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2A:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	RCALL SUBOPT_0x2A
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2C:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2D:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2E:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	RCALL SUBOPT_0x2D
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	RCALL SUBOPT_0x2D
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	CALL __MULF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x36:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x37:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	CALL _log
	__GETD2S 4
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	__GETD2S 4
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	JMP  _xatan


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
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

_frexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

_ldexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	ADD  R23,R26
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

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

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
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

_sqrt:
	rcall __PUTPARD2
	sbiw r28,4
	push r21
	ldd  r25,y+7
	tst  r25
	brne __sqrt0
	adiw r28,8
	rjmp __zerores
__sqrt0:
	brpl __sqrt1
	adiw r28,8
	rjmp __maxres
__sqrt1:
	push r20
	ldi  r20,66
	ldd  r24,y+6
	ldd  r27,y+5
	ldd  r26,y+4
__sqrt2:
	st   y,r24
	std  y+1,r25
	std  y+2,r26
	std  y+3,r27
	movw r30,r26
	movw r22,r24
	ldd  r26,y+4
	ldd  r27,y+5
	ldd  r24,y+6
	ldd  r25,y+7
	rcall __divf21
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	rcall __addf12
	rcall __unpack1
	dec  r23
	rcall __repack
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	eor  r26,r30
	andi r26,0xf8
	brne __sqrt4
	cp   r27,r31
	cpc  r24,r22
	cpc  r25,r23
	breq __sqrt3
__sqrt4:
	dec  r20
	breq __sqrt3
	movw r26,r30
	movw r24,r22
	rjmp __sqrt2
__sqrt3:
	pop  r20
	pop  r21
	adiw r28,8
	ret

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

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

;END OF CODE MARKER
__END_OF_CODE:
