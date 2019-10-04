
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
	.DEF _i=R4
	.DEF _i_msb=R5
	.DEF _j=R6
	.DEF _j_msb=R7
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

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x32,0x0
	.DB  0x14,0x0

_0x3:
	.DB  0x2
_0x4:
	.DB  0x3
_0x5:
	.DB  0x3
_0x6:
	.DB  0x2
_0x7:
	.DB  0xA
_0x8:
	.DB  0xA
_0x9:
	.DB  0xE6,0xCB,0x96,0x40
_0xA:
	.DB  0xE6,0xCB,0x96,0x40
_0xB:
	.DB  0xE6,0xCB,0x96,0x40
_0x0:
	.DB  0x44,0x69,0x73,0x74,0x61,0x6E,0x63,0x65
	.DB  0x3A,0x0,0x63,0x6D,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x08
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _cntx
	.DW  _0x3*2

	.DW  0x01
	.DW  _cnty
	.DW  _0x4*2

	.DW  0x01
	.DW  _cntx1
	.DW  _0x5*2

	.DW  0x01
	.DW  _cnty1
	.DW  _0x6*2

	.DW  0x01
	.DW  _x4
	.DW  _0x7*2

	.DW  0x01
	.DW  _y4
	.DW  _0x8*2

	.DW  0x04
	.DW  _cnt3
	.DW  _0x9*2

	.DW  0x04
	.DW  _cnt4
	.DW  _0xA*2

	.DW  0x04
	.DW  _cnt5
	.DW  _0xB*2

	.DW  0x0A
	.DW  _0x2C
	.DW  _0x0*2

	.DW  0x03
	.DW  _0x2C+10
	.DW  _0x0*2+10

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
;Date    : 1/7/2017
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
;#include <delay.h>
;#include <math.h>
;// Graphic Display functions
;#include <glcd.h>
;
;// Font used for displaying text
;// on the graphic display
;#include <font5x7.h>
;
;// Declare your global variables here
;int i,j,cnt1=0,x=50,y=20,cntx=2,cnty=3,cntx1=3,cnty1=2,cnt2=0,x1,y1,x2,y2,x3,y3,x4=10,y4=10,cnt6=0,cnt7=0,cnt8=0;

	.DSEG
;float cnt3=4.71239,cnt4=4.71239,cnt5=4.71239;
;
;
;void main(void)
; 0000 0028 {

	.CSEG
_main:
; .FSTART _main
; 0000 0029 // Declare your local variables here
; 0000 002A // Variable used to store graphic display
; 0000 002B // controller initialization data
; 0000 002C GLCDINIT_t glcd_init_data;
; 0000 002D 
; 0000 002E // Input/Output Ports initialization
; 0000 002F // Port A initialization
; 0000 0030 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0031 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,8
;	glcd_init_data -> Y+0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0032 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0033 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0034 
; 0000 0035 // Port B initialization
; 0000 0036 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0037 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0038 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0039 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 003A 
; 0000 003B // Port C initialization
; 0000 003C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 003D DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 003E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 003F PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0040 
; 0000 0041 // Port D initialization
; 0000 0042 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0043 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0044 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0045 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0046 
; 0000 0047 // Timer/Counter 0 initialization
; 0000 0048 // Clock source: System Clock
; 0000 0049 // Clock value: Timer 0 Stopped
; 0000 004A // Mode: Normal top=0xFF
; 0000 004B // OC0 output: Disconnected
; 0000 004C TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 004D TCNT0=0x00;
	OUT  0x32,R30
; 0000 004E OCR0=0x00;
	OUT  0x3C,R30
; 0000 004F 
; 0000 0050 // Timer/Counter 1 initialization
; 0000 0051 // Clock source: System Clock
; 0000 0052 // Clock value: Timer1 Stopped
; 0000 0053 // Mode: Normal top=0xFFFF
; 0000 0054 // OC1A output: Disconnected
; 0000 0055 // OC1B output: Disconnected
; 0000 0056 // Noise Canceler: Off
; 0000 0057 // Input Capture on Falling Edge
; 0000 0058 // Timer1 Overflow Interrupt: Off
; 0000 0059 // Input Capture Interrupt: Off
; 0000 005A // Compare A Match Interrupt: Off
; 0000 005B // Compare B Match Interrupt: Off
; 0000 005C TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 005D TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 005E TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 005F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0060 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0061 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0062 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0063 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0064 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0065 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0066 
; 0000 0067 // Timer/Counter 2 initialization
; 0000 0068 // Clock source: System Clock
; 0000 0069 // Clock value: Timer2 Stopped
; 0000 006A // Mode: Normal top=0xFF
; 0000 006B // OC2 output: Disconnected
; 0000 006C ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 006D TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 006E TCNT2=0x00;
	OUT  0x24,R30
; 0000 006F OCR2=0x00;
	OUT  0x23,R30
; 0000 0070 
; 0000 0071 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0072 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0073 
; 0000 0074 // External Interrupt(s) initialization
; 0000 0075 // INT0: Off
; 0000 0076 // INT1: Off
; 0000 0077 // INT2: Off
; 0000 0078 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0079 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 007A 
; 0000 007B // USART initialization
; 0000 007C // USART disabled
; 0000 007D UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 007E 
; 0000 007F // Analog Comparator initialization
; 0000 0080 // Analog Comparator: Off
; 0000 0081 // The Analog Comparator's positive input is
; 0000 0082 // connected to the AIN0 pin
; 0000 0083 // The Analog Comparator's negative input is
; 0000 0084 // connected to the AIN1 pin
; 0000 0085 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0086 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0087 
; 0000 0088 // ADC initialization
; 0000 0089 // ADC disabled
; 0000 008A ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 008B 
; 0000 008C // SPI initialization
; 0000 008D // SPI disabled
; 0000 008E SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 008F 
; 0000 0090 // TWI initialization
; 0000 0091 // TWI disabled
; 0000 0092 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0093 
; 0000 0094 // Graphic Display Controller initialization
; 0000 0095 // The PCD8544 connections are specified in the
; 0000 0096 // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 0097 // SDIN - PORTC Bit 0
; 0000 0098 // SCLK - PORTC Bit 1
; 0000 0099 // D /C - PORTC Bit 2
; 0000 009A // /SCE - PORTC Bit 3
; 0000 009B // /RES - PORTC Bit 4
; 0000 009C 
; 0000 009D // Specify the current font for displaying text
; 0000 009E glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 009F // No function is used for reading
; 0000 00A0 // image data from external memory
; 0000 00A1 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 00A2 // No function is used for writing
; 0000 00A3 // image data to external memory
; 0000 00A4 glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 00A5 // Set the LCD temperature coefficient
; 0000 00A6 glcd_init_data.temp_coef=PCD8544_DEFAULT_TEMP_COEF;
	LDD  R30,Y+6
	ANDI R30,LOW(0xFC)
	STD  Y+6,R30
; 0000 00A7 // Set the LCD bias
; 0000 00A8 glcd_init_data.bias=PCD8544_DEFAULT_BIAS;
	ANDI R30,LOW(0xE3)
	ORI  R30,LOW(0xC)
	STD  Y+6,R30
; 0000 00A9 // Set the LCD contrast control voltage VLCD
; 0000 00AA glcd_init_data.vlcd=PCD8544_DEFAULT_VLCD;
	LDD  R30,Y+7
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x32)
	STD  Y+7,R30
; 0000 00AB 
; 0000 00AC glcd_init(&glcd_init_data);
	MOVW R26,R28
	CALL _glcd_init
; 0000 00AD 
; 0000 00AE while (1)
_0xC:
; 0000 00AF       {
; 0000 00B0       // Place your code here
; 0000 00B1 //      glcd_putcharxy(10,10,'F');
; 0000 00B2       if(PINA.1 == 0)
	SBIC 0x19,1
	RJMP _0xF
; 0000 00B3         {
; 0000 00B4         cnt2++;
	LDI  R26,LOW(_cnt2)
	LDI  R27,HIGH(_cnt2)
	CALL SUBOPT_0x0
; 0000 00B5         delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0000 00B6         glcd_clear();
	CALL _glcd_clear
; 0000 00B7         }
; 0000 00B8       cnt2%=4;
_0xF:
	LDS  R30,_cnt2
	LDS  R31,_cnt2+1
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	STS  _cnt2,R30
	STS  _cnt2+1,R31
; 0000 00B9       if (cnt2 == 0)
	SBIW R30,0
	BREQ PC+2
	RJMP _0x10
; 0000 00BA           {
; 0000 00BB           glcd_clear();
	CALL _glcd_clear
; 0000 00BC           glcd_fillcircle(x,y,5);
	ST   -Y,R10
	ST   -Y,R12
	LDI  R26,LOW(5)
	CALL _glcd_fillcircle
; 0000 00BD           glcd_fillcircle(x4,y4,5);
	LDS  R30,_x4
	ST   -Y,R30
	LDS  R30,_y4
	ST   -Y,R30
	LDI  R26,LOW(5)
	CALL _glcd_fillcircle
; 0000 00BE           glcd_rectangle(0,0,84,48);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(84)
	ST   -Y,R30
	LDI  R26,LOW(48)
	CALL _glcd_rectangle
; 0000 00BF           if (x < 6 || x > 78) cntx*=-1;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R10,R30
	CPC  R11,R31
	BRLT _0x12
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0x11
_0x12:
	CALL SUBOPT_0x1
; 0000 00C0           if (y < 6 || y > 42) cnty*=-1;
_0x11:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R12,R30
	CPC  R13,R31
	BRLT _0x15
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x14
_0x15:
	LDS  R30,_cnty
	LDS  R31,_cnty+1
	CALL SUBOPT_0x2
	STS  _cnty,R30
	STS  _cnty+1,R31
; 0000 00C1           if (x4 < 6 || x4 > 78) cntx1*=-1;
_0x14:
	CALL SUBOPT_0x3
	SBIW R26,6
	BRLT _0x18
	CALL SUBOPT_0x3
	CPI  R26,LOW(0x4F)
	LDI  R30,HIGH(0x4F)
	CPC  R27,R30
	BRLT _0x17
_0x18:
	CALL SUBOPT_0x4
	STS  _cntx1,R30
	STS  _cntx1+1,R31
; 0000 00C2           if (y4 < 6 || y4 > 42) cnty1*=-1;
_0x17:
	CALL SUBOPT_0x5
	SBIW R26,6
	BRLT _0x1B
	CALL SUBOPT_0x5
	SBIW R26,43
	BRLT _0x1A
_0x1B:
	LDS  R30,_cnty1
	LDS  R31,_cnty1+1
	CALL SUBOPT_0x2
	STS  _cnty1,R30
	STS  _cnty1+1,R31
; 0000 00C3           if (x-x4<10 && y-y4<10 && x-x4>-10 && y-y4>-10)
_0x1A:
	CALL SUBOPT_0x3
	MOVW R30,R10
	SUB  R30,R26
	SBC  R31,R27
	MOVW R0,R30
	SBIW R30,10
	BRGE _0x1E
	CALL SUBOPT_0x5
	MOVW R30,R12
	SUB  R30,R26
	SBC  R31,R27
	SBIW R30,10
	BRGE _0x1E
	LDI  R30,LOW(65526)
	LDI  R31,HIGH(65526)
	CP   R30,R0
	CPC  R31,R1
	BRGE _0x1E
	CALL SUBOPT_0x5
	MOVW R30,R12
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	LDI  R30,LOW(65526)
	LDI  R31,HIGH(65526)
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x1F
_0x1E:
	RJMP _0x1D
_0x1F:
; 0000 00C4             {
; 0000 00C5             cntx*=-1;
	CALL SUBOPT_0x1
; 0000 00C6             cntx1*=-1;
	CALL SUBOPT_0x4
	STS  _cntx1,R30
	STS  _cntx1+1,R31
; 0000 00C7             }
; 0000 00C8           x+=cntx;
_0x1D:
	LDS  R30,_cntx
	LDS  R31,_cntx+1
	__ADDWRR 10,11,30,31
; 0000 00C9           y+=cnty;
	LDS  R30,_cnty
	LDS  R31,_cnty+1
	__ADDWRR 12,13,30,31
; 0000 00CA           x4+=cntx1;
	LDS  R30,_cntx1
	LDS  R31,_cntx1+1
	CALL SUBOPT_0x3
	ADD  R30,R26
	ADC  R31,R27
	STS  _x4,R30
	STS  _x4+1,R31
; 0000 00CB           y4+=cnty1;
	LDS  R30,_cnty1
	LDS  R31,_cnty1+1
	CALL SUBOPT_0x5
	ADD  R30,R26
	ADC  R31,R27
	STS  _y4,R30
	STS  _y4+1,R31
; 0000 00CC           }
; 0000 00CD       else if (cnt2 == 1)
	RJMP _0x20
_0x10:
	LDS  R26,_cnt2
	LDS  R27,_cnt2+1
	SBIW R26,1
	BRNE _0x21
; 0000 00CE         {
; 0000 00CF         PORTB.0=1;
	SBI  0x18,0
; 0000 00D0         delay_us(10);
	__DELAY_USB 27
; 0000 00D1         PORTB.0=0;
	CBI  0x18,0
; 0000 00D2         cnt1=0;
	CLR  R8
	CLR  R9
; 0000 00D3         while(PINA.0==0);
_0x26:
	SBIS 0x19,0
	RJMP _0x26
; 0000 00D4         while(PINA.0==1)
_0x29:
	SBIS 0x19,0
	RJMP _0x2B
; 0000 00D5             {
; 0000 00D6             cnt1++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	SBIW R30,1
; 0000 00D7             delay_us(1);
	__DELAY_USB 3
; 0000 00D8             }
	RJMP _0x29
_0x2B:
; 0000 00D9         cnt1/=22;
	MOVW R26,R8
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	CALL __DIVW21
	MOVW R8,R30
; 0000 00DA         glcd_outtextxy(10,0,"Distance:");
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW2MN _0x2C,0
	CALL _glcd_outtextxy
; 0000 00DB         glcd_putcharxy(13,20,((cnt1/100)%10+'0'));
	LDI  R30,LOW(13)
	CALL SUBOPT_0x6
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x7
; 0000 00DC         glcd_putcharxy(20,20,((cnt1/10)%10+'0'));
	LDI  R30,LOW(20)
	CALL SUBOPT_0x6
	CALL SUBOPT_0x8
; 0000 00DD         glcd_putcharxy(27,20,((cnt1/1)%10+'0'));
	LDI  R30,LOW(27)
	CALL SUBOPT_0x6
	CALL SUBOPT_0x9
; 0000 00DE         glcd_outtextxy(33,20,"cm");
	LDI  R30,LOW(33)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	__POINTW2MN _0x2C,10
	CALL _glcd_outtextxy
; 0000 00DF         }
; 0000 00E0       else if (cnt2 == 2)
	RJMP _0x2D
_0x21:
	LDS  R26,_cnt2
	LDS  R27,_cnt2+1
	SBIW R26,2
	BREQ PC+2
	RJMP _0x2E
; 0000 00E1         {
; 0000 00E2         glcd_clear();
	CALL _glcd_clear
; 0000 00E3         if (cnt3 >=11)
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	BRLO _0x2F
; 0000 00E4             {
; 0000 00E5             cnt4+=0.10472;
	LDS  R30,_cnt4
	LDS  R31,_cnt4+1
	LDS  R22,_cnt4+2
	LDS  R23,_cnt4+3
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 00E6             cnt7++;
	LDI  R26,LOW(_cnt7)
	LDI  R27,HIGH(_cnt7)
	CALL SUBOPT_0x0
; 0000 00E7             cnt3 = 4.71239;
	__GETD1N 0x4096CBE6
	CALL SUBOPT_0xE
; 0000 00E8             }
; 0000 00E9         if (cnt4 >=11)
_0x2F:
	CALL SUBOPT_0xF
	CALL SUBOPT_0xB
	BRLO _0x30
; 0000 00EA             {
; 0000 00EB             cnt5+=0.523599;
	LDS  R30,_cnt5
	LDS  R31,_cnt5+1
	LDS  R22,_cnt5+2
	LDS  R23,_cnt5+3
	__GETD2N 0x3F060A96
	CALL __ADDF12
	STS  _cnt5,R30
	STS  _cnt5+1,R31
	STS  _cnt5+2,R22
	STS  _cnt5+3,R23
; 0000 00EC             cnt8++;
	LDI  R26,LOW(_cnt8)
	LDI  R27,HIGH(_cnt8)
	CALL SUBOPT_0x0
; 0000 00ED             cnt4 = 4.71239;
	__GETD1N 0x4096CBE6
	CALL SUBOPT_0xD
; 0000 00EE             }
; 0000 00EF         glcd_circle(62,24,20);
_0x30:
	CALL SUBOPT_0x10
	LDI  R26,LOW(20)
	CALL _glcd_circle
; 0000 00F0         y1=sin(cnt3)*15;
	CALL SUBOPT_0xA
	CALL _sin
	CALL SUBOPT_0x11
	LDI  R26,LOW(_y1)
	LDI  R27,HIGH(_y1)
	CALL SUBOPT_0x12
; 0000 00F1         x1=cos(cnt3)*15;
	CALL SUBOPT_0xA
	CALL _cos
	CALL SUBOPT_0x11
	LDI  R26,LOW(_x1)
	LDI  R27,HIGH(_x1)
	CALL SUBOPT_0x12
; 0000 00F2         y2=sin(cnt4)*12;
	CALL SUBOPT_0xF
	CALL _sin
	CALL SUBOPT_0x13
	LDI  R26,LOW(_y2)
	LDI  R27,HIGH(_y2)
	CALL SUBOPT_0x12
; 0000 00F3         x2=cos(cnt4)*12;
	CALL SUBOPT_0xF
	CALL _cos
	CALL SUBOPT_0x13
	LDI  R26,LOW(_x2)
	LDI  R27,HIGH(_x2)
	CALL SUBOPT_0x12
; 0000 00F4         y3=sin(cnt5)*8;
	CALL SUBOPT_0x14
	CALL _sin
	CALL SUBOPT_0x15
	LDI  R26,LOW(_y3)
	LDI  R27,HIGH(_y3)
	CALL SUBOPT_0x12
; 0000 00F5         x3=cos(cnt5)*8;
	CALL SUBOPT_0x14
	CALL _cos
	CALL SUBOPT_0x15
	LDI  R26,LOW(_x3)
	LDI  R27,HIGH(_x3)
	CALL SUBOPT_0x12
; 0000 00F6         glcd_line( 62,24, 62 + x1, 24 + y1);
	CALL SUBOPT_0x10
	LDS  R30,_x1
	SUBI R30,-LOW(62)
	ST   -Y,R30
	LDS  R26,_y1
	SUBI R26,-LOW(24)
	CALL _glcd_line
; 0000 00F7         glcd_line( 62,24, 62 + x2, 24 + y2);
	CALL SUBOPT_0x10
	LDS  R30,_x2
	SUBI R30,-LOW(62)
	ST   -Y,R30
	LDS  R26,_y2
	SUBI R26,-LOW(24)
	CALL _glcd_line
; 0000 00F8         glcd_line( 62,24, 62 + x3, 24 + y3);
	CALL SUBOPT_0x10
	LDS  R30,_x3
	SUBI R30,-LOW(62)
	ST   -Y,R30
	LDS  R26,_y3
	SUBI R26,-LOW(24)
	CALL _glcd_line
; 0000 00F9         cnt6%=60;
	CALL SUBOPT_0x16
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	STS  _cnt6,R30
	STS  _cnt6+1,R31
; 0000 00FA         cnt7%=60;
	CALL SUBOPT_0x17
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	STS  _cnt7,R30
	STS  _cnt7+1,R31
; 0000 00FB         cnt8%=12;
	CALL SUBOPT_0x18
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL __MODW21
	STS  _cnt8,R30
	STS  _cnt8+1,R31
; 0000 00FC         glcd_putcharxy(0,0,((cnt8/10)%10+'0'));
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x8
; 0000 00FD         glcd_putcharxy(6,0,((cnt8/1)%10+'0'));
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x9
; 0000 00FE         glcd_putcharxy(12,0,':');
	LDI  R30,LOW(12)
	CALL SUBOPT_0x19
; 0000 00FF         glcd_putcharxy(16,0,((cnt7/10)%10+'0'));
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x17
	CALL SUBOPT_0x8
; 0000 0100         glcd_putcharxy(22,0,((cnt7/1)%10+'0'));
	LDI  R30,LOW(22)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x17
	CALL SUBOPT_0x9
; 0000 0101         glcd_putcharxy(28,0,':');
	LDI  R30,LOW(28)
	CALL SUBOPT_0x19
; 0000 0102         glcd_putcharxy(32,0,((cnt6/10)%10+'0'));
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x16
	CALL SUBOPT_0x8
; 0000 0103         glcd_putcharxy(38,0,((cnt6/1)%10+'0'));
	LDI  R30,LOW(38)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x16
	CALL SUBOPT_0x9
; 0000 0104         delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0105         cnt3+=0.10472;
	LDS  R30,_cnt3
	LDS  R31,_cnt3+1
	LDS  R22,_cnt3+2
	LDS  R23,_cnt3+3
	CALL SUBOPT_0xC
	CALL SUBOPT_0xE
; 0000 0106         cnt6++;
	LDI  R26,LOW(_cnt6)
	LDI  R27,HIGH(_cnt6)
	CALL SUBOPT_0x0
; 0000 0107         }
; 0000 0108       }
_0x2E:
_0x2D:
_0x20:
	RJMP _0xC
; 0000 0109 }
_0x31:
	RJMP _0x31
; .FEND

	.DSEG
_0x2C:
	.BYTE 0xD

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
	CALL SUBOPT_0x1A
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	JMP  _0x210000D
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
	RJMP _0x210000D
; .FEND
_sin:
; .FSTART _sin
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	CALL SUBOPT_0x1B
	__GETD1N 0x3E22F983
	CALL __MULF12
	CALL SUBOPT_0x1C
	RCALL _floor
	CALL SUBOPT_0x1B
	CALL __SWAPD12
	CALL __SUBF12
	CALL SUBOPT_0x1C
	__GETD1N 0x3F000000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000017
	CALL SUBOPT_0x1D
	__GETD2N 0x3F000000
	CALL SUBOPT_0x1E
	LDI  R17,LOW(1)
_0x2000017:
	CALL SUBOPT_0x1B
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000018
	CALL SUBOPT_0x1B
	__GETD1N 0x3F000000
	CALL SUBOPT_0x1E
_0x2000018:
	CPI  R17,0
	BREQ _0x2000019
	CALL SUBOPT_0x1D
	CALL __ANEGF1
	__PUTD1S 5
_0x2000019:
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1B
	CALL __MULF12
	__PUTD1S 1
	__GETD2N 0x4226C4B1
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x422DE51D
	CALL __SWAPD12
	CALL __SUBF12
	CALL SUBOPT_0x1F
	__GETD2N 0x4104534C
	CALL __ADDF12
	CALL SUBOPT_0x1B
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 1
	__GETD2N 0x3FDEED11
	CALL __ADDF12
	CALL SUBOPT_0x1F
	__GETD2N 0x3FA87B5E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	LDD  R17,Y+0
	ADIW R28,9
	RET
; .FEND
_cos:
; .FSTART _cos
	CALL SUBOPT_0x1A
	__GETD1N 0x3FC90FDB
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL _sin
	RJMP _0x210000D
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
_pcd8544_delay_G101:
; .FSTART _pcd8544_delay_G101
	RET
; .FEND
_pcd8544_wrbus_G101:
; .FSTART _pcd8544_wrbus_G101
	ST   -Y,R26
	ST   -Y,R17
	CBI  0x15,3
	LDI  R17,LOW(8)
_0x2020004:
	RCALL _pcd8544_delay_G101
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BREQ _0x2020006
	SBI  0x15,0
	RJMP _0x2020007
_0x2020006:
	CBI  0x15,0
_0x2020007:
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
	RCALL _pcd8544_delay_G101
	SBI  0x15,1
	RCALL _pcd8544_delay_G101
	CBI  0x15,1
	SUBI R17,LOW(1)
	BRNE _0x2020004
	SBI  0x15,3
	LDD  R17,Y+0
	RJMP _0x210000B
; .FEND
_pcd8544_wrcmd:
; .FSTART _pcd8544_wrcmd
	ST   -Y,R26
	CBI  0x15,2
	LD   R26,Y
	RCALL _pcd8544_wrbus_G101
	RJMP _0x210000E
; .FEND
_pcd8544_wrdata_G101:
; .FSTART _pcd8544_wrdata_G101
	ST   -Y,R26
	SBI  0x15,2
	LD   R26,Y
	RCALL _pcd8544_wrbus_G101
	RJMP _0x210000E
; .FEND
_pcd8544_setaddr_G101:
; .FSTART _pcd8544_setaddr_G101
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
	STS  _gfx_addr_G101,R30
	STS  _gfx_addr_G101+1,R31
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
	RCALL _pcd8544_setaddr_G101
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	RJMP _0x210000B
; .FEND
_pcd8544_rdbyte:
; .FSTART _pcd8544_rdbyte
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_gotoxy
	CALL SUBOPT_0x20
	LD   R30,Z
	RJMP _0x210000B
; .FEND
_pcd8544_wrbyte:
; .FSTART _pcd8544_wrbyte
	ST   -Y,R26
	CALL SUBOPT_0x21
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G101)
	SBCI R31,HIGH(-_gfx_buffer_G101)
	LD   R26,Y
	STD  Z+0,R26
	RCALL _pcd8544_wrdata_G101
	RJMP _0x210000E
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
	BREQ _0x2020008
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
	RJMP _0x20200A0
_0x2020008:
	LDI  R17,LOW(0)
	LDI  R16,LOW(3)
	LDI  R19,LOW(50)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20200A0:
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
	CALL SUBOPT_0x22
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
	RJMP _0x210000A
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	LD   R30,Y
	CPI  R30,0
	BREQ _0x202000A
	LDI  R30,LOW(12)
	RJMP _0x202000B
_0x202000A:
	LDI  R30,LOW(8)
_0x202000B:
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
_0x210000E:
	ADIW R28,1
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x202000D
	LDI  R19,LOW(255)
_0x202000D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _pcd8544_gotoxy
	__GETWRN 16,17,504
_0x202000E:
	MOVW R30,R16
	__SUBWRN 16,17,1
	SBIW R30,0
	BREQ _0x2020010
	MOV  R26,R19
	RCALL _pcd8544_wrbyte
	RJMP _0x202000E
_0x2020010:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
_0x210000D:
	ADIW R28,4
	RET
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x54)
	BRSH _0x2020012
	LDD  R26,Y+3
	CPI  R26,LOW(0x30)
	BRLO _0x2020011
_0x2020012:
	RJMP _0x210000C
_0x2020011:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+3
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x2020014
	OR   R17,R16
	RJMP _0x2020015
_0x2020014:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2020015:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
_0x210000C:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
_glcd_getpixel:
; .FSTART _glcd_getpixel
	ST   -Y,R26
	LDD  R26,Y+1
	CPI  R26,LOW(0x54)
	BRSH _0x2020017
	LD   R26,Y
	CPI  R26,LOW(0x30)
	BRLO _0x2020016
_0x2020017:
	LDI  R30,LOW(0)
	RJMP _0x210000B
_0x2020016:
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_setaddr_G101
	CALL SUBOPT_0x20
	LD   R1,Z
	LD   R30,Y
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	AND  R30,R1
	BREQ _0x2020019
	LDI  R30,LOW(1)
	RJMP _0x202001A
_0x2020019:
	LDI  R30,LOW(0)
_0x202001A:
_0x210000B:
	ADIW R28,2
	RET
; .FEND
_pcd8544_wrmasked_G101:
; .FSTART _pcd8544_wrmasked_G101
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2020020
	CPI  R30,LOW(0x8)
	BRNE _0x2020021
_0x2020020:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x2020022
_0x2020021:
	CPI  R30,LOW(0x3)
	BRNE _0x2020024
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2020025
_0x2020024:
	CPI  R30,0
	BRNE _0x2020026
_0x2020025:
_0x2020022:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2020027
_0x2020026:
	CPI  R30,LOW(0x2)
	BRNE _0x2020028
_0x2020027:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x202001E
_0x2020028:
	CPI  R30,LOW(0x1)
	BRNE _0x2020029
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x202001E
_0x2020029:
	CPI  R30,LOW(0x4)
	BRNE _0x202001E
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x202001E:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
	LDD  R17,Y+0
_0x210000A:
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
	BRSH _0x202002C
	LDD  R26,Y+15
	CPI  R26,LOW(0x30)
	BRSH _0x202002C
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x202002C
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x202002B
_0x202002C:
	RJMP _0x2100009
_0x202002B:
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
	BRLO _0x202002E
	LDD  R26,Y+16
	LDI  R30,LOW(84)
	SUB  R30,R26
	STD  Y+14,R30
_0x202002E:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,49
	BRLO _0x202002F
	LDD  R26,Y+15
	LDI  R30,LOW(48)
	SUB  R30,R26
	STD  Y+13,R30
_0x202002F:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x2020030
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x2020034
	RJMP _0x2100009
_0x2020034:
	CPI  R30,LOW(0x3)
	BRNE _0x2020037
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2020036
	RJMP _0x2100009
_0x2020036:
_0x2020037:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2020039
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2020038
_0x2020039:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x23
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x202003B:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x202003D
	MOV  R17,R16
_0x202003E:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2020040
	CALL SUBOPT_0x24
	RJMP _0x202003E
_0x2020040:
	RJMP _0x202003B
_0x202003D:
_0x2020038:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x2020041
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0x23
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x2020042
	SUBI R19,-LOW(1)
_0x2020042:
	LDI  R18,LOW(0)
_0x2020043:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2020045
	LDD  R17,Y+14
_0x2020046:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2020048
	CALL SUBOPT_0x24
	RJMP _0x2020046
_0x2020048:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x23
	RJMP _0x2020043
_0x2020045:
_0x2020041:
_0x2020030:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2020049:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x202004B
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x202004C
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x202004D
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x2020052
	CPI  R30,LOW(0x3)
	BRNE _0x2020053
_0x2020052:
	RJMP _0x2020054
_0x2020053:
	CPI  R30,LOW(0x7)
	BRNE _0x2020055
_0x2020054:
	RJMP _0x2020056
_0x2020055:
	CPI  R30,LOW(0x8)
	BRNE _0x2020057
_0x2020056:
	RJMP _0x2020058
_0x2020057:
	CPI  R30,LOW(0x9)
	BRNE _0x2020059
_0x2020058:
	RJMP _0x202005A
_0x2020059:
	CPI  R30,LOW(0xA)
	BRNE _0x202005B
_0x202005A:
	ST   -Y,R16
	LDD  R26,Y+16
	RCALL _pcd8544_gotoxy
	RJMP _0x2020050
_0x202005B:
	CPI  R30,LOW(0x6)
	BRNE _0x2020050
	CALL SUBOPT_0x25
_0x2020050:
_0x202005D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x202005F
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x2020060
	CALL SUBOPT_0x26
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x21
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G101)
	SBCI R31,HIGH(-_gfx_buffer_G101)
	LD   R26,Z
	CALL _glcd_writemem
	RJMP _0x2020061
_0x2020060:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2020065
	LDI  R21,LOW(0)
	RJMP _0x2020066
_0x2020065:
	CPI  R30,LOW(0xA)
	BRNE _0x2020064
	LDI  R21,LOW(255)
	RJMP _0x2020066
_0x2020064:
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x202006D
	CPI  R30,LOW(0x8)
	BRNE _0x202006E
_0x202006D:
_0x2020066:
	CALL SUBOPT_0x28
	MOV  R21,R30
	RJMP _0x202006F
_0x202006E:
	CPI  R30,LOW(0x3)
	BRNE _0x2020071
	COM  R21
	RJMP _0x2020072
_0x2020071:
	CPI  R30,0
	BRNE _0x2020074
_0x2020072:
_0x202006F:
	MOV  R26,R21
	RCALL _pcd8544_wrdata_G101
	RJMP _0x202006B
_0x2020074:
	CALL SUBOPT_0x29
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G101
_0x202006B:
_0x2020061:
	RJMP _0x202005D
_0x202005F:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2020075
_0x202004D:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2020076
_0x202004C:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2020077
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2020078
_0x2020077:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2020078:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x202007C
	CALL SUBOPT_0x25
_0x202007D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x202007F
	CALL SUBOPT_0x21
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G101)
	SBCI R31,HIGH(-_gfx_buffer_G101)
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x2A
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x26
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x202007D
_0x202007F:
	RJMP _0x202007B
_0x202007C:
	CPI  R30,LOW(0x9)
	BRNE _0x2020080
	LDI  R21,LOW(0)
	RJMP _0x2020081
_0x2020080:
	CPI  R30,LOW(0xA)
	BRNE _0x2020087
	LDI  R21,LOW(255)
_0x2020081:
	CALL SUBOPT_0x28
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2020084:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2020086
	CALL SUBOPT_0x29
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G101
	RJMP _0x2020084
_0x2020086:
	RJMP _0x202007B
_0x2020087:
_0x2020088:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x202008A
	CALL SUBOPT_0x2B
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G101
	RJMP _0x2020088
_0x202008A:
_0x202007B:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x202008B
	RJMP _0x202004B
_0x202008B:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x202008C
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20200A1
_0x202008C:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20200A1:
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
_0x2020076:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2020091
	CALL SUBOPT_0x25
_0x2020092:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2020094
	CALL SUBOPT_0x21
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G101)
	SBCI R31,HIGH(-_gfx_buffer_G101)
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x2A
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x26
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2020092
_0x2020094:
	RJMP _0x2020090
_0x2020091:
	CPI  R30,LOW(0x9)
	BRNE _0x2020095
	LDI  R21,LOW(0)
	RJMP _0x2020096
_0x2020095:
	CPI  R30,LOW(0xA)
	BRNE _0x202009C
	LDI  R21,LOW(255)
_0x2020096:
	CALL SUBOPT_0x28
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x2020099:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x202009B
	CALL SUBOPT_0x29
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G101
	RJMP _0x2020099
_0x202009B:
	RJMP _0x2020090
_0x202009C:
_0x202009D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x202009F
	CALL SUBOPT_0x2B
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G101
	RJMP _0x202009D
_0x202009F:
_0x2020090:
_0x2020075:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2020049
_0x202004B:
_0x2100009:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x2C
	BRLT _0x2040003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2100002
_0x2040003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x54)
	LDI  R30,HIGH(0x54)
	CPC  R27,R30
	BRLT _0x2040004
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	JMP  _0x2100002
_0x2040004:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2100002
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x2C
	BRLT _0x2040005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2100002
_0x2040005:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,48
	BRLT _0x2040006
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	JMP  _0x2100002
_0x2040006:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2100002
; .FEND
_glcd_setpixel:
; .FSTART _glcd_setpixel
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	LDS  R26,_glcd_state
	RCALL _glcd_putpixel
	JMP  _0x2100002
; .FEND
_glcd_getcharw_G102:
; .FSTART _glcd_getcharw_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x2D
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x204000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2100008
_0x204000B:
	CALL SUBOPT_0x2E
	STD  Y+7,R0
	CALL SUBOPT_0x2E
	STD  Y+6,R0
	CALL SUBOPT_0x2E
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x204000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2100008
_0x204000C:
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
	BRLO _0x204000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2100008
_0x204000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x204000E
	SUBI R20,-LOW(1)
_0x204000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x204000F
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
	RJMP _0x2100008
_0x204000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2040010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2040012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2040010
_0x2040012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2100008:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G102:
; .FSTART _glcd_new_line_G102
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x2F
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
	CALL SUBOPT_0x2D
	SBIW R30,0
	BRNE PC+2
	RJMP _0x204001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2040020
	RJMP _0x2040021
_0x2040020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G102
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2040022
	CALL __LOADLOCR6
	RJMP _0x2100006
_0x2040022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	CALL SUBOPT_0x30
	__CPWRN 16,17,85
	BRLO _0x2040023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G102
_0x2040023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x2F
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
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x31
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x2F
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x31
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2040024
_0x2040021:
	RCALL _glcd_new_line_G102
	CALL __LOADLOCR6
	RJMP _0x2100006
_0x2040024:
_0x204001F:
	__PUTBMRN _glcd_state,2,16
	CALL __LOADLOCR6
	RJMP _0x2100006
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
	JMP  _0x2100001
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x2040025:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040027
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2040025
_0x2040027:
	LDD  R17,Y+0
	JMP  _0x2100003
; .FEND
_glcd_putpixelm_G102:
; .FSTART _glcd_putpixelm_G102
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	__GETB1MN _glcd_state,9
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x204003E
	LDS  R30,_glcd_state
	RJMP _0x204003F
_0x204003E:
	__GETB1MN _glcd_state,1
_0x204003F:
	MOV  R26,R30
	RCALL _glcd_putpixel
	LD   R30,Y
	LSL  R30
	ST   Y,R30
	CPI  R30,0
	BRNE _0x2040041
	LDI  R30,LOW(1)
	ST   Y,R30
_0x2040041:
	LD   R30,Y
	JMP  _0x2100001
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
	JMP  _0x2100002
; .FEND
_glcd_line:
; .FSTART _glcd_line
	ST   -Y,R26
	SBIW R28,11
	CALL __SAVELOCR6
	LDD  R26,Y+20
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+20,R30
	LDD  R26,Y+18
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+18,R30
	LDD  R26,Y+19
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+19,R30
	LDD  R26,Y+17
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+17,R30
	LDD  R30,Y+18
	__PUTB1MN _glcd_state,2
	LDD  R30,Y+17
	__PUTB1MN _glcd_state,3
	LDI  R30,LOW(1)
	STD  Y+8,R30
	LDD  R30,Y+17
	LDD  R26,Y+19
	CP   R30,R26
	BRNE _0x2040042
	LDD  R17,Y+20
	LDD  R26,Y+18
	CP   R17,R26
	BRNE _0x2040043
	ST   -Y,R17
	LDD  R30,Y+20
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G102
	RJMP _0x2100007
_0x2040043:
	LDD  R26,Y+18
	CP   R17,R26
	BRSH _0x2040044
	LDD  R30,Y+18
	SUB  R30,R17
	MOV  R16,R30
	__GETWRN 20,21,1
	RJMP _0x2040045
_0x2040044:
	LDD  R26,Y+18
	MOV  R30,R17
	SUB  R30,R26
	MOV  R16,R30
	__GETWRN 20,21,-1
_0x2040045:
_0x2040047:
	LDD  R19,Y+19
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2040049:
	CALL SUBOPT_0x32
	BRSH _0x204004B
	ST   -Y,R17
	ST   -Y,R19
	INC  R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G102
	STD  Y+7,R30
	RJMP _0x2040049
_0x204004B:
	LDD  R30,Y+7
	STD  Y+8,R30
	ADD  R17,R20
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BRNE _0x2040047
	RJMP _0x204004C
_0x2040042:
	LDD  R30,Y+18
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x204004D
	LDD  R19,Y+19
	LDD  R26,Y+17
	CP   R19,R26
	BRSH _0x204004E
	LDD  R30,Y+17
	SUB  R30,R19
	MOV  R18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x204011B
_0x204004E:
	LDD  R26,Y+17
	MOV  R30,R19
	SUB  R30,R26
	MOV  R18,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x204011B:
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2040051:
	LDD  R17,Y+20
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2040053:
	CALL SUBOPT_0x32
	BRSH _0x2040055
	ST   -Y,R17
	INC  R17
	CALL SUBOPT_0x33
	STD  Y+7,R30
	RJMP _0x2040053
_0x2040055:
	LDD  R30,Y+7
	STD  Y+8,R30
	LDD  R30,Y+13
	ADD  R19,R30
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BRNE _0x2040051
	RJMP _0x2040056
_0x204004D:
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2040057:
	CALL SUBOPT_0x32
	BRLO PC+2
	RJMP _0x2040059
	LDD  R17,Y+20
	LDD  R19,Y+19
	LDI  R30,LOW(1)
	MOV  R18,R30
	MOV  R16,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+20
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
	TST  R21
	BRPL _0x204005A
	LDI  R16,LOW(255)
	MOVW R30,R20
	CALL __ANEGW1
	MOVW R20,R30
_0x204005A:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	STD  Y+15,R30
	STD  Y+15+1,R31
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+19
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+13,R26
	STD  Y+13+1,R27
	LDD  R26,Y+14
	TST  R26
	BRPL _0x204005B
	LDI  R18,LOW(255)
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CALL __ANEGW1
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x204005B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LSL  R30
	ROL  R31
	STD  Y+11,R30
	STD  Y+11+1,R31
	ST   -Y,R17
	ST   -Y,R19
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G102
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R20,R26
	CPC  R21,R27
	BRLT _0x204005C
_0x204005E:
	ADD  R17,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CALL SUBOPT_0x34
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R20,R26
	CPC  R21,R27
	BRGE _0x2040060
	ADD  R19,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CALL SUBOPT_0x35
_0x2040060:
	ST   -Y,R17
	CALL SUBOPT_0x33
	STD  Y+8,R30
	LDD  R30,Y+18
	CP   R30,R17
	BRNE _0x204005E
	RJMP _0x2040061
_0x204005C:
_0x2040063:
	ADD  R19,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	CALL SUBOPT_0x34
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2040065
	ADD  R17,R16
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CALL SUBOPT_0x35
_0x2040065:
	ST   -Y,R17
	CALL SUBOPT_0x33
	STD  Y+8,R30
	LDD  R30,Y+17
	CP   R30,R19
	BRNE _0x2040063
_0x2040061:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+17
	SUBI R30,-LOW(1)
	STD  Y+17,R30
	RJMP _0x2040057
_0x2040059:
_0x2040056:
_0x204004C:
_0x2100007:
	CALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND
_glcd_corners_G102:
; .FSTART _glcd_corners_G102
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R17,Z+3
	LDD  R16,Z+1
	LDD  R19,Z+2
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X
	CP   R16,R17
	BRSH _0x2040066
	MOV  R21,R16
	MOV  R16,R17
	MOV  R17,R21
_0x2040066:
	CP   R18,R19
	BRSH _0x2040067
	MOV  R21,R18
	MOV  R18,R19
	MOV  R19,R21
_0x2040067:
	MOV  R30,R17
	__PUTB1SNS 6,3
	MOV  R30,R19
	__PUTB1SNS 6,2
	MOV  R30,R16
	__PUTB1SNS 6,1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R18
	CALL __LOADLOCR6
	RJMP _0x2100006
; .FEND
_glcd_rectangle:
; .FSTART _glcd_rectangle
	ST   -Y,R26
	CALL __SAVELOCR4
	__GETB1MN _glcd_state,8
	SUBI R30,LOW(1)
	MOV  R19,R30
	MOVW R26,R28
	ADIW R26,4
	RCALL _glcd_corners_G102
	LDD  R30,Y+5
	SUB  R30,R19
	MOV  R17,R30
	LDD  R30,Y+4
	SUB  R30,R19
	MOV  R16,R30
	LDD  R30,Y+7
	ST   -Y,R30
	LDD  R30,Y+7
	ST   -Y,R30
	ST   -Y,R17
	LDD  R26,Y+9
	RCALL _glcd_line
	ST   -Y,R17
	LDD  R30,Y+7
	ST   -Y,R30
	ST   -Y,R17
	MOV  R26,R16
	RCALL _glcd_line
	LDD  R30,Y+5
	ST   -Y,R30
	ST   -Y,R16
	MOV  R30,R19
	LDD  R26,Y+9
	ADD  R30,R26
	ST   -Y,R30
	MOV  R26,R16
	RCALL _glcd_line
	LDD  R30,Y+7
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+9
	ST   -Y,R30
	MOV  R30,R19
	LDD  R26,Y+9
	ADD  R26,R30
	RJMP _0x2100005
; .FEND
_glcd_plot8_G102:
; .FSTART _glcd_plot8_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R30,Y+13
	STD  Y+8,R30
	__GETB1MN _glcd_state,8
	STD  Y+7,R30
	LDS  R30,_glcd_state
	STD  Y+6,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+15
	CALL SUBOPT_0x30
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+16
	CALL SUBOPT_0x36
	LDD  R30,Y+16
	CALL SUBOPT_0x37
	BREQ _0x2040073
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2040075
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x38
	BRLT _0x2040077
	CALL SUBOPT_0x39
	BRGE _0x2040078
_0x2040077:
	RJMP _0x2040076
_0x2040078:
_0x2040073:
	TST  R19
	BRMI _0x2040079
	CALL SUBOPT_0x3A
_0x2040079:
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x204007B
	__CPWRN 18,19,2
	BRGE _0x204007C
_0x204007B:
	RJMP _0x204007A
_0x204007C:
	CALL SUBOPT_0x3B
	BRNE _0x204007D
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(1)
	RCALL _glcd_setpixel
_0x204007D:
_0x204007A:
_0x2040076:
_0x2040075:
	LDD  R30,Y+8
	ANDI R30,LOW(0x88)
	CPI  R30,LOW(0x88)
	BREQ _0x204007F
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2040081
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-270)
	SBCI R27,HIGH(-270)
	CALL SUBOPT_0x3C
	BRLT _0x2040083
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-270)
	SBCI R27,HIGH(-270)
	CALL SUBOPT_0x3D
	BRGE _0x2040084
_0x2040083:
	RJMP _0x2040082
_0x2040084:
_0x204007F:
	CALL SUBOPT_0x3E
	BRLO _0x2040085
	CALL SUBOPT_0x3F
	BRNE _0x2040086
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(1)
	RCALL _glcd_setpixel
_0x2040086:
_0x2040085:
_0x2040082:
_0x2040081:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+15
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
	TST  R17
	BRPL PC+2
	RJMP _0x2040087
	LDD  R30,Y+8
	ANDI R30,LOW(0x82)
	CPI  R30,LOW(0x82)
	BREQ _0x2040089
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x204008B
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-90)
	SBCI R27,HIGH(-90)
	CALL SUBOPT_0x3C
	BRLT _0x204008D
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-90)
	SBCI R27,HIGH(-90)
	CALL SUBOPT_0x3D
	BRGE _0x204008E
_0x204008D:
	RJMP _0x204008C
_0x204008E:
_0x2040089:
	TST  R19
	BRMI _0x204008F
	CALL SUBOPT_0x3A
_0x204008F:
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x2040091
	__CPWRN 18,19,2
	BRGE _0x2040092
_0x2040091:
	RJMP _0x2040090
_0x2040092:
	CALL SUBOPT_0x3B
	BRNE _0x2040093
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(1)
	RCALL _glcd_setpixel
_0x2040093:
_0x2040090:
_0x204008C:
_0x204008B:
	LDD  R30,Y+8
	ANDI R30,LOW(0x84)
	CPI  R30,LOW(0x84)
	BREQ _0x2040095
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x2040097
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(270)
	LDI  R31,HIGH(270)
	CALL SUBOPT_0x38
	BRLT _0x2040099
	CALL SUBOPT_0x39
	BRGE _0x204009A
_0x2040099:
	RJMP _0x2040098
_0x204009A:
_0x2040095:
	CALL SUBOPT_0x3E
	BRLO _0x204009B
	CALL SUBOPT_0x3F
	BRNE _0x204009C
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(1)
	RCALL _glcd_setpixel
_0x204009C:
_0x204009B:
_0x2040098:
_0x2040097:
_0x2040087:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+16
	CALL SUBOPT_0x30
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+15
	CALL SUBOPT_0x36
	LDD  R30,Y+15
	CALL SUBOPT_0x37
	BREQ _0x204009E
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20400A0
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x20400A2
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x20400A3
_0x20400A2:
	RJMP _0x20400A1
_0x20400A3:
_0x204009E:
	TST  R19
	BRMI _0x20400A4
	CALL SUBOPT_0x3A
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x20400A5
	MOV  R30,R16
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x40
	BRNE _0x20400A6
	MOV  R30,R16
	SUBI R30,-LOW(1)
	ST   -Y,R30
	MOV  R26,R18
	RCALL _glcd_setpixel
_0x20400A6:
_0x20400A5:
_0x20400A4:
_0x20400A1:
_0x20400A0:
	LDD  R30,Y+8
	ANDI R30,LOW(0x88)
	CPI  R30,LOW(0x88)
	BREQ _0x20400A8
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20400AA
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(360)
	LDI  R31,HIGH(360)
	CALL SUBOPT_0x38
	BRLT _0x20400AC
	CALL SUBOPT_0x39
	BRGE _0x20400AD
_0x20400AC:
	RJMP _0x20400AB
_0x20400AD:
_0x20400A8:
	CALL SUBOPT_0x3E
	BRLO _0x20400AE
	MOV  R30,R16
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x41
	BRNE _0x20400AF
	MOV  R30,R16
	SUBI R30,-LOW(1)
	ST   -Y,R30
	MOV  R26,R20
	RCALL _glcd_setpixel
_0x20400AF:
_0x20400AE:
_0x20400AB:
_0x20400AA:
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+16
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
	TST  R17
	BRPL PC+2
	RJMP _0x20400B0
	LDD  R30,Y+8
	ANDI R30,LOW(0x82)
	CPI  R30,LOW(0x82)
	BREQ _0x20400B2
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20400B4
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x38
	BRLT _0x20400B6
	CALL SUBOPT_0x39
	BRGE _0x20400B7
_0x20400B6:
	RJMP _0x20400B5
_0x20400B7:
_0x20400B2:
	TST  R19
	BRMI _0x20400B8
	CALL SUBOPT_0x3A
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	BRLO _0x20400BA
	__CPWRN 16,17,2
	BRGE _0x20400BB
_0x20400BA:
	RJMP _0x20400B9
_0x20400BB:
	MOV  R30,R16
	SUBI R30,LOW(2)
	CALL SUBOPT_0x40
	BRNE _0x20400BC
	MOV  R30,R16
	SUBI R30,LOW(1)
	ST   -Y,R30
	MOV  R26,R18
	RCALL _glcd_setpixel
_0x20400BC:
_0x20400B9:
_0x20400B8:
_0x20400B5:
_0x20400B4:
	LDD  R30,Y+8
	ANDI R30,LOW(0x84)
	CPI  R30,LOW(0x84)
	BREQ _0x20400BE
	LDD  R30,Y+8
	ANDI R30,LOW(0x80)
	BRNE _0x20400C0
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-180)
	SBCI R27,HIGH(-180)
	CALL SUBOPT_0x3C
	BRLT _0x20400C2
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SUBI R26,LOW(-180)
	SBCI R27,HIGH(-180)
	CALL SUBOPT_0x3D
	BRGE _0x20400C3
_0x20400C2:
	RJMP _0x20400C1
_0x20400C3:
_0x20400BE:
	CALL SUBOPT_0x3E
	BRLO _0x20400C5
	__CPWRN 16,17,2
	BRGE _0x20400C6
_0x20400C5:
	RJMP _0x20400C4
_0x20400C6:
	MOV  R30,R16
	SUBI R30,LOW(2)
	CALL SUBOPT_0x41
	BRNE _0x20400C7
	MOV  R30,R16
	SUBI R30,LOW(1)
	ST   -Y,R30
	MOV  R26,R20
	RCALL _glcd_setpixel
_0x20400C7:
_0x20400C4:
_0x20400C1:
_0x20400C0:
_0x20400B0:
	CALL __LOADLOCR6
	ADIW R28,19
	RET
; .FEND
_glcd_line2_G102:
; .FSTART _glcd_line2_G102
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R26,Y+7
	CLR  R27
	LDD  R30,Y+5
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	RCALL _glcd_clipx
	MOV  R17,R30
	LDD  R26,Y+7
	CLR  R27
	LDD  R30,Y+5
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipx
	MOV  R16,R30
	LDD  R26,Y+6
	CLR  R27
	LDD  R30,Y+4
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	RCALL _glcd_clipy
	MOV  R19,R30
	LDD  R26,Y+6
	CLR  R27
	LDD  R30,Y+4
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	MOV  R18,R30
	ST   -Y,R17
	ST   -Y,R19
	ST   -Y,R16
	MOV  R26,R19
	RCALL _glcd_line
	ST   -Y,R17
	ST   -Y,R18
	ST   -Y,R16
	MOV  R26,R18
_0x2100005:
	RCALL _glcd_line
	CALL __LOADLOCR4
_0x2100006:
	ADIW R28,8
	RET
; .FEND
_glcd_quadrant_G102:
; .FSTART _glcd_quadrant_G102
	ST   -Y,R26
	CALL __SAVELOCR6
	LDD  R26,Y+9
	CPI  R26,LOW(0x54)
	BRSH _0x20400C9
	LDD  R26,Y+8
	CPI  R26,LOW(0x30)
	BRLO _0x20400C8
_0x20400C9:
	RJMP _0x2100004
_0x20400C8:
	__GETBRMN 21,_glcd_state,8
_0x20400CB:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20400CD
	LDD  R30,Y+7
	CPI  R30,0
	BRNE _0x20400CE
	RJMP _0x2100004
_0x20400CE:
	LDD  R30,Y+7
	SUBI R30,LOW(1)
	STD  Y+7,R30
	SUBI R30,-LOW(1)
	MOV  R16,R30
	LDI  R31,0
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	SUB  R26,R30
	SBC  R27,R31
	MOVW R30,R26
	CALL __LSLW2
	CALL __ASRW2
	MOVW R18,R30
	LDI  R17,LOW(0)
_0x20400D0:
	LDD  R26,Y+6
	CPI  R26,LOW(0x40)
	BRNE _0x20400D2
	CALL SUBOPT_0x42
	ST   -Y,R17
	MOV  R26,R16
	RCALL _glcd_line2_G102
	CALL SUBOPT_0x42
	ST   -Y,R16
	MOV  R26,R17
	RCALL _glcd_line2_G102
	RJMP _0x20400D3
_0x20400D2:
	CALL SUBOPT_0x42
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+10
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _glcd_plot8_G102
_0x20400D3:
	SUBI R17,-1
	TST  R19
	BRPL _0x20400D4
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x204011C
_0x20400D4:
	SUBI R16,1
	MOV  R26,R17
	CLR  R27
	MOV  R30,R16
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R30,R26
_0x204011C:
	LSL  R30
	ROL  R31
	ADIW R30,1
	__ADDWRR 18,19,30,31
	CP   R16,R17
	BRSH _0x20400D0
	RJMP _0x20400CB
_0x20400CD:
_0x2100004:
	CALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND
_glcd_circle:
; .FSTART _glcd_circle
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	LDI  R26,LOW(143)
	RCALL _glcd_quadrant_G102
	RJMP _0x2100001
; .FEND
_glcd_fillcircle:
; .FSTART _glcd_fillcircle
	ST   -Y,R26
	CALL __SAVELOCR4
	LDS  R17,_glcd_state
	__GETB1MN _glcd_state,8
	MOV  R16,R30
	__GETB1MN _glcd_state,9
	MOV  R19,R30
	__GETB1MN _glcd_state,16
	STS  _glcd_state,R30
	CALL SUBOPT_0x22
	LDD  R30,Y+6
	ST   -Y,R30
	LDD  R30,Y+6
	ST   -Y,R30
	LDD  R30,Y+6
	ST   -Y,R30
	LDI  R26,LOW(64)
	RCALL _glcd_quadrant_G102
	STS  _glcd_state,R17
	__PUTBMRN _glcd_state,8,16
	__PUTBMRN _glcd_state,9,19
	CALL __LOADLOCR4
	ADIW R28,7
	RET
; .FEND

	.CSEG

	.DSEG

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
_0x2100003:
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
_0x2100002:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x20C0007
	CPI  R30,LOW(0xA)
	BRNE _0x20C0008
_0x20C0007:
	LDS  R17,_glcd_state
	RJMP _0x20C0009
_0x20C0008:
	CPI  R30,LOW(0x9)
	BRNE _0x20C000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x20C0009
_0x20C000B:
	CPI  R30,LOW(0x8)
	BRNE _0x20C0005
	__GETBRMN 17,_glcd_state,16
_0x20C0009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x20C000E
	CPI  R17,0
	BREQ _0x20C000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2100001
_0x20C000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2100001
_0x20C000E:
	CPI  R17,0
	BRNE _0x20C0011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2100001
_0x20C0011:
_0x20C0005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2100001
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x20C0015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2100001
_0x20C0015:
	CPI  R30,LOW(0x2)
	BRNE _0x20C0016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2100001
_0x20C0016:
	CPI  R30,LOW(0x3)
	BRNE _0x20C0018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2100001
_0x20C0018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2100001:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x20C001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x20C001B
_0x20C001C:
	CPI  R30,LOW(0x2)
	BRNE _0x20C001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x20C001B
_0x20C001D:
	CPI  R30,LOW(0x3)
	BRNE _0x20C001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x20C001B:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_cntx:
	.BYTE 0x2
_cnty:
	.BYTE 0x2
_cntx1:
	.BYTE 0x2
_cnty1:
	.BYTE 0x2
_cnt2:
	.BYTE 0x2
_x1:
	.BYTE 0x2
_y1:
	.BYTE 0x2
_x2:
	.BYTE 0x2
_y2:
	.BYTE 0x2
_x3:
	.BYTE 0x2
_y3:
	.BYTE 0x2
_x4:
	.BYTE 0x2
_y4:
	.BYTE 0x2
_cnt6:
	.BYTE 0x2
_cnt7:
	.BYTE 0x2
_cnt8:
	.BYTE 0x2
_cnt3:
	.BYTE 0x4
_cnt4:
	.BYTE 0x4
_cnt5:
	.BYTE 0x4
_gfx_addr_G101:
	.BYTE 0x2
_gfx_buffer_G101:
	.BYTE 0x1F8
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x0:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	LDS  R30,_cntx
	LDS  R31,_cntx+1
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	STS  _cntx,R30
	STS  _cntx+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDS  R26,_x4
	LDS  R27,_x4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDS  R30,_cntx1
	LDS  R31,_cntx1+1
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	LDS  R26,_y4
	LDS  R27,_y4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	MOVW R26,R8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x7:
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _glcd_putcharxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _glcd_putcharxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	LDS  R26,_cnt3
	LDS  R27,_cnt3+1
	LDS  R24,_cnt3+2
	LDS  R25,_cnt3+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	__GETD1N 0x41300000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	__GETD2N 0x3DD67770
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	STS  _cnt4,R30
	STS  _cnt4+1,R31
	STS  _cnt4+2,R22
	STS  _cnt4+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	STS  _cnt3,R30
	STS  _cnt3+1,R31
	STS  _cnt3+2,R22
	STS  _cnt3+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	LDS  R26,_cnt4
	LDS  R27,_cnt4+1
	LDS  R24,_cnt4+2
	LDS  R25,_cnt4+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(62)
	ST   -Y,R30
	LDI  R30,LOW(24)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	__GETD2N 0x41700000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	__GETD2N 0x41400000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDS  R26,_cnt5
	LDS  R27,_cnt5+1
	LDS  R24,_cnt5+2
	LDS  R25,_cnt5+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	__GETD2N 0x41000000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDS  R26,_cnt6
	LDS  R27,_cnt6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDS  R26,_cnt7
	LDS  R27,_cnt7+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDS  R26,_cnt8
	LDS  R27,_cnt8+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(58)
	JMP  _glcd_putcharxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	CALL __PUTPARD2
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1B:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	__PUTD1S 5
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	CALL __SUBF12
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	__GETD2S 1
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDS  R30,_gfx_addr_G101
	LDS  R31,_gfx_addr_G101+1
	SUBI R30,LOW(-_gfx_buffer_G101)
	SBCI R31,HIGH(-_gfx_buffer_G101)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(_gfx_addr_G101)
	LDI  R27,HIGH(_gfx_addr_G101)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x24:
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
SUBOPT_0x25:
	ST   -Y,R16
	LDD  R26,Y+16
	JMP  _pcd8544_setaddr_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x26:
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
SUBOPT_0x27:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2A:
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
SUBOPT_0x2B:
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
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2F:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x32:
	LDD  R26,Y+6
	SUBI R26,-LOW(1)
	STD  Y+6,R26
	SUBI R26,LOW(1)
	__GETB1MN _glcd_state,8
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	ST   -Y,R19
	LDD  R26,Y+10
	JMP  _glcd_putpixelm_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R18,R26
	LDD  R26,Y+17
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x37:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	LDD  R30,Y+8
	ANDI R30,LOW(0x81)
	CPI  R30,LOW(0x81)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x38:
	SUB  R30,R26
	SBC  R31,R27
	MOVW R0,R30
	MOVW R26,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R0
	CPC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	ST   -Y,R16
	MOV  R26,R18
	JMP  _glcd_setpixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	ST   -Y,R16
	MOV  R26,R18
	SUBI R26,LOW(2)
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3E:
	ST   -Y,R16
	MOV  R26,R20
	CALL _glcd_setpixel
	LDD  R26,Y+7
	CPI  R26,LOW(0x2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	ST   -Y,R16
	MOV  R26,R20
	SUBI R26,-LOW(2)
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x40:
	ST   -Y,R30
	MOV  R26,R18
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	ST   -Y,R30
	MOV  R26,R20
	CALL _glcd_getpixel
	MOV  R26,R30
	LDD  R30,Y+6
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	LDD  R30,Y+9
	ST   -Y,R30
	LDD  R30,Y+9
	ST   -Y,R30
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

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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
