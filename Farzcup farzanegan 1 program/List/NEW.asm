
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega64
;Program type           : Application
;Clock frequency        : 11/059200 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega64
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

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
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
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
	.DEF _cmp=R4
	.DEF _cmp_msb=R5
	.DEF _rx_wr_index1=R7
	.DEF _rx_rd_index1=R6
	.DEF _rx_counter1=R9
	.DEF _t=R10
	.DEF _t_msb=R11
	.DEF _u=R12
	.DEF _u_msb=R13
	.DEF _chr1=R8

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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer3_ovf_isr
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x4E,0x0,0x0,0x0
	.DB  0x0,0x0

_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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
	.ORG 0x500

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 2/11/2017
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega64
;Program type            : Application
;AVR Core Clock frequency: 11.059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*****************************************************/
;
;#include <mega64.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;
;// I2C Bus functions
;#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=1
   .equ __scl_bit=0
; 0000 0021 #endasm
;#include <i2c.h>
;
;eeprom int c;
;//////////////////////////////////////////cmp
; #define EEPROM_BUS_ADDRESS 0xc0
;int cmp=0;
;/* read a byte from the EEPROM */
;unsigned char compass_read(unsigned char address) {
; 0000 0029 unsigned char compass_read(unsigned char address) {

	.CSEG
_compass_read:
; .FSTART _compass_read
; 0000 002A unsigned char data;
; 0000 002B i2c_start();
	ST   -Y,R26
	ST   -Y,R17
;	address -> Y+1
;	data -> R17
	CALL _i2c_start
; 0000 002C i2c_write(EEPROM_BUS_ADDRESS);
	LDI  R26,LOW(192)
	CALL _i2c_write
; 0000 002D i2c_write(address);
	LDD  R26,Y+1
	CALL SUBOPT_0x0
; 0000 002E i2c_start();
; 0000 002F i2c_write(EEPROM_BUS_ADDRESS | 1);
	LDI  R26,LOW(193)
	CALL _i2c_write
; 0000 0030 data=i2c_read(0);
	LDI  R26,LOW(0)
	CALL _i2c_read
	MOV  R17,R30
; 0000 0031 i2c_stop();
	CALL _i2c_stop
; 0000 0032 return data;
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,2
	RET
; 0000 0033 }
; .FEND
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x15 ;PORTC
; 0000 0037 #endasm
;#include <lcd.h>
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART1 Receiver buffer
;#define RX_BUFFER_SIZE1 8
;char rx_buffer1[RX_BUFFER_SIZE1];
;
;#if RX_BUFFER_SIZE1<256
;unsigned char rx_wr_index1,rx_rd_index1,rx_counter1;
;#else
;unsigned int rx_wr_index1,rx_rd_index1,rx_counter1;
;#endif
;
;// This flag is set on USART1 Receiver buffer overflow
;bit rx_buffer_overflow1;
;
;   int t=0,u=0,n=0;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0000 006C {
_usart1_rx_isr:
; .FSTART _usart1_rx_isr
	CALL SUBOPT_0x1
; 0000 006D char status,data;
; 0000 006E status=UCSR1A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,155
; 0000 006F data=UDR1;
	LDS  R16,156
; 0000 0070  u=0;
	CLR  R12
	CLR  R13
; 0000 0071 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0072    {
; 0000 0073    rx_buffer1[rx_wr_index1]=data;
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	ST   Z,R16
; 0000 0074    if (++rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x4
	CLR  R7
; 0000 0075    if (++rx_counter1 == RX_BUFFER_SIZE1)
_0x4:
	INC  R9
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x5
; 0000 0076       {
; 0000 0077       rx_counter1=0;
	CLR  R9
; 0000 0078       rx_buffer_overflow1=1;
	SET
	BLD  R2,0
; 0000 0079       };
_0x5:
; 0000 007A    };
_0x3:
; 0000 007B     if (data=='1'){
	CPI  R16,49
	BRNE _0x6
; 0000 007C    lcd_gotoxy(12,1);
	CALL SUBOPT_0x2
; 0000 007D    lcd_putchar('1');
	LDI  R26,LOW(49)
	CALL _lcd_putchar
; 0000 007E    t=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 007F    }
; 0000 0080    else    if (data=='2'){
	RJMP _0x7
_0x6:
	CPI  R16,50
	BRNE _0x8
; 0000 0081    lcd_gotoxy(12,1);
	CALL SUBOPT_0x2
; 0000 0082    lcd_putchar('2');
	LDI  R26,LOW(50)
	CALL _lcd_putchar
; 0000 0083    t=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R10,R30
; 0000 0084    }
; 0000 0085     else {
	RJMP _0x9
_0x8:
; 0000 0086    lcd_gotoxy(12,1);
	CALL SUBOPT_0x2
; 0000 0087    lcd_putchar('n');
	LDI  R26,LOW(110)
	CALL _lcd_putchar
; 0000 0088    t=0;}
	CLR  R10
	CLR  R11
_0x9:
_0x7:
; 0000 0089 }
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x13C
; .FEND
;
;// Get a character from the USART1 Receiver buffer
;#pragma used+
;char getchar1(void)
; 0000 008E {
; 0000 008F char data;
; 0000 0090 while (rx_counter1==0);
;	data -> R17
; 0000 0091 data=rx_buffer1[rx_rd_index1];
; 0000 0092 if (++rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
; 0000 0093 #asm("cli")
; 0000 0094 --rx_counter1;
; 0000 0095 #asm("sei")
; 0000 0096 return data;
; 0000 0097 }
;#pragma used-
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(char c)
; 0000 009C {
; 0000 009D while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
; 0000 009E UDR1=c;
; 0000 009F }
;#pragma used-
;int s=0,i=0,SRFR,SRFB,SRFL;
;unsigned int data_srf;
;unsigned int data0_srf;
;unsigned int data1_srf;
;unsigned int data2_srf;
;void write_i2c(unsigned char busaddres , unsigned char reg , unsigned char data)
; 0000 00A7 {
; 0000 00A8 #asm ("wdr");
;	busaddres -> Y+2
;	reg -> Y+1
;	data -> Y+0
; 0000 00A9 i2c_start();
; 0000 00AA i2c_write(busaddres);
; 0000 00AB i2c_write(reg);
; 0000 00AC i2c_write(data);
; 0000 00AD i2c_stop();
; 0000 00AE }
;int RL=0;
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
; 0000 00B1 {
_timer3_ovf_isr:
; .FSTART _timer3_ovf_isr
	CALL SUBOPT_0x1
; 0000 00B2 s++;
	LDI  R26,LOW(_s)
	LDI  R27,HIGH(_s)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 00B3 TCCR3B=0x00;
	CALL SUBOPT_0x3
; 0000 00B4 TCNT3H=0x00;
; 0000 00B5 TCNT3L=0x00;
; 0000 00B6 if (s==6){
	LDS  R26,_s
	LDS  R27,_s+1
	SBIW R26,6
	BREQ PC+2
	RJMP _0x11
; 0000 00B7 i2c_start();
	CALL _i2c_start
; 0000 00B8 i2c_write(0xE0);
	LDI  R26,LOW(224)
	CALL SUBOPT_0x4
; 0000 00B9 i2c_write(0x01);
; 0000 00BA i2c_start();
; 0000 00BB i2c_write(0xE0|1);
	LDI  R26,LOW(225)
	CALL SUBOPT_0x5
; 0000 00BC data0_srf=i2c_read(1);
; 0000 00BD data1_srf=i2c_read(1);
; 0000 00BE data2_srf=i2c_read(0);
; 0000 00BF data_srf=data1_srf;
; 0000 00C0 data_srf=data_srf<<8;
; 0000 00C1 data_srf=data_srf | data2_srf;
; 0000 00C2 i2c_stop();
; 0000 00C3 SRFR=data_srf;
	STS  _SRFR,R30
	STS  _SRFR+1,R31
; 0000 00C4 //////////////////////////////////////////////////////////
; 0000 00C5 i2c_start();
	CALL _i2c_start
; 0000 00C6 i2c_write(0xE2);
	LDI  R26,LOW(226)
	CALL SUBOPT_0x4
; 0000 00C7 i2c_write(0x01);
; 0000 00C8 i2c_start();
; 0000 00C9 i2c_write(0xE2|1);
	LDI  R26,LOW(227)
	CALL SUBOPT_0x5
; 0000 00CA data0_srf=i2c_read(1);
; 0000 00CB data1_srf=i2c_read(1);
; 0000 00CC data2_srf=i2c_read(0);
; 0000 00CD data_srf=data1_srf;
; 0000 00CE data_srf=data_srf<<8;
; 0000 00CF data_srf=data_srf | data2_srf;
; 0000 00D0 i2c_stop();
; 0000 00D1 SRFB=data_srf;
	STS  _SRFB,R30
	STS  _SRFB+1,R31
; 0000 00D2 ///////////////////////////////////////////////////////////////
; 0000 00D3  i2c_start();
	CALL _i2c_start
; 0000 00D4 i2c_write(0xE4);
	LDI  R26,LOW(228)
	CALL SUBOPT_0x4
; 0000 00D5 i2c_write(0x01);
; 0000 00D6 i2c_start();
; 0000 00D7 i2c_write(0xE4|1);
	LDI  R26,LOW(229)
	CALL SUBOPT_0x5
; 0000 00D8 data0_srf=i2c_read(1);
; 0000 00D9 data1_srf=i2c_read(1);
; 0000 00DA data2_srf=i2c_read(0);
; 0000 00DB data_srf=data1_srf;
; 0000 00DC data_srf=data_srf<<8;
; 0000 00DD data_srf=data_srf | data2_srf;
; 0000 00DE i2c_stop();
; 0000 00DF SRFL=data_srf;
	STS  _SRFL,R30
	STS  _SRFL+1,R31
; 0000 00E0 /////////
; 0000 00E1 lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x6
; 0000 00E2 lcd_putchar((SRFR/100)%10 +'0');
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
; 0000 00E3 lcd_putchar((SRFR/10)%10 +'0');
	CALL SUBOPT_0x7
	CALL SUBOPT_0x9
; 0000 00E4 lcd_putchar((SRFR/1)%10 +'0');
	CALL SUBOPT_0x7
	CALL SUBOPT_0xA
; 0000 00E5 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x6
; 0000 00E6 lcd_putchar((SRFL/100)%10 +'0');
	CALL SUBOPT_0xB
	CALL SUBOPT_0x8
; 0000 00E7 lcd_putchar((SRFL/10)%10 +'0');
	CALL SUBOPT_0xB
	CALL SUBOPT_0x9
; 0000 00E8 lcd_putchar((SRFL/1)%10 +'0');
	CALL SUBOPT_0xB
	CALL SUBOPT_0xA
; 0000 00E9 lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x6
; 0000 00EA lcd_putchar((SRFB/100)%10 +'0');
	CALL SUBOPT_0xC
	CALL SUBOPT_0x8
; 0000 00EB lcd_putchar((SRFB/10)%10 +'0');
	CALL SUBOPT_0xC
	CALL SUBOPT_0x9
; 0000 00EC lcd_putchar((SRFB/1)%10 +'0');
	CALL SUBOPT_0xC
	CALL SUBOPT_0xA
; 0000 00ED s=0;
	LDI  R30,LOW(0)
	STS  _s,R30
	STS  _s+1,R30
; 0000 00EE }
; 0000 00EF RL=SRFR-SRFL;
_0x11:
	CALL SUBOPT_0xB
	LDS  R30,_SRFR
	LDS  R31,_SRFR+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _RL,R30
	STS  _RL+1,R31
; 0000 00F0       if(RL>=0)
	LDS  R26,_RL+1
	TST  R26
	BRMI _0x12
; 0000 00F1       {  #asm ("wdr");
	wdr
; 0000 00F2        lcd_gotoxy(12,1);
	CALL SUBOPT_0x2
; 0000 00F3       lcd_putchar('+');
	LDI  R26,LOW(43)
	CALL _lcd_putchar
; 0000 00F4       lcd_putchar((RL/100)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0x8
; 0000 00F5       lcd_putchar((RL/10)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0x9
; 0000 00F6       lcd_putchar((RL/1)%10+'0');
	CALL SUBOPT_0xD
	RJMP _0x126
; 0000 00F7       }
; 0000 00F8       else if(RL<0)
_0x12:
	LDS  R26,_RL+1
	TST  R26
	BRPL _0x14
; 0000 00F9       {  #asm ("wdr");
	wdr
; 0000 00FA        lcd_gotoxy(12,1);
	CALL SUBOPT_0x2
; 0000 00FB       lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL _lcd_putchar
; 0000 00FC       lcd_putchar((-RL/100)%10+'0');
	CALL SUBOPT_0xE
	CALL SUBOPT_0x8
; 0000 00FD       lcd_putchar((-RL/10)%10+'0');
	CALL SUBOPT_0xE
	CALL SUBOPT_0x9
; 0000 00FE       lcd_putchar((-RL/1)%10+'0');
	CALL SUBOPT_0xE
_0x126:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0xF
; 0000 00FF       }
; 0000 0100       if (RL<=20 && RL>=-20) RL=0;
_0x14:
	CALL SUBOPT_0xD
	SBIW R26,21
	BRGE _0x16
	CALL SUBOPT_0xD
	CPI  R26,LOW(0xFFEC)
	LDI  R30,HIGH(0xFFEC)
	CPC  R27,R30
	BRGE _0x17
_0x16:
	RJMP _0x15
_0x17:
	LDI  R30,LOW(0)
	STS  _RL,R30
	STS  _RL+1,R30
; 0000 0101       else RL=RL*1.5;
	RJMP _0x18
_0x15:
	LDS  R30,_RL
	LDS  R31,_RL+1
	CALL SUBOPT_0x10
	__GETD2N 0x3FC00000
	CALL __MULF12
	LDI  R26,LOW(_RL)
	LDI  R27,HIGH(_RL)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 0102 }
_0x18:
_0x13C:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;#define ADC_VREF_TYPE 0x40
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0108 {
_read_adc:
; .FSTART _read_adc
; 0000 0109 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 010A // Delay needed for the stabilization of the ADC input voltage
; 0000 010B delay_us(10);
	__DELAY_USB 37
; 0000 010C // Start the AD conversion
; 0000 010D ADCSRA|=0x40;
	SBI  0x6,6
; 0000 010E // Wait for the AD conversion to complete
; 0000 010F while ((ADCSRA & 0x10)==0);
_0x19:
	SBIS 0x6,4
	RJMP _0x19
; 0000 0110 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0111 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 0112 }
; .FEND
;void motor(int ML1,int ML2,int MR2,int MR1)
; 0000 0114     {
_motor:
; .FSTART _motor
; 0000 0115     #asm("cli")  ;
	ST   -Y,R27
	ST   -Y,R26
;	ML1 -> Y+6
;	ML2 -> Y+4
;	MR2 -> Y+2
;	MR1 -> Y+0
	cli
; 0000 0116     #asm("wdr") ;
	wdr
; 0000 0117 
; 0000 0118     if(ML1<-255) ML1=-255;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x1C
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0119     if(ML2<-255) ML2=-255;
_0x1C:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x1D
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 011A     if(MR1<-255) MR1=-255;
_0x1D:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x1E
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   Y,R30
	STD  Y+1,R31
; 0000 011B     if(MR2<-255) MR2=-255;
_0x1E:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x1F
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 011C 
; 0000 011D     if(ML1>255) ML1=255;
_0x1F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x20
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 011E     if(ML2>255) ML2=255;
_0x20:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x21
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 011F     if(MR1>255) MR1=255;
_0x21:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x22
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0120     if(MR2>255) MR2=255;
_0x22:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x23
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0121     /////////////////////////////////
; 0000 0122     if(ML1>=0){
_0x23:
	LDD  R26,Y+7
	TST  R26
	BRMI _0x24
; 0000 0123     PORTD.7=0;
	CBI  0x12,7
; 0000 0124     OCR2=ML1;}
	RJMP _0x127
; 0000 0125     else if(ML1<0){
_0x24:
	LDD  R26,Y+7
	TST  R26
	BRPL _0x28
; 0000 0126     PORTD.7=1;
	SBI  0x12,7
; 0000 0127     OCR2=ML1;}
_0x127:
	LDD  R30,Y+6
	OUT  0x23,R30
; 0000 0128 
; 0000 0129 
; 0000 012A 
; 0000 012B     /////////////////////////
; 0000 012C     if(ML2>=0)
_0x28:
	LDD  R26,Y+5
	TST  R26
	BRMI _0x2B
; 0000 012D     {
; 0000 012E     PORTD.6=0;
	CBI  0x12,6
; 0000 012F     OCR1B=ML2;
	RJMP _0x128
; 0000 0130     }
; 0000 0131     else if(ML2<0){
_0x2B:
	LDD  R26,Y+5
	TST  R26
	BRPL _0x2F
; 0000 0132     PORTD.6=1;
	SBI  0x12,6
; 0000 0133     OCR1B=ML2;}
_0x128:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 0134 
; 0000 0135     /////////////////////////
; 0000 0136     if(MR1>=0){
_0x2F:
	LDD  R26,Y+1
	TST  R26
	BRMI _0x32
; 0000 0137     PORTD.4=0;
	CBI  0x12,4
; 0000 0138     OCR0=MR1;}
	RJMP _0x129
; 0000 0139     else if(MR1<0){
_0x32:
	LDD  R26,Y+1
	TST  R26
	BRPL _0x36
; 0000 013A     PORTD.4=1;
	SBI  0x12,4
; 0000 013B     OCR0=MR1;}
_0x129:
	LD   R30,Y
	OUT  0x31,R30
; 0000 013C 
; 0000 013D     ////////////////////////
; 0000 013E     if(MR2>=0){
_0x36:
	LDD  R26,Y+3
	TST  R26
	BRMI _0x39
; 0000 013F     PORTD.5=0;
	CBI  0x12,5
; 0000 0140     OCR1A=MR2;}
	RJMP _0x12A
; 0000 0141     else if(MR2<0){
_0x39:
	LDD  R26,Y+3
	TST  R26
	BRPL _0x3D
; 0000 0142     PORTD.5=1;
	SBI  0x12,5
; 0000 0143     OCR1A=MR2;}
_0x12A:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0144     #asm("wdr") ;
_0x3D:
	wdr
; 0000 0145     #asm("sei") ;
	sei
; 0000 0146     }
	ADIW R28,8
	RET
; .FEND
;#define KAF 500
;int adc[16],min=0,i,kaf[16],mini=0,r=0,l=0,f=0,b=0,p=0,h=0;
;unsigned char chr1='N';
;void sensor()
; 0000 014B     {
_sensor:
; .FSTART _sensor
; 0000 014C     #asm("cli");
	cli
; 0000 014D     #asm("wdr")
	wdr
; 0000 014E     for(i=0;i<16;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
_0x41:
	CALL SUBOPT_0x11
	SBIW R26,16
	BRLT PC+2
	RJMP _0x42
; 0000 014F         {
; 0000 0150 
; 0000 0151         #asm("wdr")  ;
	wdr
; 0000 0152         PORTA.3=(i/8)%2;
	CALL SUBOPT_0x11
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x12
	BRNE _0x43
	CBI  0x1B,3
	RJMP _0x44
_0x43:
	SBI  0x1B,3
_0x44:
; 0000 0153         PORTA.2=(i/4)%2;
	CALL SUBOPT_0x11
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x12
	BRNE _0x45
	CBI  0x1B,2
	RJMP _0x46
_0x45:
	SBI  0x1B,2
_0x46:
; 0000 0154         PORTA.1=(i/2)%2;
	CALL SUBOPT_0x11
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x12
	BRNE _0x47
	CBI  0x1B,1
	RJMP _0x48
_0x47:
	SBI  0x1B,1
_0x48:
; 0000 0155         PORTA.0=(i/1)%2;
	CALL SUBOPT_0x13
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __MANDW12
	CPI  R30,0
	BRNE _0x49
	CBI  0x1B,0
	RJMP _0x4A
_0x49:
	SBI  0x1B,0
_0x4A:
; 0000 0156         adc[i]=read_adc(7);
	CALL SUBOPT_0x14
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R26,LOW(7)
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 0157         kaf[i]=read_adc(6);
	CALL SUBOPT_0x15
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R26,LOW(6)
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 0158         ////////////////////////////////////////////////////////////moghayese
; 0000 0159         if (adc[i]<adc[min])
	CALL SUBOPT_0x14
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X+
	LD   R1,X
	CALL SUBOPT_0x16
	CP   R0,R30
	CPC  R1,R31
	BRGE _0x4B
; 0000 015A         min=i;
	CALL SUBOPT_0x13
	STS  _min,R30
	STS  _min+1,R31
; 0000 015B 
; 0000 015C         if (kaf[i]<kaf[mini])
_0x4B:
	CALL SUBOPT_0x15
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X+
	LD   R1,X
	CALL SUBOPT_0x17
	CP   R0,R30
	CPC  R1,R31
	BRGE _0x4C
; 0000 015D         mini=i;
	CALL SUBOPT_0x13
	STS  _mini,R30
	STS  _mini+1,R31
; 0000 015E 
; 0000 015F         }
_0x4C:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x41
_0x42:
; 0000 0160     h=(adc[1]+adc[15]+adc[0] )/3;
	__GETW2MN _adc,2
	__GETW1MN _adc,30
	ADD  R30,R26
	ADC  R31,R27
	LDS  R26,_adc
	LDS  R27,_adc+1
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __DIVW21
	STS  _h,R30
	STS  _h+1,R31
; 0000 0161 
; 0000 0162     if(chr1=='R' && (kaf[12]<KAF || kaf[13]<KAF || kaf[14]<KAF || kaf[15]<KAF || kaf[0]<KAF || kaf[1]<KAF ))       p=1;
	LDI  R30,LOW(82)
	CP   R30,R8
	BRNE _0x4E
	CALL SUBOPT_0x18
	BRLT _0x4F
	CALL SUBOPT_0x19
	BRLT _0x4F
	CALL SUBOPT_0x1A
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLT _0x4F
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLT _0x4F
	CALL SUBOPT_0x1C
	BRLT _0x4F
	CALL SUBOPT_0x1D
	BRGE _0x4E
_0x4F:
	RJMP _0x51
_0x4E:
	RJMP _0x4D
_0x51:
	RJMP _0x12B
; 0000 0163     else if(chr1=='L' && (kaf[0]<KAF || kaf[1]<KAF || kaf[2]<KAF || kaf[3]<KAF ||kaf[12]<KAF || kaf[13]<KAF ))     p=1;
_0x4D:
	LDI  R30,LOW(76)
	CP   R30,R8
	BRNE _0x54
	CALL SUBOPT_0x1C
	BRLT _0x55
	CALL SUBOPT_0x1D
	BRLT _0x55
	CALL SUBOPT_0x1E
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLT _0x55
	CALL SUBOPT_0x1F
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLT _0x55
	CALL SUBOPT_0x18
	BRLT _0x55
	CALL SUBOPT_0x19
	BRGE _0x54
_0x55:
	RJMP _0x57
_0x54:
	RJMP _0x53
_0x57:
	RJMP _0x12B
; 0000 0164     else if(chr1=='F' && (kaf[4]<KAF || kaf[5]<KAF || kaf[6]<KAF || kaf[7]<KAF || kaf[0]<KAF || kaf[12]<KAF ))           ...
_0x53:
	LDI  R30,LOW(70)
	CP   R30,R8
	BRNE _0x5A
	__GETW2MN _kaf,8
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLT _0x5B
	__GETW2MN _kaf,10
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLT _0x5B
	__GETW2MN _kaf,12
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLT _0x5B
	__GETW2MN _kaf,14
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLT _0x5B
	CALL SUBOPT_0x1C
	BRLT _0x5B
	CALL SUBOPT_0x18
	BRGE _0x5A
_0x5B:
	RJMP _0x5D
_0x5A:
	RJMP _0x59
_0x5D:
_0x12B:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _p,R30
	STS  _p+1,R31
; 0000 0165 
; 0000 0166     if(chr1!='N')
_0x59:
	LDI  R30,LOW(78)
	CP   R30,R8
	BREQ _0x5E
; 0000 0167       {
; 0000 0168       if((kaf[2]<=KAF || kaf[3]<=KAF )&& chr1=='R')  p=0;
	CALL SUBOPT_0x1E
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLT _0x60
	CALL SUBOPT_0x1F
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRGE _0x62
_0x60:
	LDI  R30,LOW(82)
	CP   R30,R8
	BREQ _0x63
_0x62:
	RJMP _0x5F
_0x63:
	RJMP _0x12C
; 0000 0169       else if((kaf[14]<=KAF || kaf[15]<=KAF)&& chr1=='L')  p=0;
_0x5F:
	CALL SUBOPT_0x1A
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLT _0x66
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRGE _0x68
_0x66:
	LDI  R30,LOW(76)
	CP   R30,R8
	BREQ _0x69
_0x68:
	RJMP _0x65
_0x69:
	RJMP _0x12C
; 0000 016A       else if((kaf[10]<=KAF || kaf[11]<=KAF || kaf[9]<=KAF)&& chr1=='F')  p=0;
_0x65:
	CALL SUBOPT_0x20
	BRLT _0x6C
	CALL SUBOPT_0x21
	BRLT _0x6C
	CALL SUBOPT_0x22
	BRGE _0x6E
_0x6C:
	LDI  R30,LOW(70)
	CP   R30,R8
	BREQ _0x6F
_0x6E:
	RJMP _0x6B
_0x6F:
_0x12C:
	LDI  R30,LOW(0)
	STS  _p,R30
	STS  _p+1,R30
; 0000 016B       }
_0x6B:
; 0000 016C 
; 0000 016D     ///////////////////////////////////////////////////////////chap
; 0000 016E     lcd_gotoxy(0,0);
_0x5E:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x23
; 0000 016F     lcd_putchar((min/10)%10+'0');
	CALL SUBOPT_0x24
	CALL SUBOPT_0x9
; 0000 0170     lcd_putchar((min/1)%10+'0');
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA
; 0000 0171     lcd_putchar('=');
	LDI  R26,LOW(61)
	CALL _lcd_putchar
; 0000 0172     lcd_putchar((adc[min]/1000)%10+'0');
	CALL SUBOPT_0x16
	CALL SUBOPT_0x25
; 0000 0173     lcd_putchar((adc[min]/100)%10+'0');
	CALL SUBOPT_0x16
	MOVW R26,R30
	CALL SUBOPT_0x8
; 0000 0174     lcd_putchar((adc[min]/10)%10+'0');
	CALL SUBOPT_0x16
	MOVW R26,R30
	CALL SUBOPT_0x9
; 0000 0175     lcd_putchar((adc[min]/1)%10+'0');
	CALL SUBOPT_0x16
	MOVW R26,R30
	CALL SUBOPT_0xA
; 0000 0176     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x6
; 0000 0177     lcd_putchar((mini/10)%10+'0');
	CALL SUBOPT_0x26
	CALL SUBOPT_0x9
; 0000 0178     lcd_putchar((mini/1)%10+'0');
	CALL SUBOPT_0x26
	CALL SUBOPT_0xA
; 0000 0179     lcd_putchar('=');
	LDI  R26,LOW(61)
	CALL _lcd_putchar
; 0000 017A     lcd_putchar((kaf[mini]/1000)%10+'0');
	CALL SUBOPT_0x17
	CALL SUBOPT_0x25
; 0000 017B     lcd_putchar((kaf[mini]/100)%10+'0');
	CALL SUBOPT_0x17
	MOVW R26,R30
	CALL SUBOPT_0x8
; 0000 017C     lcd_putchar((kaf[mini]/10)%10+'0');
	CALL SUBOPT_0x17
	MOVW R26,R30
	CALL SUBOPT_0x9
; 0000 017D     lcd_putchar((kaf[mini]/1)%10+'0');
	CALL SUBOPT_0x17
	MOVW R26,R30
	CALL SUBOPT_0xA
; 0000 017E     lcd_gotoxy(15,0) ;
	LDI  R30,LOW(15)
	CALL SUBOPT_0x23
; 0000 017F     lcd_putchar((p/1)%10 + '0' ) ;
	CALL SUBOPT_0x27
	CALL SUBOPT_0xA
; 0000 0180     #asm("wdr") ;
	wdr
; 0000 0181     }
	RET
; .FEND
;
;int SL,SR,SB,sum=0;
;void read_sharp()
; 0000 0185     {
_read_sharp:
; .FSTART _read_sharp
; 0000 0186     #asm("cli") ;
	cli
; 0000 0187     #asm("wdr") ;
	wdr
; 0000 0188     SB=read_adc(5);
	LDI  R26,LOW(5)
	RCALL _read_adc
	STS  _SB,R30
	STS  _SB+1,R31
; 0000 0189     SR=read_adc(4);
	LDI  R26,LOW(4)
	RCALL _read_adc
	STS  _SR,R30
	STS  _SR+1,R31
; 0000 018A     SL=read_adc(3);
	LDI  R26,LOW(3)
	RCALL _read_adc
	STS  _SL,R30
	STS  _SL+1,R31
; 0000 018B 
; 0000 018C     lcd_gotoxy(13,1);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x6
; 0000 018D     lcd_putchar((SR/100)%10+'0');
	CALL SUBOPT_0x28
	CALL SUBOPT_0x8
; 0000 018E     lcd_putchar((SR/10)%10+'0');
	CALL SUBOPT_0x28
	CALL SUBOPT_0x9
; 0000 018F     lcd_putchar((SR/1)%10+'0');
	CALL SUBOPT_0x28
	CALL SUBOPT_0xA
; 0000 0190 
; 0000 0191     lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x23
; 0000 0192     lcd_putchar((SB/100)%10+'0');
	CALL SUBOPT_0x29
	CALL SUBOPT_0x8
; 0000 0193     lcd_putchar((SB/10)%10+'0');
	CALL SUBOPT_0x29
	CALL SUBOPT_0x9
; 0000 0194     lcd_putchar((SB/1)%10+'0');
	CALL SUBOPT_0x29
	CALL SUBOPT_0xA
; 0000 0195 
; 0000 0196     lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x6
; 0000 0197     lcd_putchar((SL/100)%10+'0');
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x8
; 0000 0198     lcd_putchar((SL/10)%10+'0');
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x9
; 0000 0199     lcd_putchar((SL/1)%10+'0');
	CALL SUBOPT_0x2A
	CALL SUBOPT_0xA
; 0000 019A 
; 0000 019B     sum=SL-SR;
	CALL SUBOPT_0x28
	LDS  R30,_SL
	LDS  R31,_SL+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _sum,R30
	STS  _sum+1,R31
; 0000 019C     }
	RET
; .FEND
;void compass()
; 0000 019E     {
_compass:
; .FSTART _compass
; 0000 019F     #asm("wdr");
	wdr
; 0000 01A0       cmp=compass_read(1)-c;
	LDI  R26,LOW(1)
	CALL _compass_read
	MOV  R0,R30
	CLR  R1
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	CALL __EEPROMRDW
	MOVW R26,R0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R4,R26
; 0000 01A1       lcd_gotoxy(12,0);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x23
; 0000 01A2       if(cmp<0) cmp=cmp;
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRGE _0x70
	MOVW R4,R4
; 0000 01A3       if(cmp>128) cmp=cmp-255;
_0x70:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x71
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	__SUBWRR 4,5,30,31
; 0000 01A4       if(cmp<-128) cmp=cmp+255;
_0x71:
	LDI  R30,LOW(65408)
	LDI  R31,HIGH(65408)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x72
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	MOVW R4,R30
; 0000 01A5 
; 0000 01A6       if(cmp>=0)
_0x72:
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRLT _0x73
; 0000 01A7       {  #asm ("wdr");
	wdr
; 0000 01A8        lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x23
; 0000 01A9       lcd_putchar('+');
	LDI  R26,LOW(43)
	CALL _lcd_putchar
; 0000 01AA       lcd_putchar((cmp/100)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0x8
; 0000 01AB       lcd_putchar((cmp/10)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0x9
; 0000 01AC       lcd_putchar((cmp/1)%10+'0');
	MOVW R26,R4
	RJMP _0x12D
; 0000 01AD       }
; 0000 01AE       else if(cmp<0)
_0x73:
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRGE _0x75
; 0000 01AF       {
; 0000 01B0       #asm ("wdr");
	wdr
; 0000 01B1       lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x23
; 0000 01B2       lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL _lcd_putchar
; 0000 01B3       lcd_putchar((-cmp/100)%10+'0');
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x8
; 0000 01B4       lcd_putchar((-cmp/10)%10+'0');
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x9
; 0000 01B5       lcd_putchar((-cmp/1)%10+'0');
	CALL SUBOPT_0x2B
_0x12D:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0xF
; 0000 01B6       }
; 0000 01B7 
; 0000 01B8        if(cmp>-40 && cmp<30)   cmp=(float)-cmp*3;
_0x75:
	LDI  R30,LOW(65496)
	LDI  R31,HIGH(65496)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x77
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R4,R30
	CPC  R5,R31
	BRLT _0x78
_0x77:
	RJMP _0x76
_0x78:
	MOVW R30,R4
	CALL __ANEGW1
	CALL SUBOPT_0x10
	__GETD2N 0x40400000
	RJMP _0x12E
; 0000 01B9       else  cmp=(float)-cmp*2.5;
_0x76:
	MOVW R30,R4
	CALL __ANEGW1
	CALL SUBOPT_0x10
	__GETD2N 0x40200000
_0x12E:
	CALL __MULF12
	CALL __CFD1
	MOVW R4,R30
; 0000 01BA 
; 0000 01BB     }
	RET
; .FEND
;void sahmi()
; 0000 01BD {
; 0000 01BE     if(SB<150 )  motor(-255-RL+cmp,-255+RL+cmp,255+RL-cmp,255-RL+cmp);
; 0000 01BF     ///////////////////////////////////////////////////////////////
; 0000 01C0     else if(SB>300  && RL>-80 && RL<40)  motor(255/4+RL+cmp,255/4-RL+cmp,-255/4-RL+cmp,-255/4+RL+cmp);
; 0000 01C1 
; 0000 01C2            //////////////////////////////////////////////////////////////
; 0000 01C3     else if(SB>300 && (RL<-60|| RL>40 )  )
; 0000 01C4     {
; 0000 01C5             RL=(float)RL*1.2;
; 0000 01C6             motor(-RL+cmp,RL+cmp,RL+cmp,-RL+cmp);
; 0000 01C7     }
; 0000 01C8     else{
; 0000 01C9      motor(0+cmp/2,0+cmp/2,0+cmp/2,0+cmp/2);
; 0000 01CA      }
; 0000 01CB 
; 0000 01CC     #asm ("wdr");
; 0000 01CD 
; 0000 01CE     }
;
;void catch()
; 0000 01D1       {
_catch:
; .FSTART _catch
; 0000 01D2       #asm("wdr")
	wdr
; 0000 01D3       compass();
	CALL SUBOPT_0x2C
; 0000 01D4       sensor();
; 0000 01D5       read_sharp();
; 0000 01D6       if(chr1=='N') {
	LDI  R30,LOW(78)
	CP   R30,R8
	BREQ PC+2
	RJMP _0x86
; 0000 01D7       if(kaf[0]<=KAF || kaf[1]<=KAF || kaf[2]<=KAF || kaf[3]<=KAF)  chr1='R';
	LDS  R26,_kaf
	LDS  R27,_kaf+1
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLT _0x88
	__GETW2MN _kaf,2
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLT _0x88
	CALL SUBOPT_0x1E
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLT _0x88
	CALL SUBOPT_0x1F
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRGE _0x87
_0x88:
	LDI  R30,LOW(82)
	RJMP _0x131
; 0000 01D8       else if(kaf[12]<=KAF || kaf[13]<=KAF || kaf[14]<=KAF || kaf[15]<=KAF)  chr1='L';
_0x87:
	__GETW2MN _kaf,24
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLT _0x8C
	__GETW2MN _kaf,26
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLT _0x8C
	CALL SUBOPT_0x1A
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLT _0x8C
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRGE _0x8B
_0x8C:
	LDI  R30,LOW(76)
	RJMP _0x131
; 0000 01D9       else if(kaf[4]<=KAF || kaf[5]<=KAF || kaf[6]<=KAF || kaf[7]<=KAF)  chr1='B';
_0x8B:
	__GETW2MN _kaf,8
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLT _0x90
	__GETW2MN _kaf,10
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLT _0x90
	__GETW2MN _kaf,12
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLT _0x90
	__GETW2MN _kaf,14
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRGE _0x8F
_0x90:
	LDI  R30,LOW(66)
	RJMP _0x131
; 0000 01DA       else if(kaf[9]<=KAF || kaf[10]<=KAF || kaf[11]<=KAF)  chr1='F';
_0x8F:
	CALL SUBOPT_0x22
	BRLT _0x94
	CALL SUBOPT_0x20
	BRLT _0x94
	CALL SUBOPT_0x21
	BRGE _0x93
_0x94:
	LDI  R30,LOW(70)
_0x131:
	MOV  R8,R30
; 0000 01DB             }
_0x93:
; 0000 01DC 
; 0000 01DD       if(adc[min]<800 )
_0x86:
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x320)
	LDI  R26,HIGH(0x320)
	CPC  R31,R26
	BRLT PC+2
	RJMP _0x96
; 0000 01DE          {
; 0000 01DF          if(kaf[mini]<KAF)
	CALL SUBOPT_0x17
	CPI  R30,LOW(0x1F4)
	LDI  R26,HIGH(0x1F4)
	CPC  R31,R26
	BRLT PC+2
	RJMP _0x97
; 0000 01E0             {
; 0000 01E1             #asm("wdr")
	wdr
; 0000 01E2             compass();
	CALL SUBOPT_0x2C
; 0000 01E3             sensor();
; 0000 01E4             read_sharp();
; 0000 01E5             while((SR>=300 ) || chr1=='R' )
_0x98:
	CALL SUBOPT_0x28
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRGE _0x9B
	LDI  R30,LOW(82)
	CP   R30,R8
	BREQ _0x9B
	RJMP _0x9A
_0x9B:
; 0000 01E6                 {
; 0000 01E7                 #asm("wdr")
	wdr
; 0000 01E8                 compass();
	CALL SUBOPT_0x2C
; 0000 01E9                 sensor();
; 0000 01EA                 read_sharp();
; 0000 01EB                 if (min<=15 && min>=9 ) chr1='N';
	CALL SUBOPT_0x24
	SBIW R26,16
	BRGE _0x9E
	CALL SUBOPT_0x24
	SBIW R26,9
	BRGE _0x9F
_0x9E:
	RJMP _0x9D
_0x9F:
	LDI  R30,LOW(78)
	MOV  R8,R30
; 0000 01EC                 if(SR>450 || p==1)          motor(-128+cmp,128+cmp,128+cmp,-128+cmp);
_0x9D:
	CALL SUBOPT_0x28
	CPI  R26,LOW(0x1C3)
	LDI  R30,HIGH(0x1C3)
	CPC  R27,R30
	BRGE _0xA1
	CALL SUBOPT_0x27
	SBIW R26,1
	BRNE _0xA0
_0xA1:
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
	MOVW R30,R4
	CALL SUBOPT_0x2E
	MOVW R26,R4
	SUBI R26,LOW(-65408)
	SBCI R27,HIGH(-65408)
	RJMP _0x132
; 0000 01ED                 //else if(min==0 )    motor(255+cmp,255+cmp,-255+cmp,-255+cmp);
; 0000 01EE                 else if(min==9)     motor(-128+cmp,-255+cmp,128+cmp,255+cmp);         //motor(-255,-128,255,128);
_0xA0:
	CALL SUBOPT_0x24
	SBIW R26,9
	BRNE _0xA4
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2F
	MOVW R26,R4
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x132
; 0000 01EF                 else if(min==10)    motor(-128+cmp,-255+cmp,128+cmp,255+cmp);   //motor(-255,0,255,0);
_0xA4:
	CALL SUBOPT_0x24
	SBIW R26,10
	BRNE _0xA6
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2F
	MOVW R26,R4
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x132
; 0000 01F0                 else if(min==11)    motor(-255+cmp,-128+cmp,255+cmp,128+cmp);   //motor(-255,128,255,-128);
_0xA6:
	CALL SUBOPT_0x24
	SBIW R26,11
	BRNE _0xA8
	CALL SUBOPT_0x30
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x31
	SUBI R26,LOW(-128)
	SBCI R27,HIGH(-128)
	RJMP _0x132
; 0000 01F1                 else if(min==12)    motor(-255+cmp,0+cmp,255+cmp,0+cmp);    //motor(-255,255,255,-255);
_0xA8:
	CALL SUBOPT_0x24
	SBIW R26,12
	BRNE _0xAA
	CALL SUBOPT_0x30
	CALL SUBOPT_0x32
	MOVW R30,R4
	CALL SUBOPT_0x31
	ADIW R26,0
	RJMP _0x132
; 0000 01F2                 else if(min==13)    motor(-255+cmp,128+cmp,255+cmp,-128+cmp);         //motor(-128,255,128,-255);
_0xAA:
	CALL SUBOPT_0x24
	SBIW R26,13
	BRNE _0xAC
	MOVW R30,R4
	CALL SUBOPT_0x2F
	MOVW R30,R4
	CALL SUBOPT_0x31
	SUBI R26,LOW(-65408)
	SBCI R27,HIGH(-65408)
	RJMP _0x132
; 0000 01F3                 else if(min==14)    motor(-255+cmp,255+cmp,255+cmp,-255+cmp);    //motor(0,255,0,-255);
_0xAC:
	CALL SUBOPT_0x24
	SBIW R26,14
	BRNE _0xAE
	CALL SUBOPT_0x30
	CALL SUBOPT_0x33
	MOVW R30,R4
	CALL SUBOPT_0x31
	SUBI R26,LOW(-65281)
	SBCI R27,HIGH(-65281)
	RJMP _0x132
; 0000 01F4                 else if(min==15)    motor(-128+cmp,255+cmp,128+cmp,-255+cmp); //motor(128,255,-128,-255);
_0xAE:
	CALL SUBOPT_0x24
	SBIW R26,15
	BRNE _0xB0
	CALL SUBOPT_0x2D
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	CALL SUBOPT_0x2E
	MOVW R26,R4
	SUBI R26,LOW(-65281)
	SBCI R27,HIGH(-65281)
	RJMP _0x132
; 0000 01F5                 else                motor(cmp,cmp,cmp,cmp);
_0xB0:
	CALL SUBOPT_0x34
_0x132:
	CALL _motor
; 0000 01F6                 }
	RJMP _0x98
_0x9A:
; 0000 01F7             while((SL>=300 ) || chr1=='L')
_0xB2:
	CALL SUBOPT_0x2A
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRGE _0xB5
	LDI  R30,LOW(76)
	CP   R30,R8
	BREQ _0xB5
	RJMP _0xB4
_0xB5:
; 0000 01F8                 {
; 0000 01F9                 #asm("wdr")
	wdr
; 0000 01FA                compass();
	CALL SUBOPT_0x2C
; 0000 01FB                 sensor();
; 0000 01FC                 read_sharp();
; 0000 01FD                 if (min<=7 && min>=1 ) chr1='N';
	CALL SUBOPT_0x24
	SBIW R26,8
	BRGE _0xB8
	CALL SUBOPT_0x24
	SBIW R26,1
	BRGE _0xB9
_0xB8:
	RJMP _0xB7
_0xB9:
	LDI  R30,LOW(78)
	MOV  R8,R30
; 0000 01FE                 if(SL>450 || p==1)          motor(128+cmp,-128+cmp,-128+cmp,128+cmp);
_0xB7:
	CALL SUBOPT_0x2A
	CPI  R26,LOW(0x1C3)
	LDI  R30,HIGH(0x1C3)
	CPC  R27,R30
	BRGE _0xBB
	CALL SUBOPT_0x27
	SBIW R26,1
	BRNE _0xBA
_0xBB:
	MOVW R30,R4
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x35
	SUBI R26,LOW(-128)
	SBCI R27,HIGH(-128)
	RJMP _0x133
; 0000 01FF                 //else if(min==0 )    motor(255+cmp,255+cmp,-255+cmp,-255+cmp);
; 0000 0200                 else if(min==1)     motor(255+cmp,0+cmp,-255+cmp,0+cmp);      //motor(255,128,-255,-128);
_0xBA:
	CALL SUBOPT_0x24
	SBIW R26,1
	BRNE _0xBE
	CALL SUBOPT_0x33
	CALL SUBOPT_0x32
	CALL SUBOPT_0x30
	MOVW R26,R4
	ADIW R26,0
	RJMP _0x133
; 0000 0201                 else if(min==2)     motor(255+cmp,-255+cmp,-255+cmp,255+cmp);     //motor(255,0,-255,0);
_0xBE:
	CALL SUBOPT_0x24
	SBIW R26,2
	BRNE _0xC0
	CALL SUBOPT_0x33
	CALL SUBOPT_0x30
	CALL SUBOPT_0x30
	MOVW R26,R4
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x133
; 0000 0202                 else if(min==3)     motor(128+cmp,-255+cmp,-128+cmp,255+cmp);    //motor(255,-128,-255,128);
_0xC0:
	CALL SUBOPT_0x24
	SBIW R26,3
	BRNE _0xC2
	MOVW R30,R4
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x30
	MOVW R30,R4
	CALL SUBOPT_0x35
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x133
; 0000 0203                 else if(min==4)     motor(128+cmp,-255+cmp,-128+cmp,255+cmp);        //motor(255,-255,-255,255);
_0xC2:
	CALL SUBOPT_0x24
	SBIW R26,4
	BRNE _0xC4
	MOVW R30,R4
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x30
	MOVW R30,R4
	CALL SUBOPT_0x35
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x133
; 0000 0204                 else if(min==5)     motor(-128+cmp,-255+cmp,128+cmp,255+cmp);   //motor(128,-255,-128,255);
_0xC4:
	CALL SUBOPT_0x24
	SBIW R26,5
	BRNE _0xC6
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2F
	MOVW R26,R4
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x133
; 0000 0205                 else if(min==6)     motor(-255+cmp,-255+cmp,255+cmp,255+cmp);    //motor(0,-255,0,255);
_0xC6:
	CALL SUBOPT_0x24
	SBIW R26,6
	BRNE _0xC8
	CALL SUBOPT_0x30
	CALL SUBOPT_0x36
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x133
; 0000 0206                 else if(min==7)     motor(-255+cmp,-128+cmp,255+cmp,128+cmp);    //motor(-128,-255,128,255);
_0xC8:
	CALL SUBOPT_0x24
	SBIW R26,7
	BRNE _0xCA
	CALL SUBOPT_0x30
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x31
	SUBI R26,LOW(-128)
	SBCI R27,HIGH(-128)
	RJMP _0x133
; 0000 0207                 else                motor(cmp,cmp,cmp,cmp);
_0xCA:
	CALL SUBOPT_0x34
_0x133:
	CALL _motor
; 0000 0208 
; 0000 0209                 }
	RJMP _0xB2
_0xB4:
; 0000 020A             while(SB>=300 || chr1=='B')
_0xCC:
	CALL SUBOPT_0x29
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRGE _0xCF
	LDI  R30,LOW(66)
	CP   R30,R8
	BRNE _0xCE
_0xCF:
; 0000 020B                 {
; 0000 020C                 #asm("wdr")
	wdr
; 0000 020D                 compass();
	CALL SUBOPT_0x2C
; 0000 020E                 sensor();
; 0000 020F                 read_sharp();
; 0000 0210                 if(SB>500)                                             motor(128+cmp,128+cmp,-128+cmp,-128+cmp);
	CALL SUBOPT_0x29
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLT _0xD1
	MOVW R30,R4
	CALL SUBOPT_0x2E
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	CALL SUBOPT_0x35
	SUBI R26,LOW(-65408)
	SBCI R27,HIGH(-65408)
	RJMP _0x134
; 0000 0211                 else if((min>=0 && min<=3) || (min>=13 && min<=15))    motor(255+cmp,255+cmp,-255+cmp,-255+cmp);
_0xD1:
	LDS  R26,_min+1
	TST  R26
	BRMI _0xD4
	CALL SUBOPT_0x24
	SBIW R26,4
	BRLT _0xD6
_0xD4:
	CALL SUBOPT_0x24
	SBIW R26,13
	BRLT _0xD7
	CALL SUBOPT_0x24
	SBIW R26,16
	BRLT _0xD6
_0xD7:
	RJMP _0xD3
_0xD6:
	CALL SUBOPT_0x33
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x30
	MOVW R26,R4
	SUBI R26,LOW(-65281)
	SBCI R27,HIGH(-65281)
	RJMP _0x134
; 0000 0212                 else                                                   motor(cmp,cmp,cmp,cmp);
_0xD3:
	CALL SUBOPT_0x34
_0x134:
	CALL _motor
; 0000 0213                 chr1='N';
	LDI  R30,LOW(78)
	MOV  R8,R30
; 0000 0214                 }
	RJMP _0xCC
_0xCE:
; 0000 0215             while(chr1=='F')
_0xDB:
	LDI  R30,LOW(70)
	CP   R30,R8
	BRNE _0xDD
; 0000 0216                 {
; 0000 0217                 #asm("wdr")
	wdr
; 0000 0218                 compass();
	CALL SUBOPT_0x2C
; 0000 0219                 sensor();
; 0000 021A                 read_sharp();
; 0000 021B                 if((mini>=5 && mini<=7)||p==1)        motor(-128+cmp,-128+cmp,128+cmp,128+cmp);
	CALL SUBOPT_0x26
	SBIW R26,5
	BRLT _0xDF
	CALL SUBOPT_0x26
	SBIW R26,8
	BRLT _0xE1
_0xDF:
	CALL SUBOPT_0x27
	SBIW R26,1
	BRNE _0xDE
_0xE1:
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	CALL SUBOPT_0x2E
	MOVW R26,R4
	SUBI R26,LOW(-128)
	SBCI R27,HIGH(-128)
	RJMP _0x135
; 0000 021C                 else if(min<=11 && min>=5 && adc[min]<800)     {motor(-255+cmp,-255+cmp,255+cmp,255+cmp);chr1='N';}
_0xDE:
	CALL SUBOPT_0x24
	SBIW R26,12
	BRGE _0xE5
	CALL SUBOPT_0x24
	SBIW R26,5
	BRLT _0xE5
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x320)
	LDI  R26,HIGH(0x320)
	CPC  R31,R26
	BRLT _0xE6
_0xE5:
	RJMP _0xE4
_0xE6:
	CALL SUBOPT_0x30
	CALL SUBOPT_0x36
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	CALL _motor
	LDI  R30,LOW(78)
	MOV  R8,R30
; 0000 021D                 else                           motor(cmp,cmp,cmp,cmp);
	RJMP _0xE7
_0xE4:
	CALL SUBOPT_0x34
_0x135:
	CALL _motor
; 0000 021E                 }
_0xE7:
	RJMP _0xDB
_0xDD:
; 0000 021F 
; 0000 0220             //if((mini>=5 && mini<=7)||p==1)        motor(-128+cmp,-128+cmp,128+cmp,128+cmp);
; 0000 0221             //else if(min<=11 && min>=5)     motor(-255+cmp,-255+cmp,255+cmp,255+cmp);
; 0000 0222             //else
; 0000 0223                                        motor(cmp,cmp,cmp,cmp);
	CALL SUBOPT_0x34
	RJMP _0x136
; 0000 0224             }
; 0000 0225          else{
_0x97:
; 0000 0226          chr1='N';
	LDI  R30,LOW(78)
	MOV  R8,R30
; 0000 0227          #asm("wdr")
	wdr
; 0000 0228          if(min==0 )         motor(255+cmp,255+cmp,-255+cmp,-255+cmp);
	LDS  R30,_min
	LDS  R31,_min+1
	SBIW R30,0
	BRNE _0xE9
	CALL SUBOPT_0x33
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	RJMP _0x137
; 0000 0229          else if(min==1)     motor(255+cmp,0+cmp,-255+cmp,0+cmp);      //motor(255,128,-255,-128);
_0xE9:
	CALL SUBOPT_0x24
	SBIW R26,1
	BRNE _0xEB
	CALL SUBOPT_0x33
	CALL SUBOPT_0x32
	CALL SUBOPT_0x30
	MOVW R26,R4
	ADIW R26,0
	RJMP _0x136
; 0000 022A          else if(min==2)     motor(255+cmp,-255+cmp,-255+cmp,255+cmp);     //motor(255,0,-255,0);
_0xEB:
	CALL SUBOPT_0x24
	SBIW R26,2
	BRNE _0xED
	CALL SUBOPT_0x33
	CALL SUBOPT_0x30
	CALL SUBOPT_0x30
	MOVW R26,R4
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x136
; 0000 022B          else if(min==3)     motor(128+cmp,-255+cmp,-128+cmp,255+cmp);    //motor(255,-128,-255,128);
_0xED:
	CALL SUBOPT_0x24
	SBIW R26,3
	BRNE _0xEF
	MOVW R30,R4
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x30
	MOVW R30,R4
	CALL SUBOPT_0x35
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x136
; 0000 022C          else if(min==4)     motor(128+cmp,-255+cmp,-128+cmp,255+cmp);        //motor(255,-255,-255,255);
_0xEF:
	CALL SUBOPT_0x24
	SBIW R26,4
	BRNE _0xF1
	MOVW R30,R4
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x30
	MOVW R30,R4
	CALL SUBOPT_0x35
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x136
; 0000 022D          else if(min==5)     motor(-128+cmp,-255+cmp,128+cmp,255+cmp);   //motor(128,-255,-128,255);
_0xF1:
	CALL SUBOPT_0x24
	SBIW R26,5
	BRNE _0xF3
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2F
	MOVW R26,R4
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x136
; 0000 022E          else if(min==6)     motor(-255+cmp,-255+cmp,255+cmp,255+cmp);    //motor(0,-255,0,255);
_0xF3:
	CALL SUBOPT_0x24
	SBIW R26,6
	BRNE _0xF5
	CALL SUBOPT_0x30
	CALL SUBOPT_0x36
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x136
; 0000 022F          else if(min==7)     motor(-255+cmp,-128+cmp,255+cmp,128+cmp);    //motor(-128,-255,128,255);
_0xF5:
	CALL SUBOPT_0x24
	SBIW R26,7
	BRNE _0xF7
	CALL SUBOPT_0x30
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x31
	SUBI R26,LOW(-128)
	SBCI R27,HIGH(-128)
	RJMP _0x136
; 0000 0230          else if(min==8)     motor(-255+cmp,0+cmp,255+cmp,0+cmp);    //motor(-255,-255,255,255);
_0xF7:
	CALL SUBOPT_0x24
	SBIW R26,8
	BRNE _0xF9
	CALL SUBOPT_0x30
	CALL SUBOPT_0x32
	MOVW R30,R4
	CALL SUBOPT_0x31
	ADIW R26,0
	RJMP _0x136
; 0000 0231          else if(min==9)     motor(-128+cmp,-255+cmp,128+cmp,255+cmp);         //motor(-255,-128,255,128);
_0xF9:
	CALL SUBOPT_0x24
	SBIW R26,9
	BRNE _0xFB
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2F
	MOVW R26,R4
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x136
; 0000 0232          else if(min==10)    motor(-128+cmp,-255+cmp,128+cmp,255+cmp);   //motor(-255,0,255,0);
_0xFB:
	CALL SUBOPT_0x24
	SBIW R26,10
	BRNE _0xFD
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2F
	MOVW R26,R4
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x136
; 0000 0233          else if(min==11)    motor(-255+cmp,-128+cmp,255+cmp,128+cmp);   //motor(-255,128,255,-128);
_0xFD:
	CALL SUBOPT_0x24
	SBIW R26,11
	BRNE _0xFF
	CALL SUBOPT_0x30
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x31
	SUBI R26,LOW(-128)
	SBCI R27,HIGH(-128)
	RJMP _0x136
; 0000 0234          else if(min==12)    motor(-255+cmp,0+cmp,255+cmp,0+cmp);    //motor(-255,255,255,-255);
_0xFF:
	CALL SUBOPT_0x24
	SBIW R26,12
	BRNE _0x101
	CALL SUBOPT_0x30
	CALL SUBOPT_0x32
	MOVW R30,R4
	CALL SUBOPT_0x31
	ADIW R26,0
	RJMP _0x136
; 0000 0235          else if(min==13)    motor(-255+cmp,128+cmp,255+cmp,-128+cmp);         //motor(-128,255,128,-255);
_0x101:
	CALL SUBOPT_0x24
	SBIW R26,13
	BRNE _0x103
	MOVW R30,R4
	CALL SUBOPT_0x2F
	MOVW R30,R4
	CALL SUBOPT_0x31
	SUBI R26,LOW(-65408)
	SBCI R27,HIGH(-65408)
	RJMP _0x136
; 0000 0236          else if(min==14)    motor(-255+cmp,255+cmp,255+cmp,-255+cmp);    //motor(0,255,0,-255);
_0x103:
	CALL SUBOPT_0x24
	SBIW R26,14
	BRNE _0x105
	CALL SUBOPT_0x30
	CALL SUBOPT_0x33
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	RJMP _0x137
; 0000 0237          else if(min==15)    motor(-128+cmp,255+cmp,128+cmp,-255+cmp); //motor(128,255,-128,-255);p); //motor(128,255,-1 ...
_0x105:
	CALL SUBOPT_0x24
	SBIW R26,15
	BRNE _0x107
	CALL SUBOPT_0x2D
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
_0x137:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R4
	SUBI R26,LOW(-65281)
	SBCI R27,HIGH(-65281)
_0x136:
	CALL _motor
; 0000 0238          }
_0x107:
; 0000 0239          }
; 0000 023A       else
	RJMP _0x108
_0x96:
; 0000 023B         {
; 0000 023C         sum*=2;
	CALL SUBOPT_0x37
	LSL  R30
	ROL  R31
	STS  _sum,R30
	STS  _sum+1,R31
; 0000 023D         if(SB>=200)  motor(cmp,cmp,cmp,cmp);
	CALL SUBOPT_0x29
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0x109
	CALL SUBOPT_0x34
	RJMP _0x138
; 0000 023E         else         motor(-255+sum+cmp,-255-sum+cmp,255-sum+cmp,255+sum+cmp);
_0x109:
	CALL SUBOPT_0x37
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x38
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	SUB  R30,R26
	SBC  R31,R27
	CALL SUBOPT_0x38
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	SUB  R30,R26
	SBC  R31,R27
	ADD  R30,R4
	ADC  R31,R5
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x37
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	ADD  R30,R4
	ADC  R31,R5
	MOVW R26,R30
_0x138:
	CALL _motor
; 0000 023F         }
_0x108:
; 0000 0240       }
	RET
; .FEND
;void darvaze()
; 0000 0242       {
; 0000 0243       compass();
; 0000 0244       sensor();
; 0000 0245       read_sharp();
; 0000 0246       if(adc[min]<800 && SB>=180)
; 0000 0247         {
; 0000 0248         if(SB>280)              motor(255+cmp,255+cmp,-255+cmp,-255+cmp);
; 0000 0249         else if(min==0)      motor(cmp,cmp,cmp,cmp);
; 0000 024A         else if(min>0 && min<=6 && SR<200)  motor(200+cmp,-200+cmp,-200+cmp,200+cmp);
; 0000 024B         else if(min>=10 && min<=15 && SL<200) motor(-200+cmp,200+cmp,200+cmp,-200+cmp);
; 0000 024C         else                       motor(cmp,cmp,cmp,cmp);
; 0000 024D         }
; 0000 024E       else
; 0000 024F         {
; 0000 0250         sum*=2;
; 0000 0251         if(SB>=200)  motor(cmp,cmp,cmp,cmp);
; 0000 0252         else         motor(-255+sum+cmp,-255-sum+cmp,255-sum+cmp,255+sum+cmp);
; 0000 0253         }
; 0000 0254       }
;void bt()
; 0000 0256     {
; 0000 0257 
; 0000 0258    // if(((min>=0 && min<=4) || (min>=12 && min<=15)) && adc[min]<800)  putchar1('2');
; 0000 0259    if(h<100 && t!=2) {
; 0000 025A     putchar1('2');
; 0000 025B    #asm("wdr")
; 0000 025C 
; 0000 025D     }
; 0000 025E     else /*if((min>=4 && min<=12) && adc[min]<800) */                     putchar1('1');
; 0000 025F      #asm("wdr")
; 0000 0260 
; 0000 0261     }
;void main(void)
; 0000 0263 {
_main:
; .FSTART _main
; 0000 0264 // Declare your local variables here
; 0000 0265 
; 0000 0266 // Input/Output Ports initialization
; 0000 0267 // Port A initialization
; 0000 0268 // Func7=In Func6=Out Func5=Out Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0269 // State7=T State6=0 State5=0 State4=T State3=0 State2=0 State1=0 State0=0
; 0000 026A PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 026B DDRA=0x6F;
	LDI  R30,LOW(111)
	OUT  0x1A,R30
; 0000 026C 
; 0000 026D // Port B initialization
; 0000 026E // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 026F // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 0270 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0271 DDRB=0xF0;
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 0272 
; 0000 0273 // Port C initialization
; 0000 0274 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0275 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0276 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0277 DDRC=0x00;
	OUT  0x14,R30
; 0000 0278 
; 0000 0279 // Port D initialization
; 0000 027A // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 027B // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 027C PORTD=0x00;
	OUT  0x12,R30
; 0000 027D DDRD=0xF0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 027E 
; 0000 027F // Port E initialization
; 0000 0280 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0281 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0282 PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 0283 DDRE=0x00;
	OUT  0x2,R30
; 0000 0284 
; 0000 0285 // Port F initialization
; 0000 0286 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0287 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0288 PORTF=0x00;
	STS  98,R30
; 0000 0289 DDRF=0x00;
	STS  97,R30
; 0000 028A 
; 0000 028B // Port G initialization
; 0000 028C // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 028D // State4=T State3=T State2=T State1=T State0=T
; 0000 028E PORTG=0x00;
	STS  101,R30
; 0000 028F DDRG=0x00;
	STS  100,R30
; 0000 0290 
; 0000 0291 // Timer/Counter 0 initialization
; 0000 0292 // Clock source: System Clock
; 0000 0293 // Clock value: 172.800 kHz
; 0000 0294 // Mode: Fast PWM top=FFh
; 0000 0295 // OC0 output: Non-Inverted PWM
; 0000 0296 ASSR=0x00;
	OUT  0x30,R30
; 0000 0297 TCCR0=0x6C;
	LDI  R30,LOW(108)
	OUT  0x33,R30
; 0000 0298 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0299 OCR0=0x00;
	OUT  0x31,R30
; 0000 029A 
; 0000 029B // Timer/Counter 1 initialization
; 0000 029C // Clock source: System Clock
; 0000 029D // Clock value: 172.800 kHz
; 0000 029E // Mode: Fast PWM top=00FFh
; 0000 029F // OC1A output: Non-Inv.
; 0000 02A0 // OC1B output: Non-Inv.
; 0000 02A1 // OC1C output: Discon.
; 0000 02A2 // Noise Canceler: Off
; 0000 02A3 // Input Capture on Falling Edge
; 0000 02A4 // Timer1 Overflow Interrupt: Off
; 0000 02A5 // Input Capture Interrupt: Off
; 0000 02A6 // Compare A Match Interrupt: Off
; 0000 02A7 // Compare B Match Interrupt: Off
; 0000 02A8 // Compare C Match Interrupt: Off
; 0000 02A9 TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 02AA TCCR1B=0x0B;
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 02AB TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 02AC TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 02AD ICR1H=0x00;
	OUT  0x27,R30
; 0000 02AE ICR1L=0x00;
	OUT  0x26,R30
; 0000 02AF OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 02B0 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 02B1 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 02B2 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 02B3 OCR1CH=0x00;
	STS  121,R30
; 0000 02B4 OCR1CL=0x00;
	STS  120,R30
; 0000 02B5 
; 0000 02B6 // Timer/Counter 2 initialization
; 0000 02B7 // Clock source: System Clock
; 0000 02B8 // Clock value: 172.800 kHz
; 0000 02B9 // Mode: Fast PWM top=FFh
; 0000 02BA // OC2 output: Non-Inverted PWM
; 0000 02BB TCCR2=0x6B;
	LDI  R30,LOW(107)
	OUT  0x25,R30
; 0000 02BC TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 02BD OCR2=0x00;
	OUT  0x23,R30
; 0000 02BE 
; 0000 02BF // Timer/Counter 3 initialization
; 0000 02C0 // Clock source: System Clock
; 0000 02C1 // Clock value: 10.800 kHz
; 0000 02C2 // Mode: Normal top=FFFFh
; 0000 02C3 // OC3A output: Discon.
; 0000 02C4 // OC3B output: Discon.
; 0000 02C5 // OC3C output: Discon.
; 0000 02C6 // Noise Canceler: Off
; 0000 02C7 // Input Capture on Falling Edge
; 0000 02C8 // Timer3 Overflow Interrupt: On
; 0000 02C9 // Input Capture Interrupt: Off
; 0000 02CA // Compare A Match Interrupt: Off
; 0000 02CB // Compare B Match Interrupt: Off
; 0000 02CC // Compare C Match Interrupt: Off
; 0000 02CD TCCR3A=0x00;
	STS  139,R30
; 0000 02CE TCCR3B=0x00;
	CALL SUBOPT_0x3
; 0000 02CF TCNT3H=0x00;
; 0000 02D0 TCNT3L=0x00;
; 0000 02D1 ICR3H=0x00;
	LDI  R30,LOW(0)
	STS  129,R30
; 0000 02D2 ICR3L=0x00;
	STS  128,R30
; 0000 02D3 OCR3AH=0x00;
	STS  135,R30
; 0000 02D4 OCR3AL=0x00;
	STS  134,R30
; 0000 02D5 OCR3BH=0x00;
	STS  133,R30
; 0000 02D6 OCR3BL=0x00;
	STS  132,R30
; 0000 02D7 OCR3CH=0x00;
	STS  131,R30
; 0000 02D8 OCR3CL=0x00;
	STS  130,R30
; 0000 02D9 
; 0000 02DA // External Interrupt(s) initialization
; 0000 02DB // INT0: Off
; 0000 02DC // INT1: Off
; 0000 02DD // INT2: Off
; 0000 02DE // INT3: Off
; 0000 02DF // INT4: Off
; 0000 02E0 // INT5: Off
; 0000 02E1 // INT6: Off
; 0000 02E2 // INT7: Off
; 0000 02E3 EICRA=0x00;
	STS  106,R30
; 0000 02E4 EICRB=0x00;
	OUT  0x3A,R30
; 0000 02E5 EIMSK=0x00;
	OUT  0x39,R30
; 0000 02E6 
; 0000 02E7 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02E8 TIMSK=0x00;
	OUT  0x37,R30
; 0000 02E9 ETIMSK=0x04;
	LDI  R30,LOW(4)
	STS  125,R30
; 0000 02EA 
; 0000 02EB // USART1 initialization
; 0000 02EC // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 02ED // USART1 Receiver: On
; 0000 02EE // USART1 Transmitter: On
; 0000 02EF // USART1 Mode: Asynchronous
; 0000 02F0 // USART1 Baud Rate: 9600
; 0000 02F1 UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 02F2 UCSR1B=0x98;
	LDI  R30,LOW(152)
	STS  154,R30
; 0000 02F3 UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 02F4 UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 02F5 UBRR1L=0x47;
	LDI  R30,LOW(71)
	STS  153,R30
; 0000 02F6 
; 0000 02F7 // Analog Comparator initialization
; 0000 02F8 // Analog Comparator: Off
; 0000 02F9 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 02FA ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02FB SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 02FC 
; 0000 02FD // ADC initialization
; 0000 02FE // ADC Clock frequency: 691.200 kHz
; 0000 02FF // ADC Voltage Reference: AVCC pin
; 0000 0300 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0301 ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 0302 
; 0000 0303 // I2C Bus initialization
; 0000 0304 i2c_init();
	CALL _i2c_init
; 0000 0305 
; 0000 0306 // LCD module initialization
; 0000 0307 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0308 
; 0000 0309 // Watchdog Timer initialization
; 0000 030A // Watchdog Timer Prescaler: OSC/16k
; 0000 030B #pragma optsize-
; 0000 030C WDTCR=0x18;
	LDI  R30,LOW(24)
	OUT  0x21,R30
; 0000 030D WDTCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x21,R30
; 0000 030E #ifdef _OPTIMIZE_SIZE_
; 0000 030F #pragma optsize+
; 0000 0310 #endif
; 0000 0311 
; 0000 0312 // Global enable interrupts
; 0000 0313 #asm("sei")
	sei
; 0000 0314 if (PINA.4==1){
	SBIS 0x19,4
	RJMP _0x121
; 0000 0315 c=compass_read(1);
	LDI  R26,LOW(1)
	CALL _compass_read
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	LDI  R31,0
	CALL __EEPROMWRW
; 0000 0316 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0317 }
; 0000 0318 while (1)
_0x121:
_0x122:
; 0000 0319       {
; 0000 031A       #asm("wdr")
	wdr
; 0000 031B       compass();
	CALL SUBOPT_0x2C
; 0000 031C       sensor();
; 0000 031D       read_sharp();
; 0000 031E       //bt();
; 0000 031F       //if(t==1 || t==0) catch();
; 0000 0320       //else if(t==2)    darvaze();
; 0000 0321 
; 0000 0322       catch();
	CALL _catch
; 0000 0323       #asm("wdr")
	wdr
; 0000 0324 
; 0000 0325       };
	RJMP _0x122
; 0000 0326 }
_0x125:
	RJMP _0x125
; .FEND
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G100:
; .FSTART __lcd_delay_G100
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x2020001
; .FEND
__lcd_read_nibble_G100:
; .FSTART __lcd_read_nibble_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G100:
; .FSTART _lcd_read_byte0_G100
	CALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	CALL __lcd_ready
	LDI  R26,LOW(2)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(12)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(1)
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	CALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x2020001
; .FEND
__long_delay_G100:
; .FSTART __long_delay_G100
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G100:
; .FSTART __lcd_init_write_G100
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2020001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x39
	RCALL __long_delay_G100
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(40)
	RCALL SUBOPT_0x3A
	LDI  R26,LOW(4)
	RCALL SUBOPT_0x3A
	LDI  R26,LOW(133)
	RCALL SUBOPT_0x3A
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x2020001
_0x200000B:
	CALL __lcd_ready
	LDI  R26,LOW(6)
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2020001:
	ADIW R28,1
	RET
; .FEND

	.ESEG
_c:
	.BYTE 0x2

	.DSEG
_rx_buffer1:
	.BYTE 0x8
_s:
	.BYTE 0x2
_i:
	.BYTE 0x2
_SRFR:
	.BYTE 0x2
_SRFB:
	.BYTE 0x2
_SRFL:
	.BYTE 0x2
_data_srf:
	.BYTE 0x2
_data0_srf:
	.BYTE 0x2
_data1_srf:
	.BYTE 0x2
_data2_srf:
	.BYTE 0x2
_RL:
	.BYTE 0x2
_adc:
	.BYTE 0x20
_min:
	.BYTE 0x2
_kaf:
	.BYTE 0x20
_mini:
	.BYTE 0x2
_p:
	.BYTE 0x2
_h:
	.BYTE 0x2
_SL:
	.BYTE 0x2
_SR:
	.BYTE 0x2
_SB:
	.BYTE 0x2
_sum:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	CALL _i2c_write
	JMP  _i2c_start

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	STS  138,R30
	STS  137,R30
	STS  136,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	CALL _i2c_write
	LDI  R26,LOW(1)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:115 WORDS
SUBOPT_0x5:
	CALL _i2c_write
	LDI  R26,LOW(1)
	CALL _i2c_read
	LDI  R31,0
	STS  _data0_srf,R30
	STS  _data0_srf+1,R31
	LDI  R26,LOW(1)
	CALL _i2c_read
	LDI  R31,0
	STS  _data1_srf,R30
	STS  _data1_srf+1,R31
	LDI  R26,LOW(0)
	CALL _i2c_read
	LDI  R31,0
	STS  _data2_srf,R30
	STS  _data2_srf+1,R31
	LDS  R30,_data1_srf
	LDS  R31,_data1_srf+1
	STS  _data_srf,R30
	STS  _data_srf+1,R31
	LDS  R31,_data_srf
	LDI  R30,LOW(0)
	STS  _data_srf,R30
	STS  _data_srf+1,R31
	LDS  R30,_data2_srf
	LDS  R31,_data2_srf+1
	LDS  R26,_data_srf
	LDS  R27,_data_srf+1
	OR   R30,R26
	OR   R31,R27
	STS  _data_srf,R30
	STS  _data_srf+1,R31
	CALL _i2c_stop
	LDS  R30,_data_srf
	LDS  R31,_data_srf+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDS  R26,_SRFR
	LDS  R27,_SRFR+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:118 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:140 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDS  R26,_SRFL
	LDS  R27,_SRFL+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDS  R26,_SRFB
	LDS  R27,_SRFB+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDS  R26,_RL
	LDS  R27,_RL+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDS  R30,_RL
	LDS  R31,_RL+1
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDS  R26,_i
	LDS  R27,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	CALL __DIVW21
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __MANDW12
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	LDS  R30,_i
	LDS  R31,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	RCALL SUBOPT_0x13
	LDI  R26,LOW(_adc)
	LDI  R27,HIGH(_adc)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	RCALL SUBOPT_0x13
	LDI  R26,LOW(_kaf)
	LDI  R27,HIGH(_kaf)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x16:
	LDS  R30,_min
	LDS  R31,_min+1
	LDI  R26,LOW(_adc)
	LDI  R27,HIGH(_adc)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x17:
	LDS  R30,_mini
	LDS  R31,_mini+1
	LDI  R26,LOW(_kaf)
	LDI  R27,HIGH(_kaf)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	__GETW2MN _kaf,24
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	__GETW2MN _kaf,26
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	__GETW2MN _kaf,28
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	__GETW2MN _kaf,30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	LDS  R26,_kaf
	LDS  R27,_kaf+1
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	__GETW2MN _kaf,2
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	__GETW2MN _kaf,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	__GETW2MN _kaf,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	__GETW2MN _kaf,20
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	__GETW2MN _kaf,22
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	__GETW2MN _kaf,18
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x23:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x24:
	LDS  R26,_min
	LDS  R27,_min+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	MOVW R26,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	MOVW R26,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	LDS  R26,_mini
	LDS  R27,_mini+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	LDS  R26,_p
	LDS  R27,_p+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x28:
	LDS  R26,_SR
	LDS  R27,_SR+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x29:
	LDS  R26,_SB
	LDS  R27,_SB+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2A:
	LDS  R26,_SL
	LDS  R27,_SL+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	MOVW R30,R4
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2C:
	CALL _compass
	CALL _sensor
	JMP  _read_sharp

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x2D:
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x2E:
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x2F:
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x30:
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x31:
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
	MOVW R30,R4
	ADIW R30,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x33:
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x34:
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R5
	ST   -Y,R4
	MOVW R26,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x35:
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x36:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	LDS  R30,_sum
	LDS  R31,_sum+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	ADD  R30,R4
	ADC  R31,R5
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_sum
	LDS  R27,_sum+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	CALL __long_delay_G100
	LDI  R26,LOW(48)
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	CALL __lcd_write_data
	JMP  __long_delay_G100


	.CSEG
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
	ldi  r22,18
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,37
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
	__DELAY_USW 0xACD
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

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
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

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

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

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
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

;END OF CODE MARKER
__END_OF_CODE:
