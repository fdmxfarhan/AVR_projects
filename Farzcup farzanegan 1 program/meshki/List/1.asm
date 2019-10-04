
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega64
;Program type           : Application
;Clock frequency        : 11.059200 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;global const stored in FLASH  : No
;8 bit enums            : Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega64
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

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
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
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
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
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

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
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

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
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

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
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
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
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
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
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
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
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
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
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
	.DEF _rx_wr_index1=R7
	.DEF _rx_rd_index1=R6
	.DEF _rx_counter1=R9
	.DEF _t=R10
	.DEF _SL=R12
	.DEF __lcd_x=R8

	.CSEG
	.ORG 0x00

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
	JMP  0x00
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0xEE:
	.DB  0x0,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x0A
	.DW  _0xEE*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

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
	LDI  R24,LOW(0x1000)
	LDI  R25,HIGH(0x1000)
	LDI  R26,LOW(0x100)
	LDI  R27,HIGH(0x100)
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

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x10FF)
	OUT  SPL,R30
	LDI  R30,HIGH(0x10FF)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x500)
	LDI  R29,HIGH(0x500)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.03.4 Standard
;Automatic Program Generator
;© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 10/31/2015
;Author  :
;Company :
;Comments:
;
;
;Chip type           : ATmega64
;Program type        : Application
;Clock frequency     : 11.059200 MHz
;Memory model        : Small
;External RAM size   : 0
;Data Stack size     : 1024
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
;#include <delay.h>
;#include <stdio.h>
;
;// I2C Bus functions
;#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=1
   .equ __scl_bit=0
; 0000 0022 #endasm
;#include <i2c.h>
;eeprom int c;
;//////////////////////////////////////////cmp
; #define EEPROM_BUS_ADDRESS 0xc0
;int cmp;
;/* read a byte from the EEPROM */
;unsigned char compass_read(unsigned char address) {
; 0000 0029 unsigned char compass_read(unsigned char address) {

	.CSEG
_compass_read:
; 0000 002A unsigned char data;
; 0000 002B i2c_start();
	ST   -Y,R17
;	address -> Y+1
;	data -> R17
	CALL _i2c_start
; 0000 002C i2c_write(EEPROM_BUS_ADDRESS);
	LDI  R30,LOW(192)
	ST   -Y,R30
	CALL _i2c_write
; 0000 002D i2c_write(address);
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _i2c_write
; 0000 002E i2c_start();
	CALL _i2c_start
; 0000 002F i2c_write(EEPROM_BUS_ADDRESS | 1);
	LDI  R30,LOW(193)
	ST   -Y,R30
	CALL _i2c_write
; 0000 0030 data=i2c_read(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
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
;#define KAF 400
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x15 ;PORTC
; 0000 0039 #endasm
;#include <lcd.h>
;
;#define RXB8 1
;#define TXB8 0
;#define UPE 2
;#define OVR 3
;#define FE 4
;#define UDRE 5
;#define RXC 7
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<OVR)
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
;   int t=0;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0000 0059 {
_usart1_rx_isr:
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
; 0000 005A char status,data;
; 0000 005B status=UCSR1A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,155
; 0000 005C data=UDR1;
	LDS  R16,156
; 0000 005D if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x3
; 0000 005E    {
; 0000 005F    rx_buffer1[rx_wr_index1]=data;
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	ST   Z,R16
; 0000 0060    if (++rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x4
	CLR  R7
; 0000 0061    if (++rx_counter1 == RX_BUFFER_SIZE1)
_0x4:
	INC  R9
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x5
; 0000 0062       {
; 0000 0063       rx_counter1=0;
	CLR  R9
; 0000 0064       rx_buffer_overflow1=1;
	SET
	BLD  R2,0
; 0000 0065       };
_0x5:
; 0000 0066    };
_0x3:
; 0000 0067   if (data=='1'){
	CPI  R16,49
	BRNE _0x6
; 0000 0068    lcd_gotoxy(12,1);
	CALL SUBOPT_0x0
; 0000 0069    lcd_putchar('1');
	LDI  R30,LOW(49)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 006A    t=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 006B    }
; 0000 006C    else    if (data=='2'){
	RJMP _0x7
_0x6:
	CPI  R16,50
	BRNE _0x8
; 0000 006D    lcd_gotoxy(12,1);
	CALL SUBOPT_0x0
; 0000 006E    lcd_putchar('2');
	LDI  R30,LOW(50)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 006F    t=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R10,R30
; 0000 0070    }
; 0000 0071      else    if (data=='3'){
	RJMP _0x9
_0x8:
	CPI  R16,51
	BRNE _0xA
; 0000 0072    lcd_gotoxy(12,1);
	CALL SUBOPT_0x0
; 0000 0073    lcd_putchar('3');
	LDI  R30,LOW(51)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0074    t=3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R10,R30
; 0000 0075    }
; 0000 0076    else    if (data=='4'){
	RJMP _0xB
_0xA:
	CPI  R16,52
	BRNE _0xC
; 0000 0077    lcd_gotoxy(12,1);
	CALL SUBOPT_0x0
; 0000 0078    lcd_putchar('4');
	LDI  R30,LOW(52)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0079    t=4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R10,R30
; 0000 007A    }
; 0000 007B    else if (data=='5'){
	RJMP _0xD
_0xC:
	CPI  R16,53
	BRNE _0xE
; 0000 007C       lcd_gotoxy(12,1);
	CALL SUBOPT_0x0
; 0000 007D    lcd_putchar('5');
	LDI  R30,LOW(53)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 007E    t=5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R10,R30
; 0000 007F    }
; 0000 0080       else if (data=='6'){
	RJMP _0xF
_0xE:
	CPI  R16,54
	BRNE _0x10
; 0000 0081       lcd_gotoxy(12,1);
	CALL SUBOPT_0x0
; 0000 0082    lcd_putchar('6');
	LDI  R30,LOW(54)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0083    t=6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R10,R30
; 0000 0084    }
; 0000 0085       else if (data=='7'){
	RJMP _0x11
_0x10:
	CPI  R16,55
	BRNE _0x12
; 0000 0086       lcd_gotoxy(12,1);
	CALL SUBOPT_0x0
; 0000 0087    lcd_putchar('7');
	LDI  R30,LOW(55)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0088    t=7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R10,R30
; 0000 0089    }
; 0000 008A       else if (data=='8'){
	RJMP _0x13
_0x12:
	CPI  R16,56
	BRNE _0x14
; 0000 008B       lcd_gotoxy(12,1);
	CALL SUBOPT_0x0
; 0000 008C    lcd_putchar('8');
	LDI  R30,LOW(56)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 008D    t=8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	MOVW R10,R30
; 0000 008E    }
; 0000 008F       else if (data=='9'){
	RJMP _0x15
_0x14:
	CPI  R16,57
	BRNE _0x16
; 0000 0090       lcd_gotoxy(12,1);
	CALL SUBOPT_0x0
; 0000 0091    lcd_putchar('9');
	LDI  R30,LOW(57)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0092    t=9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R10,R30
; 0000 0093    }
; 0000 0094       else if (data=='o'){
	RJMP _0x17
_0x16:
	CPI  R16,111
	BRNE _0x18
; 0000 0095       lcd_gotoxy(12,1);
	CALL SUBOPT_0x0
; 0000 0096    lcd_putchar('o');
	LDI  R30,LOW(111)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0097    t=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MOVW R10,R30
; 0000 0098    }
; 0000 0099     else {
	RJMP _0x19
_0x18:
; 0000 009A    lcd_gotoxy(12,1);
	CALL SUBOPT_0x0
; 0000 009B    lcd_putchar('n');
	LDI  R30,LOW(110)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 009C    t=0;}
	CLR  R10
	CLR  R11
_0x19:
_0x17:
_0x15:
_0x13:
_0x11:
_0xF:
_0xD:
_0xB:
_0x9:
_0x7:
; 0000 009D  }
	LD   R16,Y+
	LD   R17,Y+
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
;
;// Get a character from the USART1 Receiver buffer
;#pragma used+
;char getchar1(void)
; 0000 00A2 {
; 0000 00A3 char data;
; 0000 00A4 while (rx_counter1==0);
;	data -> R17
; 0000 00A5 data=rx_buffer1[rx_rd_index1];
; 0000 00A6 if (++rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
; 0000 00A7 #asm("cli")
; 0000 00A8 --rx_counter1;
; 0000 00A9 #asm("sei")
; 0000 00AA return data;
; 0000 00AB }
;#pragma used-
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(char c)
; 0000 00B0 {
_putchar1:
; 0000 00B1 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
_0x1E:
	LDS  R30,155
	LDI  R31,0
	ANDI R30,LOW(0x20)
	BREQ _0x1E
; 0000 00B2 UDR1=c;
	LD   R30,Y
	STS  156,R30
; 0000 00B3 }
	RJMP _0x2080002
;#pragma used-
;
;#include <delay.h>
;
;#define ADC_VREF_TYPE 0x40
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 00BC {
_read_adc:
; 0000 00BD ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	CALL SUBOPT_0x1
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 00BE // Delay needed for the stabilization of the ADC input voltage
; 0000 00BF delay_us(10);
	__DELAY_USB 37
; 0000 00C0 // Start the AD conversion
; 0000 00C1 ADCSRA|=0x40;
	CALL SUBOPT_0x2
	ORI  R30,0x40
	OUT  0x6,R30
; 0000 00C2 // Wait for the AD conversion to complete
; 0000 00C3 while ((ADCSRA & 0x10)==0);
_0x21:
	CALL SUBOPT_0x2
	ANDI R30,LOW(0x10)
	BREQ _0x21
; 0000 00C4 ADCSRA|=0x10;
	CALL SUBOPT_0x2
	ORI  R30,0x10
	OUT  0x6,R30
; 0000 00C5 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
_0x2080002:
	ADIW R28,1
	RET
; 0000 00C6 }
;
;// Declare your global variables here
;void motor(int ML1,int ML2,int MR2,int MR1){
; 0000 00C9 void motor(int ML1,int ML2,int MR2,int MR1){
_motor:
; 0000 00CA #asm("cli") ;
;	ML1 -> Y+6
;	ML2 -> Y+4
;	MR2 -> Y+2
;	MR1 -> Y+0
	cli
; 0000 00CB #asm("wdr");
	wdr
; 0000 00CC 
; 0000 00CD if(ML1<-255) ML1=-255;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x24
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00CE if(ML2<-255) ML2=-255;
_0x24:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x25
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00CF if(MR1<-255) MR1=-255;
_0x25:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x26
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00D0 if(MR2<-255) MR2=-255;
_0x26:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x27
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00D1 
; 0000 00D2 if(ML1>255) ML1=255;
_0x27:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x28
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00D3 if(ML2>255) ML2=255;
_0x28:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x29
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00D4 if(MR1>255) MR1=255;
_0x29:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x2A
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00D5 if(MR2>255) MR2=255;
_0x2A:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x2B
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00D6 /////////////////////////////////
; 0000 00D7 if(ML1>=0){
_0x2B:
	LDD  R26,Y+7
	TST  R26
	BRMI _0x2C
; 0000 00D8 PORTD.7=0;
	CBI  0x12,7
; 0000 00D9 OCR2=ML1;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	OUT  0x23,R30
; 0000 00DA #asm("wdr");
	wdr
; 0000 00DB }
; 0000 00DC else if(ML1<0){
	RJMP _0x2F
_0x2C:
	LDD  R26,Y+7
	TST  R26
	BRPL _0x30
; 0000 00DD PORTD.7=1;
	SBI  0x12,7
; 0000 00DE OCR2=ML1;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	OUT  0x23,R30
; 0000 00DF #asm("wdr");
	wdr
; 0000 00E0 }
; 0000 00E1 
; 0000 00E2 
; 0000 00E3 
; 0000 00E4      /////////////////////////
; 0000 00E5 if(ML2>=0){
_0x30:
_0x2F:
	LDD  R26,Y+5
	TST  R26
	BRMI _0x33
; 0000 00E6 PORTD.6=0;
	CBI  0x12,6
; 0000 00E7 OCR1B=ML2;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00E8 #asm("wdr");
	wdr
; 0000 00E9 }
; 0000 00EA else if(ML2<0){
	RJMP _0x36
_0x33:
	LDD  R26,Y+5
	TST  R26
	BRPL _0x37
; 0000 00EB PORTD.6=1;
	SBI  0x12,6
; 0000 00EC OCR1B=ML2;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00ED #asm("wdr");
	wdr
; 0000 00EE }
; 0000 00EF 
; 0000 00F0    /////////////////////////
; 0000 00F1 if(MR1>=0){
_0x37:
_0x36:
	LDD  R26,Y+1
	TST  R26
	BRMI _0x3A
; 0000 00F2 PORTD.4=0;
	CBI  0x12,4
; 0000 00F3 OCR0=MR1;
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x31,R30
; 0000 00F4 #asm("wdr");
	wdr
; 0000 00F5 }
; 0000 00F6 else if(MR1<0){
	RJMP _0x3D
_0x3A:
	LDD  R26,Y+1
	TST  R26
	BRPL _0x3E
; 0000 00F7 PORTD.4=1;
	SBI  0x12,4
; 0000 00F8 OCR0=MR1;
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x31,R30
; 0000 00F9 #asm("wdr")
	wdr
; 0000 00FA }
; 0000 00FB 
; 0000 00FC  ////////////////////////
; 0000 00FD  if(MR2>=0){
_0x3E:
_0x3D:
	LDD  R26,Y+3
	TST  R26
	BRMI _0x41
; 0000 00FE PORTD.5=0;
	CBI  0x12,5
; 0000 00FF OCR1A=MR2;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0100 #asm("wdr");
	wdr
; 0000 0101 }
; 0000 0102 else if(MR2<0){
	RJMP _0x44
_0x41:
	LDD  R26,Y+3
	TST  R26
	BRPL _0x45
; 0000 0103 PORTD.5=1;
	SBI  0x12,5
; 0000 0104 OCR1A=MR2;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0105 #asm("wdr");
	wdr
; 0000 0106 }
; 0000 0107 #asm("sei") ;
_0x45:
_0x44:
	sei
; 0000 0108 }
	ADIW R28,8
	RET
;
;
;
;
;int SL,SR,SB,RL=0,sum=0;
;      void sharp(){
; 0000 010E void sharp(){
_sharp:
; 0000 010F       #asm("cli") ;
	cli
; 0000 0110       #asm("wdr") ;
	wdr
; 0000 0111       SB=read_adc(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _read_adc
	STS  _SB,R30
	STS  _SB+1,R31
; 0000 0112       SR=read_adc(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	STS  _SR,R30
	STS  _SR+1,R31
; 0000 0113       SL=read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R12,R30
; 0000 0114 
; 0000 0115        lcd_gotoxy(13,1);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x3
; 0000 0116       lcd_putchar((SR/100)%10+'0');
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
; 0000 0117       lcd_putchar((SR/10)%10+'0');
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
; 0000 0118       lcd_putchar((SR/1)%10+'0');
	CALL SUBOPT_0x4
	CALL SUBOPT_0x7
; 0000 0119 //        lcd_gotoxy(8,0);
; 0000 011A //      lcd_putchar((SB/100)%10+'0');
; 0000 011B //      lcd_putchar((SB/10)%10+'0');
; 0000 011C //      lcd_putchar((SB/1)%10+'0');
; 0000 011D 
; 0000 011E        lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x3
; 0000 011F       lcd_putchar((SL/100)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0x5
; 0000 0120       lcd_putchar((SL/10)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0x6
; 0000 0121       lcd_putchar((SL/1)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0x7
; 0000 0122 
; 0000 0123         sum= SR+SL;
	MOVW R30,R12
	CALL SUBOPT_0x4
	ADD  R30,R26
	ADC  R31,R27
	STS  _sum,R30
	STS  _sum+1,R31
; 0000 0124        RL=SR-SL;
	LDS  R30,_SR
	LDS  R31,_SR+1
	SUB  R30,R12
	SBC  R31,R13
	STS  _RL,R30
	STS  _RL+1,R31
; 0000 0125 
; 0000 0126 
; 0000 0127 
; 0000 0128        //       if(RL>0)
; 0000 0129 //       {
; 0000 012A //       lcd_gotoxy(0,1);
; 0000 012B //       lcd_putchar('+');
; 0000 012C //       lcd_putchar((RL/100)%10+'0');
; 0000 012D //       lcd_putchar((RL/10)%10+'0');
; 0000 012E //       lcd_putchar((RL/1)%10+'0');
; 0000 012F //                }
; 0000 0130 //               else  if(RL<0)
; 0000 0131 //               {
; 0000 0132 //       lcd_gotoxy(0,1);
; 0000 0133 //       lcd_putchar('-');
; 0000 0134 //       lcd_putchar((-RL/100)%10+'0');
; 0000 0135 //       lcd_putchar((-RL/10)%10+'0');
; 0000 0136 //       lcd_putchar((-RL/1)%10+'0');
; 0000 0137 //                }
; 0000 0138 
; 0000 0139        if(RL>-60 && RL<80) RL=0;
	CALL SUBOPT_0x8
	LDI  R30,LOW(65476)
	LDI  R31,HIGH(65476)
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x49
	CALL SUBOPT_0x8
	CPI  R26,LOW(0x50)
	LDI  R30,HIGH(0x50)
	CPC  R27,R30
	BRLT _0x4A
_0x49:
	RJMP _0x48
_0x4A:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0xE6
; 0000 013A 
; 0000 013B           else if(RL>80) RL=RL*1.25;
_0x48:
	CALL SUBOPT_0x8
	CPI  R26,LOW(0x51)
	LDI  R30,HIGH(0x51)
	CPC  R27,R30
	BRLT _0x4C
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	__GETD2N 0x3FA00000
	CALL SUBOPT_0xB
; 0000 013C           else if(RL<-60) RL=RL;
	RJMP _0x4D
_0x4C:
	CALL SUBOPT_0x8
	CPI  R26,LOW(0xFFC4)
	LDI  R30,HIGH(0xFFC4)
	CPC  R27,R30
	BRGE _0x4E
	CALL SUBOPT_0x9
_0xE6:
	STS  _RL,R30
	STS  _RL+1,R31
; 0000 013D 
; 0000 013E 
; 0000 013F 
; 0000 0140       #asm("sei")  ;
_0x4E:
_0x4D:
	sei
; 0000 0141      }
	RET
;
;
;   int adc[16],min=0,i,kaf[16],mini=0,r=0,l=0,f=0,b=0,h=0,p=0,m=0;
;      void sensor() {
; 0000 0145 void sensor() {
_sensor:
; 0000 0146        #asm("cli") ;
	cli
; 0000 0147        #asm("wdr");
	wdr
; 0000 0148     for(i=0;i<16;i++)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _i,R30
	STS  _i+1,R31
_0x50:
	CALL SUBOPT_0xC
	SBIW R26,16
	BRLT PC+3
	JMP _0x51
; 0000 0149      {
; 0000 014A      #asm("wdr");
	wdr
; 0000 014B  PORTA.3=(i/8)%2;
	CALL SUBOPT_0xC
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0xD
	BRNE _0x52
	CBI  0x1B,3
	RJMP _0x53
_0x52:
	SBI  0x1B,3
_0x53:
; 0000 014C  PORTA.2=(i/4)%2;
	CALL SUBOPT_0xC
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xD
	BRNE _0x54
	CBI  0x1B,2
	RJMP _0x55
_0x54:
	SBI  0x1B,2
_0x55:
; 0000 014D  PORTA.1=(i/2)%2;
	CALL SUBOPT_0xC
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xD
	BRNE _0x56
	CBI  0x1B,1
	RJMP _0x57
_0x56:
	SBI  0x1B,1
_0x57:
; 0000 014E  PORTA.0=(i/1)%2;
	CALL SUBOPT_0xC
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	CPI  R30,0
	BRNE _0x58
	CBI  0x1B,0
	RJMP _0x59
_0x58:
	SBI  0x1B,0
_0x59:
; 0000 014F   adc[i]=read_adc(7);
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 0150   kaf[i]=read_adc(6);
	CALL SUBOPT_0x10
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _read_adc
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 0151 ////////////////////////////////////////////////////////////moghayese
; 0000 0152   if (adc[i]<adc[min])
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	BRGE _0x5A
; 0000 0153   {
; 0000 0154     min=i;
	CALL SUBOPT_0xE
	STS  _min,R30
	STS  _min+1,R31
; 0000 0155      }
; 0000 0156 
; 0000 0157    if (kaf[i]<kaf[mini])
_0x5A:
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL SUBOPT_0x13
	BRGE _0x5B
; 0000 0158    {
; 0000 0159 
; 0000 015A    mini=i;  }
	CALL SUBOPT_0xE
	STS  _mini,R30
	STS  _mini+1,R31
; 0000 015B 
; 0000 015C }
_0x5B:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x50
_0x51:
; 0000 015D 
; 0000 015E 
; 0000 015F 
; 0000 0160 
; 0000 0161 if (adc[min]<900 && min!=0) {
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
	CPI  R30,LOW(0x384)
	LDI  R26,HIGH(0x384)
	CPC  R31,R26
	BRGE _0x5D
	CALL SUBOPT_0x16
	SBIW R26,0
	BRNE _0x5E
_0x5D:
	RJMP _0x5C
_0x5E:
; 0000 0162 h=(adc[min]+adc[min+1]+adc[min-1])/3;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x11
	CALL SUBOPT_0x16
	LSL  R26
	ROL  R27
	__ADDW2MN _adc,2
	CALL __GETW1P
	__ADDWRR 0,1,30,31
	CALL SUBOPT_0x17
	SBIW R30,1
	CALL SUBOPT_0xF
	CALL SUBOPT_0x15
	MOVW R26,R0
	CALL SUBOPT_0x18
; 0000 0163 if (h<100) m=9;
	BRGE _0x5F
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0xE7
; 0000 0164 else  m=(h/100)%10 ;
_0x5F:
	CALL SUBOPT_0x19
_0xE7:
	STS  _m,R30
	STS  _m+1,R31
; 0000 0165 }
; 0000 0166 else if (adc[min]>900 )
	RJMP _0x61
_0x5C:
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
	CPI  R30,LOW(0x385)
	LDI  R26,HIGH(0x385)
	CPC  R31,R26
	BRLT _0x62
; 0000 0167 {
; 0000 0168 h=1023;
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	STS  _h,R30
	STS  _h+1,R31
; 0000 0169 m=11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	RJMP _0xE8
; 0000 016A }
; 0000 016B else if (min==0 ){
_0x62:
	CALL SUBOPT_0x17
	SBIW R30,0
	BRNE _0x64
; 0000 016C h=(adc[0]+adc[1]+adc[15])/3;
	__GETW1MN _adc,2
	LDS  R26,_adc
	LDS  R27,_adc+1
	ADD  R26,R30
	ADC  R27,R31
	__GETW1MN _adc,30
	CALL SUBOPT_0x18
; 0000 016D if (h<100) m=9;
	BRGE _0x65
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0xE8
; 0000 016E else  m=(h/100)%10 ;
_0x65:
	CALL SUBOPT_0x19
_0xE8:
	STS  _m,R30
	STS  _m+1,R31
; 0000 016F }
; 0000 0170  ///////////////////////////////////////////////////////////chap
; 0000 0171   lcd_gotoxy(0,0);
_0x64:
_0x61:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
; 0000 0172   lcd_putchar((min/10)%10+'0');
	CALL SUBOPT_0x16
	CALL SUBOPT_0x6
; 0000 0173   lcd_putchar((min/1)%10+'0');
	CALL SUBOPT_0x16
	CALL SUBOPT_0x7
; 0000 0174   lcd_putchar('=');
	LDI  R30,LOW(61)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0175   lcd_putchar((h/1000)%10+'0');
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
; 0000 0176   lcd_putchar((h/100)%10+'0');
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x5
; 0000 0177   lcd_putchar((h/10)%10+'0');
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x6
; 0000 0178   lcd_putchar((h/1)%10+'0');
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x7
; 0000 0179   lcd_gotoxy(11,1);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x3
; 0000 017A   lcd_putchar(m +'0');
	LDS  R30,_m
	LDS  R31,_m+1
	ADIW R30,48
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 017B   lcd_putchar((t/1)%10 +'0');
	MOVW R26,R10
	CALL SUBOPT_0x7
; 0000 017C 
; 0000 017D  lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x1A
; 0000 017E  lcd_putchar((l/1)%10 +'0');
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x7
; 0000 017F  lcd_putchar((r/1)%10 +'0');
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x7
; 0000 0180  lcd_putchar((f/1)%10 +'0');
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x7
; 0000 0181 
; 0000 0182 
; 0000 0183  lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
; 0000 0184   lcd_putchar((mini/10)%10+'0');
	LDS  R26,_mini
	LDS  R27,_mini+1
	CALL SUBOPT_0x6
; 0000 0185   lcd_putchar((mini/1)%10+'0');
	LDS  R26,_mini
	LDS  R27,_mini+1
	CALL SUBOPT_0x7
; 0000 0186   lcd_putchar('=');
	LDI  R30,LOW(61)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0187   lcd_putchar((kaf[mini]/1000)%10+'0');
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	MOVW R26,R30
	CALL SUBOPT_0x1C
; 0000 0188   lcd_putchar((kaf[mini]/100)%10+'0');
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	MOVW R26,R30
	CALL SUBOPT_0x5
; 0000 0189   lcd_putchar((kaf[mini]/10)%10+'0');
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	MOVW R26,R30
	CALL SUBOPT_0x6
; 0000 018A   lcd_putchar((kaf[mini]/1)%10+'0');
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	MOVW R26,R30
	CALL SUBOPT_0x7
; 0000 018B 
; 0000 018C       if ( (kaf[13]<KAF || kaf[12]<KAF || kaf[15]<KAF || kaf[14]<KAF)  && b==0  && l == 0 && r == 0  && f == 0)  l=1;
	__GETW2MN _kaf,26
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x68
	__GETW2MN _kaf,24
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x68
	__GETW2MN _kaf,30
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x68
	__GETW2MN _kaf,28
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRGE _0x6A
_0x68:
	CALL SUBOPT_0x20
	BRNE _0x6A
	CALL SUBOPT_0x1D
	SBIW R26,0
	BRNE _0x6A
	CALL SUBOPT_0x1E
	SBIW R26,0
	BRNE _0x6A
	CALL SUBOPT_0x1F
	SBIW R26,0
	BREQ _0x6B
_0x6A:
	RJMP _0x67
_0x6B:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _l,R30
	STS  _l+1,R31
; 0000 018D       else  if ((kaf[0]<KAF || kaf[1]<KAF || kaf[2]<KAF || kaf[3]<KAF) && b==0  && l == 0 && r == 0 && f == 0) r=1;
	RJMP _0x6C
_0x67:
	LDS  R26,_kaf
	LDS  R27,_kaf+1
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x6E
	__GETW2MN _kaf,2
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x6E
	__GETW2MN _kaf,4
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x6E
	__GETW2MN _kaf,6
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRGE _0x70
_0x6E:
	CALL SUBOPT_0x20
	BRNE _0x70
	CALL SUBOPT_0x1D
	SBIW R26,0
	BRNE _0x70
	CALL SUBOPT_0x1E
	SBIW R26,0
	BRNE _0x70
	CALL SUBOPT_0x1F
	SBIW R26,0
	BREQ _0x71
_0x70:
	RJMP _0x6D
_0x71:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _r,R30
	STS  _r+1,R31
; 0000 018E       else if((kaf[10]<KAF || kaf[9]<KAF || kaf[8]<KAF) && f==0 && b==0 && r==0 && l==0) f=1;
	RJMP _0x72
_0x6D:
	__GETW2MN _kaf,20
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x74
	__GETW2MN _kaf,18
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x74
	__GETW2MN _kaf,16
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRGE _0x76
_0x74:
	CALL SUBOPT_0x1F
	SBIW R26,0
	BRNE _0x76
	CALL SUBOPT_0x20
	BRNE _0x76
	CALL SUBOPT_0x1E
	SBIW R26,0
	BRNE _0x76
	CALL SUBOPT_0x1D
	SBIW R26,0
	BREQ _0x77
_0x76:
	RJMP _0x73
_0x77:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _f,R30
	STS  _f+1,R31
; 0000 018F       else if ((kaf[4]<KAF || kaf[5]<KAF || kaf[6]<KAF ) && f==0 && b==0 && r==0 && l==0) b=1;
	RJMP _0x78
_0x73:
	__GETW2MN _kaf,8
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x7A
	__GETW2MN _kaf,10
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x7A
	__GETW2MN _kaf,12
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRGE _0x7C
_0x7A:
	CALL SUBOPT_0x1F
	SBIW R26,0
	BRNE _0x7C
	CALL SUBOPT_0x20
	BRNE _0x7C
	CALL SUBOPT_0x1E
	SBIW R26,0
	BRNE _0x7C
	CALL SUBOPT_0x1D
	SBIW R26,0
	BREQ _0x7D
_0x7C:
	RJMP _0x79
_0x7D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _b,R30
	STS  _b+1,R31
; 0000 0190    }
_0x79:
_0x78:
_0x72:
_0x6C:
	RET
;
;
;
;      void follow ()
; 0000 0195     {
_follow:
; 0000 0196           #asm("wdr");
	wdr
; 0000 0197         if(min==0 )
	CALL SUBOPT_0x17
	SBIW R30,0
	BRNE _0x7E
; 0000 0198         {
; 0000 0199             motor(255+cmp,255+cmp,-255+cmp,-255+cmp);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
	RJMP _0xE9
; 0000 019A           }
; 0000 019B 
; 0000 019C          else if(min==1)
_0x7E:
	CALL SUBOPT_0x16
	SBIW R26,1
	BRNE _0x80
; 0000 019D          {
; 0000 019E              motor(255+cmp,0+cmp,-255+cmp,0+cmp);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
	RJMP _0xEA
; 0000 019F           }
; 0000 01A0            //motor(255,128,-255,-128);
; 0000 01A1          else if(min==2)     motor(255+cmp,-255+cmp,-255+cmp,255+cmp);     //motor(255,0,-255,0);
_0x80:
	CALL SUBOPT_0x16
	SBIW R26,2
	BRNE _0x82
	CALL SUBOPT_0x21
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x22
	CALL SUBOPT_0x25
	RJMP _0xEA
; 0000 01A2          else if(min==3)     motor(128+cmp,-255+cmp,-128+cmp,255+cmp);    //motor(255,-128,-255,128);
_0x82:
	CALL SUBOPT_0x16
	SBIW R26,3
	BRNE _0x84
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	CALL SUBOPT_0x22
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	CALL SUBOPT_0x25
	RJMP _0xEA
; 0000 01A3          else if(min==4)     motor(0+cmp,-255+cmp,0+cmp,255+cmp);        //motor(255,-255,-255,255);
_0x84:
	CALL SUBOPT_0x16
	SBIW R26,4
	BRNE _0x86
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	RJMP _0xEA
; 0000 01A4          else if(min==5)     motor(-128+cmp,-255+cmp,128+cmp,255+cmp);   //motor(128,-255,-128,255);
_0x86:
	CALL SUBOPT_0x16
	SBIW R26,5
	BRNE _0x88
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	CALL SUBOPT_0x22
	CALL SUBOPT_0x26
	CALL SUBOPT_0x25
	RJMP _0xEA
; 0000 01A5          else if(min==6)     motor(-255+cmp,-255+cmp,255+cmp,255+cmp);    //motor(0,-255,0,255);
_0x88:
	CALL SUBOPT_0x16
	SBIW R26,6
	BRNE _0x8A
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	RJMP _0xEA
; 0000 01A6          else if(min==7)     motor(-255+cmp,-128+cmp,255+cmp,128+cmp);    //motor(-128,-255,128,255);
_0x8A:
	CALL SUBOPT_0x16
	SBIW R26,7
	BRNE _0x8C
	CALL SUBOPT_0x27
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	CALL SUBOPT_0x28
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	RJMP _0xEA
; 0000 01A7          else if(min==8)     motor(-255+cmp,0+cmp,255+cmp,0+cmp);    //motor(-255,-255,255,255);
_0x8C:
	CALL SUBOPT_0x16
	SBIW R26,8
	BRNE _0x8E
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x24
	CALL SUBOPT_0x28
	MOVW R30,R4
	ADIW R30,0
	RJMP _0xEA
; 0000 01A8          else if(min==9)     motor(0+cmp,-255+cmp,0+cmp,255+cmp);         //motor(-255,-128,255,128);
_0x8E:
	CALL SUBOPT_0x16
	SBIW R26,9
	BRNE _0x90
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	RJMP _0xEA
; 0000 01A9          else if(min==10)    motor(-128+cmp,-255+cmp,255+cmp,128+cmp);   //motor(-255,128,255,-128);
_0x90:
	CALL SUBOPT_0x16
	SBIW R26,10
	BRNE _0x92
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	CALL SUBOPT_0x22
	CALL SUBOPT_0x28
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	RJMP _0xEA
; 0000 01AA          else if(min==11)  motor(-255+cmp,-255+cmp,255+cmp,255+cmp);
_0x92:
	CALL SUBOPT_0x16
	SBIW R26,11
	BRNE _0x94
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	RJMP _0xEA
; 0000 01AB          else if(min==12)    motor(-255+cmp,0+cmp,255+cmp,0+cmp);    //motor(-255,255,255,-255);
_0x94:
	CALL SUBOPT_0x16
	SBIW R26,12
	BRNE _0x96
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x24
	CALL SUBOPT_0x28
	MOVW R30,R4
	ADIW R30,0
	RJMP _0xEA
; 0000 01AC          else if(min==13)    motor(-255+cmp,128+cmp,255+cmp,-128+cmp);         //motor(-128,255,128,-255);
_0x96:
	CALL SUBOPT_0x16
	SBIW R26,13
	BRNE _0x98
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x26
	CALL SUBOPT_0x28
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	RJMP _0xEA
; 0000 01AD          else if(min==14)    motor(-255+cmp,128+cmp,255+cmp,-128+cmp);    //motor(0,255,0,-255);
_0x98:
	CALL SUBOPT_0x16
	SBIW R26,14
	BRNE _0x9A
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x26
	CALL SUBOPT_0x28
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	RJMP _0xEA
; 0000 01AE          else if(min==15)
_0x9A:
	CALL SUBOPT_0x16
	SBIW R26,15
	BRNE _0x9C
; 0000 01AF          {
; 0000 01B0          motor(-255+cmp,255+cmp,255+cmp,-255+cmp); //motor(128,255,-128,-255);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x21
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0xE9:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
_0xEA:
	ST   -Y,R31
	ST   -Y,R30
	CALL _motor
; 0000 01B1          }
; 0000 01B2     }
_0x9C:
	RET
;
;void sahmi()
; 0000 01B5 {
_sahmi:
; 0000 01B6     if(SB<150 )  motor(-255-RL+cmp,-255+RL+cmp,255+RL-cmp,255-RL+cmp);
	CALL SUBOPT_0x29
	CPI  R26,LOW(0x96)
	LDI  R30,HIGH(0x96)
	CPC  R27,R30
	BRGE _0x9D
	CALL SUBOPT_0x8
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x9
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x9
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	SUB  R30,R4
	SBC  R31,R5
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0x2A
	CALL _motor
; 0000 01B7     ///////////////////////////////////////////////////////////////
; 0000 01B8     else if(SB>300  && RL>-80 && RL<40)  motor(255/4+RL+cmp,255/4-RL+cmp,-255/4-RL+cmp,-255/4+RL+cmp);
	RJMP _0x9E
_0x9D:
	CALL SUBOPT_0x29
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	BRLT _0xA0
	CALL SUBOPT_0x8
	LDI  R30,LOW(65456)
	LDI  R31,HIGH(65456)
	CP   R30,R26
	CPC  R31,R27
	BRGE _0xA0
	CALL SUBOPT_0x8
	SBIW R26,40
	BRLT _0xA1
_0xA0:
	RJMP _0x9F
_0xA1:
	CALL SUBOPT_0x9
	ADIW R30,63
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x8
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x8
	LDI  R30,LOW(65473)
	LDI  R31,HIGH(65473)
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x9
	SUBI R30,LOW(-65473)
	SBCI R31,HIGH(-65473)
	CALL SUBOPT_0x2B
	CALL _motor
; 0000 01B9 
; 0000 01BA            //////////////////////////////////////////////////////////////
; 0000 01BB     else if(SB>300 && (RL<-60|| RL>40 )  )
	RJMP _0xA2
_0x9F:
	CALL SUBOPT_0x29
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	BRLT _0xA4
	CALL SUBOPT_0x8
	CPI  R26,LOW(0xFFC4)
	LDI  R30,HIGH(0xFFC4)
	CPC  R27,R30
	BRLT _0xA5
	CALL SUBOPT_0x8
	SBIW R26,41
	BRLT _0xA4
_0xA5:
	RJMP _0xA7
_0xA4:
	RJMP _0xA3
_0xA7:
; 0000 01BC     {
; 0000 01BD             RL=(float)RL*1.2;
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	__GETD2N 0x3F99999A
	CALL SUBOPT_0xB
; 0000 01BE             motor(-RL+cmp,RL+cmp,RL+cmp,-RL+cmp);
	CALL SUBOPT_0x9
	CALL __ANEGW1
	ADD  R30,R4
	ADC  R31,R5
	MOVW R0,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2C
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R1
	ST   -Y,R0
	CALL _motor
; 0000 01BF     }
; 0000 01C0     else{
	RJMP _0xA8
_0xA3:
; 0000 01C1      motor(0+cmp/2,0+cmp/2,0+cmp/2,0+cmp/2);
	MOVW R26,R4
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	ADIW R30,0
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	CALL _motor
; 0000 01C2      if ((m>t || t==9 ) && SB>200 )
	CALL SUBOPT_0x2D
	CP   R10,R26
	CPC  R11,R27
	BRLT _0xAA
	CALL SUBOPT_0x2E
	BRNE _0xAC
_0xAA:
	CALL SUBOPT_0x29
	CPI  R26,LOW(0xC9)
	LDI  R30,HIGH(0xC9)
	CPC  R27,R30
	BRGE _0xAD
_0xAC:
	RJMP _0xA9
_0xAD:
; 0000 01C3      {
; 0000 01C4      follow();
	RCALL _follow
; 0000 01C5      }
; 0000 01C6      }
_0xA9:
_0xA8:
_0xA2:
_0x9E:
; 0000 01C7 
; 0000 01C8     #asm ("wdr");
	wdr
; 0000 01C9 
; 0000 01CA     }
	RET
;
;
;
;
;
;
;void bt ()
; 0000 01D2  {
_bt:
; 0000 01D3       if(r!=1 && l!=1 && f!=1 && b!=1 && adc[min]<900 )
	CALL SUBOPT_0x1E
	SBIW R26,1
	BREQ _0xAF
	CALL SUBOPT_0x1D
	SBIW R26,1
	BREQ _0xAF
	CALL SUBOPT_0x1F
	SBIW R26,1
	BREQ _0xAF
	LDS  R26,_b
	LDS  R27,_b+1
	SBIW R26,1
	BREQ _0xAF
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
	CPI  R30,LOW(0x384)
	LDI  R26,HIGH(0x384)
	CPC  R31,R26
	BRLT _0xB0
_0xAF:
	RJMP _0xAE
_0xB0:
; 0000 01D4       {
; 0000 01D5             if (m==1) putchar1('1');
	CALL SUBOPT_0x2D
	SBIW R26,1
	BRNE _0xB1
	LDI  R30,LOW(49)
	RJMP _0xEB
; 0000 01D6        else if (m==2) putchar1('2');
_0xB1:
	CALL SUBOPT_0x2D
	SBIW R26,2
	BRNE _0xB3
	LDI  R30,LOW(50)
	RJMP _0xEB
; 0000 01D7        else if (m==3) putchar1('3');
_0xB3:
	CALL SUBOPT_0x2D
	SBIW R26,3
	BRNE _0xB5
	LDI  R30,LOW(51)
	RJMP _0xEB
; 0000 01D8        else if (m==4) putchar1('4');
_0xB5:
	CALL SUBOPT_0x2D
	SBIW R26,4
	BRNE _0xB7
	LDI  R30,LOW(52)
	RJMP _0xEB
; 0000 01D9        else if (m==5) putchar1('5');
_0xB7:
	CALL SUBOPT_0x2D
	SBIW R26,5
	BRNE _0xB9
	LDI  R30,LOW(53)
	RJMP _0xEB
; 0000 01DA        else if (m==6) putchar1('6');
_0xB9:
	CALL SUBOPT_0x2D
	SBIW R26,6
	BRNE _0xBB
	LDI  R30,LOW(54)
	RJMP _0xEB
; 0000 01DB        else if (m==7) putchar1('7');
_0xBB:
	CALL SUBOPT_0x2D
	SBIW R26,7
	BRNE _0xBD
	LDI  R30,LOW(55)
	RJMP _0xEB
; 0000 01DC        else if (m==8) putchar1('8');
_0xBD:
	CALL SUBOPT_0x2D
	SBIW R26,8
	BRNE _0xBF
	LDI  R30,LOW(56)
	RJMP _0xEB
; 0000 01DD        else if (m==9) putchar1('9');
_0xBF:
	CALL SUBOPT_0x2D
	SBIW R26,9
	BRNE _0xC1
	LDI  R30,LOW(57)
_0xEB:
	ST   -Y,R30
	CALL _putchar1
; 0000 01DE        }
_0xC1:
; 0000 01DF       else if (t!=10 )
	RJMP _0xC2
_0xAE:
	CALL SUBOPT_0x2F
	BREQ _0xC3
; 0000 01E0       {
; 0000 01E1          putchar1('o');
	LDI  R30,LOW(111)
	ST   -Y,R30
	CALL _putchar1
; 0000 01E2        #asm ("wdr") ;
	wdr
; 0000 01E3        }
; 0000 01E4        #asm ("wdr") ;
_0xC3:
_0xC2:
	wdr
; 0000 01E5  }
	RET
;
;
;
;void main(void)
; 0000 01EA {
_main:
; 0000 01EB #asm("wdr");
	wdr
; 0000 01EC // Declare your local variables here
; 0000 01ED 
; 0000 01EE // Input/Output Ports initialization
; 0000 01EF // Port A initialization
; 0000 01F0 // Func7=In Func6=Out Func5=Out Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 01F1 // State7=T State6=0 State5=0 State4=T State3=0 State2=0 State1=0 State0=0
; 0000 01F2 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 01F3 DDRA=0x6F;
	LDI  R30,LOW(111)
	OUT  0x1A,R30
; 0000 01F4 
; 0000 01F5 // Port B initialization
; 0000 01F6 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 01F7 // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 01F8 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 01F9 DDRB=0xF0;
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 01FA 
; 0000 01FB // Port C initialization
; 0000 01FC // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01FD // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01FE PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 01FF DDRC=0x00;
	OUT  0x14,R30
; 0000 0200 
; 0000 0201 // Port D initialization
; 0000 0202 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 0203 // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 0204 PORTD=0x00;
	OUT  0x12,R30
; 0000 0205 DDRD=0xF0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 0206 
; 0000 0207 // Port E initialization
; 0000 0208 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0209 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 020A PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 020B DDRE=0x00;
	OUT  0x2,R30
; 0000 020C 
; 0000 020D // Port F initialization
; 0000 020E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 020F // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0210 PORTF=0x00;
	STS  98,R30
; 0000 0211 DDRF=0x00;
	STS  97,R30
; 0000 0212 
; 0000 0213 // Port G initialization
; 0000 0214 // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0215 // State4=T State3=T State2=T State1=T State0=T
; 0000 0216 PORTG=0x00;
	STS  101,R30
; 0000 0217 DDRG=0x00;
	STS  100,R30
; 0000 0218 
; 0000 0219 // Timer/Counter 0 initialization
; 0000 021A // Clock source: System Clock
; 0000 021B // Clock value: 172.800 kHz
; 0000 021C // Mode: Fast PWM top=FFh
; 0000 021D // OC0 output: Non-Inverted PWM
; 0000 021E ASSR=0x00;
	OUT  0x30,R30
; 0000 021F TCCR0=0x6C;
	LDI  R30,LOW(108)
	OUT  0x33,R30
; 0000 0220 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0221 OCR0=0x00;
	OUT  0x31,R30
; 0000 0222 
; 0000 0223 // Timer/Counter 1 initialization
; 0000 0224 // Clock source: System Clock
; 0000 0225 // Clock value: 172.800 kHz
; 0000 0226 // Mode: Fast PWM top=00FFh
; 0000 0227 // OC1A output: Non-Inv.
; 0000 0228 // OC1B output: Non-Inv.
; 0000 0229 // OC1C output: Discon.
; 0000 022A // Noise Canceler: Off
; 0000 022B // Input Capture on Falling Edge
; 0000 022C // Timer 1 Overflow Interrupt: Off
; 0000 022D // Input Capture Interrupt: Off
; 0000 022E // Compare A Match Interrupt: Off
; 0000 022F // Compare B Match Interrupt: Off
; 0000 0230 // Compare C Match Interrupt: Off
; 0000 0231 TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 0232 TCCR1B=0x0B;
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 0233 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0234 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0235 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0236 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0237 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0238 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0239 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 023A OCR1BL=0x00;
	OUT  0x28,R30
; 0000 023B OCR1CH=0x00;
	STS  121,R30
; 0000 023C OCR1CL=0x00;
	STS  120,R30
; 0000 023D 
; 0000 023E // Timer/Counter 2 initialization
; 0000 023F // Clock source: System Clock
; 0000 0240 // Clock value: 172.800 kHz
; 0000 0241 // Mode: Fast PWM top=FFh
; 0000 0242 // OC2 output: Non-Inverted PWM
; 0000 0243 TCCR2=0x6B;
	LDI  R30,LOW(107)
	OUT  0x25,R30
; 0000 0244 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0245 OCR2=0x00;
	OUT  0x23,R30
; 0000 0246 
; 0000 0247 // Timer/Counter 3 initialization
; 0000 0248 // Clock source: System Clock
; 0000 0249 // Clock value: Timer 3 Stopped
; 0000 024A // Mode: Normal top=FFFFh
; 0000 024B // Noise Canceler: Off
; 0000 024C // Input Capture on Falling Edge
; 0000 024D // OC3A output: Discon.
; 0000 024E // OC3B output: Discon.
; 0000 024F // OC3C output: Discon.
; 0000 0250 // Timer 3 Overflow Interrupt: Off
; 0000 0251 // Input Capture Interrupt: Off
; 0000 0252 // Compare A Match Interrupt: Off
; 0000 0253 // Compare B Match Interrupt: Off
; 0000 0254 // Compare C Match Interrupt: Off
; 0000 0255 TCCR3A=0x00;
	STS  139,R30
; 0000 0256 TCCR3B=0x00;
	STS  138,R30
; 0000 0257 TCNT3H=0x00;
	STS  137,R30
; 0000 0258 TCNT3L=0x00;
	STS  136,R30
; 0000 0259 ICR3H=0x00;
	STS  129,R30
; 0000 025A ICR3L=0x00;
	STS  128,R30
; 0000 025B OCR3AH=0x00;
	STS  135,R30
; 0000 025C OCR3AL=0x00;
	STS  134,R30
; 0000 025D OCR3BH=0x00;
	STS  133,R30
; 0000 025E OCR3BL=0x00;
	STS  132,R30
; 0000 025F OCR3CH=0x00;
	STS  131,R30
; 0000 0260 OCR3CL=0x00;
	STS  130,R30
; 0000 0261 
; 0000 0262 // External Interrupt(s) initialization
; 0000 0263 // INT0: Off
; 0000 0264 // INT1: Off
; 0000 0265 // INT2: Off
; 0000 0266 // INT3: Off
; 0000 0267 // INT4: Off
; 0000 0268 // INT5: Off
; 0000 0269 // INT6: Off
; 0000 026A // INT7: Off
; 0000 026B EICRA=0x00;
	STS  106,R30
; 0000 026C EICRB=0x00;
	OUT  0x3A,R30
; 0000 026D EIMSK=0x00;
	OUT  0x39,R30
; 0000 026E 
; 0000 026F // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0270 TIMSK=0x00;
	OUT  0x37,R30
; 0000 0271 ETIMSK=0x00;
	STS  125,R30
; 0000 0272 
; 0000 0273 // USART1 initialization
; 0000 0274 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0275 // USART1 Receiver: On
; 0000 0276 // USART1 Transmitter: On
; 0000 0277 // USART1 Mode: Asynchronous
; 0000 0278 // USART1 Baud Rate: 9600
; 0000 0279 UCSR1A=0x00;
	STS  155,R30
; 0000 027A UCSR1B=0x98;
	LDI  R30,LOW(152)
	STS  154,R30
; 0000 027B UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 027C UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 027D UBRR1L=0x47;
	LDI  R30,LOW(71)
	STS  153,R30
; 0000 027E 
; 0000 027F // Analog Comparator initialization
; 0000 0280 // Analog Comparator: Off
; 0000 0281 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0282 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0283 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0284 
; 0000 0285 // ADC initialization
; 0000 0286 // ADC Clock frequency: 691.200 kHz
; 0000 0287 // ADC Voltage Reference: AVCC pin
; 0000 0288 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0289 ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 028A 
; 0000 028B // I2C Bus initialization
; 0000 028C i2c_init();
	CALL _i2c_init
; 0000 028D 
; 0000 028E // LCD module initialization
; 0000 028F lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0290 
; 0000 0291 // Watchdog Timer initialization
; 0000 0292 // Watchdog Timer Prescaler: OSC/16k
; 0000 0293 #pragma optsize-
; 0000 0294 WDTCR=0x18;
	LDI  R30,LOW(24)
	OUT  0x21,R30
; 0000 0295 WDTCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x21,R30
; 0000 0296 #ifdef _OPTIMIZE_SIZE_
; 0000 0297 #pragma optsize+
; 0000 0298 #endif
; 0000 0299 
; 0000 029A // Global enable interrupts
; 0000 029B #asm("sei")
	sei
; 0000 029C if (PINA.4==1){
	LDI  R26,0
	SBIC 0x19,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xC4
; 0000 029D c=compass_read(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _compass_read
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	LDI  R31,0
	CALL __EEPROMWRW
; 0000 029E delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 029F }
; 0000 02A0 while (1)
_0xC4:
_0xC5:
; 0000 02A1       {
; 0000 02A2 
; 0000 02A3        cmp=compass_read(1)-c;
	LDI  R30,LOW(1)
	ST   -Y,R30
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
; 0000 02A4         lcd_gotoxy(12,0);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x1A
; 0000 02A5       if(cmp<0) cmp=cmp;
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRGE _0xC8
	MOVW R4,R4
; 0000 02A6       if(cmp>128) cmp=cmp-255;
_0xC8:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0xC9
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	__SUBWRR 4,5,30,31
; 0000 02A7       if(cmp<-128) cmp=cmp+255;
_0xC9:
	LDI  R30,LOW(65408)
	LDI  R31,HIGH(65408)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0xCA
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	MOVW R4,R30
; 0000 02A8 
; 0000 02A9       if(cmp>=0)
_0xCA:
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRLT _0xCB
; 0000 02AA       {
; 0000 02AB       #asm("wdr");
	wdr
; 0000 02AC        lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x1A
; 0000 02AD       lcd_putchar('+');
	LDI  R30,LOW(43)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 02AE       lcd_putchar((cmp/100)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0x5
; 0000 02AF       lcd_putchar((cmp/10)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0x6
; 0000 02B0       lcd_putchar((cmp/1)%10+'0');
	MOVW R26,R4
	RJMP _0xEC
; 0000 02B1       }
; 0000 02B2       else if(cmp<0)
_0xCB:
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRGE _0xCD
; 0000 02B3       {
; 0000 02B4       #asm("wdr");
	wdr
; 0000 02B5        lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x1A
; 0000 02B6       lcd_putchar('-');
	LDI  R30,LOW(45)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 02B7       lcd_putchar((-cmp/100)%10+'0');
	CALL SUBOPT_0x30
	CALL SUBOPT_0x5
; 0000 02B8       lcd_putchar((-cmp/10)%10+'0');
	CALL SUBOPT_0x30
	CALL SUBOPT_0x6
; 0000 02B9       lcd_putchar((-cmp/1)%10+'0');
	CALL SUBOPT_0x30
_0xEC:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	ADIW R30,48
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 02BA       }
; 0000 02BB         if(cmp>-50  && cmp<50) cmp=(float)-cmp*2.25;
_0xCD:
	LDI  R30,LOW(65486)
	LDI  R31,HIGH(65486)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0xCF
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CP   R4,R30
	CPC  R5,R31
	BRLT _0xD0
_0xCF:
	RJMP _0xCE
_0xD0:
	MOVW R30,R4
	CALL __ANEGW1
	CALL SUBOPT_0xA
	__GETD2N 0x40100000
	RJMP _0xED
; 0000 02BC         else cmp=(float)-cmp*1.75;
_0xCE:
	MOVW R30,R4
	CALL __ANEGW1
	CALL SUBOPT_0xA
	__GETD2N 0x3FE00000
_0xED:
	CALL __MULF12
	CALL __CFD1
	MOVW R4,R30
; 0000 02BD       sensor();
	CALL _sensor
; 0000 02BE       sharp();
	CALL _sharp
; 0000 02BF       bt();
	RCALL _bt
; 0000 02C0       #asm("wdr") ;
	wdr
; 0000 02C1       if(adc[min]<900  && (t==0 || (m<t && t!=10)|| (m<t && t!=9)))
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
	CPI  R30,LOW(0x384)
	LDI  R26,HIGH(0x384)
	CPC  R31,R26
	BRGE _0xD3
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BREQ _0xD4
	CALL SUBOPT_0x2D
	CP   R26,R10
	CPC  R27,R11
	BRGE _0xD5
	CALL SUBOPT_0x2F
	BRNE _0xD4
_0xD5:
	CALL SUBOPT_0x2D
	CP   R26,R10
	CPC  R27,R11
	BRGE _0xD7
	CALL SUBOPT_0x2E
	BRNE _0xD4
_0xD7:
	RJMP _0xD3
_0xD4:
	RJMP _0xDA
_0xD3:
	RJMP _0xD2
_0xDA:
; 0000 02C2       {
; 0000 02C3       follow();
	RCALL _follow
; 0000 02C4       #asm("wdr");
	wdr
; 0000 02C5       }
; 0000 02C6       else if (t==10 || adc[min]>900)
	RJMP _0xDB
_0xD2:
	CALL SUBOPT_0x2F
	BREQ _0xDD
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
	CPI  R30,LOW(0x385)
	LDI  R26,HIGH(0x385)
	CPC  R31,R26
	BRLT _0xDC
_0xDD:
; 0000 02C7        {
; 0000 02C8         sahmi();
	RCALL _sahmi
; 0000 02C9         #asm("wdr");
	wdr
; 0000 02CA        }
; 0000 02CB        else if (m>t || t==9 )
	RJMP _0xDF
_0xDC:
	CALL SUBOPT_0x2D
	CP   R10,R26
	CPC  R11,R27
	BRLT _0xE1
	CALL SUBOPT_0x2E
	BRNE _0xE0
_0xE1:
; 0000 02CC        {
; 0000 02CD         if (SB>200 ) follow() ;
	CALL SUBOPT_0x29
	CPI  R26,LOW(0xC9)
	LDI  R30,HIGH(0xC9)
	CPC  R27,R30
	BRLT _0xE3
	RCALL _follow
; 0000 02CE         else sahmi();
	RJMP _0xE4
_0xE3:
	RCALL _sahmi
; 0000 02CF         }
_0xE4:
; 0000 02D0 //        while(l==1 ){
; 0000 02D1 //          sensor();
; 0000 02D2 //            cmp=compass_read(1)-c;
; 0000 02D3 //          if(cmp>-50  && cmp<50) cmp=(float)-cmp*2.25;
; 0000 02D4 //else cmp=(float)-cmp*1.75;
; 0000 02D5 //          sharp();
; 0000 02D6 //          #asm("wdr");
; 0000 02D7 //          if(kaf[15]<KAF || kaf[13]<KAF )
; 0000 02D8 //          {
; 0000 02D9 //               p=0;
; 0000 02DA //              motor(255+cmp,-255+cmp,-255+cmp,255+cmp);
; 0000 02DB //
; 0000 02DC //          }
; 0000 02DD //          else if(kaf[0]<KAF || kaf[1]<KAF || kaf[2]<KAF || kaf[3]<KAF || kaf[12]<KAF)
; 0000 02DE //          {
; 0000 02DF //              p=1;
; 0000 02E0 //              motor(255+cmp,-255+cmp,-255+cmp,255+cmp);
; 0000 02E1 //
; 0000 02E2 //          }
; 0000 02E3 //          else if(p==0 &&((min>=8 && min<16 ) || min==0) )
; 0000 02E4 //          {
; 0000 02E5 //              motor(0+cmp/2,0+cmp/2,0+cmp/2,0+cmp/2);
; 0000 02E6 //          }
; 0000 02E7 //          else if(p==0 && min>0 && min<8)
; 0000 02E8 //          {
; 0000 02E9 //              l=0;
; 0000 02EA //              p=0;
; 0000 02EB //              break;
; 0000 02EC //
; 0000 02ED //          }
; 0000 02EE //      }
; 0000 02EF //        while(r==1)
; 0000 02F0 //        {
; 0000 02F1 //          sensor();
; 0000 02F2 //            cmp=compass_read(1)-c;
; 0000 02F3 //          if(cmp>-50  && cmp<50) cmp=(float)-cmp*2.25;
; 0000 02F4 //else cmp=(float)-cmp*1.75;
; 0000 02F5 //          sharp();
; 0000 02F6 //          #asm("wdr")
; 0000 02F7 //          if(kaf[3]<KAF || kaf[2]<KAF || kaf[1]<KAF)
; 0000 02F8 //          {
; 0000 02F9 //               p=0;
; 0000 02FA //              motor(-255+cmp,255+cmp,255+cmp,-255+cmp );
; 0000 02FB //          }
; 0000 02FC //          else if(kaf[0]<KAF || kaf[15]<KAF || kaf[12]<KAF || kaf[13]<KAF )
; 0000 02FD //          {
; 0000 02FE //              p=1;
; 0000 02FF //              motor(-255+cmp,255+cmp,255+cmp,-255+cmp);
; 0000 0300 //          }
; 0000 0301 //          else if(p==0 && min>=0 && min<8 )
; 0000 0302 //          {
; 0000 0303 //              motor(0+cmp/2,0+cmp/2,0+cmp/2,0+cmp/2);
; 0000 0304 //          }
; 0000 0305 //          else if(p==0 &&(( min>=8 && min<16) ))
; 0000 0306 //          {
; 0000 0307 //             r=0;
; 0000 0308 //              p=0;
; 0000 0309 //              break;
; 0000 030A //          }
; 0000 030B //      }
; 0000 030C //      while(f==1)
; 0000 030D //      {
; 0000 030E //          sensor();
; 0000 030F //            cmp=compass_read(1)-c;
; 0000 0310 //          if(cmp>-50  && cmp<50) cmp=(float)-cmp*2.25;
; 0000 0311 //else cmp=(float)-cmp*1.75;
; 0000 0312 //          sharp();
; 0000 0313 //          #asm("wdr")
; 0000 0314 //          if( kaf[9]<KAF || kaf[10]<KAF)
; 0000 0315 //          {
; 0000 0316 //               p=0;
; 0000 0317 //              motor(-255+cmp,-255+cmp,255+cmp,255+cmp);
; 0000 0318 //
; 0000 0319 //          }
; 0000 031A //          else if(kaf[4]<KAF || kaf[5]<KAF || kaf[6]<KAF ||kaf[8]<KAF)
; 0000 031B //          {
; 0000 031C //              p=1;
; 0000 031D //              motor(-255+cmp,-255+cmp,255+cmp,255+cmp);
; 0000 031E //          }
; 0000 031F //          else if(p==0 && ((min>=0 && min<5 )|| (min>11 && min<16)))
; 0000 0320 //          {
; 0000 0321 //              motor(0+cmp,0+cmp,0+cmp,0+cmp);
; 0000 0322 //          }
; 0000 0323 //          else if(p==0 && min>4 && min<12)
; 0000 0324 //          {
; 0000 0325 //              f=0;
; 0000 0326 //              p=0;
; 0000 0327 //              break;
; 0000 0328 //          }
; 0000 0329 //      }
; 0000 032A //        while(b==1)
; 0000 032B //        {
; 0000 032C //          sensor();
; 0000 032D //          cmp=compass_read(1)-c;
; 0000 032E //          if(cmp>-50  && cmp<50) cmp=(float)-cmp*2.25;
; 0000 032F //else cmp=(float)-cmp*1.75;
; 0000 0330 //
; 0000 0331 //          sharp();
; 0000 0332 //          #asm("wdr")
; 0000 0333 //          if( kaf[6]<KAF || kaf[5]<KAF  )
; 0000 0334 //          {
; 0000 0335 //               p=0;
; 0000 0336 //              motor(255+cmp,255+cmp,-255+cmp,-255+cmp);
; 0000 0337 //
; 0000 0338 //          }
; 0000 0339           ////////////////////////&& beshe ba do taraf
; 0000 033A //         else if(kaf[9]<KAF || kaf[10]<KAF  || kaf[8]<KAF || kaf[4]<KAF)
; 0000 033B //         {
; 0000 033C //            p=1;
; 0000 033D //              motor(255+cmp,255+cmp,-255+cmp,-255+cmp);
; 0000 033E //          }
; 0000 033F //          else if(p==0 && min>4 && min<12 )
; 0000 0340 //          {
; 0000 0341 //              motor(0+cmp,0+cmp,0+cmp,0+cmp);
; 0000 0342 //          }
; 0000 0343 //          else if(p==0 && ((min>=0 && min<5 )|| (min>11 && min<16)))
; 0000 0344 //          {
; 0000 0345 //              b=0;
; 0000 0346 //              p=0;
; 0000 0347 //              break;
; 0000 0348 //          }
; 0000 0349 //
; 0000 034A //          }
; 0000 034B 
; 0000 034C       };
_0xE0:
_0xDF:
_0xDB:
	RJMP _0xC5
; 0000 034D  }
_0xE5:
	RJMP _0xE5
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

	.CSEG
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G101:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G101:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x2080001
__lcd_read_nibble_G101:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
    andi  r30,0xf0
	RET
_lcd_read_byte0_G101:
	CALL __lcd_delay_G101
	RCALL __lcd_read_nibble_G101
    mov   r26,r30
	RCALL __lcd_read_nibble_G101
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	CALL SUBOPT_0x1
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R8,Y+1
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	MOV  R8,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	INC  R8
	LDS  R30,__lcd_maxx
	CP   R30,R8
	BRSH _0x2020004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	ST   -Y,R30
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2020004:
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x2080001
__long_delay_G101:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G101:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2080001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	CALL SUBOPT_0x1
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	__PUTB1MN __base_y_G101,2
	CALL SUBOPT_0x1
	SUBI R30,LOW(-192)
	SBCI R31,HIGH(-192)
	__PUTB1MN __base_y_G101,3
	CALL SUBOPT_0x31
	CALL SUBOPT_0x31
	CALL SUBOPT_0x31
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	CALL SUBOPT_0x32
	LDI  R30,LOW(4)
	CALL SUBOPT_0x32
	LDI  R30,LOW(133)
	CALL SUBOPT_0x32
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BREQ _0x202000B
	LDI  R30,LOW(0)
	RJMP _0x2080001
_0x202000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2080001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.ESEG
_c:
	.BYTE 0x2

	.DSEG
_rx_buffer1:
	.BYTE 0x8
_SR:
	.BYTE 0x2
_SB:
	.BYTE 0x2
_RL:
	.BYTE 0x2
_sum:
	.BYTE 0x2
_adc:
	.BYTE 0x20
_min:
	.BYTE 0x2
_i:
	.BYTE 0x2
_kaf:
	.BYTE 0x20
_mini:
	.BYTE 0x2
_r:
	.BYTE 0x2
_l:
	.BYTE 0x2
_f:
	.BYTE 0x2
_b:
	.BYTE 0x2
_h:
	.BYTE 0x2
_m:
	.BYTE 0x2
__base_y_G101:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
_p_S1030024:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	IN   R30,0x6
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDS  R26,_SR
	LDS  R27,_SR+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	ADIW R30,48
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:74 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	ADIW R30,48
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	ADIW R30,48
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x8:
	LDS  R26,_RL
	LDS  R27,_RL+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x9:
	LDS  R30,_RL
	LDS  R31,_RL+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	CALL __MULF12
	LDI  R26,LOW(_RL)
	LDI  R27,HIGH(_RL)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDS  R26,_i
	LDS  R27,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDS  R30,_i
	LDS  R31,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(_adc)
	LDI  R27,HIGH(_adc)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0xE
	LDI  R26,LOW(_kaf)
	LDI  R27,HIGH(_kaf)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X+
	LD   R1,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x12:
	LDS  R30,_min
	LDS  R31,_min+1
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CP   R0,R30
	CPC  R1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x14:
	LDS  R30,_mini
	LDS  R31,_mini+1
	LDI  R26,LOW(_kaf)
	LDI  R27,HIGH(_kaf)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x15:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x16:
	LDS  R26,_min
	LDS  R27,_min+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDS  R30,_min
	LDS  R31,_min+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x18:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __DIVW21
	STS  _h,R30
	STS  _h+1,R31
	LDS  R26,_h
	LDS  R27,_h+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x19:
	LDS  R26,_h
	LDS  R27,_h+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDS  R26,_h
	LDS  R27,_h+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	MOVW R26,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1D:
	LDS  R26,_l
	LDS  R27,_l+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1E:
	LDS  R26,_r
	LDS  R27,_r+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1F:
	LDS  R26,_f
	LDS  R27,_f+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x20:
	LDS  R26,_b
	LDS  R27,_b+1
	SBIW R26,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x21:
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x22:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	MOVW R30,R4
	ADIW R30,0
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x24:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	ADIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x25:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x27:
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x28:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	LDS  R26,_SB
	LDS  R27,_SB+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	SUB  R30,R26
	SBC  R31,R27
	ADD  R30,R4
	ADC  R31,R5
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	ADD  R30,R4
	ADC  R31,R5
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2C:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	RCALL SUBOPT_0x8
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2D:
	LDS  R26,_m
	LDS  R27,_m+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	MOVW R30,R4
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G101


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
	ld   r23,y+
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
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
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
	ret

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
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

;END OF CODE MARKER
__END_OF_CODE:
