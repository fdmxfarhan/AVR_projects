
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

_0xC8:
	.DB  0x0,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x0A
	.DW  _0xC8*2

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
; 0000 0021 #endasm
;#include <i2c.h>
;eeprom int c;
;//////////////////////////////////////////cmp
; #define EEPROM_BUS_ADDRESS 0xc0
;int cmp;
;/* read a byte from the EEPROM */
;unsigned char compass_read(unsigned char address) {
; 0000 0028 unsigned char compass_read(unsigned char address) {

	.CSEG
_compass_read:
; 0000 0029 unsigned char data;
; 0000 002A i2c_start();
	ST   -Y,R17
;	address -> Y+1
;	data -> R17
	CALL _i2c_start
; 0000 002B i2c_write(EEPROM_BUS_ADDRESS);
	LDI  R30,LOW(192)
	ST   -Y,R30
	CALL _i2c_write
; 0000 002C i2c_write(address);
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _i2c_write
; 0000 002D i2c_start();
	CALL _i2c_start
; 0000 002E i2c_write(EEPROM_BUS_ADDRESS | 1);
	LDI  R30,LOW(193)
	ST   -Y,R30
	CALL _i2c_write
; 0000 002F data=i2c_read(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_read
	MOV  R17,R30
; 0000 0030 i2c_stop();
	CALL _i2c_stop
; 0000 0031 return data;
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x2080002
; 0000 0032 }
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x15 ;PORTC
; 0000 0037 #endasm
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
; 0000 0057 {
_usart1_rx_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0058 char status,data;
; 0000 0059 status=UCSR1A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,155
; 0000 005A data=UDR1;
	LDS  R16,156
; 0000 005B if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x3
; 0000 005C    {
; 0000 005D    rx_buffer1[rx_wr_index1]=data;
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	ST   Z,R16
; 0000 005E    if (++rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x4
	CLR  R7
; 0000 005F    if (++rx_counter1 == RX_BUFFER_SIZE1)
_0x4:
	INC  R9
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x5
; 0000 0060       {
; 0000 0061       rx_counter1=0;
	CLR  R9
; 0000 0062       rx_buffer_overflow1=1;
	SET
	BLD  R2,0
; 0000 0063       };
_0x5:
; 0000 0064    };
_0x3:
; 0000 0065 //    if (data=='2'){
; 0000 0066 //   lcd_gotoxy(12,1);
; 0000 0067 //   lcd_putchar('2');
; 0000 0068 //   t=2;
; 0000 0069 //   }
; 0000 006A //   else    if (data=='1'){
; 0000 006B //   lcd_gotoxy(12,1);
; 0000 006C //   lcd_putchar('1');
; 0000 006D //   t=1;
; 0000 006E //   }
; 0000 006F //     else    if (data=='3'){
; 0000 0070 //   lcd_gotoxy(12,1);
; 0000 0071 //   lcd_putchar('3');
; 0000 0072 //   t=3;
; 0000 0073 //   }
; 0000 0074 //    else {
; 0000 0075 //   lcd_gotoxy(12,1);
; 0000 0076 //   lcd_putchar('n');
; 0000 0077 //   }
; 0000 0078 
; 0000 0079 }
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;// Get a character from the USART1 Receiver buffer
;#pragma used+
;char getchar1(void)
; 0000 007E {
; 0000 007F char data;
; 0000 0080 while (rx_counter1==0);
;	data -> R17
; 0000 0081 data=rx_buffer1[rx_rd_index1];
; 0000 0082 if (++rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
; 0000 0083 #asm("cli")
; 0000 0084 --rx_counter1;
; 0000 0085 #asm("sei")
; 0000 0086 return data;
; 0000 0087 }
;#pragma used-
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(char c)
; 0000 008C {
; 0000 008D while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
; 0000 008E UDR1=c;
; 0000 008F }
;#pragma used-
;
;#include <delay.h>
;
;#define ADC_VREF_TYPE 0x40
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0098 {
_read_adc:
; 0000 0099 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	CALL SUBOPT_0x0
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 009A // Delay needed for the stabilization of the ADC input voltage
; 0000 009B delay_us(10);
	__DELAY_USB 37
; 0000 009C // Start the AD conversion
; 0000 009D ADCSRA|=0x40;
	CALL SUBOPT_0x1
	ORI  R30,0x40
	OUT  0x6,R30
; 0000 009E // Wait for the AD conversion to complete
; 0000 009F while ((ADCSRA & 0x10)==0);
_0xD:
	CALL SUBOPT_0x1
	ANDI R30,LOW(0x10)
	BREQ _0xD
; 0000 00A0 ADCSRA|=0x10;
	CALL SUBOPT_0x1
	ORI  R30,0x10
	OUT  0x6,R30
; 0000 00A1 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x2080001
; 0000 00A2 }
;
;// Declare your global variables here
;void motor(int ML1,int ML2,int MR2,int MR1){
; 0000 00A5 void motor(int ML1,int ML2,int MR2,int MR1){
_motor:
; 0000 00A6 #asm("cli")
;	ML1 -> Y+6
;	ML2 -> Y+4
;	MR2 -> Y+2
;	MR1 -> Y+0
	cli
; 0000 00A7 #asm("wdr") ;
	wdr
; 0000 00A8 
; 0000 00A9 if(ML1<-255) ML1=-255;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x10
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00AA if(ML2<-255) ML2=-255;
_0x10:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x11
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00AB if(MR1<-255) MR1=-255;
_0x11:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x12
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00AC if(MR2<-255) MR2=-255;
_0x12:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x13
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00AD 
; 0000 00AE if(ML1>255) ML1=255;
_0x13:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x14
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00AF if(ML2>255) ML2=255;
_0x14:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x15
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00B0 if(MR1>255) MR1=255;
_0x15:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x16
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00B1 if(MR2>255) MR2=255;
_0x16:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x17
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00B2 /////////////////////////////////
; 0000 00B3 if(ML1>=0){
_0x17:
	LDD  R26,Y+7
	TST  R26
	BRMI _0x18
; 0000 00B4 PORTD.7=0;
	CBI  0x12,7
; 0000 00B5 OCR2=ML1;}
	RJMP _0xBD
; 0000 00B6 else if(ML1<0){
_0x18:
	LDD  R26,Y+7
	TST  R26
	BRPL _0x1C
; 0000 00B7 PORTD.7=1;
	SBI  0x12,7
; 0000 00B8 OCR2=ML1;}
_0xBD:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	OUT  0x23,R30
; 0000 00B9 
; 0000 00BA 
; 0000 00BB 
; 0000 00BC      /////////////////////////
; 0000 00BD if(ML2>=0){
_0x1C:
	LDD  R26,Y+5
	TST  R26
	BRMI _0x1F
; 0000 00BE PORTD.6=0;
	CBI  0x12,6
; 0000 00BF OCR1B=ML2;}
	RJMP _0xBE
; 0000 00C0 else if(ML2<0){
_0x1F:
	LDD  R26,Y+5
	TST  R26
	BRPL _0x23
; 0000 00C1 PORTD.6=1;
	SBI  0x12,6
; 0000 00C2 OCR1B=ML2;}
_0xBE:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00C3 
; 0000 00C4    /////////////////////////
; 0000 00C5 if(MR1>=0){
_0x23:
	LDD  R26,Y+1
	TST  R26
	BRMI _0x26
; 0000 00C6 PORTD.4=0;
	CBI  0x12,4
; 0000 00C7 OCR0=MR1;}
	RJMP _0xBF
; 0000 00C8 else if(MR1<0){
_0x26:
	LDD  R26,Y+1
	TST  R26
	BRPL _0x2A
; 0000 00C9 PORTD.4=1;
	SBI  0x12,4
; 0000 00CA OCR0=MR1;}
_0xBF:
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x31,R30
; 0000 00CB 
; 0000 00CC  ////////////////////////
; 0000 00CD  if(MR2>=0){
_0x2A:
	LDD  R26,Y+3
	TST  R26
	BRMI _0x2D
; 0000 00CE PORTD.5=0;
	CBI  0x12,5
; 0000 00CF OCR1A=MR2;}
	RJMP _0xC0
; 0000 00D0 else if(MR2<0){
_0x2D:
	LDD  R26,Y+3
	TST  R26
	BRPL _0x31
; 0000 00D1 PORTD.5=1;
	SBI  0x12,5
; 0000 00D2 OCR1A=MR2;}
_0xC0:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00D3 #asm("wdr") ;
_0x31:
	wdr
; 0000 00D4 #asm("sei")
	sei
; 0000 00D5 }
	ADIW R28,8
	RET
;
;
;
;
;int SL,SR,SB,RL,sum=0;
;      void sharp(){
; 0000 00DB void sharp(){
; 0000 00DC       #asm("cli")
; 0000 00DD        #asm("wdr") ;
; 0000 00DE 
; 0000 00DF       SB=read_adc(5);
; 0000 00E0       SR=read_adc(4);
; 0000 00E1       SL=read_adc(3);
; 0000 00E2 
; 0000 00E3        lcd_gotoxy(13,1);
; 0000 00E4       lcd_putchar((SR/100)%10+'0');
; 0000 00E5       lcd_putchar((SR/10)%10+'0');
; 0000 00E6       lcd_putchar((SR/1)%10+'0');
; 0000 00E7         lcd_gotoxy(8,0);
; 0000 00E8       lcd_putchar((SB/100)%10+'0');
; 0000 00E9       lcd_putchar((SB/10)%10+'0');
; 0000 00EA       lcd_putchar((SB/1)%10+'0');
; 0000 00EB 
; 0000 00EC        lcd_gotoxy(8,1);
; 0000 00ED       lcd_putchar((SL/100)%10+'0');
; 0000 00EE       lcd_putchar((SL/10)%10+'0');
; 0000 00EF       lcd_putchar((SL/1)%10+'0');
; 0000 00F0 
; 0000 00F1        #asm("wdr") ;
; 0000 00F2        RL=SR-SL;
; 0000 00F3        sum= SR+SL;
; 0000 00F4 //       if(RL>0)
; 0000 00F5 //       {
; 0000 00F6 //       lcd_gotoxy(0,1);
; 0000 00F7 //       lcd_putchar('+');
; 0000 00F8 //       lcd_putchar((RL/100)%10+'0');
; 0000 00F9 //       lcd_putchar((RL/10)%10+'0');
; 0000 00FA //       lcd_putchar((RL/1)%10+'0');
; 0000 00FB //                }
; 0000 00FC //               else  if(RL<0)
; 0000 00FD //               {
; 0000 00FE //       lcd_gotoxy(0,1);
; 0000 00FF //       lcd_putchar('-');
; 0000 0100 //       lcd_putchar((-RL/100)%10+'0');
; 0000 0101 //       lcd_putchar((-RL/10)%10+'0');
; 0000 0102 //       lcd_putchar((-RL/1)%10+'0');
; 0000 0103 //                }
; 0000 0104       #asm("sei")
; 0000 0105      }
;
;
;   int adc[16],min=0,i,kaf[16],mini=0,r=0,l=0;
;      void sensor() {
; 0000 0109 void sensor() {
_sensor:
; 0000 010A        #asm("cli")
	cli
; 0000 010B 
; 0000 010C     for(i=0;i<16;i++)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _i,R30
	STS  _i+1,R31
_0x35:
	CALL SUBOPT_0x2
	SBIW R26,16
	BRLT PC+3
	JMP _0x36
; 0000 010D      {
; 0000 010E      #asm("wdr") ;
	wdr
; 0000 010F  PORTA.3=(i/8)%2;
	CALL SUBOPT_0x2
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x3
	BRNE _0x37
	CBI  0x1B,3
	RJMP _0x38
_0x37:
	SBI  0x1B,3
_0x38:
; 0000 0110  PORTA.2=(i/4)%2;
	CALL SUBOPT_0x2
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x3
	BRNE _0x39
	CBI  0x1B,2
	RJMP _0x3A
_0x39:
	SBI  0x1B,2
_0x3A:
; 0000 0111  PORTA.1=(i/2)%2;
	CALL SUBOPT_0x2
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x3
	BRNE _0x3B
	CBI  0x1B,1
	RJMP _0x3C
_0x3B:
	SBI  0x1B,1
_0x3C:
; 0000 0112  PORTA.0=(i/1)%2;
	CALL SUBOPT_0x2
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	CPI  R30,0
	BRNE _0x3D
	CBI  0x1B,0
	RJMP _0x3E
_0x3D:
	SBI  0x1B,0
_0x3E:
; 0000 0113   //adc[i]=read_adc(7);
; 0000 0114          adc[i]=read_adc(0);
	CALL SUBOPT_0x4
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 0115   //kaf[i]=read_adc(6);
; 0000 0116 ////////////////////////////////////////////////////////////moghayese
; 0000 0117   if (adc[i]<adc[min])
	CALL SUBOPT_0x4
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X+
	LD   R1,X
	CALL SUBOPT_0x5
	CP   R0,R30
	CPC  R1,R31
	BRGE _0x3F
; 0000 0118   {  min=i;  }
	LDS  R30,_i
	LDS  R31,_i+1
	STS  _min,R30
	STS  _min+1,R31
; 0000 0119 
; 0000 011A //   if (kaf[i]<kaf[mini])
; 0000 011B //   {
; 0000 011C 
; 0000 011D //   mini=i;  }
; 0000 011E //
; 0000 011F }
_0x3F:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x35
_0x36:
; 0000 0120  ///////////////////////////////////////////////////////////chap
; 0000 0121   lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0122   lcd_putchar((min/10)%10+'0');
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
; 0000 0123   lcd_putchar((min/1)%10+'0');
	CALL SUBOPT_0x6
	CALL SUBOPT_0x8
; 0000 0124   lcd_putchar('=');
	LDI  R30,LOW(61)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0125   lcd_putchar((adc[min]/1000)%10+'0');
	CALL SUBOPT_0x5
	MOVW R26,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x7
; 0000 0126   lcd_putchar((adc[min]/100)%10+'0');
	CALL SUBOPT_0x5
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x7
; 0000 0127   lcd_putchar((adc[min]/10)%10+'0');
	CALL SUBOPT_0x5
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x7
; 0000 0128   lcd_putchar((adc[min]/1)%10+'0');
	CALL SUBOPT_0x5
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x8
; 0000 0129  #asm("wdr") ;
	wdr
; 0000 012A 
; 0000 012B // lcd_gotoxy(0,1);
; 0000 012C //  lcd_putchar((mini/10)%10+'0');
; 0000 012D //  lcd_putchar((mini/1)%10+'0');
; 0000 012E //  lcd_putchar('=');
; 0000 012F //  lcd_putchar((kaf[mini]/1000)%10+'0');
; 0000 0130 //  lcd_putchar((kaf[mini]/100)%10+'0');
; 0000 0131 //  lcd_putchar((kaf[mini]/10)%10+'0');
; 0000 0132 //  lcd_putchar((kaf[mini]/1)%10+'0');
; 0000 0133 
; 0000 0134 
; 0000 0135 
; 0000 0136       if ((kaf[0]<400 || kaf[1]<300 || kaf[2]<300 || kaf[3]<400) ) r=1;
	LDS  R26,_kaf
	LDS  R27,_kaf+1
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x41
	__GETW2MN _kaf,2
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRLT _0x41
	__GETW2MN _kaf,4
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRLT _0x41
	__GETW2MN _kaf,6
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRGE _0x40
_0x41:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _r,R30
	STS  _r+1,R31
; 0000 0137 
; 0000 0138    if ((kaf[12]<400 || kaf[13]<300 || kaf[14]<300 || kaf[15]<400)  ) l=1;
_0x40:
	__GETW2MN _kaf,24
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x44
	__GETW2MN _kaf,26
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRLT _0x44
	__GETW2MN _kaf,28
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRLT _0x44
	__GETW2MN _kaf,30
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRGE _0x43
_0x44:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _l,R30
	STS  _l+1,R31
; 0000 0139 
; 0000 013A 
; 0000 013B 
; 0000 013C 
; 0000 013D     #asm("sei")
_0x43:
	sei
; 0000 013E 
; 0000 013F   }
	RET
;
;      void compass() {
; 0000 0141 void compass() {
; 0000 0142          #asm("cli")
; 0000 0143       #asm("wdr") ;
; 0000 0144 
; 0000 0145 cmp=compass_read(1)-c;
; 0000 0146 
; 0000 0147       if(cmp<0) cmp=cmp;
; 0000 0148       if(cmp>128) cmp=cmp-255;
; 0000 0149       if(cmp<-128) cmp=cmp+255;
; 0000 014A 
; 0000 014B       if(cmp>=0)
; 0000 014C       {
; 0000 014D        lcd_gotoxy(12,0);
; 0000 014E       lcd_putchar('+');
; 0000 014F       lcd_putchar((cmp/100)%10+'0');
; 0000 0150       lcd_putchar((cmp/10)%10+'0');
; 0000 0151       lcd_putchar((cmp/1)%10+'0');
; 0000 0152       }
; 0000 0153       else if(cmp<0)
; 0000 0154       {
; 0000 0155        lcd_gotoxy(12,0);
; 0000 0156       lcd_putchar('-');
; 0000 0157       lcd_putchar((-cmp/100)%10+'0');
; 0000 0158       lcd_putchar((-cmp/10)%10+'0');
; 0000 0159       lcd_putchar((-cmp/1)%10+'0');
; 0000 015A       }
; 0000 015B 
; 0000 015C 
; 0000 015D 
; 0000 015E 
; 0000 015F 
; 0000 0160 
; 0000 0161 //       if(cmp>-60 && cmp<0)  cmp=-cmp*2.5;
; 0000 0162 //       else cmp=-cmp;
; 0000 0163 if(cmp>-20 && cmp<0)
; 0000 0164 cmp=-cmp*2;
; 0000 0165 else
; 0000 0166 cmp=-cmp;
; 0000 0167 
; 0000 0168 
; 0000 0169 
; 0000 016A        #asm("wdr") ;
; 0000 016B         #asm("sei")
; 0000 016C        }
;      void follow ()
; 0000 016E     {
_follow:
; 0000 016F 
; 0000 0170           #asm("wdr") ;
	wdr
; 0000 0171           if(RL>0) RL=RL*1.5;
	LDS  R26,_RL
	LDS  R27,_RL+1
	CALL __CPW02
	BRGE _0x50
	LDS  R30,_RL
	LDS  R31,_RL+1
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3FC00000
	CALL __MULF12
	LDI  R26,LOW(_RL)
	LDI  R27,HIGH(_RL)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 0172           else if(RL<0) RL=RL*4;
	RJMP _0x51
_0x50:
	LDS  R26,_RL+1
	TST  R26
	BRPL _0x52
	LDS  R30,_RL
	LDS  R31,_RL+1
	CALL __LSLW2
	STS  _RL,R30
	STS  _RL+1,R31
; 0000 0173 
; 0000 0174 
; 0000 0175 
; 0000 0176          if(min==0 || min==1 || min==15)  motor(255+cmp,255+cmp,-255+cmp,-255+cmp);
_0x52:
_0x51:
	CALL SUBOPT_0x9
	SBIW R26,0
	BREQ _0x54
	CALL SUBOPT_0x9
	SBIW R26,1
	BREQ _0x54
	CALL SUBOPT_0x9
	SBIW R26,15
	BRNE _0x53
_0x54:
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	RJMP _0xC3
; 0000 0177 //         if(min==0 ) {
; 0000 0178 //         if(adc[min]<100){
; 0000 0179 //          if (RL<0) motor(255-RL+cmp,0+RL+cmp,-255+RL+cmp,0-RL+cmp);
; 0000 017A //         else  motor(128-RL+cmp,255+RL+cmp,-128+RL+cmp,-255-RL+cmp);
; 0000 017B //         }
; 0000 017C //          motor(255+cmp,255+cmp,-255+cmp,-255+cmp);
; 0000 017D //          }
; 0000 017E 
; 0000 017F          else if(min==1)
_0x53:
	CALL SUBOPT_0x9
	SBIW R26,1
	BRNE _0x57
; 0000 0180          {
; 0000 0181 //            if(adc[min]<100)
; 0000 0182 //            {
; 0000 0183 //           if (RL<0) motor(255-RL+cmp,0+RL+cmp,-255+RL+cmp,0-RL+cmp);
; 0000 0184         //   else  motor(128-RL+cmp,255+RL+cmp,-128+RL+cmp,-255-RL+cmp);
; 0000 0185           //  }
; 0000 0186 
; 0000 0187          motor(255+cmp,0+cmp,-255+cmp,0+cmp);
	CALL SUBOPT_0xA
	MOVW R30,R4
	ADIW R30,0
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	RJMP _0xC4
; 0000 0188           }
; 0000 0189 
; 0000 018A 
; 0000 018B            //motor(255,128,-255,-128);
; 0000 018C          else if(min==2)     motor(255+cmp,-255+cmp,-255+cmp,255+cmp);     //motor(255,0,-255,0);
_0x57:
	CALL SUBOPT_0x9
	SBIW R26,2
	BRNE _0x59
	CALL SUBOPT_0xA
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0xB
	CALL SUBOPT_0xD
	RJMP _0xC4
; 0000 018D          else if(min==3)     motor(128+cmp,-255+cmp,-128+cmp,255+cmp);    //motor(255,-128,-255,128);
_0x59:
	CALL SUBOPT_0x9
	SBIW R26,3
	BRNE _0x5B
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	CALL SUBOPT_0xB
	CALL SUBOPT_0xE
	CALL SUBOPT_0xD
	RJMP _0xC4
; 0000 018E          else if(min==4)     motor(0+cmp,-255+cmp,0+cmp,255+cmp);         //motor(255,-255,-255,255);
_0x5B:
	CALL SUBOPT_0x9
	SBIW R26,4
	BRNE _0x5D
	MOVW R30,R4
	ADIW R30,0
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	RJMP _0xC4
; 0000 018F          else if(min==5)     motor(-128+cmp,-255+cmp,128+cmp,255+cmp );    //motor(128,-255,-128,255);
_0x5D:
	CALL SUBOPT_0x9
	SBIW R26,5
	BRNE _0x5F
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	CALL SUBOPT_0xB
	CALL SUBOPT_0xF
	RJMP _0xC4
; 0000 0190          else if(min==6)     motor(-255+cmp,-255+cmp,255+cmp,255+cmp);    //motor(0,-255,0,255);
_0x5F:
	CALL SUBOPT_0x9
	SBIW R26,6
	BRNE _0x61
	CALL SUBOPT_0x10
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	RJMP _0xC4
; 0000 0191          else if(min==7)     motor(-255+cmp,-128+cmp,255+cmp,128+cmp);    //motor(-128,-255,128,255);
_0x61:
	CALL SUBOPT_0x9
	SBIW R26,7
	BRNE _0x63
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0xE
	CALL SUBOPT_0x11
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	RJMP _0xC4
; 0000 0192          else if(min==8)     motor(-255+cmp,0+cmp,255+cmp,0+cmp);    //motor(-255,-255,255,255);
_0x63:
	CALL SUBOPT_0x9
	SBIW R26,8
	BRNE _0x65
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0xC
	CALL SUBOPT_0x11
	MOVW R30,R4
	ADIW R30,0
	RJMP _0xC4
; 0000 0193          else if(min==9)     motor(-128+cmp,-255+cmp,128+cmp,255+cmp);        //motor(-255,-128,255,128);
_0x65:
	CALL SUBOPT_0x9
	SBIW R26,9
	BRNE _0x67
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	CALL SUBOPT_0xB
	CALL SUBOPT_0xF
	RJMP _0xC4
; 0000 0194          else if(min==10)    motor(-255+cmp,-255+cmp,255+cmp,255+cmp);    //motor(-255,0,255,0);
_0x67:
	CALL SUBOPT_0x9
	SBIW R26,10
	BRNE _0x69
	CALL SUBOPT_0x10
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	RJMP _0xC4
; 0000 0195          else if(min==11)    motor(-255+cmp,-128+cmp,255+cmp,128+cmp);    //motor(-255,128,255,-128);
_0x69:
	CALL SUBOPT_0x9
	SBIW R26,11
	BRNE _0x6B
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0xE
	CALL SUBOPT_0x11
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	RJMP _0xC4
; 0000 0196          else if(min==12)    motor(-255+cmp,0+cmp,255+cmp,0+cmp);    //motor(-255,255,255,-255);
_0x6B:
	CALL SUBOPT_0x9
	SBIW R26,12
	BRNE _0x6D
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0xC
	CALL SUBOPT_0x11
	MOVW R30,R4
	ADIW R30,0
	RJMP _0xC4
; 0000 0197          else if(min==13)    motor(-255+cmp,128+cmp,255+cmp,-128+cmp);         //motor(-128,255,128,-255);
_0x6D:
	CALL SUBOPT_0x9
	SBIW R26,13
	BRNE _0x6F
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	CALL SUBOPT_0x11
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	RJMP _0xC4
; 0000 0198          else if(min==14)    motor(-255+cmp,255+cmp,255+cmp,-255+cmp);    //motor(0,255,0,-255);
_0x6F:
	CALL SUBOPT_0x9
	SBIW R26,14
	BRNE _0x71
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x11
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	RJMP _0xC3
; 0000 0199 
; 0000 019A 
; 0000 019B          else if(min==15)
_0x71:
	CALL SUBOPT_0x9
	SBIW R26,15
	BRNE _0x73
; 0000 019C          {
; 0000 019D //           if(adc[min]<150){
; 0000 019E //          if (RL<0) motor(255-RL+cmp,0+RL+cmp,-255+RL+cmp,0-RL+cmp);
; 0000 019F //          else  motor(128-RL+cmp,255+RL+cmp,-128+RL+cmp,-255-RL+cmp);
; 0000 01A0 //           }
; 0000 01A1          motor(-128+cmp,255+cmp,128+cmp,-255+cmp); //motor(128,255,-128,-255);
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	CALL SUBOPT_0x11
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
_0xC3:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
_0xC4:
	ST   -Y,R31
	ST   -Y,R30
	CALL _motor
; 0000 01A2          }
; 0000 01A3          #asm("wdr") ;
_0x73:
	wdr
; 0000 01A4 
; 0000 01A5           }
	RET
;      void sahmi()
; 0000 01A7           {
; 0000 01A8 
; 0000 01A9            if (RL<50 && RL>-50) RL=0;
; 0000 01AA          //else  if(RL>0) RL=RL*2;
; 0000 01AB           else if(RL<0) RL=RL*0.8;
; 0000 01AC 
; 0000 01AD           if(SB<190)
; 0000 01AE            {
; 0000 01AF           motor(-128-RL+cmp,-255+RL+cmp,128+RL-cmp,255-RL+cmp);
; 0000 01B0            }
; 0000 01B1            ///////////////////////////////////////////////////////////////
; 0000 01B2 //           else if(SB>190 && (RL>60 || RL<-60))
; 0000 01B3 //           {
; 0000 01B4           // RL=RL*3;
; 0000 01B5 //          motor(255-RL+cmp,255+RL+cmp,-255+RL+cmp,-255-RL+cmp);
; 0000 01B6 //          }
; 0000 01B7            //////////////////////////////////////////////////////////////
; 0000 01B8            else if(SB>190 && RL<-70 )
; 0000 01B9            {
; 0000 01BA            motor((255+cmp)*0.5,(-255+cmp)*0.5,(-255+cmp)*0.5,(255+cmp)*0.5);
; 0000 01BB            }
; 0000 01BC             else if(SB>190 && RL>70 )
; 0000 01BD            {
; 0000 01BE            motor((-255+cmp)*0.5,(255+cmp)*0.5,(255+cmp)*0.5,(-255+cmp)*0.5);
; 0000 01BF            }
; 0000 01C0 
; 0000 01C1           else    motor(0+cmp,0+cmp,0+cmp,0+cmp);
; 0000 01C2           //t=0;
; 0000 01C3 
; 0000 01C4           }
;
;       void taghib(){
; 0000 01C6 void taghib(){
; 0000 01C7 
; 0000 01C8         #asm("wdr") ;
; 0000 01C9           if(min==0)       motor(255,255,-255,-255);
; 0000 01CA          else if(min==1)   motor(255,128,-255,-128);
; 0000 01CB          else if(min==2)     motor(255,0,-255,0);
; 0000 01CC          else if(min==3)     motor(255,-128,-255,128);
; 0000 01CD          else if(min==4)    motor(255,-255,-255,255);
; 0000 01CE          else if(min==5)    motor(128,-255,-128,255);
; 0000 01CF          else if(min==6)     motor(0,-255,0,255);
; 0000 01D0          else if(min==7)     motor(-128,-255,128,255);
; 0000 01D1          else if(min==8)    motor(-255,-255,255,255);
; 0000 01D2          else if(min==9)     motor(-255,-128,255,128);
; 0000 01D3          else if(min==10)   motor(-255,0,255,0);
; 0000 01D4          else if(min==11)    motor(-255,128,255,-128);
; 0000 01D5          else if(min==12)   motor(-255,255,255,-255);
; 0000 01D6          else if(min==13)   motor(-128,255,128,-255);
; 0000 01D7          else if(min==14)   motor(0,255,0,-255);
; 0000 01D8          else if(min==15)  motor(128,255,-128,-255);
; 0000 01D9 
; 0000 01DA          #asm("wdr") ;
; 0000 01DB 
; 0000 01DC        }
;        int outr=0,outl=0;
;        void out () {
; 0000 01DE void out () {
; 0000 01DF 
; 0000 01E0       if ((sum<550 && SR>310 && SL<200) && ((min>0 && min<8 ) || min==0)  ) {
; 0000 01E1    #asm ("wdr");
; 0000 01E2 //  motor(-255+cmp,255+cmp,255+cmp,-255+cmp);
; 0000 01E3 //  delay_ms(30);
; 0000 01E4 //  sr=1;
; 0000 01E5 //  while (min>=0 && min<9){ motor(0+cmp,0+cmp,0+cmp,0+cmp);
; 0000 01E6 //  sensor();
; 0000 01E7 //   compass();
; 0000 01E8 //  #asm ("wdr");
; 0000 01E9 //   }
; 0000 01EA    outr=1;
; 0000 01EB    }
; 0000 01EC    ///////////
; 0000 01ED      else if ((sum<550 && SL>300 && SR<150 )&& ((min>7 && min<16 ) || min==0) ) {
; 0000 01EE    #asm ("wdr");
; 0000 01EF //  motor(255+cmp,-255+cmp,-255+cmp,255+cmp);
; 0000 01F0 //  delay_ms(30);
; 0000 01F1 //  sr=1;
; 0000 01F2 //  while (min>7 && min<16){ motor(0+cmp,0+cmp,0+cmp,0+cmp);
; 0000 01F3 //  sensor();
; 0000 01F4 //   compass();
; 0000 01F5 //  #asm ("wdr");
; 0000 01F6 outl=1;
; 0000 01F7    }
; 0000 01F8 //   else {
; 0000 01F9 // outl=0;
; 0000 01FA // outr=0;
; 0000 01FB //   }
; 0000 01FC    }
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
;void main(void)
; 0000 020D {
_main:
; 0000 020E // Declare your local variables here
; 0000 020F 
; 0000 0210 // Input/Output Ports initialization
; 0000 0211 // Port A initialization
; 0000 0212 // Func7=In Func6=Out Func5=Out Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0213 // State7=T State6=0 State5=0 State4=T State3=0 State2=0 State1=0 State0=0
; 0000 0214 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0215 DDRA=0x6F;
	LDI  R30,LOW(111)
	OUT  0x1A,R30
; 0000 0216 
; 0000 0217 // Port B initialization
; 0000 0218 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 0219 // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 021A PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 021B DDRB=0xF0;
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 021C 
; 0000 021D // Port C initialization
; 0000 021E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 021F // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0220 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0221 DDRC=0x00;
	OUT  0x14,R30
; 0000 0222 
; 0000 0223 // Port D initialization
; 0000 0224 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 0225 // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 0226 PORTD=0x00;
	OUT  0x12,R30
; 0000 0227 DDRD=0xF0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 0228 
; 0000 0229 // Port E initialization
; 0000 022A // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 022B // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 022C PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 022D DDRE=0x00;
	OUT  0x2,R30
; 0000 022E 
; 0000 022F // Port F initialization
; 0000 0230 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0231 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0232 PORTF=0x00;
	STS  98,R30
; 0000 0233 DDRF=0x00;
	STS  97,R30
; 0000 0234 
; 0000 0235 // Port G initialization
; 0000 0236 // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0237 // State4=T State3=T State2=T State1=T State0=T
; 0000 0238 PORTG=0x00;
	STS  101,R30
; 0000 0239 DDRG=0x00;
	STS  100,R30
; 0000 023A 
; 0000 023B // Timer/Counter 0 initialization
; 0000 023C // Clock source: System Clock
; 0000 023D // Clock value: 172.800 kHz
; 0000 023E // Mode: Fast PWM top=FFh
; 0000 023F // OC0 output: Non-Inverted PWM
; 0000 0240 ASSR=0x00;
	OUT  0x30,R30
; 0000 0241 TCCR0=0x6C;
	LDI  R30,LOW(108)
	OUT  0x33,R30
; 0000 0242 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0243 OCR0=0x00;
	OUT  0x31,R30
; 0000 0244 
; 0000 0245 // Timer/Counter 1 initialization
; 0000 0246 // Clock source: System Clock
; 0000 0247 // Clock value: 172.800 kHz
; 0000 0248 // Mode: Fast PWM top=00FFh
; 0000 0249 // OC1A output: Non-Inv.
; 0000 024A // OC1B output: Non-Inv.
; 0000 024B // OC1C output: Discon.
; 0000 024C // Noise Canceler: Off
; 0000 024D // Input Capture on Falling Edge
; 0000 024E // Timer 1 Overflow Interrupt: Off
; 0000 024F // Input Capture Interrupt: Off
; 0000 0250 // Compare A Match Interrupt: Off
; 0000 0251 // Compare B Match Interrupt: Off
; 0000 0252 // Compare C Match Interrupt: Off
; 0000 0253 TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 0254 TCCR1B=0x0B;
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 0255 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0256 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0257 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0258 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0259 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 025A OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 025B OCR1BH=0x00;
	OUT  0x29,R30
; 0000 025C OCR1BL=0x00;
	OUT  0x28,R30
; 0000 025D OCR1CH=0x00;
	STS  121,R30
; 0000 025E OCR1CL=0x00;
	STS  120,R30
; 0000 025F 
; 0000 0260 // Timer/Counter 2 initialization
; 0000 0261 // Clock source: System Clock
; 0000 0262 // Clock value: 172.800 kHz
; 0000 0263 // Mode: Fast PWM top=FFh
; 0000 0264 // OC2 output: Non-Inverted PWM
; 0000 0265 TCCR2=0x6B;
	LDI  R30,LOW(107)
	OUT  0x25,R30
; 0000 0266 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0267 OCR2=0x00;
	OUT  0x23,R30
; 0000 0268 
; 0000 0269 // Timer/Counter 3 initialization
; 0000 026A // Clock source: System Clock
; 0000 026B // Clock value: Timer 3 Stopped
; 0000 026C // Mode: Normal top=FFFFh
; 0000 026D // Noise Canceler: Off
; 0000 026E // Input Capture on Falling Edge
; 0000 026F // OC3A output: Discon.
; 0000 0270 // OC3B output: Discon.
; 0000 0271 // OC3C output: Discon.
; 0000 0272 // Timer 3 Overflow Interrupt: Off
; 0000 0273 // Input Capture Interrupt: Off
; 0000 0274 // Compare A Match Interrupt: Off
; 0000 0275 // Compare B Match Interrupt: Off
; 0000 0276 // Compare C Match Interrupt: Off
; 0000 0277 TCCR3A=0x00;
	STS  139,R30
; 0000 0278 TCCR3B=0x00;
	STS  138,R30
; 0000 0279 TCNT3H=0x00;
	STS  137,R30
; 0000 027A TCNT3L=0x00;
	STS  136,R30
; 0000 027B ICR3H=0x00;
	STS  129,R30
; 0000 027C ICR3L=0x00;
	STS  128,R30
; 0000 027D OCR3AH=0x00;
	STS  135,R30
; 0000 027E OCR3AL=0x00;
	STS  134,R30
; 0000 027F OCR3BH=0x00;
	STS  133,R30
; 0000 0280 OCR3BL=0x00;
	STS  132,R30
; 0000 0281 OCR3CH=0x00;
	STS  131,R30
; 0000 0282 OCR3CL=0x00;
	STS  130,R30
; 0000 0283 
; 0000 0284 // External Interrupt(s) initialization
; 0000 0285 // INT0: Off
; 0000 0286 // INT1: Off
; 0000 0287 // INT2: Off
; 0000 0288 // INT3: Off
; 0000 0289 // INT4: Off
; 0000 028A // INT5: Off
; 0000 028B // INT6: Off
; 0000 028C // INT7: Off
; 0000 028D EICRA=0x00;
	STS  106,R30
; 0000 028E EICRB=0x00;
	OUT  0x3A,R30
; 0000 028F EIMSK=0x00;
	OUT  0x39,R30
; 0000 0290 
; 0000 0291 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0292 TIMSK=0x00;
	OUT  0x37,R30
; 0000 0293 ETIMSK=0x00;
	STS  125,R30
; 0000 0294 
; 0000 0295 // USART1 initialization
; 0000 0296 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0297 // USART1 Receiver: On
; 0000 0298 // USART1 Transmitter: On
; 0000 0299 // USART1 Mode: Asynchronous
; 0000 029A // USART1 Baud Rate: 9600
; 0000 029B UCSR1A=0x00;
	STS  155,R30
; 0000 029C UCSR1B=0x98;
	LDI  R30,LOW(152)
	STS  154,R30
; 0000 029D UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 029E UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 029F UBRR1L=0x47;
	LDI  R30,LOW(71)
	STS  153,R30
; 0000 02A0 
; 0000 02A1 // Analog Comparator initialization
; 0000 02A2 // Analog Comparator: Off
; 0000 02A3 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 02A4 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02A5 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 02A6 
; 0000 02A7 // ADC initialization
; 0000 02A8 // ADC Clock frequency: 691.200 kHz
; 0000 02A9 // ADC Voltage Reference: AVCC pin
; 0000 02AA ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 02AB ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 02AC 
; 0000 02AD // I2C Bus initialization
; 0000 02AE i2c_init();
	CALL _i2c_init
; 0000 02AF 
; 0000 02B0 // LCD module initialization
; 0000 02B1 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 02B2 
; 0000 02B3 // Watchdog Timer initialization
; 0000 02B4 // Watchdog Timer Prescaler: OSC/16k
; 0000 02B5 #pragma optsize-
; 0000 02B6 WDTCR=0x18;
	LDI  R30,LOW(24)
	OUT  0x21,R30
; 0000 02B7 WDTCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x21,R30
; 0000 02B8 #ifdef _OPTIMIZE_SIZE_
; 0000 02B9 #pragma optsize+
; 0000 02BA #endif
; 0000 02BB 
; 0000 02BC // Global enable interrupts
; 0000 02BD #asm("sei")
	sei
; 0000 02BE if (PINA.4==1){
	LDI  R26,0
	SBIC 0x19,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xB5
; 0000 02BF c=compass_read(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _compass_read
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	LDI  R31,0
	CALL __EEPROMWRW
; 0000 02C0 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 02C1 }
; 0000 02C2 
; 0000 02C3 while (1)
_0xB5:
_0xB6:
; 0000 02C4       {
; 0000 02C5 
; 0000 02C6      // compass();
; 0000 02C7       sensor();
	CALL _sensor
; 0000 02C8      // sharp();
; 0000 02C9       //out();
; 0000 02CA 
; 0000 02CB 
; 0000 02CC 
; 0000 02CD        if(adc[min]<900 ){
	CALL SUBOPT_0x5
	CPI  R30,LOW(0x384)
	LDI  R26,HIGH(0x384)
	CPC  R31,R26
	BRGE _0xB9
; 0000 02CE        follow();
	RCALL _follow
; 0000 02CF        #asm("wdr") ;
	wdr
; 0000 02D0 
; 0000 02D1 
; 0000 02D2        }
; 0000 02D3 
; 0000 02D4 
; 0000 02D5        else if (adc[min]>900 ){
	RJMP _0xBA
_0xB9:
	CALL SUBOPT_0x5
	CPI  R30,LOW(0x385)
	LDI  R26,HIGH(0x385)
	CPC  R31,R26
	BRLT _0xBB
; 0000 02D6 
; 0000 02D7      // sahmi();
; 0000 02D8      motor(0+cmp,0+cmp,0+cmp,0+cmp);
	MOVW R30,R4
	ADIW R30,0
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	ST   -Y,R31
	ST   -Y,R30
	CALL _motor
; 0000 02D9 
; 0000 02DA       }
; 0000 02DB 
; 0000 02DC 
; 0000 02DD 
; 0000 02DE 
; 0000 02DF 
; 0000 02E0 
; 0000 02E1 
; 0000 02E2 
; 0000 02E3 
; 0000 02E4 
; 0000 02E5 
; 0000 02E6 
; 0000 02E7 
; 0000 02E8 
; 0000 02E9            ////////////chap
; 0000 02EA //        while (l==1 /*&& outl==1*/){
; 0000 02EB //
; 0000 02EC //   #asm("wdr") ;
; 0000 02ED 
; 0000 02EE //
; 0000 02EF //
; 0000 02F0 //
; 0000 02F1 //
; 0000 02F2 //if(kaf[12]<400  ) {
; 0000 02F3 //cmp=-cmp;
; 0000 02F4 //
; 0000 02F5 //motor(0+(cmp*0.5),0+(cmp*0.5),0+(cmp*0.5),0+(cmp*0.5));
; 0000 02F6 //#asm("wdr") ;
; 0000 02F7 //}
; 0000 02F8 
; 0000 02F9 // if(kaf[13]<300  ){
; 0000 02FA //
; 0000 02FB // motor(0+(cmp*0.5),0+(cmp*0.5),0+(cmp*0.5),0+(cmp*0.5));
; 0000 02FC // #asm("wdr") ;
; 0000 02FD //}
; 0000 02FE 
; 0000 02FF 
; 0000 0300 //else if(kaf[14]<300  ){
; 0000 0301 //
; 0000 0302 // motor(0+cmp,0+cmp,0+cmp,0+cmp);
; 0000 0303 //
; 0000 0304 // #asm("wdr") ;
; 0000 0305 //}
; 0000 0306 
; 0000 0307 
; 0000 0308 //
; 0000 0309 //
; 0000 030A // if(( kaf[15]<400  )  && (min>=8 && min<16)  /*&& SL>33088*/   ){
; 0000 030B //
; 0000 030C //
; 0000 030D // motor((255+cmp)/2,(-255+cmp)/2,(-255+cmp)/2,(255+cmp)/2);
; 0000 030E // #asm("wdr") ;
; 0000 030F 
; 0000 0310 //   }
; 0000 0311 //
; 0000 0312 
; 0000 0313 //
; 0000 0314 //
; 0000 0315 
; 0000 0316 //
; 0000 0317 // else if ( min<8 && min>0  ) {
; 0000 0318 //
; 0000 0319 // l=0;
; 0000 031A // outl=0;
; 0000 031B // sensor();
; 0000 031C // follow();
; 0000 031D // compass();
; 0000 031E // #asm("wdr") ;
; 0000 031F // }
; 0000 0320 //
; 0000 0321 //
; 0000 0322 // #asm("wdr") ;
; 0000 0323 //compass();
; 0000 0324 // sensor();
; 0000 0325 //   sharp();
; 0000 0326 //
; 0000 0327 // }
; 0000 0328 //
; 0000 0329   //////rast
; 0000 032A // while (r==1 /*&& outr==1*/) {
; 0000 032B //
; 0000 032C // if(kaf[3]<400 ) {
; 0000 032D //motor(0+cmp,0+cmp,0+cmp,0+cmp);
; 0000 032E // #asm("wdr") ;
; 0000 032F //}
; 0000 0330 //
; 0000 0331 // if(kaf[2]<300 ) {
; 0000 0332 //motor(0+cmp,0+cmp,0+cmp,0+cmp);
; 0000 0333 // #asm("wdr") ;
; 0000 0334 //}
; 0000 0335 //
; 0000 0336 // if(( kaf[0]<400 || kaf[1]<300) &&( min>=0 && min<=8) /*&& SR>280*/){
; 0000 0337 //
; 0000 0338 // motor((-255+cmp)/4,(255+cmp)/4,(255+cmp)/4,(-255+cmp)/4);
; 0000 0339 //
; 0000 033A // #asm("wdr") ;
; 0000 033B //
; 0000 033C // }
; 0000 033D 
; 0000 033E 
; 0000 033F // else if (min>8 && min<16   ) {
; 0000 0340 //   r=0;
; 0000 0341 //   outr=0;
; 0000 0342 //    sensor();
; 0000 0343 // follow();
; 0000 0344 // #asm("wdr") ;
; 0000 0345 // }
; 0000 0346 //
; 0000 0347 //
; 0000 0348 //
; 0000 0349 // #asm("wdr") ;
; 0000 034A // compass();
; 0000 034B // sensor();
; 0000 034C // sharp();
; 0000 034D // }
; 0000 034E 
; 0000 034F 
; 0000 0350 
; 0000 0351 
; 0000 0352 
; 0000 0353         //////////////////////////12 13 14 15 left
; 0000 0354         /////////////////////////////0 1 2 3          right
; 0000 0355         ///////////////////////////////// 4 5 6 7 back
; 0000 0356         ///////////////////////////   8 9 10 11 front
; 0000 0357 
; 0000 0358 
; 0000 0359 
; 0000 035A       };
_0xBB:
_0xBA:
	RJMP _0xB6
; 0000 035B }
_0xBC:
	RJMP _0xBC
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
	CALL SUBOPT_0x0
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
_0x2080002:
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
	CALL SUBOPT_0x0
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	__PUTB1MN __base_y_G101,2
	CALL SUBOPT_0x0
	SUBI R30,LOW(-192)
	SBCI R31,HIGH(-192)
	__PUTB1MN __base_y_G101,3
	CALL SUBOPT_0x12
	CALL SUBOPT_0x12
	CALL SUBOPT_0x12
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	CALL SUBOPT_0x13
	LDI  R30,LOW(4)
	CALL SUBOPT_0x13
	LDI  R30,LOW(133)
	CALL SUBOPT_0x13
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
_r:
	.BYTE 0x2
_l:
	.BYTE 0x2
_outr:
	.BYTE 0x2
_outl:
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
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	IN   R30,0x6
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	LDS  R26,_i
	LDS  R27,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDS  R30,_i
	LDS  R31,_i+1
	LDI  R26,LOW(_adc)
	LDI  R27,HIGH(_adc)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x5:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R26,_min
	LDS  R27,_min+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x7:
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	ADIW R30,48
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	CALL __MODW21
	ADIW R30,48
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x9:
	LDS  R26,_min
	LDS  R27,_min+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0xA:
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	ADIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
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

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
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

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

;END OF CODE MARKER
__END_OF_CODE:
