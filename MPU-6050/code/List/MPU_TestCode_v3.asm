
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
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
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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

_0x0:
	.DB  0xA,0xD,0x77,0x77,0x77,0x2E,0x52,0x6F
	.DB  0x62,0x6F,0x74,0x69,0x63,0x4E,0x47,0x4F
	.DB  0x2E,0x63,0x6F,0x6D,0xA,0xD,0x77,0x77
	.DB  0x77,0x2E,0x45,0x43,0x41,0x2E,0x69,0x72
	.DB  0xA,0xD,0xA,0xD,0x0,0x43,0x6F,0x72
	.DB  0x72,0x65,0x63,0x74,0x2C,0x20,0x4D,0x50
	.DB  0x55,0x36,0x30,0x35,0x30,0x20,0x41,0x64
	.DB  0x64,0x72,0x20,0x69,0x73,0x20,0x30,0x78
	.DB  0x25,0x58,0x20,0xA,0xD,0x0,0x45,0x52
	.DB  0x52,0x4F,0x52,0x2C,0x20,0x53,0x74,0x6F
	.DB  0x70,0x70,0x69,0x6E,0x67,0x20,0xA,0xD
	.DB  0x0,0x4D,0x50,0x55,0x36,0x30,0x35,0x30
	.DB  0x20,0x53,0x65,0x74,0x75,0x70,0x20,0x3D
	.DB  0x3D,0x3E,0x20,0x43,0x6F,0x6D,0x70,0x6C
	.DB  0x65,0x74,0x65,0xA,0xD,0xA,0xD,0x0
	.DB  0x41,0x63,0x63,0x65,0x6C,0x20,0x4F,0x66
	.DB  0x66,0x73,0x65,0x74,0x20,0x56,0x61,0x6C
	.DB  0x3A,0x20,0x25,0x2E,0x32,0x66,0x20,0x2C
	.DB  0x20,0x25,0x2E,0x32,0x66,0x20,0x2C,0x20
	.DB  0x25,0x2E,0x32,0x66,0x20,0xA,0xD,0x0
	.DB  0x47,0x79,0x72,0x6F,0x20,0x20,0x4F,0x66
	.DB  0x66,0x73,0x65,0x74,0x20,0x56,0x61,0x6C
	.DB  0x3A,0x20,0x25,0x2E,0x32,0x66,0x20,0x2C
	.DB  0x20,0x25,0x2E,0x32,0x66,0x20,0x2C,0x20
	.DB  0x25,0x2E,0x32,0x66,0x20,0xA,0xD,0x0
	.DB  0xA,0x0,0x54,0x65,0x6D,0x70,0x20,0x56
	.DB  0x61,0x6C,0x20,0x69,0x73,0x3A,0x20,0x25
	.DB  0x2E,0x31,0x66,0x20,0x64,0x65,0x67,0x72
	.DB  0x65,0x65,0x20,0x43,0x65,0x6C,0x73,0x69
	.DB  0x75,0x73,0x20,0xA,0xD,0x0,0x20,0x20
	.DB  0x20,0x20,0x47,0x79,0x72,0x6F,0x20,0x52
	.DB  0x61,0x77,0x20,0x20,0x56,0x61,0x6C,0x3A
	.DB  0x20,0x25,0x2E,0x30,0x66,0x20,0x2C,0x20
	.DB  0x25,0x2E,0x30,0x66,0x20,0x2C,0x20,0x25
	.DB  0x2E,0x30,0x66,0x20,0xA,0xD,0x0,0x41
	.DB  0x76,0x72,0x67,0x47,0x79,0x72,0x6F,0x20
	.DB  0x52,0x61,0x77,0x20,0x20,0x56,0x61,0x6C
	.DB  0x3A,0x20,0x25,0x2E,0x30,0x66,0x20,0x2C
	.DB  0x20,0x25,0x2E,0x30,0x66,0x20,0x2C,0x20
	.DB  0x25,0x2E,0x30,0x66,0x20,0xA,0xD,0x0
	.DB  0x20,0x20,0x20,0x20,0x47,0x79,0x72,0x6F
	.DB  0x20,0x52,0x61,0x74,0x65,0x20,0x56,0x61
	.DB  0x6C,0x3A,0x20,0x25,0x2E,0x31,0x66,0x20
	.DB  0x2C,0x20,0x25,0x2E,0x31,0x66,0x20,0x2C
	.DB  0x20,0x25,0x2E,0x31,0x66,0x20,0xA,0xD
	.DB  0x0,0x20,0x20,0x20,0x20,0x41,0x63,0x63
	.DB  0x65,0x6C,0x20,0x52,0x61,0x77,0x20,0x56
	.DB  0x61,0x6C,0x3A,0x20,0x25,0x2E,0x31,0x66
	.DB  0x20,0x2C,0x20,0x25,0x2E,0x31,0x66,0x20
	.DB  0x2C,0x20,0x25,0x2E,0x31,0x66,0x20,0xA
	.DB  0xD,0x0,0x41,0x76,0x72,0x67,0x41,0x63
	.DB  0x63,0x65,0x6C,0x20,0x52,0x61,0x77,0x20
	.DB  0x56,0x61,0x6C,0x3A,0x20,0x25,0x2E,0x31
	.DB  0x66,0x20,0x2C,0x20,0x25,0x2E,0x31,0x66
	.DB  0x20,0x2C,0x20,0x25,0x2E,0x31,0x66,0x20
	.DB  0xA,0xD,0x0,0x20,0x20,0x41,0x63,0x63
	.DB  0x65,0x6C,0x20,0x49,0x6E,0x20,0x31,0x47
	.DB  0x20,0x56,0x61,0x6C,0x3A,0x20,0x25,0x2E
	.DB  0x31,0x66,0x20,0x2C,0x20,0x25,0x2E,0x31
	.DB  0x66,0x20,0x2C,0x20,0x25,0x2E,0x31,0x66
	.DB  0x20,0xA,0xD,0x0,0x41,0x63,0x63,0x65
	.DB  0x6C,0x20,0x20,0x41,0x6E,0x67,0x6C,0x65
	.DB  0x20,0x20,0x56,0x61,0x6C,0x3A,0x20,0x25
	.DB  0x2E,0x31,0x66,0x20,0x2C,0x20,0x25,0x2E
	.DB  0x31,0x66,0x20,0x2C,0x20,0x25,0x2E,0x31
	.DB  0x66,0x20,0xA,0xD,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  _0x8
	.DW  _0x0*2+200

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
	.ORG 0x260

	.CSEG
;/*****************************************************
;CodeWizardAVR V2.05.3 Standard
;
;Project : Test & Start MPU6050 Sensor With I2C Comunication & Usart Monitoring
;Version : 3.0
;Date    : 1392/9/20
;Author  : S_Ahmad
;Company : www.RoboticNGO.com    www.ECA.ir
;Comments:
;
;Chip type               : ATmega32
;AVR Core Clock frequency: 8.000000 MHz
;*****************************************************/
;#include <mega32.h>
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
;#include <i2c.h>
;#include <delay.h>
;#include <stdio.h>
;#include <stdlib.h>
;#include "LIB\MPU6050 LIB\MPU6050.h"
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;void WaitInPrint()
; 0000 0016 {

	.CSEG
_WaitInPrint:
; .FSTART _WaitInPrint
; 0000 0017     getchar();
	CALL _getchar
; 0000 0018 }
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;void main(void)
; 0000 001B {
_main:
; .FSTART _main
; 0000 001C PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 001D DDRA=0x00;
	OUT  0x1A,R30
; 0000 001E 
; 0000 001F PORTB=0x00;
	OUT  0x18,R30
; 0000 0020 DDRB=0x00;
	OUT  0x17,R30
; 0000 0021 
; 0000 0022 PORTC=0x00;
	OUT  0x15,R30
; 0000 0023 DDRC=0x00;
	OUT  0x14,R30
; 0000 0024 
; 0000 0025 PORTD=0x60;
	LDI  R30,LOW(96)
	OUT  0x12,R30
; 0000 0026 DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0027 
; 0000 0028 // Timer/Counter 0 initialization
; 0000 0029 // Clock source: System Clock
; 0000 002A // Clock value: Timer 0 Stopped
; 0000 002B // Mode: Normal top=0xFF
; 0000 002C // OC0 output: Disconnected
; 0000 002D TCCR0=0x00;
	OUT  0x33,R30
; 0000 002E TCNT0=0x00;
	OUT  0x32,R30
; 0000 002F OCR0=0x00;
	OUT  0x3C,R30
; 0000 0030 
; 0000 0031 // Timer/Counter 1 initialization
; 0000 0032 // Clock source: System Clock
; 0000 0033 // Clock value: Timer1 Stopped
; 0000 0034 // Mode: Normal top=0xFFFF
; 0000 0035 // OC1A output: Discon.
; 0000 0036 // OC1B output: Discon.
; 0000 0037 // Noise Canceler: Off
; 0000 0038 // Input Capture on Falling Edge
; 0000 0039 // Timer1 Overflow Interrupt: Off
; 0000 003A // Input Capture Interrupt: Off
; 0000 003B // Compare A Match Interrupt: Off
; 0000 003C // Compare B Match Interrupt: Off
; 0000 003D TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 003E TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 003F TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0040 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0041 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0042 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0043 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0044 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0045 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0046 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0047 
; 0000 0048 // Timer/Counter 2 initialization
; 0000 0049 // Clock source: System Clock
; 0000 004A // Clock value: Timer2 Stopped
; 0000 004B // Mode: Normal top=0xFF
; 0000 004C // OC2 output: Disconnected
; 0000 004D ASSR=0x00;
	OUT  0x22,R30
; 0000 004E TCCR2=0x00;
	OUT  0x25,R30
; 0000 004F TCNT2=0x00;
	OUT  0x24,R30
; 0000 0050 OCR2=0x00;
	OUT  0x23,R30
; 0000 0051 
; 0000 0052 // External Interrupt(s) initialization
; 0000 0053 // INT0: Off
; 0000 0054 // INT1: Off
; 0000 0055 // INT2: Off
; 0000 0056 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0057 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0058 
; 0000 0059 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 005A TIMSK=0x00;
	OUT  0x39,R30
; 0000 005B 
; 0000 005C // USART initialization
; 0000 005D // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 005E // USART Receiver: On
; 0000 005F // USART Transmitter: On
; 0000 0060 // USART Mode: Asynchronous
; 0000 0061 // USART Baud Rate: 9600
; 0000 0062 UCSRA=0x00;
	OUT  0xB,R30
; 0000 0063 UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0064 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0065 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0066 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0067 
; 0000 0068 // Analog Comparator initialization
; 0000 0069 // Analog Comparator: Off
; 0000 006A // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 006B ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 006C SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 006D 
; 0000 006E // ADC initialization
; 0000 006F // ADC disabled
; 0000 0070 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0071 
; 0000 0072 // SPI initialization
; 0000 0073 // SPI disabled
; 0000 0074 SPCR=0x00;
	OUT  0xD,R30
; 0000 0075 
; 0000 0076 // TWI initialization
; 0000 0077 // TWI disabled
; 0000 0078 TWCR=0x00;
	OUT  0x36,R30
; 0000 0079 
; 0000 007A // I2C Bus initialization
; 0000 007B // I2C Port: PORTC
; 0000 007C // I2C SDA bit: 1
; 0000 007D // I2C SCL bit: 0
; 0000 007E // Bit Rate: 100 kHz
; 0000 007F // Note: I2C settings are specified in the
; 0000 0080 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 0081 i2c_init();
	CALL _i2c_init
; 0000 0082 //////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
; 0000 0083 printf("\n\rwww.RoboticNGO.com\n\rwww.ECA.ir\n\r\n\r");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x0
; 0000 0084 WaitInPrint();
	RCALL _WaitInPrint
; 0000 0085 
; 0000 0086     if(MPU6050_Test_I2C())
	RCALL _MPU6050_Test_I2C
	CPI  R30,0
	BREQ _0x3
; 0000 0087     {
; 0000 0088         printf("Correct, MPU6050 Addr is 0x%X \n\r",MPU6050_ADDRESS);
	__POINTW1FN _0x0,37
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0xD0
	CALL SUBOPT_0x1
; 0000 0089         WaitInPrint();
	RJMP _0xA
; 0000 008A     }
; 0000 008B     else
_0x3:
; 0000 008C     {
; 0000 008D         printf("ERROR, Stopping \n\r");
	__POINTW1FN _0x0,70
	CALL SUBOPT_0x0
; 0000 008E         WaitInPrint();
_0xA:
	RCALL _WaitInPrint
; 0000 008F     }
; 0000 0090 
; 0000 0091 MPU6050_Init();
	RCALL _MPU6050_Init
; 0000 0092 printf("MPU6050 Setup ==> Complete\n\r\n\r");
	__POINTW1FN _0x0,89
	CALL SUBOPT_0x0
; 0000 0093 
; 0000 0094 Get_Accel_Offset();
	RCALL _Get_Accel_Offset
; 0000 0095 Get_Gyro_Offset();
	RCALL _Get_Gyro_Offset
; 0000 0096 printf("Accel Offset Val: %.2f , %.2f , %.2f \n\r",Accel_Offset_Val[X],Accel_Offset_Val[Y],Accel_Offset_Val[Z]);
	__POINTW1FN _0x0,120
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Accel_Offset_Val
	LDS  R31,_Accel_Offset_Val+1
	LDS  R22,_Accel_Offset_Val+2
	LDS  R23,_Accel_Offset_Val+3
	CALL __PUTPARD1
	__GETD1MN _Accel_Offset_Val,4
	CALL __PUTPARD1
	__GETD1MN _Accel_Offset_Val,8
	CALL SUBOPT_0x2
; 0000 0097 printf("Gyro  Offset Val: %.2f , %.2f , %.2f \n\r",Gyro_Offset_Val[X],Gyro_Offset_Val[Y],Gyro_Offset_Val[Z]);
	__POINTW1FN _0x0,160
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Gyro_Offset_Val
	LDS  R31,_Gyro_Offset_Val+1
	LDS  R22,_Gyro_Offset_Val+2
	LDS  R23,_Gyro_Offset_Val+3
	CALL __PUTPARD1
	__GETD1MN _Gyro_Offset_Val,4
	CALL __PUTPARD1
	__GETD1MN _Gyro_Offset_Val,8
	CALL SUBOPT_0x2
; 0000 0098 WaitInPrint();
	RCALL _WaitInPrint
; 0000 0099 
; 0000 009A     while (1)
_0x5:
; 0000 009B     {
; 0000 009C         WaitInPrint();
	RCALL _WaitInPrint
; 0000 009D         puts("\n");
	__POINTW2MN _0x8,0
	CALL _puts
; 0000 009E 
; 0000 009F         Get_Temp_Val();
	RCALL _Get_Temp_Val
; 0000 00A0 
; 0000 00A1         Get_Gyro_Val();
	RCALL _Get_Gyro_Val
; 0000 00A2         Get_AvrgGyro_Val();
	RCALL _Get_AvrgGyro_Val
; 0000 00A3 
; 0000 00A4         Get_Accel_Val();
	RCALL _Get_Accel_Val
; 0000 00A5         Get_AvrgAccel_Val();
	RCALL _Get_AvrgAccel_Val
; 0000 00A6         Get_Accel_Angles();
	RCALL _Get_Accel_Angles
; 0000 00A7 
; 0000 00A8         printf("Temp Val is: %.1f degree Celsius \n\r",Temp_Val);
	__POINTW1FN _0x0,202
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Temp_Val
	LDS  R31,_Temp_Val+1
	LDS  R22,_Temp_Val+2
	LDS  R23,_Temp_Val+3
	CALL SUBOPT_0x1
; 0000 00A9 
; 0000 00AA         printf("\n");
	__POINTW1FN _0x0,200
	CALL SUBOPT_0x0
; 0000 00AB 
; 0000 00AC         printf("    Gyro Raw  Val: %.0f , %.0f , %.0f \n\r",Gyro_Raw_Val[X],Gyro_Raw_Val[Y],Gyro_Raw_Val[Z]);
	__POINTW1FN _0x0,238
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3
	CALL __PUTPARD1
	CALL SUBOPT_0x4
	CALL __PUTPARD1
	CALL SUBOPT_0x5
	CALL SUBOPT_0x2
; 0000 00AD         printf("AvrgGyro Raw  Val: %.0f , %.0f , %.0f \n\r",AvrgGyro_Raw_Val[X],AvrgGyro_Raw_Val[Y],AvrgGyro_Raw_Val[Z]) ...
	__POINTW1FN _0x0,279
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6
	CALL __PUTPARD1
	CALL SUBOPT_0x7
	CALL __PUTPARD1
	CALL SUBOPT_0x8
	CALL SUBOPT_0x2
; 0000 00AE         printf("    Gyro Rate Val: %.1f , %.1f , %.1f \n\r",GyroRate_Val[X],GyroRate_Val[Y],GyroRate_Val[Z]);
	__POINTW1FN _0x0,320
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_GyroRate_Val
	LDS  R31,_GyroRate_Val+1
	LDS  R22,_GyroRate_Val+2
	LDS  R23,_GyroRate_Val+3
	CALL __PUTPARD1
	__GETD1MN _GyroRate_Val,4
	CALL __PUTPARD1
	__GETD1MN _GyroRate_Val,8
	CALL SUBOPT_0x2
; 0000 00AF 
; 0000 00B0         printf("\n");
	__POINTW1FN _0x0,200
	CALL SUBOPT_0x0
; 0000 00B1 
; 0000 00B2         printf("    Accel Raw Val: %.1f , %.1f , %.1f \n\r",Accel_Raw_Val[X],Accel_Raw_Val[Y],Accel_Raw_Val[Z]);
	__POINTW1FN _0x0,361
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
	CALL __PUTPARD1
	CALL SUBOPT_0xA
	CALL __PUTPARD1
	CALL SUBOPT_0xB
	CALL SUBOPT_0x2
; 0000 00B3         printf("AvrgAccel Raw Val: %.1f , %.1f , %.1f \n\r",AvrgAccel_Raw_Val[X],AvrgAccel_Raw_Val[Y],AvrgAccel_Raw_Val[ ...
	__POINTW1FN _0x0,402
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xC
	CALL __PUTPARD1
	CALL SUBOPT_0xD
	CALL __PUTPARD1
	CALL SUBOPT_0xE
	CALL SUBOPT_0x2
; 0000 00B4         printf("  Accel In 1G Val: %.1f , %.1f , %.1f \n\r",Accel_In_g[X],Accel_In_g[Y],Accel_In_g[Z]);
	__POINTW1FN _0x0,443
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Accel_In_g
	LDS  R31,_Accel_In_g+1
	LDS  R22,_Accel_In_g+2
	LDS  R23,_Accel_In_g+3
	CALL __PUTPARD1
	__GETD1MN _Accel_In_g,4
	CALL __PUTPARD1
	__GETD1MN _Accel_In_g,8
	CALL SUBOPT_0x2
; 0000 00B5         printf("Accel  Angle  Val: %.1f , %.1f , %.1f \n\r",Accel_Angle[X],Accel_Angle[Y],Accel_Angle[Z]);
	__POINTW1FN _0x0,484
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Accel_Angle
	LDS  R31,_Accel_Angle+1
	LDS  R22,_Accel_Angle+2
	LDS  R23,_Accel_Angle+3
	CALL __PUTPARD1
	__GETD1MN _Accel_Angle,4
	CALL __PUTPARD1
	__GETD1MN _Accel_Angle,8
	CALL SUBOPT_0x2
; 0000 00B6 
; 0000 00B7     }
	RJMP _0x5
; 0000 00B8 }
_0x9:
	RJMP _0x9
; .FEND

	.DSEG
_0x8:
	.BYTE 0x2
;//*****************************************************************************
;// Usefull Library With I2C 4 Setup MPU6050
;// Copyright :              WWW.RoboticNGO.com      &      www.ECA.ir
;// Author :                 S_Ahmad (Seyyed Ahmad Mousavi)
;// Remarks :
;// known Problems :         None
;// Version :                1.5
;// Date :                   1392/10/23
;// Company :                www.RoboticNGO.com      &      www.ECA.ir
;// Compiler:                CodeVisionAVR V2.05.3+
;//
;// -----------------
;//                  |                 ----------------
;//                  |- 5v  ----- Vcc -| MPU 6050     |
;// MicroController  |- GND ----- GND -| Acceleration,|
;// Board            |- SDA ----- SDA -| Gyro, Temp   |
;//                  |- SCL ----- SCL -|   Module     |
;//                  |                 ----------------
;//------------------
;//
;//*****************************************************************************
;#include <delay.h>
;#include <i2c.h>
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
; 0001 002B {

	.CSEG
_read_i2c:
; .FSTART _read_i2c
; 0001 002C unsigned char Data;
; 0001 002D i2c_start();
	ST   -Y,R26
	ST   -Y,R17
;	BusAddres -> Y+3
;	Reg -> Y+2
;	Ack -> Y+1
;	Data -> R17
	CALL _i2c_start
; 0001 002E i2c_write(BusAddres);
	LDD  R26,Y+3
	CALL _i2c_write
; 0001 002F i2c_write(Reg);
	LDD  R26,Y+2
	CALL _i2c_write
; 0001 0030 i2c_start();
	CALL _i2c_start
; 0001 0031 i2c_write(BusAddres + 1);
	LDD  R26,Y+3
	SUBI R26,-LOW(1)
	CALL _i2c_write
; 0001 0032 delay_us(10);
	__DELAY_USB 27
; 0001 0033 Data=i2c_read(Ack);
	LDD  R26,Y+1
	CALL _i2c_read
	MOV  R17,R30
; 0001 0034 i2c_stop();
	CALL _i2c_stop
; 0001 0035 return Data;
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,4
	RET
; 0001 0036 }
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;void write_i2c(unsigned char BusAddres , unsigned char Reg , unsigned char Data)
; 0001 0039 {
_write_i2c:
; .FSTART _write_i2c
; 0001 003A i2c_start();
	ST   -Y,R26
;	BusAddres -> Y+2
;	Reg -> Y+1
;	Data -> Y+0
	CALL _i2c_start
; 0001 003B i2c_write(BusAddres);
	LDD  R26,Y+2
	CALL _i2c_write
; 0001 003C i2c_write(Reg);
	LDD  R26,Y+1
	CALL _i2c_write
; 0001 003D i2c_write(Data);
	LD   R26,Y
	CALL _i2c_write
; 0001 003E i2c_stop();
	CALL _i2c_stop
; 0001 003F }
	ADIW R28,3
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// This function can test i2c communication MPU6050
;unsigned char MPU6050_Test_I2C()
; 0001 0043 {
_MPU6050_Test_I2C:
; .FSTART _MPU6050_Test_I2C
; 0001 0044     unsigned char Data = 0x00;
; 0001 0045     Data=read_i2c(MPU6050_ADDRESS, RA_WHO_AM_I, 0);
	ST   -Y,R17
;	Data -> R17
	LDI  R17,0
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(117)
	CALL SUBOPT_0xF
	MOV  R17,R30
; 0001 0046     if(Data == 0x68)
	CPI  R17,104
	BRNE _0x20003
; 0001 0047         return 1;       // Means Comunication With MPU6050 is Corect
	LDI  R30,LOW(1)
	RJMP _0x20A000A
; 0001 0048     else
_0x20003:
; 0001 0049         return 0;       // Means ERROR, Stopping
	LDI  R30,LOW(0)
; 0001 004A }
_0x20A000A:
	LD   R17,Y+
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// This function can move MPU6050 to sleep
;void MPU6050_Sleep(char ON_or_OFF)
; 0001 004E {
; 0001 004F     if(ON_or_OFF == on)
;	ON_or_OFF -> Y+0
; 0001 0050         write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (1<<6)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
; 0001 0051     else if(ON_or_OFF == off)
; 0001 0052         write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (0)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
; 0001 0053 }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// This function can restor MPU6050 to default
;void MPU6050_Reset()
; 0001 0057 {
; 0001 0058     // When set to 1, DEVICE_RESET bit in RA_PWR_MGMT_1 resets all internal registers to their default values.
; 0001 0059     // The bit automatically clears to 0 once the reset is done.
; 0001 005A     // The default values for each register can be found in RA_MPU6050.h
; 0001 005B     write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, 0x80);
; 0001 005C     // Now all reg reset to default values
; 0001 005D }
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// MPU6050 sensor initialization
;void MPU6050_Init()
; 0001 0061 {
_MPU6050_Init:
; .FSTART _MPU6050_Init
; 0001 0062     //Sets sample rate to 1000/1+4 = 200Hz
; 0001 0063     write_i2c(MPU6050_ADDRESS, RA_SMPLRT_DIV, SampleRateDiv);
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	LDI  R26,LOW(4)
	CALL SUBOPT_0x10
; 0001 0064     //Disable FSync, 42Hz DLPF
; 0001 0065     write_i2c(MPU6050_ADDRESS, RA_CONFIG, (EXT_SYNC_SET<<3)|(DLPF_CFG));
	LDI  R30,LOW(26)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL SUBOPT_0x10
; 0001 0066     //Disable all axis gyro self tests, scale of 2000 degrees/s
; 0001 0067     write_i2c(MPU6050_ADDRESS, RA_GYRO_CONFIG, ((XG_ST|YG_ST|ZG_ST)<<5)|GFS_SEL);
	LDI  R30,LOW(27)
	ST   -Y,R30
	LDI  R26,LOW(24)
	CALL SUBOPT_0x10
; 0001 0068     //Disable accel self tests, scale of +-16g, no DHPF
; 0001 0069     write_i2c(MPU6050_ADDRESS, RA_ACCEL_CONFIG, ((XA_ST|YA_ST|ZA_ST)<<5)|AFS_SEL);
	LDI  R30,LOW(28)
	CALL SUBOPT_0x11
; 0001 006A     //Disable sensor output to FIFO buffer
; 0001 006B     write_i2c(MPU6050_ADDRESS, RA_FIFO_EN, FIFO_En_Parameters);
	LDI  R30,LOW(35)
	CALL SUBOPT_0x11
; 0001 006C 
; 0001 006D     //Freefall threshold of |0mg|
; 0001 006E     write_i2c(MPU6050_ADDRESS, RA_FF_THR, 0x00);
	LDI  R30,LOW(29)
	CALL SUBOPT_0x11
; 0001 006F     //Freefall duration limit of 0
; 0001 0070     write_i2c(MPU6050_ADDRESS, RA_FF_DUR, 0x00);
	LDI  R30,LOW(30)
	CALL SUBOPT_0x11
; 0001 0071     //Motion threshold of 0mg
; 0001 0072     write_i2c(MPU6050_ADDRESS, RA_MOT_THR, 0x00);
	LDI  R30,LOW(31)
	CALL SUBOPT_0x11
; 0001 0073     //Motion duration of 0s
; 0001 0074     write_i2c(MPU6050_ADDRESS, RA_MOT_DUR, 0x00);
	LDI  R30,LOW(32)
	CALL SUBOPT_0x11
; 0001 0075     //Zero motion threshold
; 0001 0076     write_i2c(MPU6050_ADDRESS, RA_ZRMOT_THR, 0x00);
	LDI  R30,LOW(33)
	CALL SUBOPT_0x11
; 0001 0077     //Zero motion duration threshold
; 0001 0078     write_i2c(MPU6050_ADDRESS, RA_ZRMOT_DUR, 0x00);
	LDI  R30,LOW(34)
	CALL SUBOPT_0x11
; 0001 0079 
; 0001 007A //////////////////////////////////////////////////////////////
; 0001 007B //  AUX I2C setup
; 0001 007C //////////////////////////////////////////////////////////////
; 0001 007D     //Sets AUX I2C to single master control, plus other config
; 0001 007E     write_i2c(MPU6050_ADDRESS, RA_I2C_MST_CTRL, 0x00);
	LDI  R30,LOW(36)
	CALL SUBOPT_0x11
; 0001 007F     //Setup AUX I2C slaves
; 0001 0080     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_ADDR, 0x00);
	LDI  R30,LOW(37)
	CALL SUBOPT_0x11
; 0001 0081     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_REG, 0x00);
	LDI  R30,LOW(38)
	CALL SUBOPT_0x11
; 0001 0082     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_CTRL, 0x00);
	LDI  R30,LOW(39)
	CALL SUBOPT_0x11
; 0001 0083 
; 0001 0084     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_ADDR, 0x00);
	LDI  R30,LOW(40)
	CALL SUBOPT_0x11
; 0001 0085     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_REG, 0x00);
	LDI  R30,LOW(41)
	CALL SUBOPT_0x11
; 0001 0086     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_CTRL, 0x00);
	LDI  R30,LOW(42)
	CALL SUBOPT_0x11
; 0001 0087 
; 0001 0088     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_ADDR, 0x00);
	LDI  R30,LOW(43)
	CALL SUBOPT_0x11
; 0001 0089     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_REG, 0x00);
	LDI  R30,LOW(44)
	CALL SUBOPT_0x11
; 0001 008A     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_CTRL, 0x00);
	LDI  R30,LOW(45)
	CALL SUBOPT_0x11
; 0001 008B 
; 0001 008C     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_ADDR, 0x00);
	LDI  R30,LOW(46)
	CALL SUBOPT_0x11
; 0001 008D     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_REG, 0x00);
	LDI  R30,LOW(47)
	CALL SUBOPT_0x11
; 0001 008E     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_CTRL, 0x00);
	LDI  R30,LOW(48)
	CALL SUBOPT_0x11
; 0001 008F 
; 0001 0090     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_ADDR, 0x00);
	LDI  R30,LOW(49)
	CALL SUBOPT_0x11
; 0001 0091     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_REG, 0x00);
	LDI  R30,LOW(50)
	CALL SUBOPT_0x11
; 0001 0092     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_DO, 0x00);
	LDI  R30,LOW(51)
	CALL SUBOPT_0x11
; 0001 0093     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_CTRL, 0x00);
	LDI  R30,LOW(52)
	CALL SUBOPT_0x11
; 0001 0094     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_DI, 0x00);
	LDI  R30,LOW(53)
	CALL SUBOPT_0x11
; 0001 0095 
; 0001 0096     //Setup INT pin and AUX I2C pass through
; 0001 0097     write_i2c(MPU6050_ADDRESS, RA_INT_PIN_CFG, 0x00);
	LDI  R30,LOW(55)
	CALL SUBOPT_0x11
; 0001 0098     //Enable data ready interrupt
; 0001 0099     write_i2c(MPU6050_ADDRESS, RA_INT_ENABLE, 0x00);
	LDI  R30,LOW(56)
	CALL SUBOPT_0x11
; 0001 009A 
; 0001 009B     //Slave out, dont care
; 0001 009C     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_DO, 0x00);
	LDI  R30,LOW(99)
	CALL SUBOPT_0x11
; 0001 009D     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_DO, 0x00);
	LDI  R30,LOW(100)
	CALL SUBOPT_0x11
; 0001 009E     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_DO, 0x00);
	LDI  R30,LOW(101)
	CALL SUBOPT_0x11
; 0001 009F     write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_DO, 0x00);
	LDI  R30,LOW(102)
	CALL SUBOPT_0x11
; 0001 00A0     //More slave config
; 0001 00A1     write_i2c(MPU6050_ADDRESS, RA_I2C_MST_DELAY_CTRL, 0x00);
	LDI  R30,LOW(103)
	CALL SUBOPT_0x11
; 0001 00A2 
; 0001 00A3     //Reset sensor signal paths
; 0001 00A4     write_i2c(MPU6050_ADDRESS, RA_SIGNAL_PATH_RESET, 0x00);
	LDI  R30,LOW(104)
	CALL SUBOPT_0x11
; 0001 00A5     //Motion detection control
; 0001 00A6     write_i2c(MPU6050_ADDRESS, RA_MOT_DETECT_CTRL, 0x00);
	LDI  R30,LOW(105)
	CALL SUBOPT_0x11
; 0001 00A7     //Disables FIFO, AUX I2C, FIFO and I2C reset bits to 0
; 0001 00A8     write_i2c(MPU6050_ADDRESS, RA_USER_CTRL, 0x00);
	LDI  R30,LOW(106)
	CALL SUBOPT_0x11
; 0001 00A9 
; 0001 00AA     //Sets clock source to gyro reference w/ PLL
; 0001 00AB     write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (SLEEP<<6)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
	LDI  R30,LOW(107)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL SUBOPT_0x10
; 0001 00AC     //Controls frequency of wakeups in accel low power mode plus the sensor standby modes
; 0001 00AD     write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_2, (LP_WAKE_CTRL<<6)|(STBY_XA<<5)|(STBY_YA<<4)|(STBY_ZA<<3)|(STBY_XG<<2)|(STB ...
	LDI  R30,LOW(108)
	CALL SUBOPT_0x11
; 0001 00AE     //Data transfer to and from the FIFO buffer
; 0001 00AF     write_i2c(MPU6050_ADDRESS, RA_FIFO_R_W, 0x00);
	LDI  R30,LOW(116)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _write_i2c
; 0001 00B0 
; 0001 00B1 //  MPU6050 Setup Complete
; 0001 00B2 }
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// get accel offset X,Y,Z
;void Get_Accel_Offset()
; 0001 00B6 {
_Get_Accel_Offset:
; .FSTART _Get_Accel_Offset
; 0001 00B7   #define    NumAve4AO      100
; 0001 00B8   float Ave=0;
; 0001 00B9   unsigned char i= NumAve4AO;
; 0001 00BA   while(i--)
	CALL SUBOPT_0x12
;	Ave -> Y+1
;	i -> R17
	LDI  R17,100
_0x20008:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000A
; 0001 00BB   {
; 0001 00BC     Accel_Offset_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
; 0001 00BD                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)   );
	CALL SUBOPT_0x13
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x14
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_Accel_Offset_Val)
	LDI  R27,HIGH(_Accel_Offset_Val)
	CALL SUBOPT_0x15
; 0001 00BE     Ave = (float) Ave + (Accel_Offset_Val[X] / NumAve4AO);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0001 00BF     delay_us(10);
; 0001 00C0   }
	RJMP _0x20008
_0x2000A:
; 0001 00C1   Accel_Offset_Val[X] = Ave;
	CALL SUBOPT_0x18
	STS  _Accel_Offset_Val,R30
	STS  _Accel_Offset_Val+1,R31
	STS  _Accel_Offset_Val+2,R22
	STS  _Accel_Offset_Val+3,R23
; 0001 00C2   Ave = 0;
	CALL SUBOPT_0x19
; 0001 00C3   i = NumAve4AO;
; 0001 00C4   while(i--)
_0x2000B:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000D
; 0001 00C5   {
; 0001 00C6     Accel_Offset_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
; 0001 00C7                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)   );
	CALL SUBOPT_0x1A
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1B
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Accel_Offset_Val,4
	CALL SUBOPT_0x15
; 0001 00C8     Ave = (float) Ave + (Accel_Offset_Val[Y] / NumAve4AO);
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x17
; 0001 00C9     delay_us(10);
; 0001 00CA   }
	RJMP _0x2000B
_0x2000D:
; 0001 00CB   Accel_Offset_Val[Y] = Ave;
	CALL SUBOPT_0x18
	__PUTD1MN _Accel_Offset_Val,4
; 0001 00CC   Ave = 0;
	CALL SUBOPT_0x19
; 0001 00CD   i = NumAve4AO;
; 0001 00CE   while(i--)
_0x2000E:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20010
; 0001 00CF   {
; 0001 00D0     Accel_Offset_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
; 0001 00D1                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)   );
	CALL SUBOPT_0x1D
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1E
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Accel_Offset_Val,8
	CALL SUBOPT_0x15
; 0001 00D2     Ave = (float) Ave + (Accel_Offset_Val[Z] / NumAve4AO);
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x17
; 0001 00D3     delay_us(10);
; 0001 00D4   }
	RJMP _0x2000E
_0x20010:
; 0001 00D5   Accel_Offset_Val[Z] = Ave;
	CALL SUBOPT_0x18
	__PUTD1MN _Accel_Offset_Val,8
; 0001 00D6 }
	RJMP _0x20A0009
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Gets raw accelerometer data, performs no processing
;void Get_Accel_Val()
; 0001 00DA {
_Get_Accel_Val:
; .FSTART _Get_Accel_Val
; 0001 00DB     Accel_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
; 0001 00DC                          read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)    );
	CALL SUBOPT_0x13
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x14
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_Accel_Raw_Val)
	LDI  R27,HIGH(_Accel_Raw_Val)
	CALL SUBOPT_0x15
; 0001 00DD     Accel_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
; 0001 00DE                          read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)    );
	CALL SUBOPT_0x1A
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1B
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Accel_Raw_Val,4
	CALL SUBOPT_0x15
; 0001 00DF     Accel_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
; 0001 00E0                          read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)    );
	CALL SUBOPT_0x1D
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1E
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Accel_Raw_Val,8
	CALL SUBOPT_0x15
; 0001 00E1 
; 0001 00E2     Accel_In_g[X] = Accel_Raw_Val[X] - Accel_Offset_Val[X];
	CALL SUBOPT_0x16
	CALL SUBOPT_0x9
	CALL SUBOPT_0x20
; 0001 00E3     Accel_In_g[Y] = Accel_Raw_Val[Y] - Accel_Offset_Val[Y];
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x21
; 0001 00E4     Accel_In_g[Z] = Accel_Raw_Val[Z] - Accel_Offset_Val[Z];
	CALL SUBOPT_0xB
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x22
; 0001 00E5 
; 0001 00E6     Accel_In_g[X] = Accel_In_g[X] / ACCEL_Sensitivity;
; 0001 00E7     Accel_In_g[Y] = Accel_In_g[Y] / ACCEL_Sensitivity;
; 0001 00E8     Accel_In_g[Z] = Accel_In_g[Z] / ACCEL_Sensitivity;
; 0001 00E9 }
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Gets n average raw accelerometer data, performs no processing
;void Get_AvrgAccel_Val()
; 0001 00ED {
_Get_AvrgAccel_Val:
; .FSTART _Get_AvrgAccel_Val
; 0001 00EE   #define    NumAve4A      50
; 0001 00EF   float Ave=0;
; 0001 00F0   unsigned char i= NumAve4A;
; 0001 00F1   while(i--)
	CALL SUBOPT_0x12
;	Ave -> Y+1
;	i -> R17
	LDI  R17,50
_0x20011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20013
; 0001 00F2   {
; 0001 00F3     AvrgAccel_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
; 0001 00F4                              read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)   );
	CALL SUBOPT_0x13
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x14
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_AvrgAccel_Raw_Val)
	LDI  R27,HIGH(_AvrgAccel_Raw_Val)
	CALL SUBOPT_0x15
; 0001 00F5     Ave = (float) Ave + (AvrgAccel_Raw_Val[X] / NumAve4A);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
; 0001 00F6     delay_us(10);
; 0001 00F7   }
	RJMP _0x20011
_0x20013:
; 0001 00F8   AvrgAccel_Raw_Val[X] = Ave;
	CALL SUBOPT_0x18
	STS  _AvrgAccel_Raw_Val,R30
	STS  _AvrgAccel_Raw_Val+1,R31
	STS  _AvrgAccel_Raw_Val+2,R22
	STS  _AvrgAccel_Raw_Val+3,R23
; 0001 00F9   Ave = 0;
	CALL SUBOPT_0x25
; 0001 00FA   i = NumAve4A;
; 0001 00FB   while(i--)
_0x20014:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20016
; 0001 00FC   {
; 0001 00FD     AvrgAccel_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
; 0001 00FE                              read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)   );
	CALL SUBOPT_0x1A
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1B
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _AvrgAccel_Raw_Val,4
	CALL SUBOPT_0x15
; 0001 00FF     Ave = (float) Ave + (AvrgAccel_Raw_Val[Y] / NumAve4A);
	__GETD2MN _AvrgAccel_Raw_Val,4
	CALL SUBOPT_0x24
; 0001 0100     delay_us(10);
; 0001 0101   }
	RJMP _0x20014
_0x20016:
; 0001 0102   AvrgAccel_Raw_Val[Y] = Ave;
	CALL SUBOPT_0x18
	__PUTD1MN _AvrgAccel_Raw_Val,4
; 0001 0103   Ave = 0;
	CALL SUBOPT_0x25
; 0001 0104   i = NumAve4A;
; 0001 0105   while(i--)
_0x20017:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20019
; 0001 0106   {
; 0001 0107     AvrgAccel_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
; 0001 0108                              read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)   );
	CALL SUBOPT_0x1D
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1E
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _AvrgAccel_Raw_Val,8
	CALL SUBOPT_0x15
; 0001 0109     Ave = (float) Ave + (AvrgAccel_Raw_Val[Z] / NumAve4A);
	__GETD2MN _AvrgAccel_Raw_Val,8
	CALL SUBOPT_0x24
; 0001 010A     delay_us(10);
; 0001 010B   }
	RJMP _0x20017
_0x20019:
; 0001 010C   AvrgAccel_Raw_Val[Z] = Ave;
	CALL SUBOPT_0x18
	__PUTD1MN _AvrgAccel_Raw_Val,8
; 0001 010D 
; 0001 010E   Accel_In_g[X] = AvrgAccel_Raw_Val[X] - Accel_Offset_Val[X];
	CALL SUBOPT_0x16
	CALL SUBOPT_0xC
	CALL SUBOPT_0x20
; 0001 010F   Accel_In_g[Y] = AvrgAccel_Raw_Val[Y] - Accel_Offset_Val[Y];
	CALL SUBOPT_0xD
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x21
; 0001 0110   Accel_In_g[Z] = AvrgAccel_Raw_Val[Z] - Accel_Offset_Val[Z];
	CALL SUBOPT_0xE
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x22
; 0001 0111 
; 0001 0112   Accel_In_g[X] = Accel_In_g[X] / ACCEL_Sensitivity;  //  g/LSB
; 0001 0113   Accel_In_g[Y] = Accel_In_g[Y] / ACCEL_Sensitivity;  //  g/LSB
; 0001 0114   Accel_In_g[Z] = Accel_In_g[Z] / ACCEL_Sensitivity;  //  g/LSB
; 0001 0115 
; 0001 0116 }
	RJMP _0x20A0009
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Gets angles from accelerometer data
;void Get_Accel_Angles()
; 0001 011A {
_Get_Accel_Angles:
; .FSTART _Get_Accel_Angles
; 0001 011B // If you want be averaged of accelerometer data, write (on),else write (off)
; 0001 011C #define  GetAvrg  on
; 0001 011D 
; 0001 011E #if GetAvrg == on
; 0001 011F     Get_AvrgAccel_Val();
	RCALL _Get_AvrgAccel_Val
; 0001 0120 //  Calculate The Angle Of Each Axis
; 0001 0121     Accel_Angle[X] = 57.295*atan((float) AvrgAccel_Raw_Val[X] / sqrt(pow((float)AvrgAccel_Raw_Val[Z],2)+pow((float)AvrgA ...
	CALL SUBOPT_0xE
	CALL SUBOPT_0x26
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xD
	CALL SUBOPT_0x26
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x27
	CALL SUBOPT_0x23
	CALL SUBOPT_0x28
	STS  _Accel_Angle,R30
	STS  _Accel_Angle+1,R31
	STS  _Accel_Angle+2,R22
	STS  _Accel_Angle+3,R23
; 0001 0122     Accel_Angle[Y] = 57.295*atan((float) AvrgAccel_Raw_Val[Y] / sqrt(pow((float)AvrgAccel_Raw_Val[Z],2)+pow((float)AvrgA ...
	CALL SUBOPT_0xD
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xE
	CALL SUBOPT_0x26
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	CALL SUBOPT_0x26
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x27
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x28
	__PUTD1MN _Accel_Angle,4
; 0001 0123     Accel_Angle[Z] = 57.295*atan((float) sqrt(pow((float)AvrgAccel_Raw_Val[X],2)+pow((float)AvrgAccel_Raw_Val[Y],2))/ Av ...
	CALL SUBOPT_0xC
	CALL SUBOPT_0x26
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xD
	CALL SUBOPT_0x26
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x27
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0xE
	CALL SUBOPT_0x28
	__PUTD1MN _Accel_Angle,8
; 0001 0124 #else
; 0001 0125     Get_Accel_Val();
; 0001 0126 //  Calculate The Angle Of Each Axis
; 0001 0127     Accel_Angle[X] = 57.295*atan((float) Accel_Raw_Val[X] / sqrt(pow((float)Accel_Raw_Val[Z],2)+pow((float)Accel_Raw_Val ...
; 0001 0128     Accel_Angle[Y] = 57.295*atan((float) Accel_Raw_Val[Y] / sqrt(pow((float)Accel_Raw_Val[Z],2)+pow((float)Accel_Raw_Val ...
; 0001 0129     Accel_Angle[Z] = 57.295*atan((float) sqrt(pow((float)Accel_Raw_Val[X],2)+pow((float)Accel_Raw_Val[Y],2))/ Accel_Raw_ ...
; 0001 012A #endif
; 0001 012B 
; 0001 012C }
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// get gyro offset X,Y,Z
;void Get_Gyro_Offset()
; 0001 0130 {
_Get_Gyro_Offset:
; .FSTART _Get_Gyro_Offset
; 0001 0131   #define    NumAve4GO      100
; 0001 0132 
; 0001 0133   float Ave = 0;
; 0001 0134   unsigned char i = NumAve4GO;
; 0001 0135   Gyro_Offset_Val[X] = Gyro_Offset_Val[Y] = Gyro_Offset_Val[Z] = 0;
	CALL SUBOPT_0x12
;	Ave -> Y+1
;	i -> R17
	LDI  R17,100
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0001 0136 
; 0001 0137   while(i--)
_0x2001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2001C
; 0001 0138   {
; 0001 0139     Gyro_Offset_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8)|
; 0001 013A                            read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0)   );
	CALL SUBOPT_0x2D
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2E
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_Gyro_Offset_Val)
	LDI  R27,HIGH(_Gyro_Offset_Val)
	CALL SUBOPT_0x15
; 0001 013B     Ave = (float) Ave + (Gyro_Offset_Val[X] / NumAve4GO);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
; 0001 013C     delay_us(1);
; 0001 013D   }
	RJMP _0x2001A
_0x2001C:
; 0001 013E   Gyro_Offset_Val[X] = Ave;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x2C
; 0001 013F   Ave = 0;
	CALL SUBOPT_0x19
; 0001 0140   i = NumAve4GO;
; 0001 0141   while(i--)
_0x2001D:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2001F
; 0001 0142   {
; 0001 0143     Gyro_Offset_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8)|
; 0001 0144                            read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0)   );
	CALL SUBOPT_0x31
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x32
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Gyro_Offset_Val,4
	CALL SUBOPT_0x15
; 0001 0145     Ave = (float) Ave + (Gyro_Offset_Val[Y] / NumAve4GO);
	CALL SUBOPT_0x33
	CALL SUBOPT_0x30
; 0001 0146     delay_us(1);
; 0001 0147   }
	RJMP _0x2001D
_0x2001F:
; 0001 0148   Gyro_Offset_Val[Y] = Ave;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x2B
; 0001 0149   Ave = 0;
	CALL SUBOPT_0x19
; 0001 014A   i = NumAve4GO;
; 0001 014B   while(i--)
_0x20020:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20022
; 0001 014C   {
; 0001 014D       Gyro_Offset_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8)|
; 0001 014E                              read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0)   );
	CALL SUBOPT_0x34
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x35
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Gyro_Offset_Val,8
	CALL SUBOPT_0x15
; 0001 014F     Ave = (float) Ave + (Gyro_Offset_Val[Z] / NumAve4GO);
	CALL SUBOPT_0x36
	CALL SUBOPT_0x30
; 0001 0150     delay_us(1);
; 0001 0151   }
	RJMP _0x20020
_0x20022:
; 0001 0152   Gyro_Offset_Val[Z] = Ave;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x2A
; 0001 0153 
; 0001 0154 }
	RJMP _0x20A0009
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Function to read the gyroscope rate data and convert it into degrees/s
;void Get_Gyro_Val()
; 0001 0158 {
_Get_Gyro_Val:
; .FSTART _Get_Gyro_Val
; 0001 0159     Gyro_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8) |
; 0001 015A                         read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0))    ;
	CALL SUBOPT_0x2D
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2E
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_Gyro_Raw_Val)
	LDI  R27,HIGH(_Gyro_Raw_Val)
	CALL SUBOPT_0x15
; 0001 015B     Gyro_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8) |
; 0001 015C                         read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0))    ;
	CALL SUBOPT_0x31
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x32
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Gyro_Raw_Val,4
	CALL SUBOPT_0x15
; 0001 015D     Gyro_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8) |
; 0001 015E                         read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0))    ;
	CALL SUBOPT_0x34
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x35
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _Gyro_Raw_Val,8
	CALL SUBOPT_0x15
; 0001 015F 
; 0001 0160     GyroRate_Val[X] = Gyro_Raw_Val[X] - Gyro_Offset_Val[X];
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x3
	CALL SUBOPT_0x37
; 0001 0161     GyroRate_Val[Y] = Gyro_Raw_Val[Y] - Gyro_Offset_Val[Y];
	CALL SUBOPT_0x4
	CALL SUBOPT_0x33
	CALL SUBOPT_0x38
; 0001 0162     GyroRate_Val[Z] = Gyro_Raw_Val[Z] - Gyro_Offset_Val[Z];
	CALL SUBOPT_0x5
	CALL SUBOPT_0x36
	CALL SUBOPT_0x39
; 0001 0163 
; 0001 0164     GyroRate_Val[X] = GyroRate_Val[X] / GYRO_Sensitivity;
; 0001 0165     GyroRate_Val[Y] = GyroRate_Val[Y] / GYRO_Sensitivity;
; 0001 0166     GyroRate_Val[Z] = GyroRate_Val[Z] / GYRO_Sensitivity;
; 0001 0167 
; 0001 0168 }
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Function to read the Avrrage of gyroscope rate data and convert it into degrees/s
;void Get_AvrgGyro_Val()
; 0001 016C {
_Get_AvrgGyro_Val:
; .FSTART _Get_AvrgGyro_Val
; 0001 016D   #define    NumAve4G      50
; 0001 016E 
; 0001 016F   float Ave = 0;
; 0001 0170   unsigned char i = NumAve4G;
; 0001 0171   AvrgGyro_Raw_Val[X] = AvrgGyro_Raw_Val[Y] = AvrgGyro_Raw_Val[Z] = 0;
	CALL SUBOPT_0x12
;	Ave -> Y+1
;	i -> R17
	LDI  R17,50
	CALL SUBOPT_0x29
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3C
; 0001 0172 
; 0001 0173   while(i--)
_0x20023:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20025
; 0001 0174   {
; 0001 0175     AvrgGyro_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8)|
; 0001 0176                             read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0)   );
	CALL SUBOPT_0x2D
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2E
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_AvrgGyro_Raw_Val)
	LDI  R27,HIGH(_AvrgGyro_Raw_Val)
	CALL SUBOPT_0x15
; 0001 0177     Ave = (float) Ave + (AvrgGyro_Raw_Val[X] / NumAve4G);
	LDS  R26,_AvrgGyro_Raw_Val
	LDS  R27,_AvrgGyro_Raw_Val+1
	LDS  R24,_AvrgGyro_Raw_Val+2
	LDS  R25,_AvrgGyro_Raw_Val+3
	CALL SUBOPT_0x3D
; 0001 0178     delay_us(1);
; 0001 0179   }
	RJMP _0x20023
_0x20025:
; 0001 017A   AvrgGyro_Raw_Val[X] = Ave;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x3C
; 0001 017B   Ave = 0;
	CALL SUBOPT_0x25
; 0001 017C   i = NumAve4G;
; 0001 017D   while(i--)
_0x20026:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20028
; 0001 017E   {
; 0001 017F     AvrgGyro_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8)|
; 0001 0180                             read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0)   );
	CALL SUBOPT_0x31
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x32
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _AvrgGyro_Raw_Val,4
	CALL SUBOPT_0x15
; 0001 0181     Ave = (float) Ave + (AvrgGyro_Raw_Val[Y] / NumAve4G);
	__GETD2MN _AvrgGyro_Raw_Val,4
	CALL SUBOPT_0x3D
; 0001 0182     delay_us(1);
; 0001 0183   }
	RJMP _0x20026
_0x20028:
; 0001 0184   AvrgGyro_Raw_Val[Y] = Ave;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x3B
; 0001 0185   Ave = 0;
	CALL SUBOPT_0x25
; 0001 0186   i = NumAve4G;
; 0001 0187   while(i--)
_0x20029:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2002B
; 0001 0188   {
; 0001 0189     AvrgGyro_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8)|
; 0001 018A                             read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0)   );
	CALL SUBOPT_0x34
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x35
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__POINTW2MN _AvrgGyro_Raw_Val,8
	CALL SUBOPT_0x15
; 0001 018B     Ave = (float) Ave + (AvrgGyro_Raw_Val[Z] / NumAve4G);
	__GETD2MN _AvrgGyro_Raw_Val,8
	CALL SUBOPT_0x3D
; 0001 018C     delay_us(1);
; 0001 018D   }
	RJMP _0x20029
_0x2002B:
; 0001 018E   AvrgGyro_Raw_Val[Z] = Ave;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x3A
; 0001 018F 
; 0001 0190   GyroRate_Val[X] = AvrgGyro_Raw_Val[X] - Gyro_Offset_Val[X];
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x6
	CALL SUBOPT_0x37
; 0001 0191   GyroRate_Val[Y] = AvrgGyro_Raw_Val[Y] - Gyro_Offset_Val[Y];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x33
	CALL SUBOPT_0x38
; 0001 0192   GyroRate_Val[Z] = AvrgGyro_Raw_Val[Z] - Gyro_Offset_Val[Z];
	CALL SUBOPT_0x8
	CALL SUBOPT_0x36
	CALL SUBOPT_0x39
; 0001 0193 
; 0001 0194   GyroRate_Val[X] = GyroRate_Val[X] / GYRO_Sensitivity;   // (º/s)/LSB
; 0001 0195   GyroRate_Val[Y] = GyroRate_Val[Y] / GYRO_Sensitivity;   // (º/s)/LSB
; 0001 0196   GyroRate_Val[Z] = GyroRate_Val[Z] / GYRO_Sensitivity;   // (º/s)/LSB
; 0001 0197 
; 0001 0198 }
_0x20A0009:
	LDD  R17,Y+0
	ADIW R28,5
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;// Function to read the Temperature
;void Get_Temp_Val()
; 0001 019C {
_Get_Temp_Val:
; .FSTART _Get_Temp_Val
; 0001 019D     Temp_Val = ((read_i2c(MPU6050_ADDRESS, RA_TEMP_OUT_H, 0)<< 8)|
; 0001 019E                   read_i2c(MPU6050_ADDRESS, RA_TEMP_OUT_L, 0)   );
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(65)
	CALL SUBOPT_0xF
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(66)
	CALL SUBOPT_0xF
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_Temp_Val)
	LDI  R27,HIGH(_Temp_Val)
	CALL SUBOPT_0x15
; 0001 019F // Compute the temperature in degrees
; 0001 01A0     Temp_Val = (Temp_Val /TEMP_Sensitivity) + 36.53;
	LDS  R26,_Temp_Val
	LDS  R27,_Temp_Val+1
	LDS  R24,_Temp_Val+2
	LDS  R25,_Temp_Val+3
	__GETD1N 0x43AA0000
	CALL __DIVF21
	__GETD2N 0x42121EB8
	CALL __ADDF12
	STS  _Temp_Val,R30
	STS  _Temp_Val+1,R31
	STS  _Temp_Val+2,R22
	STS  _Temp_Val+3,R23
; 0001 01A1 }
	RET
; .FEND
;//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
;#pragma warn+
;
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
_getchar:
; .FSTART _getchar
getchar0:
     sbis usr,rxc
     rjmp getchar0
     in   r30,udr
	RET
; .FEND
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
_puts:
; .FSTART _puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000003:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000005
	MOV  R26,R17
	RCALL _putchar
	RJMP _0x2000003
_0x2000005:
	LDI  R26,LOW(10)
	RCALL _putchar
	LDD  R17,Y+0
	RJMP _0x20A0008
; .FEND
_put_usart_G100:
; .FSTART _put_usart_G100
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x20A0008:
	ADIW R28,3
	RET
; .FEND
__ftoe_G100:
; .FSTART __ftoe_G100
	CALL SUBOPT_0x3E
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2000019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,0
	CALL _strcpyf
	RJMP _0x20A0007
_0x2000019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2000018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,1
	CALL _strcpyf
	RJMP _0x20A0007
_0x2000018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x200001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x200001B:
	LDD  R17,Y+11
_0x200001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001E
	CALL SUBOPT_0x3F
	RJMP _0x200001C
_0x200001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x200001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x3F
	RJMP _0x2000020
_0x200001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x40
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000021
	CALL SUBOPT_0x3F
_0x2000022:
	CALL SUBOPT_0x40
	BRLO _0x2000024
	CALL SUBOPT_0x41
	CALL SUBOPT_0x42
	RJMP _0x2000022
_0x2000024:
	RJMP _0x2000025
_0x2000021:
_0x2000026:
	CALL SUBOPT_0x40
	BRSH _0x2000028
	CALL SUBOPT_0x41
	CALL SUBOPT_0x43
	CALL SUBOPT_0x44
	SUBI R19,LOW(1)
	RJMP _0x2000026
_0x2000028:
	CALL SUBOPT_0x3F
_0x2000025:
	__GETD1S 12
	CALL SUBOPT_0x45
	CALL SUBOPT_0x44
	CALL SUBOPT_0x40
	BRLO _0x2000029
	CALL SUBOPT_0x41
	CALL SUBOPT_0x42
_0x2000029:
_0x2000020:
	LDI  R17,LOW(0)
_0x200002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x200002C
	CALL SUBOPT_0x46
	CALL SUBOPT_0x47
	CALL SUBOPT_0x45
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x48
	CALL SUBOPT_0x41
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4A
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x41
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x44
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x200002A
	CALL SUBOPT_0x49
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x200002A
_0x200002C:
	CALL SUBOPT_0x4D
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x200002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2000113
_0x200002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2000113:
	ST   X,R30
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4D
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x4D
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0007:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000036
	CPI  R18,37
	BRNE _0x2000037
	LDI  R17,LOW(1)
	RJMP _0x2000038
_0x2000037:
	CALL SUBOPT_0x4E
_0x2000038:
	RJMP _0x2000035
_0x2000036:
	CPI  R30,LOW(0x1)
	BRNE _0x2000039
	CPI  R18,37
	BRNE _0x200003A
	CALL SUBOPT_0x4E
	RJMP _0x2000114
_0x200003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x200003B
	LDI  R16,LOW(1)
	RJMP _0x2000035
_0x200003B:
	CPI  R18,43
	BRNE _0x200003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003C:
	CPI  R18,32
	BRNE _0x200003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003D:
	RJMP _0x200003E
_0x2000039:
	CPI  R30,LOW(0x2)
	BRNE _0x200003F
_0x200003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000040
	ORI  R16,LOW(128)
	RJMP _0x2000035
_0x2000040:
	RJMP _0x2000041
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
_0x2000041:
	CPI  R18,48
	BRLO _0x2000044
	CPI  R18,58
	BRLO _0x2000045
_0x2000044:
	RJMP _0x2000043
_0x2000045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000035
_0x2000043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2000046
	LDI  R17,LOW(4)
	RJMP _0x2000035
_0x2000046:
	RJMP _0x2000047
_0x2000042:
	CPI  R30,LOW(0x4)
	BRNE _0x2000049
	CPI  R18,48
	BRLO _0x200004B
	CPI  R18,58
	BRLO _0x200004C
_0x200004B:
	RJMP _0x200004A
_0x200004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2000035
_0x200004A:
_0x2000047:
	CPI  R18,108
	BRNE _0x200004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2000035
_0x200004D:
	RJMP _0x200004E
_0x2000049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2000035
_0x200004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000053
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x50
	CALL SUBOPT_0x4F
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x51
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x45)
	BREQ _0x2000057
	CPI  R30,LOW(0x65)
	BRNE _0x2000058
_0x2000057:
	RJMP _0x2000059
_0x2000058:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x200005A
_0x2000059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x52
	CALL __GETD1P
	CALL SUBOPT_0x53
	CALL SUBOPT_0x54
	LDD  R26,Y+13
	TST  R26
	BRMI _0x200005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x200005D
	CPI  R26,LOW(0x20)
	BREQ _0x200005F
	RJMP _0x2000060
_0x200005B:
	CALL SUBOPT_0x55
	CALL __ANEGF1
	CALL SUBOPT_0x53
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200005D:
	SBRS R16,7
	RJMP _0x2000061
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x51
	RJMP _0x2000062
_0x2000061:
_0x200005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000062:
_0x2000060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2000064
	CALL SUBOPT_0x55
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2000065
_0x2000064:
	CALL SUBOPT_0x55
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G100
_0x2000065:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x56
	RJMP _0x2000066
_0x200005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2000068
	CALL SUBOPT_0x54
	CALL SUBOPT_0x57
	CALL SUBOPT_0x56
	RJMP _0x2000069
_0x2000068:
	CPI  R30,LOW(0x70)
	BRNE _0x200006B
	CALL SUBOPT_0x54
	CALL SUBOPT_0x57
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x200006D
	CP   R20,R17
	BRLO _0x200006E
_0x200006D:
	RJMP _0x200006C
_0x200006E:
	MOV  R17,R20
_0x200006C:
_0x2000066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x200006F
_0x200006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2000072
	CPI  R30,LOW(0x69)
	BRNE _0x2000073
_0x2000072:
	ORI  R16,LOW(4)
	RJMP _0x2000074
_0x2000073:
	CPI  R30,LOW(0x75)
	BRNE _0x2000075
_0x2000074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000076
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x58
	LDI  R17,LOW(10)
	RJMP _0x2000077
_0x2000076:
	__GETD1N 0x2710
	CALL SUBOPT_0x58
	LDI  R17,LOW(5)
	RJMP _0x2000077
_0x2000075:
	CPI  R30,LOW(0x58)
	BRNE _0x2000079
	ORI  R16,LOW(8)
	RJMP _0x200007A
_0x2000079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20000B8
_0x200007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007C
	__GETD1N 0x10000000
	CALL SUBOPT_0x58
	LDI  R17,LOW(8)
	RJMP _0x2000077
_0x200007C:
	__GETD1N 0x1000
	CALL SUBOPT_0x58
	LDI  R17,LOW(4)
_0x2000077:
	CPI  R20,0
	BREQ _0x200007D
	ANDI R16,LOW(127)
	RJMP _0x200007E
_0x200007D:
	LDI  R20,LOW(1)
_0x200007E:
	SBRS R16,1
	RJMP _0x200007F
	CALL SUBOPT_0x54
	CALL SUBOPT_0x52
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2000115
_0x200007F:
	SBRS R16,2
	RJMP _0x2000081
	CALL SUBOPT_0x54
	CALL SUBOPT_0x57
	CALL __CWD1
	RJMP _0x2000115
_0x2000081:
	CALL SUBOPT_0x54
	CALL SUBOPT_0x57
	CLR  R22
	CLR  R23
_0x2000115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000084
	CALL SUBOPT_0x55
	CALL __ANEGD1
	CALL SUBOPT_0x53
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2000085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2000086
_0x2000085:
	ANDI R16,LOW(251)
_0x2000086:
_0x2000083:
	MOV  R19,R20
_0x200006F:
	SBRC R16,0
	RJMP _0x2000087
_0x2000088:
	CP   R17,R21
	BRSH _0x200008B
	CP   R19,R21
	BRLO _0x200008C
_0x200008B:
	RJMP _0x200008A
_0x200008C:
	SBRS R16,7
	RJMP _0x200008D
	SBRS R16,2
	RJMP _0x200008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x200008F
_0x200008E:
	LDI  R18,LOW(48)
_0x200008F:
	RJMP _0x2000090
_0x200008D:
	LDI  R18,LOW(32)
_0x2000090:
	CALL SUBOPT_0x4E
	SUBI R21,LOW(1)
	RJMP _0x2000088
_0x200008A:
_0x2000087:
_0x2000091:
	CP   R17,R20
	BRSH _0x2000093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000094
	CALL SUBOPT_0x59
	BREQ _0x2000095
	SUBI R21,LOW(1)
_0x2000095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x51
	CPI  R21,0
	BREQ _0x2000096
	SUBI R21,LOW(1)
_0x2000096:
	SUBI R20,LOW(1)
	RJMP _0x2000091
_0x2000093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2000097
_0x2000098:
	CPI  R19,0
	BREQ _0x200009A
	SBRS R16,3
	RJMP _0x200009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x200009C
_0x200009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x200009C:
	CALL SUBOPT_0x4E
	CPI  R21,0
	BREQ _0x200009D
	SUBI R21,LOW(1)
_0x200009D:
	SUBI R19,LOW(1)
	RJMP _0x2000098
_0x200009A:
	RJMP _0x200009E
_0x2000097:
_0x20000A0:
	CALL SUBOPT_0x5A
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A2
	SBRS R16,3
	RJMP _0x20000A3
	SUBI R18,-LOW(55)
	RJMP _0x20000A4
_0x20000A3:
	SUBI R18,-LOW(87)
_0x20000A4:
	RJMP _0x20000A5
_0x20000A2:
	SUBI R18,-LOW(48)
_0x20000A5:
	SBRC R16,4
	RJMP _0x20000A7
	CPI  R18,49
	BRSH _0x20000A9
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000A8
_0x20000A9:
	RJMP _0x20000AB
_0x20000A8:
	CP   R20,R19
	BRSH _0x2000116
	CP   R21,R19
	BRLO _0x20000AE
	SBRS R16,0
	RJMP _0x20000AF
_0x20000AE:
	RJMP _0x20000AD
_0x20000AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000B0
_0x2000116:
	LDI  R18,LOW(48)
_0x20000AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000B1
	CALL SUBOPT_0x59
	BREQ _0x20000B2
	SUBI R21,LOW(1)
_0x20000B2:
_0x20000B1:
_0x20000B0:
_0x20000A7:
	CALL SUBOPT_0x4E
	CPI  R21,0
	BREQ _0x20000B3
	SUBI R21,LOW(1)
_0x20000B3:
_0x20000AD:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x5A
	CALL __MODD21U
	CALL SUBOPT_0x53
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x58
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20000A1
	RJMP _0x20000A0
_0x20000A1:
_0x200009E:
	SBRS R16,0
	RJMP _0x20000B4
_0x20000B5:
	CPI  R21,0
	BREQ _0x20000B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x51
	RJMP _0x20000B5
_0x20000B7:
_0x20000B4:
_0x20000B8:
_0x2000054:
_0x2000114:
	LDI  R17,LOW(0)
_0x2000035:
	RJMP _0x2000030
_0x2000032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	CALL SUBOPT_0x3E
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x202000D
	CALL SUBOPT_0x5B
	__POINTW2FN _0x2020000,0
	CALL _strcpyf
	RJMP _0x20A0006
_0x202000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x202000C
	CALL SUBOPT_0x5B
	__POINTW2FN _0x2020000,1
	CALL _strcpyf
	RJMP _0x20A0006
_0x202000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x202000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
	LDI  R30,LOW(45)
	ST   X,R30
_0x202000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2020010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2020010:
	LDD  R17,Y+8
_0x2020011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2020013
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x47
	CALL SUBOPT_0x5F
	RJMP _0x2020011
_0x2020013:
	CALL SUBOPT_0x60
	CALL __ADDF12
	CALL SUBOPT_0x5C
	LDI  R17,LOW(0)
	CALL SUBOPT_0x61
	CALL SUBOPT_0x5F
_0x2020014:
	CALL SUBOPT_0x60
	CALL __CMPF12
	BRLO _0x2020016
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x43
	CALL SUBOPT_0x5F
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2020017
	CALL SUBOPT_0x5B
	__POINTW2FN _0x2020000,5
	CALL _strcpyf
	RJMP _0x20A0006
_0x2020017:
	RJMP _0x2020014
_0x2020016:
	CPI  R17,0
	BRNE _0x2020018
	CALL SUBOPT_0x5D
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2020019
_0x2020018:
_0x202001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x202001C
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x47
	CALL SUBOPT_0x45
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x60
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x4A
	LDI  R31,0
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x62
	CALL __MULF12
	CALL SUBOPT_0x63
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x5C
	RJMP _0x202001A
_0x202001C:
_0x2020019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20A0005
	CALL SUBOPT_0x5D
	LDI  R30,LOW(46)
	ST   X,R30
_0x202001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2020020
	CALL SUBOPT_0x63
	CALL SUBOPT_0x43
	CALL SUBOPT_0x5C
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x4A
	LDI  R31,0
	CALL SUBOPT_0x63
	CALL SUBOPT_0x62
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x5C
	RJMP _0x202001E
_0x2020020:
_0x20A0005:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0006:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
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
	CALL SUBOPT_0x64
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x65
	RJMP _0x20A0001
__floor1:
    brtc __floor0
	CALL SUBOPT_0x66
	CALL __SUBF12
	RJMP _0x20A0001
; .FEND
_log:
; .FSTART _log
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x67
	CALL __CPD02
	BRLT _0x204000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20A0004
_0x204000C:
	CALL SUBOPT_0x68
	CALL __PUTPARD1
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0x69
	CALL SUBOPT_0x67
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x204000D
	CALL SUBOPT_0x6A
	CALL __ADDF12
	CALL SUBOPT_0x69
	__SUBWRN 16,17,1
_0x204000D:
	CALL SUBOPT_0x6B
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6B
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x69
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6C
	__GETD2N 0x3F654226
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x67
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6D
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
	CALL SUBOPT_0x62
	__GETD2N 0x3F317218
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x20A0004:
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
	CALL SUBOPT_0x6E
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x204000F
	CALL SUBOPT_0x29
	RJMP _0x20A0003
_0x204000F:
	CALL SUBOPT_0x55
	CALL __CPD10
	BRNE _0x2040010
	CALL SUBOPT_0x61
	RJMP _0x20A0003
_0x2040010:
	CALL SUBOPT_0x6E
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040011
	__GETD1N 0x7F7FFFFF
	RJMP _0x20A0003
_0x2040011:
	CALL SUBOPT_0x6E
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	CALL SUBOPT_0x53
	CALL SUBOPT_0x6E
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x62
	CALL SUBOPT_0x4C
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x69
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6C
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0x67
	CALL __MULF12
	CALL SUBOPT_0x69
	CALL SUBOPT_0x6D
	__GETD2N 0x41A68D28
	CALL __ADDF12
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x68
	CALL SUBOPT_0x5E
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x67
	CALL SUBOPT_0x6D
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL __PUTPARD1
	MOVW R26,R16
	CALL _ldexp
_0x20A0003:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
; .FEND
_pow:
; .FSTART _pow
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x6F
	CALL __CPD10
	BRNE _0x2040012
	CALL SUBOPT_0x29
	RJMP _0x20A0002
_0x2040012:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x2040013
	CALL SUBOPT_0x48
	CALL __CPD10
	BRNE _0x2040014
	CALL SUBOPT_0x61
	RJMP _0x20A0002
_0x2040014:
	__GETD2S 8
	RCALL _log
	CALL SUBOPT_0x4B
	MOVW R26,R30
	MOVW R24,R22
	RCALL _exp
	RJMP _0x20A0002
_0x2040013:
	CALL SUBOPT_0x48
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0x65
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x48
	CALL __CPD12
	BREQ _0x2040015
	CALL SUBOPT_0x29
	RJMP _0x20A0002
_0x2040015:
	CALL SUBOPT_0x6F
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	RCALL _log
	CALL SUBOPT_0x4B
	MOVW R26,R30
	MOVW R24,R22
	RCALL _exp
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x2040016
	CALL SUBOPT_0x6F
	RJMP _0x20A0002
_0x2040016:
	CALL SUBOPT_0x6F
	CALL __ANEGF1
_0x20A0002:
	ADIW R28,12
	RET
; .FEND
_xatan:
; .FSTART _xatan
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x48
	CALL SUBOPT_0x4B
	CALL __PUTD1S0
	CALL SUBOPT_0x65
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x70
	CALL SUBOPT_0x4B
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x65
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x71
	CALL SUBOPT_0x70
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
	CALL SUBOPT_0x64
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2040020
	CALL SUBOPT_0x71
	RCALL _xatan
	RJMP _0x20A0001
_0x2040020:
	CALL SUBOPT_0x71
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040021
	CALL SUBOPT_0x66
	CALL SUBOPT_0x72
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0x4C
	RJMP _0x20A0001
_0x2040021:
	CALL SUBOPT_0x66
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x66
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x72
	__GETD2N 0x3F490FDB
	CALL __ADDF12
	RJMP _0x20A0001
; .FEND
_atan:
; .FSTART _atan
	CALL __PUTPARD2
	LDD  R26,Y+3
	TST  R26
	BRMI _0x204002C
	CALL SUBOPT_0x71
	RCALL _yatan
	RJMP _0x20A0001
_0x204002C:
	CALL SUBOPT_0x65
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	RCALL _yatan
	CALL __ANEGF1
_0x20A0001:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

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
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x2:
	CALL __PUTPARD1
	LDI  R24,12
	CALL _printf
	ADIW R28,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDS  R30,_Gyro_Raw_Val
	LDS  R31,_Gyro_Raw_Val+1
	LDS  R22,_Gyro_Raw_Val+2
	LDS  R23,_Gyro_Raw_Val+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	__GETD1MN _Gyro_Raw_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	__GETD1MN _Gyro_Raw_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDS  R30,_AvrgGyro_Raw_Val
	LDS  R31,_AvrgGyro_Raw_Val+1
	LDS  R22,_AvrgGyro_Raw_Val+2
	LDS  R23,_AvrgGyro_Raw_Val+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	__GETD1MN _AvrgGyro_Raw_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	__GETD1MN _AvrgGyro_Raw_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDS  R30,_Accel_Raw_Val
	LDS  R31,_Accel_Raw_Val+1
	LDS  R22,_Accel_Raw_Val+2
	LDS  R23,_Accel_Raw_Val+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	__GETD1MN _Accel_Raw_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	__GETD1MN _Accel_Raw_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xC:
	LDS  R30,_AvrgAccel_Raw_Val
	LDS  R31,_AvrgAccel_Raw_Val+1
	LDS  R22,_AvrgAccel_Raw_Val+2
	LDS  R23,_AvrgAccel_Raw_Val+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xD:
	__GETD1MN _AvrgAccel_Raw_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xE:
	__GETD1MN _AvrgAccel_Raw_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 39 TIMES, CODE SIZE REDUCTION:73 WORDS
SUBOPT_0xF:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _read_i2c

;OPTIMIZER ADDED SUBROUTINE, CALLED 41 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0x10:
	CALL _write_i2c
	LDI  R30,LOW(208)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 37 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x11:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x12:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	ST   -Y,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(59)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(60)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x15:
	CALL __CWD1
	CALL __CDF1
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x16:
	LDS  R26,_Accel_Offset_Val
	LDS  R27,_Accel_Offset_Val+1
	LDS  R24,_Accel_Offset_Val+2
	LDS  R25,_Accel_Offset_Val+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x17:
	__GETD1N 0x42C80000
	CALL __DIVF21
	__GETD2S 1
	CALL __ADDF12
	__PUTD1S 1
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x18:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(0)
	__CLRD1S 1
	LDI  R17,LOW(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(61)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(62)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	__GETD2MN _Accel_Offset_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(63)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(64)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	__GETD2MN _Accel_Offset_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	CALL __SUBF12
	STS  _Accel_In_g,R30
	STS  _Accel_In_g+1,R31
	STS  _Accel_In_g+2,R22
	STS  _Accel_In_g+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x21:
	CALL __SUBF12
	__PUTD1MN _Accel_In_g,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:71 WORDS
SUBOPT_0x22:
	CALL __SUBF12
	__PUTD1MN _Accel_In_g,8
	LDS  R26,_Accel_In_g
	LDS  R27,_Accel_In_g+1
	LDS  R24,_Accel_In_g+2
	LDS  R25,_Accel_In_g+3
	__GETD1N 0x46800000
	CALL __DIVF21
	STS  _Accel_In_g,R30
	STS  _Accel_In_g+1,R31
	STS  _Accel_In_g+2,R22
	STS  _Accel_In_g+3,R23
	__GETD2MN _Accel_In_g,4
	__GETD1N 0x46800000
	CALL __DIVF21
	__PUTD1MN _Accel_In_g,4
	__GETD2MN _Accel_In_g,8
	__GETD1N 0x46800000
	CALL __DIVF21
	__PUTD1MN _Accel_In_g,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	LDS  R26,_AvrgAccel_Raw_Val
	LDS  R27,_AvrgAccel_Raw_Val+1
	LDS  R24,_AvrgAccel_Raw_Val+2
	LDS  R25,_AvrgAccel_Raw_Val+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x24:
	__GETD1N 0x42480000
	CALL __DIVF21
	__GETD2S 1
	CALL __ADDF12
	__PUTD1S 1
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(0)
	__CLRD1S 1
	LDI  R17,LOW(50)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x26:
	CALL __PUTPARD1
	__GETD2N 0x40000000
	JMP  _pow

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	JMP  _sqrt

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x28:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	CALL _atan
	__GETD2N 0x42652E14
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	__PUTD1MN _Gyro_Offset_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	__PUTD1MN _Gyro_Offset_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	STS  _Gyro_Offset_Val,R30
	STS  _Gyro_Offset_Val+1,R31
	STS  _Gyro_Offset_Val+2,R22
	STS  _Gyro_Offset_Val+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(67)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(68)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2F:
	LDS  R26,_Gyro_Offset_Val
	LDS  R27,_Gyro_Offset_Val+1
	LDS  R24,_Gyro_Offset_Val+2
	LDS  R25,_Gyro_Offset_Val+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x30:
	__GETD1N 0x42C80000
	CALL __DIVF21
	__GETD2S 1
	CALL __ADDF12
	__PUTD1S 1
	__DELAY_USB 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(69)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(70)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x33:
	__GETD2MN _Gyro_Offset_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(71)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(72)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x36:
	__GETD2MN _Gyro_Offset_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x37:
	CALL __SUBF12
	STS  _GyroRate_Val,R30
	STS  _GyroRate_Val+1,R31
	STS  _GyroRate_Val+2,R22
	STS  _GyroRate_Val+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	CALL __SUBF12
	__PUTD1MN _GyroRate_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:71 WORDS
SUBOPT_0x39:
	CALL __SUBF12
	__PUTD1MN _GyroRate_Val,8
	LDS  R26,_GyroRate_Val
	LDS  R27,_GyroRate_Val+1
	LDS  R24,_GyroRate_Val+2
	LDS  R25,_GyroRate_Val+3
	__GETD1N 0x41833333
	CALL __DIVF21
	STS  _GyroRate_Val,R30
	STS  _GyroRate_Val+1,R31
	STS  _GyroRate_Val+2,R22
	STS  _GyroRate_Val+3,R23
	__GETD2MN _GyroRate_Val,4
	__GETD1N 0x41833333
	CALL __DIVF21
	__PUTD1MN _GyroRate_Val,4
	__GETD2MN _GyroRate_Val,8
	__GETD1N 0x41833333
	CALL __DIVF21
	__PUTD1MN _GyroRate_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	__PUTD1MN _AvrgGyro_Raw_Val,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	__PUTD1MN _AvrgGyro_Raw_Val,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	STS  _AvrgGyro_Raw_Val,R30
	STS  _AvrgGyro_Raw_Val+1,R31
	STS  _AvrgGyro_Raw_Val+2,R22
	STS  _AvrgGyro_Raw_Val+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x3D:
	__GETD1N 0x42480000
	CALL __DIVF21
	__GETD2S 1
	CALL __ADDF12
	__PUTD1S 1
	__DELAY_USB 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3E:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x3F:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x40:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x41:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x42:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x43:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x45:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x46:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x47:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x48:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4B:
	RCALL SUBOPT_0x46
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4C:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4D:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4E:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x4F:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x50:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x51:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x52:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x53:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x54:
	RCALL SUBOPT_0x4F
	RJMP SUBOPT_0x50

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x55:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x56:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x57:
	RCALL SUBOPT_0x52
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x58:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x59:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5A:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5B:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5C:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5D:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5E:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5F:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x60:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x62:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x64:
	CALL __PUTPARD2
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x65:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x66:
	RCALL SUBOPT_0x65
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x67:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x68:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x69:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6A:
	RCALL SUBOPT_0x68
	RJMP SUBOPT_0x67

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6B:
	RCALL SUBOPT_0x68
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6C:
	CALL __MULF12
	RCALL SUBOPT_0x5F
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6D:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6E:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6F:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x70:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x71:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x72:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	JMP  _xatan


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
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

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
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

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
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
