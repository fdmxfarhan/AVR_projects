
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
;Date    : 26/08/2017
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
;
;
;
;// -----------------
;//                  |                 ----------------
;//                  |- 5v  ----- Vcc -| MPU 6050     |
;// MicroController  |- GND ----- GND -| Acceleration,|
;// Board            |- PB1 ----- SDA -| Gyro, Temp   |
;//                  |- PB0 ----- SCL -|   Module     |
;//                  |                 ----------------
;//                  |
;//                  |                 ----------------------------
;//                  |- PC1 ----- CLK -|                          |
;//                  |- PC0 ----- DIN -|       Graphic LCD        |
;//                  |- PC2 ----- DC  -|        Nokia5110         |
;//                  |- PC3 ----- CE  -|                          |
;//                  |- PC4 ----- RST -|                          |
;//                  |                 |                          |
;//                  |                 ----------------------------
;//------------------
;
;
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
;#include <delay.h>
;
;// I2C Bus functions
;#include <i2c.h>
;
;// Graphic Display functions
;#include <glcd.h>
;
;// Font used for displaying text
;// on the graphic display
;#include <font5x7.h>
;
;// Declare your global variables here
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0043 {

	.CSEG
; 0000 0044 ADMUX=adc_input | ADC_VREF_TYPE;
;	adc_input -> Y+0
; 0000 0045 // Delay needed for the stabilization of the ADC input voltage
; 0000 0046 delay_us(10);
; 0000 0047 // Start the AD conversion
; 0000 0048 ADCSRA|=(1<<ADSC);
; 0000 0049 // Wait for the AD conversion to complete
; 0000 004A while ((ADCSRA & (1<<ADIF))==0);
; 0000 004B ADCSRA|=(1<<ADIF);
; 0000 004C return ADCW;
; 0000 004D }
;
;
;
;////////////////////////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////////////////////////
;
;
;
;
;
;
;
;
;#include <font5x7.h>
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
; 0000 0075 {
_read_i2c:
; .FSTART _read_i2c
; 0000 0076 unsigned char Data;
; 0000 0077 i2c_start();
	ST   -Y,R26
	ST   -Y,R17
;	BusAddres -> Y+3
;	Reg -> Y+2
;	Ack -> Y+1
;	Data -> R17
	CALL _i2c_start
; 0000 0078 i2c_write(BusAddres);
	LDD  R26,Y+3
	CALL _i2c_write
; 0000 0079 i2c_write(Reg);
	LDD  R26,Y+2
	CALL _i2c_write
; 0000 007A i2c_start();
	CALL _i2c_start
; 0000 007B i2c_write(BusAddres + 1);
	LDD  R26,Y+3
	SUBI R26,-LOW(1)
	CALL _i2c_write
; 0000 007C delay_us(10);
	__DELAY_USB 27
; 0000 007D Data=i2c_read(Ack);
	LDD  R26,Y+1
	CALL _i2c_read
	MOV  R17,R30
; 0000 007E i2c_stop();
	CALL _i2c_stop
; 0000 007F return Data;
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,4
	RET
; 0000 0080 }
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;void write_i2c(unsigned char BusAddres , unsigned char Reg , unsigned char Data)
; 0000 0083 {
_write_i2c:
; .FSTART _write_i2c
; 0000 0084 i2c_start();
	ST   -Y,R26
;	BusAddres -> Y+2
;	Reg -> Y+1
;	Data -> Y+0
	CALL _i2c_start
; 0000 0085 i2c_write(BusAddres);
	LDD  R26,Y+2
	CALL _i2c_write
; 0000 0086 i2c_write(Reg);
	LDD  R26,Y+1
	CALL _i2c_write
; 0000 0087 i2c_write(Data);
	LD   R26,Y
	CALL _i2c_write
; 0000 0088 i2c_stop();
	CALL _i2c_stop
; 0000 0089 }
	ADIW R28,3
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// This function can test i2c communication MPU6050
;unsigned char MPU6050_Test_I2C()
; 0000 008D {
; 0000 008E     unsigned char Data = 0x00;
; 0000 008F     Data=read_i2c(MPU6050_ADDRESS, RA_WHO_AM_I, 0);
;	Data -> R17
; 0000 0090     if(Data == 0x68)
; 0000 0091         return 1;       // Means Comunication With MPU6050 is Corect
; 0000 0092     else
; 0000 0093         return 0;       // Means ERROR, Stopping
; 0000 0094 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// This function can move MPU6050 to sleep
;void MPU6050_Sleep(char ON_or_OFF)
; 0000 0098 {
; 0000 0099     if(ON_or_OFF == on)
;	ON_or_OFF -> Y+0
; 0000 009A         write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (1<<6)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
; 0000 009B     else if(ON_or_OFF == off)
; 0000 009C         write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (0)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
; 0000 009D }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// This function can restor MPU6050 to default
;void MPU6050_Reset()
; 0000 00A1 {
; 0000 00A2     // When set to 1, DEVICE_RESET bit in RA_PWR_MGMT_1 resets all internal registers to their default values.
; 0000 00A3     // The bit automatically clears to 0 once the reset is done.
; 0000 00A4     // The default values for each register can be found in RA_MPU6050.h
; 0000 00A5     write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, 0x80);
; 0000 00A6     // Now all reg reset to default values
; 0000 00A7 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// MPU6050 sensor initialization
;void MPU6050_Init()
; 0000 00AB {
_MPU6050_Init:
; .FSTART _MPU6050_Init
; 0000 00AC     //Sets sample rate to 1000/1+4 = 200Hz
; 0000 00AD     write_i2c(MPU6050_ADDRESS, RA_SMPLRT_DIV, SampleRateDiv);
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	LDI  R26,LOW(4)
	CALL SUBOPT_0x0
; 0000 00AE     //Disable FSync, 42Hz DLPF
; 0000 00AF     write_i2c(MPU6050_ADDRESS, RA_CONFIG, (EXT_SYNC_SET<<3)|(DLPF_CFG));
	LDI  R30,LOW(26)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL SUBOPT_0x0
; 0000 00B0     //Disable all axis gyro self tests, scale of 2000 degrees/s
; 0000 00B1     write_i2c(MPU6050_ADDRESS, RA_GYRO_CONFIG, ((XG_ST|YG_ST|ZG_ST)<<5)|GFS_SEL);
	LDI  R30,LOW(27)
	ST   -Y,R30
	LDI  R26,LOW(24)
	CALL SUBOPT_0x0
; 0000 00B2     //Disable accel self tests, scale of +-16g, no DHPF
; 0000 00B3     write_i2c(MPU6050_ADDRESS, RA_ACCEL_CONFIG, ((XA_ST|YA_ST|ZA_ST)<<5)|AFS_SEL);
	LDI  R30,LOW(28)
	CALL SUBOPT_0x1
; 0000 00B4     //Disable sensor output to FIFO buffer
; 0000 00B5     write_i2c(MPU6050_ADDRESS, RA_FIFO_EN, FIFO_En_Parameters);
	LDI  R30,LOW(35)
	CALL SUBOPT_0x1
; 0000 00B6 
; 0000 00B7     //Freefall threshold of |0mg|
; 0000 00B8     write_i2c(MPU6050_ADDRESS, RA_FF_THR, 0x00);
	LDI  R30,LOW(29)
	CALL SUBOPT_0x1
; 0000 00B9     //Freefall duration limit of 0
; 0000 00BA     write_i2c(MPU6050_ADDRESS, RA_FF_DUR, 0x00);
	LDI  R30,LOW(30)
	CALL SUBOPT_0x1
; 0000 00BB     //Motion threshold of 0mg
; 0000 00BC     write_i2c(MPU6050_ADDRESS, RA_MOT_THR, 0x00);
	LDI  R30,LOW(31)
	CALL SUBOPT_0x1
; 0000 00BD     //Motion duration of 0s
; 0000 00BE     write_i2c(MPU6050_ADDRESS, RA_MOT_DUR, 0x00);
	LDI  R30,LOW(32)
	CALL SUBOPT_0x1
; 0000 00BF     //Zero motion threshold
; 0000 00C0     write_i2c(MPU6050_ADDRESS, RA_ZRMOT_THR, 0x00);
	LDI  R30,LOW(33)
	CALL SUBOPT_0x1
; 0000 00C1     //Zero motion duration threshold
; 0000 00C2     write_i2c(MPU6050_ADDRESS, RA_ZRMOT_DUR, 0x00);
	LDI  R30,LOW(34)
	CALL SUBOPT_0x1
; 0000 00C3 
; 0000 00C4 //////////////////////////////////////////////////////////////
; 0000 00C5 //  AUX I2C setup
; 0000 00C6 //////////////////////////////////////////////////////////////
; 0000 00C7     //Sets AUX I2C to single master control, plus other config
; 0000 00C8     write_i2c(MPU6050_ADDRESS, RA_I2C_MST_CTRL, 0x00);
	LDI  R30,LOW(36)
	CALL SUBOPT_0x1
; 0000 00C9     //Setup AUX I2C slaves
; 0000 00CA     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_ADDR, 0x00);
	LDI  R30,LOW(37)
	CALL SUBOPT_0x1
; 0000 00CB     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_REG, 0x00);
	LDI  R30,LOW(38)
	CALL SUBOPT_0x1
; 0000 00CC     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_CTRL, 0x00);
	LDI  R30,LOW(39)
	CALL SUBOPT_0x1
; 0000 00CD 
; 0000 00CE     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_ADDR, 0x00);
	LDI  R30,LOW(40)
	CALL SUBOPT_0x1
; 0000 00CF     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_REG, 0x00);
	LDI  R30,LOW(41)
	CALL SUBOPT_0x1
; 0000 00D0     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_CTRL, 0x00);
	LDI  R30,LOW(42)
	CALL SUBOPT_0x1
; 0000 00D1 
; 0000 00D2     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_ADDR, 0x00);
	LDI  R30,LOW(43)
	CALL SUBOPT_0x1
; 0000 00D3     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_REG, 0x00);
	LDI  R30,LOW(44)
	CALL SUBOPT_0x1
; 0000 00D4     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_CTRL, 0x00);
	LDI  R30,LOW(45)
	CALL SUBOPT_0x1
; 0000 00D5 
; 0000 00D6     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_ADDR, 0x00);
	LDI  R30,LOW(46)
	CALL SUBOPT_0x1
; 0000 00D7     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_REG, 0x00);
	LDI  R30,LOW(47)
	CALL SUBOPT_0x1
; 0000 00D8     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_CTRL, 0x00);
	LDI  R30,LOW(48)
	CALL SUBOPT_0x1
; 0000 00D9 
; 0000 00DA     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_ADDR, 0x00);
	LDI  R30,LOW(49)
	CALL SUBOPT_0x1
; 0000 00DB     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_REG, 0x00);
	LDI  R30,LOW(50)
	CALL SUBOPT_0x1
; 0000 00DC     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_DO, 0x00);
	LDI  R30,LOW(51)
	CALL SUBOPT_0x1
; 0000 00DD     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_CTRL, 0x00);
	LDI  R30,LOW(52)
	CALL SUBOPT_0x1
; 0000 00DE     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_DI, 0x00);
	LDI  R30,LOW(53)
	CALL SUBOPT_0x1
; 0000 00DF 
; 0000 00E0     //Setup INT pin and AUX I2C pass through
; 0000 00E1     write_i2c(MPU6050_ADDRESS, RA_INT_PIN_CFG, 0x00);
	LDI  R30,LOW(55)
	CALL SUBOPT_0x1
; 0000 00E2     //Enable data ready interrupt
; 0000 00E3     write_i2c(MPU6050_ADDRESS, RA_INT_ENABLE, 0x00);
	LDI  R30,LOW(56)
	CALL SUBOPT_0x1
; 0000 00E4 
; 0000 00E5     //Slave out, dont care
; 0000 00E6     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_DO, 0x00);
	LDI  R30,LOW(99)
	CALL SUBOPT_0x1
; 0000 00E7     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_DO, 0x00);
	LDI  R30,LOW(100)
	CALL SUBOPT_0x1
; 0000 00E8     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_DO, 0x00);
	LDI  R30,LOW(101)
	CALL SUBOPT_0x1
; 0000 00E9     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_DO, 0x00);
	LDI  R30,LOW(102)
	CALL SUBOPT_0x1
; 0000 00EA     //More slave config
; 0000 00EB     write_i2c(MPU6050_ADDRESS, RA_I2C_MST_DELAY_CTRL, 0x00);
	LDI  R30,LOW(103)
	CALL SUBOPT_0x1
; 0000 00EC 
; 0000 00ED     //Reset sensor signal paths
; 0000 00EE     write_i2c(MPU6050_ADDRESS, RA_SIGNAL_PATH_RESET, 0x00);
	LDI  R30,LOW(104)
	CALL SUBOPT_0x1
; 0000 00EF     //Motion detection control
; 0000 00F0     write_i2c(MPU6050_ADDRESS, RA_MOT_DETECT_CTRL, 0x00);
	LDI  R30,LOW(105)
	CALL SUBOPT_0x1
; 0000 00F1     //Disables FIFO, AUX I2C, FIFO and I2C reset bits to 0
; 0000 00F2     write_i2c(MPU6050_ADDRESS, RA_USER_CTRL, 0x00);
	LDI  R30,LOW(106)
	CALL SUBOPT_0x1
; 0000 00F3 
; 0000 00F4     //Sets clock source to gyro reference w/ PLL
; 0000 00F5     write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (SLEEP<<6)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
	LDI  R30,LOW(107)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL SUBOPT_0x0
; 0000 00F6     //Controls frequency of wakeups in accel low power mode plus the sensor standby modes
; 0000 00F7     write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_2, (LP_WAKE_CTRL<<6)|(STBY_XA<<5)|(STBY_YA<<4)|(STBY_ZA<<3)|(STBY_XG<<2)|(STB ...
	LDI  R30,LOW(108)
	CALL SUBOPT_0x1
; 0000 00F8     //Data transfer to and from the FIFO buffer
; 0000 00F9     write_i2c(MPU6050_ADDRESS, RA_FIFO_R_W, 0x00);
	LDI  R30,LOW(116)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _write_i2c
; 0000 00FA 
; 0000 00FB //  MPU6050 Setup Complete
; 0000 00FC }
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// get accel offset X,Y,Z
;void Get_Accel_Offset()
; 0000 0100 {
_Get_Accel_Offset:
; .FSTART _Get_Accel_Offset
; 0000 0101   #define    NumAve4AO      100
; 0000 0102   float Ave=0;
; 0000 0103   unsigned char i= NumAve4AO;
; 0000 0104   while(i--)
	CALL SUBOPT_0x2
;	Ave -> Y+1
;	i -> R17
	LDI  R17,100
_0xB:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0xD
; 0000 0105   {
; 0000 0106     Accel_Offset_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
; 0000 0107                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)   );
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
; 0000 0108     Ave = (float) Ave + (Accel_Offset_Val[X] / NumAve4AO);
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
; 0000 0109     delay_us(10);
; 0000 010A   }
	RJMP _0xB
_0xD:
; 0000 010B   Accel_Offset_Val[X] = Ave;
	CALL SUBOPT_0x8
	STS  _Accel_Offset_Val,R30
	STS  _Accel_Offset_Val+1,R31
	STS  _Accel_Offset_Val+2,R22
	STS  _Accel_Offset_Val+3,R23
; 0000 010C   Ave = 0;
	CALL SUBOPT_0x9
; 0000 010D   i = NumAve4AO;
; 0000 010E   while(i--)
_0xE:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x10
; 0000 010F   {
; 0000 0110     Accel_Offset_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
; 0000 0111                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)   );
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
; 0000 0112     Ave = (float) Ave + (Accel_Offset_Val[Y] / NumAve4AO);
	CALL SUBOPT_0xC
	CALL SUBOPT_0x7
; 0000 0113     delay_us(10);
; 0000 0114   }
	RJMP _0xE
_0x10:
; 0000 0115   Accel_Offset_Val[Y] = Ave;
	CALL SUBOPT_0x8
	__PUTD1MN _Accel_Offset_Val,4
; 0000 0116   Ave = 0;
	CALL SUBOPT_0x9
; 0000 0117   i = NumAve4AO;
; 0000 0118   while(i--)
_0x11:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x13
; 0000 0119   {
; 0000 011A     Accel_Offset_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
; 0000 011B                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)   );
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
; 0000 011C     Ave = (float) Ave + (Accel_Offset_Val[Z] / NumAve4AO);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x7
; 0000 011D     delay_us(10);
; 0000 011E   }
	RJMP _0x11
_0x13:
; 0000 011F   Accel_Offset_Val[Z] = Ave;
	CALL SUBOPT_0x8
	__PUTD1MN _Accel_Offset_Val,8
; 0000 0120 }
	RJMP _0x212000C
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Gets raw accelerometer data, performs no processing
;void Get_Accel_Val()
; 0000 0124 {
; 0000 0125     Accel_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
; 0000 0126                          read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)    );
; 0000 0127     Accel_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
; 0000 0128                          read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)    );
; 0000 0129     Accel_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
; 0000 012A                          read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)    );
; 0000 012B 
; 0000 012C     Accel_In_g[X] = Accel_Raw_Val[X] - Accel_Offset_Val[X];
; 0000 012D     Accel_In_g[Y] = Accel_Raw_Val[Y] - Accel_Offset_Val[Y];
; 0000 012E     Accel_In_g[Z] = Accel_Raw_Val[Z] - Accel_Offset_Val[Z];
; 0000 012F 
; 0000 0130     Accel_In_g[X] = Accel_In_g[X] / ACCEL_Sensitivity;
; 0000 0131     Accel_In_g[Y] = Accel_In_g[Y] / ACCEL_Sensitivity;
; 0000 0132     Accel_In_g[Z] = Accel_In_g[Z] / ACCEL_Sensitivity;
; 0000 0133 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Gets n average raw accelerometer data, performs no processing
;void Get_AvrgAccel_Val()
; 0000 0137 {
_Get_AvrgAccel_Val:
; .FSTART _Get_AvrgAccel_Val
; 0000 0138   #define    NumAve4A      50
; 0000 0139   float Ave=0;
; 0000 013A   unsigned char i= NumAve4A;
; 0000 013B   while(i--)
	CALL SUBOPT_0x2
;	Ave -> Y+1
;	i -> R17
	LDI  R17,50
_0x14:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x16
; 0000 013C   {
; 0000 013D     AvrgAccel_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
; 0000 013E                              read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)   );
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
; 0000 013F     Ave = (float) Ave + (AvrgAccel_Raw_Val[X] / NumAve4A);
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0000 0140     delay_us(10);
; 0000 0141   }
	RJMP _0x14
_0x16:
; 0000 0142   AvrgAccel_Raw_Val[X] = Ave;
	CALL SUBOPT_0x8
	STS  _AvrgAccel_Raw_Val,R30
	STS  _AvrgAccel_Raw_Val+1,R31
	STS  _AvrgAccel_Raw_Val+2,R22
	STS  _AvrgAccel_Raw_Val+3,R23
; 0000 0143   Ave = 0;
	CALL SUBOPT_0x12
; 0000 0144   i = NumAve4A;
; 0000 0145   while(i--)
_0x17:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x19
; 0000 0146   {
; 0000 0147     AvrgAccel_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
; 0000 0148                              read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)   );
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
; 0000 0149     Ave = (float) Ave + (AvrgAccel_Raw_Val[Y] / NumAve4A);
	__GETD2MN _AvrgAccel_Raw_Val,4
	CALL SUBOPT_0x11
; 0000 014A     delay_us(10);
; 0000 014B   }
	RJMP _0x17
_0x19:
; 0000 014C   AvrgAccel_Raw_Val[Y] = Ave;
	CALL SUBOPT_0x8
	__PUTD1MN _AvrgAccel_Raw_Val,4
; 0000 014D   Ave = 0;
	CALL SUBOPT_0x12
; 0000 014E   i = NumAve4A;
; 0000 014F   while(i--)
_0x1A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x1C
; 0000 0150   {
; 0000 0151     AvrgAccel_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
; 0000 0152                              read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)   );
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
; 0000 0153     Ave = (float) Ave + (AvrgAccel_Raw_Val[Z] / NumAve4A);
	__GETD2MN _AvrgAccel_Raw_Val,8
	CALL SUBOPT_0x11
; 0000 0154     delay_us(10);
; 0000 0155   }
	RJMP _0x1A
_0x1C:
; 0000 0156   AvrgAccel_Raw_Val[Z] = Ave;
	CALL SUBOPT_0x8
	__PUTD1MN _AvrgAccel_Raw_Val,8
; 0000 0157 
; 0000 0158   Accel_In_g[X] = AvrgAccel_Raw_Val[X] - Accel_Offset_Val[X];
	CALL SUBOPT_0x6
	CALL SUBOPT_0x13
	CALL __SUBF12
	CALL SUBOPT_0x14
; 0000 0159   Accel_In_g[Y] = AvrgAccel_Raw_Val[Y] - Accel_Offset_Val[Y];
	CALL SUBOPT_0x15
	CALL SUBOPT_0xC
	CALL __SUBF12
	CALL SUBOPT_0x16
; 0000 015A   Accel_In_g[Z] = AvrgAccel_Raw_Val[Z] - Accel_Offset_Val[Z];
	CALL SUBOPT_0x17
	CALL SUBOPT_0xF
	CALL __SUBF12
	CALL SUBOPT_0x18
; 0000 015B 
; 0000 015C   Accel_In_g[X] = Accel_In_g[X] / ACCEL_Sensitivity;  //  g/LSB
	LDS  R26,_Accel_In_g
	LDS  R27,_Accel_In_g+1
	LDS  R24,_Accel_In_g+2
	LDS  R25,_Accel_In_g+3
	CALL SUBOPT_0x19
	CALL SUBOPT_0x14
; 0000 015D   Accel_In_g[Y] = Accel_In_g[Y] / ACCEL_Sensitivity;  //  g/LSB
	__GETD2MN _Accel_In_g,4
	CALL SUBOPT_0x19
	CALL SUBOPT_0x16
; 0000 015E   Accel_In_g[Z] = Accel_In_g[Z] / ACCEL_Sensitivity;  //  g/LSB
	__GETD2MN _Accel_In_g,8
	CALL SUBOPT_0x19
	CALL SUBOPT_0x18
; 0000 015F 
; 0000 0160 }
	RJMP _0x212000C
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Gets angles from accelerometer data
;void Get_Accel_Angles()
; 0000 0164 {
_Get_Accel_Angles:
; .FSTART _Get_Accel_Angles
; 0000 0165 // If you want be averaged of accelerometer data, write (on),else write (off)
; 0000 0166 #define  GetAvrg  on
; 0000 0167 
; 0000 0168 #if GetAvrg == on
; 0000 0169     Get_AvrgAccel_Val();
	RCALL _Get_AvrgAccel_Val
; 0000 016A //  Calculate The Angle Of Each Axis
; 0000 016B     Accel_Angle[X] = 57.295*atan((float) AvrgAccel_Raw_Val[X] / sqrt(pow((float)AvrgAccel_Raw_Val[Z],2)+pow((float)AvrgA ...
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
; 0000 016C     Accel_Angle[Y] = 57.295*atan((float) AvrgAccel_Raw_Val[Y] / sqrt(pow((float)AvrgAccel_Raw_Val[Z],2)+pow((float)AvrgA ...
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
; 0000 016D     Accel_Angle[Z] = 57.295*atan((float) sqrt(pow((float)AvrgAccel_Raw_Val[X],2)+pow((float)AvrgAccel_Raw_Val[Y],2))/ Av ...
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
; 0000 016E #else
; 0000 016F     Get_Accel_Val();
; 0000 0170 //  Calculate The Angle Of Each Axis
; 0000 0171     Accel_Angle[X] = 57.295*atan((float) Accel_Raw_Val[X] / sqrt(pow((float)Accel_Raw_Val[Z],2)+pow((float)Accel_Raw_Val ...
; 0000 0172     Accel_Angle[Y] = 57.295*atan((float) Accel_Raw_Val[Y] / sqrt(pow((float)Accel_Raw_Val[Z],2)+pow((float)Accel_Raw_Val ...
; 0000 0173     Accel_Angle[Z] = 57.295*atan((float) sqrt(pow((float)Accel_Raw_Val[X],2)+pow((float)Accel_Raw_Val[Y],2))/ Accel_Raw_ ...
; 0000 0174 #endif
; 0000 0175 
; 0000 0176 }
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// get gyro offset X,Y,Z
;void Get_Gyro_Offset()
; 0000 017A {
_Get_Gyro_Offset:
; .FSTART _Get_Gyro_Offset
; 0000 017B   #define    NumAve4GO      100
; 0000 017C 
; 0000 017D   float Ave = 0;
; 0000 017E   unsigned char i = NumAve4GO;
; 0000 017F   Gyro_Offset_Val[X] = Gyro_Offset_Val[Y] = Gyro_Offset_Val[Z] = 0;
	CALL SUBOPT_0x2
;	Ave -> Y+1
;	i -> R17
	LDI  R17,100
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
; 0000 0180 
; 0000 0181   while(i--)
_0x1D:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x1F
; 0000 0182   {
; 0000 0183     Gyro_Offset_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8)|
; 0000 0184                            read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0)   );
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
; 0000 0185     Ave = (float) Ave + (Gyro_Offset_Val[X] / NumAve4GO);
	LDS  R26,_Gyro_Offset_Val
	LDS  R27,_Gyro_Offset_Val+1
	LDS  R24,_Gyro_Offset_Val+2
	LDS  R25,_Gyro_Offset_Val+3
	CALL SUBOPT_0x22
; 0000 0186     delay_us(1);
; 0000 0187   }
	RJMP _0x1D
_0x1F:
; 0000 0188   Gyro_Offset_Val[X] = Ave;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x20
; 0000 0189   Ave = 0;
	CALL SUBOPT_0x9
; 0000 018A   i = NumAve4GO;
; 0000 018B   while(i--)
_0x20:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x22
; 0000 018C   {
; 0000 018D     Gyro_Offset_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8)|
; 0000 018E                            read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0)   );
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
; 0000 018F     Ave = (float) Ave + (Gyro_Offset_Val[Y] / NumAve4GO);
	__GETD2MN _Gyro_Offset_Val,4
	CALL SUBOPT_0x22
; 0000 0190     delay_us(1);
; 0000 0191   }
	RJMP _0x20
_0x22:
; 0000 0192   Gyro_Offset_Val[Y] = Ave;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1F
; 0000 0193   Ave = 0;
	CALL SUBOPT_0x9
; 0000 0194   i = NumAve4GO;
; 0000 0195   while(i--)
_0x23:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x25
; 0000 0196   {
; 0000 0197       Gyro_Offset_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8)|
; 0000 0198                              read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0)   );
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
; 0000 0199     Ave = (float) Ave + (Gyro_Offset_Val[Z] / NumAve4GO);
	__GETD2MN _Gyro_Offset_Val,8
	CALL SUBOPT_0x22
; 0000 019A     delay_us(1);
; 0000 019B   }
	RJMP _0x23
_0x25:
; 0000 019C   Gyro_Offset_Val[Z] = Ave;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1E
; 0000 019D 
; 0000 019E }
_0x212000C:
	LDD  R17,Y+0
	ADIW R28,5
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Function to read the gyroscope rate data and convert it into degrees/s
;void Get_Gyro_Val()
; 0000 01A2 {
; 0000 01A3     Gyro_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8) |
; 0000 01A4                         read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0))    ;
; 0000 01A5     Gyro_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8) |
; 0000 01A6                         read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0))    ;
; 0000 01A7     Gyro_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8) |
; 0000 01A8                         read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0))    ;
; 0000 01A9 
; 0000 01AA     GyroRate_Val[X] = Gyro_Raw_Val[X] - Gyro_Offset_Val[X];
; 0000 01AB     GyroRate_Val[Y] = Gyro_Raw_Val[Y] - Gyro_Offset_Val[Y];
; 0000 01AC     GyroRate_Val[Z] = Gyro_Raw_Val[Z] - Gyro_Offset_Val[Z];
; 0000 01AD 
; 0000 01AE     GyroRate_Val[X] = GyroRate_Val[X] / GYRO_Sensitivity;
; 0000 01AF     GyroRate_Val[Y] = GyroRate_Val[Y] / GYRO_Sensitivity;
; 0000 01B0     GyroRate_Val[Z] = GyroRate_Val[Z] / GYRO_Sensitivity;
; 0000 01B1 
; 0000 01B2 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Function to read the Avrrage of gyroscope rate data and convert it into degrees/s
;void Get_AvrgGyro_Val()
; 0000 01B6 {
; 0000 01B7   #define    NumAve4G      50
; 0000 01B8 
; 0000 01B9   float Ave = 0;
; 0000 01BA   unsigned char i = NumAve4G;
; 0000 01BB   AvrgGyro_Raw_Val[X] = AvrgGyro_Raw_Val[Y] = AvrgGyro_Raw_Val[Z] = 0;
;	Ave -> Y+1
;	i -> R17
; 0000 01BC 
; 0000 01BD   while(i--)
; 0000 01BE   {
; 0000 01BF     AvrgGyro_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8)|
; 0000 01C0                             read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0)   );
; 0000 01C1     Ave = (float) Ave + (AvrgGyro_Raw_Val[X] / NumAve4G);
; 0000 01C2     delay_us(1);
; 0000 01C3   }
; 0000 01C4   AvrgGyro_Raw_Val[X] = Ave;
; 0000 01C5   Ave = 0;
; 0000 01C6   i = NumAve4G;
; 0000 01C7   while(i--)
; 0000 01C8   {
; 0000 01C9     AvrgGyro_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8)|
; 0000 01CA                             read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0)   );
; 0000 01CB     Ave = (float) Ave + (AvrgGyro_Raw_Val[Y] / NumAve4G);
; 0000 01CC     delay_us(1);
; 0000 01CD   }
; 0000 01CE   AvrgGyro_Raw_Val[Y] = Ave;
; 0000 01CF   Ave = 0;
; 0000 01D0   i = NumAve4G;
; 0000 01D1   while(i--)
; 0000 01D2   {
; 0000 01D3     AvrgGyro_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8)|
; 0000 01D4                             read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0)   );
; 0000 01D5     Ave = (float) Ave + (AvrgGyro_Raw_Val[Z] / NumAve4G);
; 0000 01D6     delay_us(1);
; 0000 01D7   }
; 0000 01D8   AvrgGyro_Raw_Val[Z] = Ave;
; 0000 01D9 
; 0000 01DA   GyroRate_Val[X] = AvrgGyro_Raw_Val[X] - Gyro_Offset_Val[X];
; 0000 01DB   GyroRate_Val[Y] = AvrgGyro_Raw_Val[Y] - Gyro_Offset_Val[Y];
; 0000 01DC   GyroRate_Val[Z] = AvrgGyro_Raw_Val[Z] - Gyro_Offset_Val[Z];
; 0000 01DD 
; 0000 01DE   GyroRate_Val[X] = GyroRate_Val[X] / GYRO_Sensitivity;   // (º/s)/LSB
; 0000 01DF   GyroRate_Val[Y] = GyroRate_Val[Y] / GYRO_Sensitivity;   // (º/s)/LSB
; 0000 01E0   GyroRate_Val[Z] = GyroRate_Val[Z] / GYRO_Sensitivity;   // (º/s)/LSB
; 0000 01E1 
; 0000 01E2 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Function to read the Temperature
;void Get_Temp_Val()
; 0000 01E6 {
; 0000 01E7     Temp_Val = ((read_i2c(MPU6050_ADDRESS, RA_TEMP_OUT_H, 0)<< 8)|
; 0000 01E8                   read_i2c(MPU6050_ADDRESS, RA_TEMP_OUT_L, 0)   );
; 0000 01E9 // Compute the temperature in degrees
; 0000 01EA     Temp_Val = (Temp_Val /TEMP_Sensitivity) + 36.53;
; 0000 01EB }
;
;
;
;
;
;
;// Declare your global variables here
;int cnt1,a1,a2,a3,a4,a5,a6;
;void WaitInPrint()
; 0000 01F5     {
; 0000 01F6     getchar();
; 0000 01F7     }
;
;
;
;
;
;
;
;
;////////////////////////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////////////////////////
;
;
;int gx,gy,gz;
;void getgyro()
; 0000 0207     {
; 0000 0208     Get_Gyro_Val();
; 0000 0209 
; 0000 020A     a1=Gyro_Raw_Val[X];
; 0000 020B     gx=a1;
; 0000 020C     if(a1>=-30 && a1<=30) a1=0;
; 0000 020D     if(a1>=0)
; 0000 020E         {
; 0000 020F         glcd_putcharxy(7,10,'+');
; 0000 0210         glcd_putcharxy(13,0,((a1/100)%10+'0'));
; 0000 0211         glcd_putcharxy(20,0,((a1/10)%10+'0'));
; 0000 0212         glcd_putcharxy(27,0,((a1/1)%10+'0'));
; 0000 0213         }
; 0000 0214     else if(a1 < 0)
; 0000 0215         {
; 0000 0216         glcd_putcharxy(7,0,'-');
; 0000 0217         glcd_putcharxy(13,0,((-a1/100)%10+'0'));
; 0000 0218         glcd_putcharxy(20,0,((-a1/10)%10+'0'));
; 0000 0219         glcd_putcharxy(27,0,((-a1/1)%10+'0'));
; 0000 021A         }
; 0000 021B     a1=Gyro_Raw_Val[Y];
; 0000 021C     gy=a1;
; 0000 021D     if(a1>=-30 && a1<=30) a1=0;
; 0000 021E     if(a1>=0)
; 0000 021F         {
; 0000 0220         glcd_putcharxy(7,10,'+');
; 0000 0221         glcd_putcharxy(13,10,((a1/100)%10+'0'));
; 0000 0222         glcd_putcharxy(20,10,((a1/10)%10+'0'));
; 0000 0223         glcd_putcharxy(27,10,((a1/1)%10+'0'));
; 0000 0224         }
; 0000 0225     else if(a1 < 0)
; 0000 0226         {
; 0000 0227         glcd_putcharxy(7,10,'-');
; 0000 0228         glcd_putcharxy(13,10,((-a1/100)%10+'0'));
; 0000 0229         glcd_putcharxy(20,10,((-a1/10)%10+'0'));
; 0000 022A         glcd_putcharxy(27,10,((-a1/1)%10+'0'));
; 0000 022B         }
; 0000 022C     a1=Gyro_Raw_Val[Z];
; 0000 022D     gz=a1;
; 0000 022E     if(a1>=-30 && a1<=30) a1=0;
; 0000 022F     if(a1>=0)
; 0000 0230         {
; 0000 0231         glcd_putcharxy(7,10,'+');
; 0000 0232         glcd_putcharxy(13,20,((a1/100)%10+'0'));
; 0000 0233         glcd_putcharxy(20,20,((a1/10)%10+'0'));
; 0000 0234         glcd_putcharxy(27,20,((a1/1)%10+'0'));
; 0000 0235         }
; 0000 0236     else if(a1 < 0)
; 0000 0237         {
; 0000 0238         glcd_putcharxy(7,20,'-');
; 0000 0239         glcd_putcharxy(13,20,((-a1/100)%10+'0'));
; 0000 023A         glcd_putcharxy(20,20,((-a1/10)%10+'0'));
; 0000 023B         glcd_putcharxy(27,20,((-a1/1)%10+'0'));
; 0000 023C         }
; 0000 023D     }
;
;
;int ax,ay,az;
;void getaccel()
; 0000 0242     {
_getaccel:
; .FSTART _getaccel
; 0000 0243     //Get_Accel_Val();
; 0000 0244     Get_Accel_Angles();
	RCALL _Get_Accel_Angles
; 0000 0245     //Get_AvrgAccel_Val();
; 0000 0246 
; 0000 0247     a1=Accel_Angle[X];
	LDS  R30,_Accel_Angle
	LDS  R31,_Accel_Angle+1
	LDS  R22,_Accel_Angle+2
	LDS  R23,_Accel_Angle+3
	CALL __CFD1
	MOVW R6,R30
; 0000 0248     ax=a1;
	__PUTWMRN _ax,0,6,7
; 0000 0249     //if(a1>=-30 && a1<=30) a1=0;
; 0000 024A     if(a1>=0)
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRLT _0x41
; 0000 024B         {
; 0000 024C         glcd_putcharxy(7,10,'+');
	CALL SUBOPT_0x23
; 0000 024D         glcd_putcharxy(13,0,((a1/100)%10+'0'));
	LDI  R30,LOW(0)
	CALL SUBOPT_0x24
; 0000 024E         glcd_putcharxy(20,0,((a1/10)%10+'0'));
	LDI  R30,LOW(0)
	CALL SUBOPT_0x25
; 0000 024F         glcd_putcharxy(27,0,((a1/1)%10+'0'));
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R26,R6
	RJMP _0x52
; 0000 0250         }
; 0000 0251     else if(a1 < 0)
_0x41:
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRGE _0x43
; 0000 0252         {
; 0000 0253         glcd_putcharxy(7,0,'-');
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x26
; 0000 0254         glcd_putcharxy(13,0,((-a1/100)%10+'0'));
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
; 0000 0255         glcd_putcharxy(20,0,((-a1/10)%10+'0'));
	CALL SUBOPT_0x27
	CALL SUBOPT_0x29
; 0000 0256         glcd_putcharxy(27,0,((-a1/1)%10+'0'));
	CALL SUBOPT_0x27
_0x52:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x2A
; 0000 0257         }
; 0000 0258     a1=Accel_Angle[Y]-1;
_0x43:
	__GETD2MN _Accel_Angle,4
	CALL SUBOPT_0x2B
; 0000 0259     ay=a1;
	__PUTWMRN _ay,0,6,7
; 0000 025A     //if(a1>=-30 && a1<=30) a1=0;
; 0000 025B     if(a1>=0)
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRLT _0x44
; 0000 025C         {
; 0000 025D         glcd_putcharxy(7,10,'+');
	CALL SUBOPT_0x23
; 0000 025E         glcd_putcharxy(13,10,((a1/100)%10+'0'));
	LDI  R30,LOW(10)
	CALL SUBOPT_0x24
; 0000 025F         glcd_putcharxy(20,10,((a1/10)%10+'0'));
	LDI  R30,LOW(10)
	CALL SUBOPT_0x25
; 0000 0260         glcd_putcharxy(27,10,((a1/1)%10+'0'));
	LDI  R30,LOW(10)
	ST   -Y,R30
	MOVW R26,R6
	RJMP _0x53
; 0000 0261         }
; 0000 0262     else if(a1 < 0)
_0x44:
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRGE _0x46
; 0000 0263         {
; 0000 0264         glcd_putcharxy(7,10,'-');
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(10)
	CALL SUBOPT_0x26
; 0000 0265         glcd_putcharxy(13,10,((-a1/100)%10+'0'));
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x28
; 0000 0266         glcd_putcharxy(20,10,((-a1/10)%10+'0'));
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x29
; 0000 0267         glcd_putcharxy(27,10,((-a1/1)%10+'0'));
	CALL SUBOPT_0x2C
_0x53:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x2A
; 0000 0268         }
; 0000 0269     a1=Accel_Angle[Z]-1;
_0x46:
	__GETD2MN _Accel_Angle,8
	CALL SUBOPT_0x2B
; 0000 026A     az=a1;
	__PUTWMRN _az,0,6,7
; 0000 026B     //if(a1>=-30 && a1<=30) a1=0;
; 0000 026C     if(a1>=0)
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRLT _0x47
; 0000 026D         {
; 0000 026E         glcd_putcharxy(7,10,'+');
	CALL SUBOPT_0x23
; 0000 026F         glcd_putcharxy(13,20,((a1/100)%10+'0'));
	LDI  R30,LOW(20)
	CALL SUBOPT_0x24
; 0000 0270         glcd_putcharxy(20,20,((a1/10)%10+'0'));
	LDI  R30,LOW(20)
	CALL SUBOPT_0x25
; 0000 0271         glcd_putcharxy(27,20,((a1/1)%10+'0'));
	LDI  R30,LOW(20)
	ST   -Y,R30
	MOVW R26,R6
	RJMP _0x54
; 0000 0272         }
; 0000 0273     else if(a1 < 0)
_0x47:
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRGE _0x49
; 0000 0274         {
; 0000 0275         glcd_putcharxy(7,20,'-');
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(20)
	CALL SUBOPT_0x26
; 0000 0276         glcd_putcharxy(13,20,((-a1/100)%10+'0'));
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x28
; 0000 0277         glcd_putcharxy(20,20,((-a1/10)%10+'0'));
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x29
; 0000 0278         glcd_putcharxy(27,20,((-a1/1)%10+'0'));
	CALL SUBOPT_0x2D
_0x54:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x2A
; 0000 0279         }
; 0000 027A     }
_0x49:
	RET
; .FEND
;
;int x=0,y=0,cmp,c=0;
;
;void main(void)
; 0000 027F {
_main:
; .FSTART _main
; 0000 0280 // Declare your local variables here
; 0000 0281 // Variable used to store graphic display
; 0000 0282 // controller initialization data
; 0000 0283 GLCDINIT_t glcd_init_data;
; 0000 0284 
; 0000 0285 // Input/Output Ports initialization
; 0000 0286 // Port A initialization
; 0000 0287 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0288 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,8
;	glcd_init_data -> Y+0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0289 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 028A PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 028B 
; 0000 028C // Port B initialization
; 0000 028D // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 028E DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 028F // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0290 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0291 
; 0000 0292 // Port C initialization
; 0000 0293 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0294 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0295 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0296 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0297 
; 0000 0298 // Port D initialization
; 0000 0299 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 029A DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 029B // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 029C PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 029D 
; 0000 029E // Timer/Counter 0 initialization
; 0000 029F // Clock source: System Clock
; 0000 02A0 // Clock value: Timer 0 Stopped
; 0000 02A1 // Mode: Normal top=0xFF
; 0000 02A2 // OC0 output: Disconnected
; 0000 02A3 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 02A4 TCNT0=0x00;
	OUT  0x32,R30
; 0000 02A5 OCR0=0x00;
	OUT  0x3C,R30
; 0000 02A6 
; 0000 02A7 // Timer/Counter 1 initialization
; 0000 02A8 // Clock source: System Clock
; 0000 02A9 // Clock value: Timer1 Stopped
; 0000 02AA // Mode: Normal top=0xFFFF
; 0000 02AB // OC1A output: Disconnected
; 0000 02AC // OC1B output: Disconnected
; 0000 02AD // Noise Canceler: Off
; 0000 02AE // Input Capture on Falling Edge
; 0000 02AF // Timer1 Overflow Interrupt: Off
; 0000 02B0 // Input Capture Interrupt: Off
; 0000 02B1 // Compare A Match Interrupt: Off
; 0000 02B2 // Compare B Match Interrupt: Off
; 0000 02B3 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 02B4 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 02B5 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 02B6 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 02B7 ICR1H=0x00;
	OUT  0x27,R30
; 0000 02B8 ICR1L=0x00;
	OUT  0x26,R30
; 0000 02B9 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 02BA OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 02BB OCR1BH=0x00;
	OUT  0x29,R30
; 0000 02BC OCR1BL=0x00;
	OUT  0x28,R30
; 0000 02BD 
; 0000 02BE // Timer/Counter 2 initialization
; 0000 02BF // Clock source: System Clock
; 0000 02C0 // Clock value: Timer2 Stopped
; 0000 02C1 // Mode: Normal top=0xFF
; 0000 02C2 // OC2 output: Disconnected
; 0000 02C3 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 02C4 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 02C5 TCNT2=0x00;
	OUT  0x24,R30
; 0000 02C6 OCR2=0x00;
	OUT  0x23,R30
; 0000 02C7 
; 0000 02C8 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02C9 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 02CA 
; 0000 02CB // External Interrupt(s) initialization
; 0000 02CC // INT0: Off
; 0000 02CD // INT1: Off
; 0000 02CE // INT2: Off
; 0000 02CF MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 02D0 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 02D1 
; 0000 02D2 // USART initialization
; 0000 02D3 // USART disabled
; 0000 02D4 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 02D5 
; 0000 02D6 // Analog Comparator initialization
; 0000 02D7 // Analog Comparator: Off
; 0000 02D8 // The Analog Comparator's positive input is
; 0000 02D9 // connected to the AIN0 pin
; 0000 02DA // The Analog Comparator's negative input is
; 0000 02DB // connected to the AIN1 pin
; 0000 02DC ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02DD 
; 0000 02DE // ADC initialization
; 0000 02DF // ADC Clock frequency: 62/500 kHz
; 0000 02E0 // ADC Voltage Reference: AVCC pin
; 0000 02E1 // ADC Auto Trigger Source: ADC Stopped
; 0000 02E2 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 02E3 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 02E4 SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 02E5 
; 0000 02E6 // SPI initialization
; 0000 02E7 // SPI disabled
; 0000 02E8 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 02E9 
; 0000 02EA // TWI initialization
; 0000 02EB // TWI disabled
; 0000 02EC TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 02ED 
; 0000 02EE // Bit-Banged I2C Bus initialization
; 0000 02EF // I2C Port: PORTB
; 0000 02F0 // I2C SDA bit: 1
; 0000 02F1 // I2C SCL bit: 0
; 0000 02F2 // Bit Rate: 100 kHz
; 0000 02F3 // Note: I2C settings are specified in the
; 0000 02F4 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 02F5 i2c_init();
	CALL _i2c_init
; 0000 02F6 
; 0000 02F7 // Graphic Display Controller initialization
; 0000 02F8 // The PCD8544 connections are specified in the
; 0000 02F9 // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 02FA // SDIN - PORTC Bit 0
; 0000 02FB // SCLK - PORTC Bit 1
; 0000 02FC // D /C - PORTC Bit 2
; 0000 02FD // /SCE - PORTC Bit 3
; 0000 02FE // /RES - PORTC Bit 4
; 0000 02FF 
; 0000 0300 // Specify the current font for displaying text
; 0000 0301 glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0302 // No function is used for reading
; 0000 0303 // image data from external memory
; 0000 0304 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 0305 // No function is used for writing
; 0000 0306 // image data to external memory
; 0000 0307 glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 0308 // Set the LCD temperature coefficient
; 0000 0309 glcd_init_data.temp_coef=PCD8544_DEFAULT_TEMP_COEF;
	LDD  R30,Y+6
	ANDI R30,LOW(0xFC)
	STD  Y+6,R30
; 0000 030A // Set the LCD bias
; 0000 030B glcd_init_data.bias=PCD8544_DEFAULT_BIAS;
	ANDI R30,LOW(0xE3)
	ORI  R30,LOW(0xC)
	STD  Y+6,R30
; 0000 030C // Set the LCD contrast control voltage VLCD
; 0000 030D glcd_init_data.vlcd=PCD8544_DEFAULT_VLCD;
	LDD  R30,Y+7
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x32)
	STD  Y+7,R30
; 0000 030E 
; 0000 030F glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 0310 
; 0000 0311 
; 0000 0312 
; 0000 0313 
; 0000 0314 
; 0000 0315 MPU6050_Init();
	RCALL _MPU6050_Init
; 0000 0316 Get_Accel_Offset();
	RCALL _Get_Accel_Offset
; 0000 0317 Get_Gyro_Offset();
	RCALL _Get_Gyro_Offset
; 0000 0318 
; 0000 0319 
; 0000 031A while (1)
_0x4A:
; 0000 031B     {
; 0000 031C     // Place your code here
; 0000 031D 
; 0000 031E     getaccel();
	RCALL _getaccel
; 0000 031F     //delay_ms(300);
; 0000 0320     x+=abs(ax);
	LDS  R26,_ax
	LDS  R27,_ax+1
	CALL _abs
	CALL SUBOPT_0x2E
	ADD  R30,R26
	ADC  R31,R27
	STS  _x,R30
	STS  _x+1,R31
; 0000 0321     glcd_putcharxy(40,0,((x/100)%10+'0'));
	LDI  R30,LOW(40)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
; 0000 0322     glcd_putchar((x/10)%10+'0');
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x30
; 0000 0323     glcd_putchar((x/1)%10+'0');
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x31
; 0000 0324 
; 0000 0325     y+=abs(ay);
	LDS  R26,_ay
	LDS  R27,_ay+1
	CALL _abs
	CALL SUBOPT_0x32
	ADD  R30,R26
	ADC  R31,R27
	STS  _y,R30
	STS  _y+1,R31
; 0000 0326     glcd_putcharxy(40,10,((y/100)%10+'0'));
	LDI  R30,LOW(40)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL SUBOPT_0x32
	CALL SUBOPT_0x2F
; 0000 0327     glcd_putchar((y/10)%10+'0');
	CALL SUBOPT_0x32
	CALL SUBOPT_0x30
; 0000 0328     glcd_putchar((y/1)%10+'0');
	CALL SUBOPT_0x32
	CALL SUBOPT_0x31
; 0000 0329 
; 0000 032A //    Get_Gyro_Val();
; 0000 032B //    a1=(Gyro_Raw_Val[Z]/1000);
; 0000 032C //    cmp+=a1;
; 0000 032D //    if(cmp>255)  cmp=255;
; 0000 032E //    if(cmp<-255) cmp=-255;
; 0000 032F //
; 0000 0330 //    glcd_outtextxy(0,10,"CMP:");
; 0000 0331 //    if(cmp>=0)
; 0000 0332 //        {
; 0000 0333 //        glcd_putchar('+');
; 0000 0334 //        glcd_putchar((cmp/1000)%10+'0');
; 0000 0335 //        glcd_putchar((cmp/100)%10+'0');
; 0000 0336 //        glcd_putchar((cmp/10)%10+'0');
; 0000 0337 //        glcd_putchar((cmp/1)%10+'0');
; 0000 0338 //        }
; 0000 0339 //    else
; 0000 033A //        {
; 0000 033B //        glcd_putchar('-');
; 0000 033C //        glcd_putchar((-cmp/1000)%10+'0');
; 0000 033D //        glcd_putchar((-cmp/100)%10+'0');
; 0000 033E //        glcd_putchar((-cmp/10)%10+'0');
; 0000 033F //        glcd_putchar((-cmp/1)%10+'0');
; 0000 0340 //        }
; 0000 0341 //
; 0000 0342 //
; 0000 0343     }
	RJMP _0x4A
; 0000 0344 }
_0x4D:
	RJMP _0x4D
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
	RJMP _0x212000B
; .FEND
_pcd8544_wrcmd:
; .FSTART _pcd8544_wrcmd
	ST   -Y,R26
	CBI  0x15,2
	LD   R26,Y
	RCALL _pcd8544_wrbus_G100
	RJMP _0x212000A
; .FEND
_pcd8544_wrdata_G100:
; .FSTART _pcd8544_wrdata_G100
	ST   -Y,R26
	SBI  0x15,2
	LD   R26,Y
	RCALL _pcd8544_wrbus_G100
	RJMP _0x212000A
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
	ADIW R28,3
	RET
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
	RJMP _0x212000B
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
_0x212000B:
	ADIW R28,2
	RET
; .FEND
_pcd8544_wrbyte:
; .FSTART _pcd8544_wrbyte
	ST   -Y,R26
	CALL SUBOPT_0x33
	LD   R26,Y
	STD  Z+0,R26
	RCALL _pcd8544_wrdata_G100
	RJMP _0x212000A
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
	RJMP _0x2120009
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
_0x212000A:
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
	ADIW R28,4
	RET
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
_0x2120009:
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
	RJMP _0x2120008
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
	RJMP _0x2120008
_0x2000034:
	CPI  R30,LOW(0x3)
	BRNE _0x2000037
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000036
	RJMP _0x2120008
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
	CALL SUBOPT_0x34
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
	CALL SUBOPT_0x35
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
	CALL SUBOPT_0x34
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
	CALL SUBOPT_0x35
	RJMP _0x2000046
_0x2000048:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x34
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
	CALL SUBOPT_0x36
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
	CALL SUBOPT_0x37
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x33
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
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x200006D
	CPI  R30,LOW(0x8)
	BRNE _0x200006E
_0x200006D:
_0x2000066:
	CALL SUBOPT_0x39
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
	CALL SUBOPT_0x3A
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
	CALL SUBOPT_0x36
_0x200007D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200007F
	CALL SUBOPT_0x33
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x3B
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x37
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
	CALL SUBOPT_0x39
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
	CALL SUBOPT_0x3A
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
	CALL SUBOPT_0x3C
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
	CALL SUBOPT_0x36
_0x2000092:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000094
	CALL SUBOPT_0x33
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x3B
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x37
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
	CALL SUBOPT_0x39
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
	CALL SUBOPT_0x3A
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
	CALL SUBOPT_0x3C
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
_0x2120008:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x3D
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
	CALL SUBOPT_0x3D
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
	CALL SUBOPT_0x3E
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	CALL SUBOPT_0x3F
	JMP  _0x2120005
_0x202000B:
	CALL SUBOPT_0x40
	STD  Y+7,R0
	CALL SUBOPT_0x40
	STD  Y+6,R0
	CALL SUBOPT_0x40
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	CALL SUBOPT_0x3F
	JMP  _0x2120005
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
	CALL SUBOPT_0x3F
	JMP  _0x2120005
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
	CALL __LOADLOCR6
	JMP  _0x2120005
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
	CALL __LOADLOCR6
	JMP  _0x2120005
; .FEND
_glcd_new_line_G101:
; .FSTART _glcd_new_line_G101
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x41
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
	CALL SUBOPT_0x3E
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
	CALL __LOADLOCR6
	JMP  _0x2120004
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
	CALL SUBOPT_0x41
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
	CALL SUBOPT_0x41
	CALL SUBOPT_0x42
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x41
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x42
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020024
_0x2020021:
	RCALL _glcd_new_line_G101
	CALL __LOADLOCR6
	JMP  _0x2120004
_0x2020024:
_0x202001F:
	__PUTBMRN _glcd_state,2,16
	CALL __LOADLOCR6
	JMP  _0x2120004
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
_abs:
; .FSTART _abs
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    sbiw r30,0
    brpl __abs0
    com  r30
    com  r31
    adiw r30,1
__abs0:
    ret
; .FEND

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
	CALL SUBOPT_0x43
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x44
	JMP  _0x2120001
__floor1:
    brtc __floor0
	CALL SUBOPT_0x45
	CALL __SUBF12
	JMP  _0x2120001
; .FEND
_log:
; .FSTART _log
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x46
	CALL __CPD02
	BRLT _0x20A000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x2120007
_0x20A000C:
	CALL SUBOPT_0x47
	CALL __PUTPARD1
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0x48
	CALL SUBOPT_0x46
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x20A000D
	CALL SUBOPT_0x49
	CALL __ADDF12
	CALL SUBOPT_0x48
	__SUBWRN 16,17,1
_0x20A000D:
	CALL SUBOPT_0x4A
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4A
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x48
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4B
	__GETD2N 0x3F654226
	CALL SUBOPT_0x4C
	__GETD1N 0x4054114E
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x46
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4E
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
_0x2120007:
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
	CALL SUBOPT_0x4F
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x20A000F
	CALL SUBOPT_0x1D
	RJMP _0x2120006
_0x20A000F:
	__GETD1S 10
	CALL __CPD10
	BRNE _0x20A0010
	__GETD1N 0x3F800000
	RJMP _0x2120006
_0x20A0010:
	CALL SUBOPT_0x4F
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x20A0011
	__GETD1N 0x7F7FFFFF
	RJMP _0x2120006
_0x20A0011:
	CALL SUBOPT_0x4F
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	__PUTD1S 10
	CALL SUBOPT_0x4F
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	CALL SUBOPT_0x4F
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x4D
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x48
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4B
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0x46
	CALL __MULF12
	CALL SUBOPT_0x48
	CALL SUBOPT_0x4E
	__GETD2N 0x41A68D28
	CALL __ADDF12
	__PUTD1S 2
	CALL SUBOPT_0x47
	__GETD2S 2
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x46
	CALL SUBOPT_0x4E
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL __PUTPARD1
	MOVW R26,R16
	CALL _ldexp
_0x2120006:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
; .FEND
_pow:
; .FSTART _pow
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x50
	CALL __CPD10
	BRNE _0x20A0012
	CALL SUBOPT_0x1D
	RJMP _0x2120005
_0x20A0012:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x20A0013
	CALL SUBOPT_0x51
	CALL __CPD10
	BRNE _0x20A0014
	__GETD1N 0x3F800000
	RJMP _0x2120005
_0x20A0014:
	__GETD2S 8
	CALL SUBOPT_0x52
	RCALL _exp
	RJMP _0x2120005
_0x20A0013:
	CALL SUBOPT_0x51
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0x44
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x51
	CALL __CPD12
	BREQ _0x20A0015
	CALL SUBOPT_0x1D
	RJMP _0x2120005
_0x20A0015:
	CALL SUBOPT_0x50
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x52
	RCALL _exp
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x20A0016
	CALL SUBOPT_0x50
	RJMP _0x2120005
_0x20A0016:
	CALL SUBOPT_0x50
	CALL __ANEGF1
_0x2120005:
	ADIW R28,12
	RET
; .FEND
_xatan:
; .FSTART _xatan
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x51
	CALL SUBOPT_0x53
	CALL __PUTD1S0
	CALL SUBOPT_0x44
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x54
	CALL SUBOPT_0x53
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x44
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x55
	CALL SUBOPT_0x54
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
_0x2120004:
	ADIW R28,8
	RET
; .FEND
_yatan:
; .FSTART _yatan
	CALL SUBOPT_0x43
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x20A0020
	CALL SUBOPT_0x55
	RCALL _xatan
	RJMP _0x2120001
_0x20A0020:
	CALL SUBOPT_0x55
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x20A0021
	CALL SUBOPT_0x45
	CALL SUBOPT_0x56
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0x4D
	RJMP _0x2120001
_0x20A0021:
	CALL SUBOPT_0x45
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x45
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x56
	__GETD2N 0x3F490FDB
	CALL __ADDF12
	RJMP _0x2120001
; .FEND
_atan:
; .FSTART _atan
	CALL __PUTPARD2
	LDD  R26,Y+3
	TST  R26
	BRMI _0x20A002C
	CALL SUBOPT_0x55
	RCALL _yatan
	RJMP _0x2120001
_0x20A002C:
	CALL SUBOPT_0x44
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	RCALL _yatan
	CALL __ANEGF1
	RJMP _0x2120001
; .FEND

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
_gx:
	.BYTE 0x2
_gy:
	.BYTE 0x2
_gz:
	.BYTE 0x2
_ax:
	.BYTE 0x2
_ay:
	.BYTE 0x2
_az:
	.BYTE 0x2
_x:
	.BYTE 0x2
_y:
	.BYTE 0x2
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R26,LOW(43)
	CALL _glcd_putcharxy
	LDI  R30,LOW(13)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x24:
	ST   -Y,R30
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
	CALL _glcd_putcharxy
	LDI  R30,LOW(20)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x25:
	ST   -Y,R30
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
	CALL _glcd_putcharxy
	LDI  R30,LOW(27)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	ST   -Y,R30
	LDI  R26,LOW(45)
	CALL _glcd_putcharxy
	LDI  R30,LOW(13)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R30,R6
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x28:
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
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x29:
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
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2A:
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _glcd_putcharxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2B:
	__GETD1N 0x3F800000
	CALL __SWAPD12
	CALL __SUBF12
	CALL __CFD1
	MOVW R6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(10)
	ST   -Y,R30
	MOVW R30,R6
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(20)
	ST   -Y,R30
	MOVW R30,R6
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	LDS  R26,_x
	LDS  R27,_x+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _glcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _glcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	LDS  R26,_y
	LDS  R27,_y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x33:
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
SUBOPT_0x34:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x35:
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
SUBOPT_0x36:
	ST   -Y,R16
	LDD  R26,Y+16
	JMP  _pcd8544_setaddr_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x37:
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
SUBOPT_0x38:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3B:
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
SUBOPT_0x3C:
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
	RJMP SUBOPT_0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __LOADLOCR6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x41:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x42:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	CALL __PUTPARD2
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x44:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x45:
	RCALL SUBOPT_0x44
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x46:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x47:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x48:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	RCALL SUBOPT_0x47
	RJMP SUBOPT_0x46

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	RCALL SUBOPT_0x47
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4B:
	CALL __MULF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4F:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x51:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x52:
	CALL _log
	__GETD2S 4
	RJMP SUBOPT_0x4C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	__GETD2S 4
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x54:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x55:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
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

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
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
