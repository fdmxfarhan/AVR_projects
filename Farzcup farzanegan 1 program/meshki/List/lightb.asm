
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

_0x152:
	.DB  0x0,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x0A
	.DW  _0x152*2

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
	ADIW R28,2
	RET
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
; 0000 0065     if (data=='2'){
	CPI  R16,50
	BRNE _0x6
; 0000 0066    lcd_gotoxy(12,1);
	CALL SUBOPT_0x0
; 0000 0067    lcd_putchar('2');
	LDI  R30,LOW(50)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0068    t=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R10,R30
; 0000 0069    }
; 0000 006A    else    if (data=='1'){
	RJMP _0x7
_0x6:
	CPI  R16,49
	BRNE _0x8
; 0000 006B    lcd_gotoxy(12,1);
	CALL SUBOPT_0x0
; 0000 006C    lcd_putchar('1');
	LDI  R30,LOW(49)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 006D    t=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 006E    }
; 0000 006F      else    if (data=='3'){
	RJMP _0x9
_0x8:
	CPI  R16,51
	BRNE _0xA
; 0000 0070    lcd_gotoxy(12,1);
	CALL SUBOPT_0x0
; 0000 0071    lcd_putchar('3');
	LDI  R30,LOW(51)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0072    t=3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R10,R30
; 0000 0073    }
; 0000 0074     else {
	RJMP _0xB
_0xA:
; 0000 0075    lcd_gotoxy(12,1);
	CALL SUBOPT_0x0
; 0000 0076    lcd_putchar('n');
	LDI  R30,LOW(110)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0077    t=0;}
	CLR  R10
	CLR  R11
_0xB:
_0x9:
_0x7:
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
_putchar1:
; 0000 008D while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
_0x10:
	LDS  R30,155
	LDI  R31,0
	ANDI R30,LOW(0x20)
	BREQ _0x10
; 0000 008E UDR1=c;
	LD   R30,Y
	STS  156,R30
; 0000 008F }
	RJMP _0x2080002
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
	CALL SUBOPT_0x1
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 009A // Delay needed for the stabilization of the ADC input voltage
; 0000 009B delay_us(10);
	__DELAY_USB 37
; 0000 009C // Start the AD conversion
; 0000 009D ADCSRA|=0x40;
	CALL SUBOPT_0x2
	ORI  R30,0x40
	OUT  0x6,R30
; 0000 009E // Wait for the AD conversion to complete
; 0000 009F while ((ADCSRA & 0x10)==0);
_0x13:
	CALL SUBOPT_0x2
	ANDI R30,LOW(0x10)
	BREQ _0x13
; 0000 00A0 ADCSRA|=0x10;
	CALL SUBOPT_0x2
	ORI  R30,0x10
	OUT  0x6,R30
; 0000 00A1 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
_0x2080002:
	ADIW R28,1
	RET
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
	BRGE _0x16
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00AA if(ML2<-255) ML2=-255;
_0x16:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x17
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00AB if(MR1<-255) MR1=-255;
_0x17:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x18
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00AC if(MR2<-255) MR2=-255;
_0x18:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x19
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00AD 
; 0000 00AE if(ML1>255) ML1=255;
_0x19:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1A
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00AF if(ML2>255) ML2=255;
_0x1A:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1B
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00B0 if(MR1>255) MR1=255;
_0x1B:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1C
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00B1 if(MR2>255) MR2=255;
_0x1C:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1D
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00B2 /////////////////////////////////
; 0000 00B3 if(ML1>=0){
_0x1D:
	LDD  R26,Y+7
	TST  R26
	BRMI _0x1E
; 0000 00B4 PORTD.7=0;
	CBI  0x12,7
; 0000 00B5 OCR2=ML1;}
	RJMP _0x146
; 0000 00B6 else if(ML1<0){
_0x1E:
	LDD  R26,Y+7
	TST  R26
	BRPL _0x22
; 0000 00B7 PORTD.7=1;
	SBI  0x12,7
; 0000 00B8 OCR2=ML1;}
_0x146:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	OUT  0x23,R30
; 0000 00B9 
; 0000 00BA 
; 0000 00BB 
; 0000 00BC      /////////////////////////
; 0000 00BD if(ML2>=0){
_0x22:
	LDD  R26,Y+5
	TST  R26
	BRMI _0x25
; 0000 00BE PORTD.6=0;
	CBI  0x12,6
; 0000 00BF OCR1B=ML2;
	RJMP _0x147
; 0000 00C0 }
; 0000 00C1 else if(ML2<0){
_0x25:
	LDD  R26,Y+5
	TST  R26
	BRPL _0x29
; 0000 00C2 PORTD.6=1;
	SBI  0x12,6
; 0000 00C3 OCR1B=ML2;}
_0x147:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00C4 
; 0000 00C5    /////////////////////////
; 0000 00C6 if(MR1>=0){
_0x29:
	LDD  R26,Y+1
	TST  R26
	BRMI _0x2C
; 0000 00C7 PORTD.4=0;
	CBI  0x12,4
; 0000 00C8 OCR0=MR1;}
	RJMP _0x148
; 0000 00C9 else if(MR1<0){
_0x2C:
	LDD  R26,Y+1
	TST  R26
	BRPL _0x30
; 0000 00CA PORTD.4=1;
	SBI  0x12,4
; 0000 00CB OCR0=MR1;}
_0x148:
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x31,R30
; 0000 00CC 
; 0000 00CD  ////////////////////////
; 0000 00CE  if(MR2>=0){
_0x30:
	LDD  R26,Y+3
	TST  R26
	BRMI _0x33
; 0000 00CF PORTD.5=0;
	CBI  0x12,5
; 0000 00D0 OCR1A=MR2;}
	RJMP _0x149
; 0000 00D1 else if(MR2<0){
_0x33:
	LDD  R26,Y+3
	TST  R26
	BRPL _0x37
; 0000 00D2 PORTD.5=1;
	SBI  0x12,5
; 0000 00D3 OCR1A=MR2;}
_0x149:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00D4 #asm("wdr") ;
_0x37:
	wdr
; 0000 00D5 #asm("sei")
	sei
; 0000 00D6 }
	ADIW R28,8
	RET
;
;
;
;
;int SL,SR,SB,RL,sum=0;
;      void sharp(){
; 0000 00DC void sharp(){
_sharp:
; 0000 00DD       #asm("cli")
	cli
; 0000 00DE        #asm("wdr") ;
	wdr
; 0000 00DF 
; 0000 00E0       SB=read_adc(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _read_adc
	STS  _SB,R30
	STS  _SB+1,R31
; 0000 00E1       SR=read_adc(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	STS  _SR,R30
	STS  _SR+1,R31
; 0000 00E2       SL=read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R12,R30
; 0000 00E3 
; 0000 00E4        lcd_gotoxy(13,1);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x3
; 0000 00E5       lcd_putchar((SR/100)%10+'0');
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
; 0000 00E6       lcd_putchar((SR/10)%10+'0');
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
; 0000 00E7       lcd_putchar((SR/1)%10+'0');
	CALL SUBOPT_0x4
	CALL SUBOPT_0x7
; 0000 00E8         lcd_gotoxy(8,0);
	CALL SUBOPT_0x8
; 0000 00E9       lcd_putchar((SB/100)%10+'0');
	CALL SUBOPT_0x9
	CALL SUBOPT_0x5
; 0000 00EA       lcd_putchar((SB/10)%10+'0');
	CALL SUBOPT_0x9
	CALL SUBOPT_0x6
; 0000 00EB       lcd_putchar((SB/1)%10+'0');
	CALL SUBOPT_0x9
	CALL SUBOPT_0x7
; 0000 00EC 
; 0000 00ED        lcd_gotoxy(8,1);
	CALL SUBOPT_0x3
; 0000 00EE       lcd_putchar((SL/100)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0x5
; 0000 00EF       lcd_putchar((SL/10)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0x6
; 0000 00F0       lcd_putchar((SL/1)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0xA
; 0000 00F1 
; 0000 00F2        #asm("wdr") ;
	wdr
; 0000 00F3        RL=(SR-SL);
	LDS  R30,_SR
	LDS  R31,_SR+1
	SUB  R30,R12
	SBC  R31,R13
	CALL SUBOPT_0xB
; 0000 00F4        sum= SR+SL;
	MOVW R30,R12
	CALL SUBOPT_0x4
	ADD  R30,R26
	ADC  R31,R27
	STS  _sum,R30
	STS  _sum+1,R31
; 0000 00F5          RL=(SR-SL)/2;
	CALL SUBOPT_0x4
	SUB  R26,R12
	SBC  R27,R13
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 00F6 
; 0000 00F7        if(RL>-80 && RL<80) RL=0;
	LDI  R30,LOW(65456)
	LDI  R31,HIGH(65456)
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x3B
	CALL SUBOPT_0xE
	CPI  R26,LOW(0x50)
	LDI  R30,HIGH(0x50)
	CPC  R27,R30
	BRLT _0x3C
_0x3B:
	RJMP _0x3A
_0x3C:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0xB
; 0000 00F8 //       if (RL<50 && RL>-50) RL=0;
; 0000 00F9          if(RL>0) RL=RL*1.5;
_0x3A:
	CALL SUBOPT_0xF
	BRGE _0x3D
	CALL SUBOPT_0x10
	__GETD2N 0x3FC00000
	RJMP _0x14A
; 0000 00FA        else if(RL<0) RL=RL*0.8;
_0x3D:
	LDS  R26,_RL+1
	TST  R26
	BRPL _0x3F
	CALL SUBOPT_0x10
	__GETD2N 0x3F4CCCCD
_0x14A:
	CALL __MULF12
	LDI  R26,LOW(_RL)
	LDI  R27,HIGH(_RL)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 00FB 
; 0000 00FC 
; 0000 00FD      //  if(RL>-100 && RL<100) RL=0;
; 0000 00FE //       if(RL>0)
; 0000 00FF //       {
; 0000 0100 //       lcd_gotoxy(0,1);
; 0000 0101 //       lcd_putchar('+');
; 0000 0102 //       lcd_putchar((RL/100)%10+'0');
; 0000 0103 //       lcd_putchar((RL/10)%10+'0');
; 0000 0104 //       lcd_putchar((RL/1)%10+'0');
; 0000 0105 //                }
; 0000 0106 //               else  if(RL<0)
; 0000 0107 //               {
; 0000 0108 //       lcd_gotoxy(0,1);
; 0000 0109 //       lcd_putchar('-');
; 0000 010A //       lcd_putchar((-RL/100)%10+'0');
; 0000 010B //       lcd_putchar((-RL/10)%10+'0');
; 0000 010C //       lcd_putchar((-RL/1)%10+'0');
; 0000 010D //                }
; 0000 010E       #asm("sei")
_0x3F:
	sei
; 0000 010F      }
	RET
;
;
;   int adc[16],min=0,i,kaf[16],mini=0,r=0,l=0,f=0,b=0,back=0,h=0;
;      void sensor() {
; 0000 0113 void sensor() {
_sensor:
; 0000 0114        #asm("cli")
	cli
; 0000 0115 
; 0000 0116     for(i=0;i<16;i++)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _i,R30
	STS  _i+1,R31
_0x41:
	CALL SUBOPT_0x11
	SBIW R26,16
	BRLT PC+3
	JMP _0x42
; 0000 0117      {
; 0000 0118      #asm("wdr") ;
	wdr
; 0000 0119  PORTA.3=(i/8)%2;
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
; 0000 011A  PORTA.2=(i/4)%2;
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
; 0000 011B  PORTA.1=(i/2)%2;
	CALL SUBOPT_0x11
	CALL SUBOPT_0xC
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	CPI  R30,0
	BRNE _0x47
	CBI  0x1B,1
	RJMP _0x48
_0x47:
	SBI  0x1B,1
_0x48:
; 0000 011C  PORTA.0=(i/1)%2;
	CALL SUBOPT_0x11
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	CPI  R30,0
	BRNE _0x49
	CBI  0x1B,0
	RJMP _0x4A
_0x49:
	SBI  0x1B,0
_0x4A:
; 0000 011D   adc[i]=read_adc(7);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
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
; 0000 011E   kaf[i]=read_adc(6);
	CALL SUBOPT_0x15
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 011F ////////////////////////////////////////////////////////////moghayese
; 0000 0120   if (adc[i]<adc[min])
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X+
	LD   R1,X
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	BRGE _0x4B
; 0000 0121   {  min=i;  }
	CALL SUBOPT_0x13
	STS  _min,R30
	STS  _min+1,R31
; 0000 0122 
; 0000 0123    if (kaf[i]<kaf[mini])
_0x4B:
	CALL SUBOPT_0x15
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X+
	LD   R1,X
	CALL SUBOPT_0x18
	CALL SUBOPT_0x17
	BRGE _0x4C
; 0000 0124    {
; 0000 0125 
; 0000 0126    mini=i;  }
	CALL SUBOPT_0x13
	STS  _mini,R30
	STS  _mini+1,R31
; 0000 0127 
; 0000 0128  }
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
; 0000 0129 h=(adc[15]+adc[1]+adc[0])/3;
	CALL SUBOPT_0x19
	__GETW1MN _adc,2
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x1A
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __DIVW21
	STS  _h,R30
	STS  _h+1,R31
; 0000 012A  ///////////////////////////////////////////////////////////chap
; 0000 012B   lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8
; 0000 012C   lcd_putchar((min/10)%10+'0');
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x6
; 0000 012D   lcd_putchar((min/1)%10+'0');
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA
; 0000 012E   lcd_putchar('=');
	LDI  R30,LOW(61)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 012F   lcd_putchar((adc[min]/1000)%10+'0');
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
; 0000 0130   lcd_putchar((adc[min]/100)%10+'0');
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x5
; 0000 0131   lcd_putchar((adc[min]/10)%10+'0');
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x6
; 0000 0132   lcd_putchar((adc[min]/1)%10+'0');
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1C
	CALL SUBOPT_0xA
; 0000 0133  #asm("wdr") ;
	wdr
; 0000 0134 
; 0000 0135  lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
; 0000 0136   lcd_putchar((mini/10)%10+'0');
	LDS  R26,_mini
	LDS  R27,_mini+1
	CALL SUBOPT_0x6
; 0000 0137   lcd_putchar((mini/1)%10+'0');
	LDS  R26,_mini
	LDS  R27,_mini+1
	CALL SUBOPT_0xA
; 0000 0138   lcd_putchar('=');
	LDI  R30,LOW(61)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0139   lcd_putchar((kaf[mini]/1000)%10+'0');
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
; 0000 013A   lcd_putchar((kaf[mini]/100)%10+'0');
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x5
; 0000 013B   lcd_putchar((kaf[mini]/10)%10+'0');
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x6
; 0000 013C   lcd_putchar((kaf[mini]/1)%10+'0');
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1C
	CALL SUBOPT_0xA
; 0000 013D 
; 0000 013E   if((kaf[12]<400 || kaf[13]<400 || kaf[14]<400 || kaf[15]<400) && (kaf[0]<400 || kaf[1]<400 || kaf[2]<400 || kaf[3]<400)  && r==0 && l==0 )
	CALL SUBOPT_0x1E
	BRLT _0x4E
	CALL SUBOPT_0x1F
	BRLT _0x4E
	CALL SUBOPT_0x20
	BRLT _0x4E
	CALL SUBOPT_0x21
	BRGE _0x50
_0x4E:
	CALL SUBOPT_0x22
	BRLT _0x51
	CALL SUBOPT_0x23
	BRLT _0x51
	CALL SUBOPT_0x24
	BRLT _0x51
	CALL SUBOPT_0x25
	BRGE _0x50
_0x51:
	CALL SUBOPT_0x26
	SBIW R26,0
	BRNE _0x50
	CALL SUBOPT_0x27
	SBIW R26,0
	BREQ _0x53
_0x50:
	RJMP _0x4D
_0x53:
; 0000 013F    {
; 0000 0140    if (adc[min]<900 && ((min>11 && min<16 )||( min>=0 && min<5 ))&& f==0 && (kaf[8]<400 || kaf[9]<400 || kaf[10]<400 || kaf[11]<400)) {
	CALL SUBOPT_0x16
	CALL SUBOPT_0x28
	CPI  R30,LOW(0x384)
	LDI  R26,HIGH(0x384)
	CPC  R31,R26
	BRGE _0x55
	CALL SUBOPT_0x1B
	SBIW R26,12
	BRLT _0x56
	CALL SUBOPT_0x1B
	SBIW R26,16
	BRLT _0x58
_0x56:
	LDS  R26,_min+1
	TST  R26
	BRMI _0x59
	CALL SUBOPT_0x1B
	SBIW R26,5
	BRLT _0x58
_0x59:
	RJMP _0x55
_0x58:
	CALL SUBOPT_0x29
	SBIW R26,0
	BRNE _0x55
	__GETW2MN _kaf,16
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x5C
	__GETW2MN _kaf,18
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x5C
	__GETW2MN _kaf,20
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x5C
	__GETW2MN _kaf,22
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRGE _0x55
_0x5C:
	RJMP _0x5E
_0x55:
	RJMP _0x54
_0x5E:
; 0000 0141 
; 0000 0142 
; 0000 0143 
; 0000 0144    f=1;
	CALL SUBOPT_0x2A
; 0000 0145 
; 0000 0146    #asm("wdr") ;
	wdr
; 0000 0147    }
; 0000 0148 
; 0000 0149    }
_0x54:
; 0000 014A 
; 0000 014B     if ((kaf[0]<400 || kaf[1]<400 || kaf[2]<400 || kaf[3]<400)  ) r=1;  //  && l==0
_0x4D:
	CALL SUBOPT_0x22
	BRLT _0x60
	CALL SUBOPT_0x23
	BRLT _0x60
	CALL SUBOPT_0x24
	BRLT _0x60
	CALL SUBOPT_0x25
	BRGE _0x5F
_0x60:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x2B
; 0000 014C 
; 0000 014D 
; 0000 014E       if ((kaf[12]<400 || kaf[13]<400 || kaf[14]<400 || kaf[15]<400))  l=1;
_0x5F:
	CALL SUBOPT_0x1E
	BRLT _0x63
	CALL SUBOPT_0x1F
	BRLT _0x63
	CALL SUBOPT_0x20
	BRLT _0x63
	CALL SUBOPT_0x21
	BRGE _0x62
_0x63:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x2C
; 0000 014F //  if (kaf[4]<300 || kaf[5]<300 || kaf[6]<400 || kaf[7]<300 )  b=1;
; 0000 0150 
; 0000 0151       if ((f==1 || b==1) && (r==1|| l==1 ) ){
_0x62:
	CALL SUBOPT_0x29
	SBIW R26,1
	BREQ _0x66
	LDS  R26,_b
	LDS  R27,_b+1
	SBIW R26,1
	BRNE _0x68
_0x66:
	CALL SUBOPT_0x26
	SBIW R26,1
	BREQ _0x69
	CALL SUBOPT_0x27
	SBIW R26,1
	BRNE _0x68
_0x69:
	RJMP _0x6B
_0x68:
	RJMP _0x65
_0x6B:
; 0000 0152      f=0;
	CALL SUBOPT_0x2D
; 0000 0153      //b=0;
; 0000 0154      }
; 0000 0155      if (r==1 && l==1) {
_0x65:
	CALL SUBOPT_0x26
	SBIW R26,1
	BRNE _0x6D
	CALL SUBOPT_0x27
	SBIW R26,1
	BREQ _0x6E
_0x6D:
	RJMP _0x6C
_0x6E:
; 0000 0156      r=0;
	CALL SUBOPT_0x2E
; 0000 0157      l=0;
	CALL SUBOPT_0x2C
; 0000 0158      if (min>=4 && min<=12) b=1;
	CALL SUBOPT_0x1B
	SBIW R26,4
	BRLT _0x70
	CALL SUBOPT_0x1B
	SBIW R26,13
	BRLT _0x71
_0x70:
	RJMP _0x6F
_0x71:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _b,R30
	STS  _b+1,R31
; 0000 0159      else f=1;
	RJMP _0x72
_0x6F:
	CALL SUBOPT_0x2A
; 0000 015A      }
_0x72:
; 0000 015B 
; 0000 015C 
; 0000 015D    }
_0x6C:
	RET
;
;
;
;
;
;
;
;//    #asm("sei")
;//    }
;
;   void compass() {
; 0000 0168 void compass() {
_compass:
; 0000 0169  #asm("cli")
	cli
; 0000 016A  #asm ("wdr");
	wdr
; 0000 016B cmp=compass_read(1)-c;
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
; 0000 016C         lcd_gotoxy(12,0);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x8
; 0000 016D       if(cmp<0) cmp=cmp;
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRGE _0x73
	MOVW R4,R4
; 0000 016E       if(cmp>128) cmp=cmp-255;
_0x73:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x74
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	__SUBWRR 4,5,30,31
; 0000 016F       if(cmp<-128) cmp=cmp+255;
_0x74:
	LDI  R30,LOW(65408)
	LDI  R31,HIGH(65408)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x75
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	MOVW R4,R30
; 0000 0170 
; 0000 0171       if(cmp>=0)
_0x75:
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRLT _0x76
; 0000 0172       {  #asm ("wdr");
	wdr
; 0000 0173        lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x8
; 0000 0174       lcd_putchar('+');
	LDI  R30,LOW(43)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0175       lcd_putchar((cmp/100)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0x5
; 0000 0176       lcd_putchar((cmp/10)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0x6
; 0000 0177       lcd_putchar((cmp/1)%10+'0');
	MOVW R26,R4
	RJMP _0x14B
; 0000 0178       }
; 0000 0179       else if(cmp<0)
_0x76:
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRGE _0x78
; 0000 017A       {  #asm ("wdr");
	wdr
; 0000 017B        lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x8
; 0000 017C       lcd_putchar('-');
	LDI  R30,LOW(45)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 017D       lcd_putchar((-cmp/100)%10+'0');
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x5
; 0000 017E       lcd_putchar((-cmp/10)%10+'0');
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x6
; 0000 017F       lcd_putchar((-cmp/1)%10+'0');
	CALL SUBOPT_0x2F
_0x14B:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	ADIW R30,48
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0180       }
; 0000 0181 
; 0000 0182 //      if(25>cmp&&-25<cmp)   cmp=-2.5*cmp;
; 0000 0183 //
; 0000 0184 //     else                  cmp=-cmp;
; 0000 0185 
; 0000 0186 
; 0000 0187 
; 0000 0188 
; 0000 0189 
; 0000 018A ////abi
; 0000 018B //if(cmp>-40 && cmp<60) cmp=-cmp*2;
; 0000 018C // else cmp=-cmp*2.5;
; 0000 018D if(cmp>-40 && cmp<10) cmp=-cmp*2;
_0x78:
	LDI  R30,LOW(65496)
	LDI  R31,HIGH(65496)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x7A
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R4,R30
	CPC  R5,R31
	BRLT _0x7B
_0x7A:
	RJMP _0x79
_0x7B:
	MOVW R30,R4
	CALL __ANEGW1
	LSL  R30
	ROL  R31
	RJMP _0x14C
; 0000 018E else cmp=-cmp;
_0x79:
	MOVW R30,R4
	CALL __ANEGW1
_0x14C:
	MOVW R4,R30
; 0000 018F 
; 0000 0190 
; 0000 0191       #asm ("wdr");
	wdr
; 0000 0192       #asm("sei") }
	sei
	RET
;
;
;  void sahmi()
; 0000 0196           {
_sahmi:
; 0000 0197 
; 0000 0198 
; 0000 0199 
; 0000 019A 
; 0000 019B 
; 0000 019C           if(SB<190)
	CALL SUBOPT_0x9
	CPI  R26,LOW(0xBE)
	LDI  R30,HIGH(0xBE)
	CPC  R27,R30
	BRGE _0x7D
; 0000 019D            {
; 0000 019E           motor(-128-RL+cmp,-255+RL+cmp,128+RL-cmp,255-RL+cmp);
	CALL SUBOPT_0x30
; 0000 019F            }
; 0000 01A0 
; 0000 01A1            ///////////////////////////////////////////////////////////////
; 0000 01A2 //           else if(SB>190 && (RL>60 || RL<-60))
; 0000 01A3 //           {
; 0000 01A4           // RL=RL*3;
; 0000 01A5 //          motor(255-RL+cmp,255+RL+cmp,-255+RL+cmp,-255-RL+cmp);
; 0000 01A6 //          }
; 0000 01A7            //////////////////////////////////////////////////////////////
; 0000 01A8            else if(SB>190 && RL<-70 )
	RJMP _0x7E
_0x7D:
	CALL SUBOPT_0x31
	BRLT _0x80
	CALL SUBOPT_0xE
	CPI  R26,LOW(0xFFBA)
	LDI  R30,HIGH(0xFFBA)
	CPC  R27,R30
	BRLT _0x81
_0x80:
	RJMP _0x7F
_0x81:
; 0000 01A9            {
; 0000 01AA            motor((255+cmp)*0.5,(-255+cmp)*0.5,(-255+cmp)*0.5,(255+cmp)*0.5);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	CALL SUBOPT_0x33
	CALL SUBOPT_0x32
	CALL _motor
; 0000 01AB            }
; 0000 01AC             else if(SB>190 && RL>70 )
	RJMP _0x82
_0x7F:
	CALL SUBOPT_0x31
	BRLT _0x84
	CALL SUBOPT_0xE
	CPI  R26,LOW(0x47)
	LDI  R30,HIGH(0x47)
	CPC  R27,R30
	BRGE _0x85
_0x84:
	RJMP _0x83
_0x85:
; 0000 01AD            {
; 0000 01AE            motor((-255+cmp)*0.5,(255+cmp)*0.5,(255+cmp)*0.5,(-255+cmp)*0.5);
	CALL SUBOPT_0x33
	CALL SUBOPT_0x32
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	CALL _motor
; 0000 01AF            if (adc[min]<60  &&( (adc[0]<60) || (adc[15]<60)|| (adc[1]<60)  )  )  t=0;}
	CALL SUBOPT_0x16
	CALL SUBOPT_0x28
	SBIW R30,60
	BRGE _0x87
	CALL SUBOPT_0x1A
	SBIW R26,60
	BRLT _0x88
	CALL SUBOPT_0x19
	SBIW R26,60
	BRLT _0x88
	__GETW2MN _adc,2
	SBIW R26,60
	BRGE _0x87
_0x88:
	RJMP _0x8A
_0x87:
	RJMP _0x86
_0x8A:
	CLR  R10
	CLR  R11
_0x86:
; 0000 01B0 
; 0000 01B1           else  {  motor(0+cmp,0+cmp,0+cmp,0+cmp);
	RJMP _0x8B
_0x83:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x34
	CALL SUBOPT_0x34
	CALL SUBOPT_0x34
	CALL _motor
; 0000 01B2           //t=0;
; 0000 01B3 //          f=0 ;
; 0000 01B4       b=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _b,R30
	STS  _b+1,R31
; 0000 01B5           }
_0x8B:
_0x82:
_0x7E:
; 0000 01B6           }
	RET
;      void follow ()
; 0000 01B8     {
_follow:
; 0000 01B9 
; 0000 01BA           #asm("wdr") ;
	wdr
; 0000 01BB //         if(RL>0) RL=RL*1.5;
; 0000 01BC //          else if(RL<0) RL=RL*4;
; 0000 01BD 
; 0000 01BE 
; 0000 01BF           /////// 15-->13     2--->4      11--->9  10--->   8-->6
; 0000 01C0 
; 0000 01C1         if(min==0 ) {
	LDS  R30,_min
	LDS  R31,_min+1
	SBIW R30,0
	BRNE _0x8C
; 0000 01C2 //        if(RL>=100 && h<50)  motor(255+cmp,-128+cmp,-255+cmp,128+cmp);
; 0000 01C3 //     else if(RL<=-100 && h<50) motor(255+cmp,-64+cmp,-255+cmp,64+cmp);
; 0000 01C4 
; 0000 01C5 
; 0000 01C6 
; 0000 01C7 
; 0000 01C8 
; 0000 01C9 
; 0000 01CA //        if(RL>=100)  motor(255+cmp,-128+cmp,-255+cmp,128+cmp);
; 0000 01CB //       else if(RL<=-100) motor(255+cmp,0+cmp,-255+cmp,0+cmp);
; 0000 01CC //        else
; 0000 01CD 
; 0000 01CE           if (h<150) {
	CALL SUBOPT_0x35
	BRGE _0x8D
; 0000 01CF                    if(RL>0 )  motor(-192,255,192,-255);
	CALL SUBOPT_0xF
	BRGE _0x8E
	CALL SUBOPT_0x36
	RJMP _0x14D
; 0000 01D0                    else if(RL<=0 ) motor(255,-128,-255,128);
_0x8E:
	CALL SUBOPT_0xF
	BRLT _0x90
	CALL SUBOPT_0x37
_0x14D:
	ST   -Y,R31
	ST   -Y,R30
	CALL _motor
; 0000 01D1 
; 0000 01D2             #asm("wdr") ;}
_0x90:
	wdr
; 0000 01D3 
; 0000 01D4             else
	RJMP _0x91
_0x8D:
; 0000 01D5         motor(255+cmp,255+cmp,-255+cmp,-255+cmp);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x39
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3A
; 0000 01D6 
; 0000 01D7           }
_0x91:
; 0000 01D8 
; 0000 01D9          else if(min==1)
	RJMP _0x92
_0x8C:
	CALL SUBOPT_0x1B
	SBIW R26,1
	BRNE _0x93
; 0000 01DA          {
; 0000 01DB 
; 0000 01DC 
; 0000 01DD //         if(RL>=100)  motor(-128-RL+cmp,255+RL+cmp,128+RL+cmp,-255-RL+cmp);
; 0000 01DE //        else if(RL<=-100) motor(255-RL+cmp,128+RL+cmp,-255+RL+cmp,-128-RL+cmp);
; 0000 01DF //
; 0000 01E0 
; 0000 01E1 //     if(RL>=100 && h<50)  motor(255+cmp,-128+cmp,-255+cmp,128+cmp);
; 0000 01E2 //     else if(RL<=-100 && h<50) motor(255+cmp,-64+cmp,-255+cmp,64+cmp);
; 0000 01E3 //
; 0000 01E4 //        else
; 0000 01E5 
; 0000 01E6          if (h<150) {
	CALL SUBOPT_0x35
	BRGE _0x94
; 0000 01E7                    if(RL>0 )  motor(-192,255,192,-255);
	CALL SUBOPT_0xF
	BRGE _0x95
	CALL SUBOPT_0x36
	RJMP _0x14E
; 0000 01E8                    else if(RL<=0 ) motor(255,-128,-255,128);
_0x95:
	CALL SUBOPT_0xF
	BRLT _0x97
	CALL SUBOPT_0x37
_0x14E:
	ST   -Y,R31
	ST   -Y,R30
	CALL _motor
; 0000 01E9 
; 0000 01EA             #asm("wdr") ;}
_0x97:
	wdr
; 0000 01EB 
; 0000 01EC             else
	RJMP _0x98
_0x94:
; 0000 01ED           motor(255+cmp,0+cmp,-255+cmp,0+cmp);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x34
	CALL SUBOPT_0x3B
	CALL _motor
; 0000 01EE 
; 0000 01EF 
; 0000 01F0           }
_0x98:
; 0000 01F1 
; 0000 01F2 
; 0000 01F3            //motor(255,128,-255,-128);
; 0000 01F4          else if(min==2)     motor(128+cmp,-255+cmp,-128+cmp,255+cmp);     //motor(255,0,-255,0);
	RJMP _0x99
_0x93:
	CALL SUBOPT_0x1B
	SBIW R26,2
	BRNE _0x9A
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	CALL _motor
; 0000 01F5          else if(min==3)     motor(0+cmp,-255+cmp,0+cmp,255+cmp);    //motor(255,-128,-255,128);
	RJMP _0x9B
_0x9A:
	CALL SUBOPT_0x1B
	SBIW R26,3
	BRNE _0x9C
	CALL SUBOPT_0x34
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x38
	CALL _motor
; 0000 01F6          else if(min==4)     motor(0+cmp,-255+cmp,0+cmp,255+cmp);         //motor(255,-255,-255,255);
	RJMP _0x9D
_0x9C:
	CALL SUBOPT_0x1B
	SBIW R26,4
	BRNE _0x9E
	CALL SUBOPT_0x34
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x38
	CALL _motor
; 0000 01F7          else if(min==5)     motor(-128+cmp,-255+cmp,128+cmp,255+cmp );    //motor(128,-255,-128,255);
	RJMP _0x9F
_0x9E:
	CALL SUBOPT_0x1B
	SBIW R26,5
	BRNE _0xA0
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3E
	CALL _motor
; 0000 01F8          else if(min==6)     motor(-255+cmp,-255+cmp,255+cmp,255+cmp);    //motor(0,-255,0,255);
	RJMP _0xA1
_0xA0:
	CALL SUBOPT_0x1B
	SBIW R26,6
	BRNE _0xA2
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	CALL _motor
; 0000 01F9          else if(min==7)     motor(-255+cmp,-128+cmp,255+cmp,128+cmp);    //motor(-128,-255,128,255);
	RJMP _0xA3
_0xA2:
	CALL SUBOPT_0x1B
	SBIW R26,7
	BRNE _0xA4
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x3D
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	CALL SUBOPT_0x3A
; 0000 01FA          else if(min==8)     motor(128+cmp,-255+cmp,-128+cmp,255+cmp);    //motor(-255,-255,255,255);
	RJMP _0xA5
_0xA4:
	CALL SUBOPT_0x1B
	SBIW R26,8
	BRNE _0xA6
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	CALL _motor
; 0000 01FB          else if(min==9)     motor(-128+cmp,-255+cmp,128+cmp,255+cmp);        //motor(-255,-128,255,128);
	RJMP _0xA7
_0xA6:
	CALL SUBOPT_0x1B
	SBIW R26,9
	BRNE _0xA8
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3E
	CALL _motor
; 0000 01FC          else if(min==10)    motor(0+cmp,-255+cmp,0+cmp,255+cmp);    //motor(-255,0,255,0);
	RJMP _0xA9
_0xA8:
	CALL SUBOPT_0x1B
	SBIW R26,10
	BRNE _0xAA
	CALL SUBOPT_0x34
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x38
	CALL _motor
; 0000 01FD          else if(min==11)    motor(-255+cmp,-128+cmp,255+cmp,128+cmp);    //motor(-255,128,255,-128);
	RJMP _0xAB
_0xAA:
	CALL SUBOPT_0x1B
	SBIW R26,11
	BRNE _0xAC
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x3D
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	CALL SUBOPT_0x3A
; 0000 01FE          else if(min==12)    motor(-255+cmp,0+cmp,255+cmp,0+cmp);    //motor(-255,255,255,-255);
	RJMP _0xAD
_0xAC:
	CALL SUBOPT_0x1B
	SBIW R26,12
	BRNE _0xAE
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x38
	CALL SUBOPT_0x34
	CALL _motor
; 0000 01FF          else if(min==13)    motor(-128+cmp,255+cmp,128+cmp,-255+cmp);         //motor(-128,255,128,-255);
	RJMP _0xAF
_0xAE:
	CALL SUBOPT_0x1B
	SBIW R26,13
	BRNE _0xB0
	CALL SUBOPT_0x40
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3A
; 0000 0200          else if(min==14)    motor(-255+cmp,255+cmp,255+cmp,-255+cmp);    //motor(0,255,0,-255);
	RJMP _0xB1
_0xB0:
	CALL SUBOPT_0x1B
	SBIW R26,14
	BRNE _0xB2
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x3A
; 0000 0201 
; 0000 0202 
; 0000 0203          else if(min==15)
	RJMP _0xB3
_0xB2:
	CALL SUBOPT_0x1B
	SBIW R26,15
	BRNE _0xB4
; 0000 0204          {
; 0000 0205 
; 0000 0206 //
; 0000 0207 //        if(RL>=100 && h<60)  motor(-128+cmp,255+cmp,128+cmp,-255+cmp);
; 0000 0208 //     else if(RL<=-100 && h<60) motor(255+cmp,-128+cmp,-255+cmp,128+cmp);
; 0000 0209 //
; 0000 020A //
; 0000 020B //
; 0000 020C //
; 0000 020D //        else
; 0000 020E                  if (h<150) {
	CALL SUBOPT_0x35
	BRGE _0xB5
; 0000 020F                    if(RL>0 )  motor(-192,255,192,-255);
	CALL SUBOPT_0xF
	BRGE _0xB6
	CALL SUBOPT_0x36
	RJMP _0x14F
; 0000 0210                    else if(RL<=0 ) motor(255,-128,-255,128);
_0xB6:
	CALL SUBOPT_0xF
	BRLT _0xB8
	CALL SUBOPT_0x37
_0x14F:
	ST   -Y,R31
	ST   -Y,R30
	CALL _motor
; 0000 0211 
; 0000 0212             #asm("wdr") ;}
_0xB8:
	wdr
; 0000 0213          motor(-128+cmp,255+cmp,128+cmp,-255+cmp); //motor(128,255,-128,-255);
_0xB5:
	CALL SUBOPT_0x40
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3A
; 0000 0214 
; 0000 0215 
; 0000 0216 
; 0000 0217          #asm("wdr") ;
	wdr
; 0000 0218           }
; 0000 0219           }
_0xB4:
_0xB3:
_0xB1:
_0xAF:
_0xAD:
_0xAB:
_0xA9:
_0xA7:
_0xA5:
_0xA3:
_0xA1:
_0x9F:
_0x9D:
_0x9B:
_0x99:
_0x92:
	RET
;
;
;       void taghib(){
; 0000 021C void taghib(){
; 0000 021D 
; 0000 021E         #asm("wdr") ;
; 0000 021F           if(min==0)       motor(255,255,-255,-255);
; 0000 0220          else if(min==1)   motor(255,128,-255,-128);
; 0000 0221          else if(min==2)     motor(255,0,-255,0);
; 0000 0222          else if(min==3)     motor(255,-128,-255,128);
; 0000 0223          else if(min==4)    motor(255,-255,-255,255);
; 0000 0224          else if(min==5)    motor(128,-255,-128,255);
; 0000 0225          else if(min==6)     motor(0,-255,0,255);
; 0000 0226          else if(min==7)     motor(-128,-255,128,255);
; 0000 0227          else if(min==8)    motor(-255,-255,255,255);
; 0000 0228          else if(min==9)     motor(-255,-128,255,128);
; 0000 0229          else if(min==10)   motor(-255,0,255,0);
; 0000 022A          else if(min==11)    motor(-255,128,255,-128);
; 0000 022B          else if(min==12)   motor(-255,255,255,-255);
; 0000 022C          else if(min==13)   motor(-128,255,128,-255);
; 0000 022D          else if(min==14)   motor(0,255,0,-255);
; 0000 022E          else if(min==15)  motor(128,255,-128,-255);
; 0000 022F 
; 0000 0230          #asm("wdr") ;
; 0000 0231 
; 0000 0232        }
;        int outr=0,outl=0;
;        void out () {
; 0000 0234 void out () {
_out:
; 0000 0235 //               sensor();
; 0000 0236 //
; 0000 0237 //                if(adc[mini]<350 &&(mini==3 || mini==2 || mini==1 || mini==0)){
; 0000 0238 //          motor(0+cmp,0+cmp,0+cmp,0+cmp);
; 0000 0239 //
; 0000 023A //          if(adc[mini-1]<300  || adc[){
; 0000 023B //          motor(-255+cmp,255+cmp,255+cmp,-255+cmp);
; 0000 023C //          delay_ms(20);
; 0000 023D //          }
; 0000 023E //          }
; 0000 023F //          if(adc[mini]<350 &&(mini==12 || mini==13 || mini==14 || mini==15)){
; 0000 0240 //          motor(0+cmp,0+cmp,0+cmp,0+cmp);
; 0000 0241 //
; 0000 0242 //          if(adc[mini-1]<300 ){
; 0000 0243 //          motor(255+cmp,-255+cmp,-255+cmp,255+cmp);
; 0000 0244 //          delay_ms(20);
; 0000 0245 //          }
; 0000 0246 //          }
; 0000 0247 // if (sum>550 && SR>310 && SL>310 )
; 0000 0248 //t=2;
; 0000 0249 //multi
; 0000 024A //else if (sum>550 && (SR>310 || SL>310) && SB>250){
; 0000 024B //putchar1(3);
; 0000 024C //if (min>=0 && min<9 && t==3) motor (255+cmp,0+cmp,-255+cmp,0+cmp);  ////harekate 2
; 0000 024D //else if (min>8 && min<16 && t==3)    motor(0+cmp,255+cmp,0+cmp,-255+cmp);  /////harekate 14
; 0000 024E //}
; 0000 024F 
; 0000 0250 //
; 0000 0251 //     else  if (sum>550 && (SR>310||SL>310) && SB<250 ) {
; 0000 0252 //
; 0000 0253 //      putchar1(2);
; 0000 0254 //
; 0000 0255 //     }
; 0000 0256       if ((/*sum<550&&*/  SR>250 && SL<100) && ((min>0 && min<8 ) || min==0)  ) {
	CALL SUBOPT_0x4
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0xD9
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R12,R30
	CPC  R13,R31
	BRLT _0xDA
_0xD9:
	RJMP _0xDB
_0xDA:
	CALL SUBOPT_0x1B
	CALL __CPW02
	BRGE _0xDC
	CALL SUBOPT_0x1B
	SBIW R26,8
	BRLT _0xDE
_0xDC:
	CALL SUBOPT_0x1B
	SBIW R26,0
	BRNE _0xDB
_0xDE:
	RJMP _0xE0
_0xDB:
	RJMP _0xD8
_0xE0:
; 0000 0257    #asm ("wdr");
	wdr
; 0000 0258 //  motor(-255+cmp,255+cmp,255+cmp,-255+cmp);
; 0000 0259 //  delay_ms(30);
; 0000 025A //  sr=1;
; 0000 025B //  while (min>=0 && min<9){ motor(0+cmp,0+cmp,0+cmp,0+cmp);
; 0000 025C //  sensor();
; 0000 025D //   compass();
; 0000 025E //  #asm ("wdr");
; 0000 025F //   }
; 0000 0260    outr=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _outr,R30
	STS  _outr+1,R31
; 0000 0261    }
; 0000 0262    ///////////
; 0000 0263      else if ((/*sum<550 &&*/ SL>300 && SR<110 )&& ((min>7 && min<16 ) || min==0) ) {
	RJMP _0xE1
_0xD8:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0xE3
	CALL SUBOPT_0x4
	CPI  R26,LOW(0x6E)
	LDI  R30,HIGH(0x6E)
	CPC  R27,R30
	BRLT _0xE4
_0xE3:
	RJMP _0xE5
_0xE4:
	CALL SUBOPT_0x1B
	SBIW R26,8
	BRLT _0xE6
	CALL SUBOPT_0x1B
	SBIW R26,16
	BRLT _0xE8
_0xE6:
	CALL SUBOPT_0x1B
	SBIW R26,0
	BRNE _0xE5
_0xE8:
	RJMP _0xEA
_0xE5:
	RJMP _0xE2
_0xEA:
; 0000 0264    #asm ("wdr");
	wdr
; 0000 0265 //  motor(255+cmp,-255+cmp,-255+cmp,255+cmp);
; 0000 0266 //  delay_ms(30);
; 0000 0267 //  sr=1;
; 0000 0268 //  while (min>7 && min<16){ motor(0+cmp,0+cmp,0+cmp,0+cmp);
; 0000 0269 //  sensor();
; 0000 026A //   compass();
; 0000 026B //  #asm ("wdr");
; 0000 026C outl=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _outl,R30
	STS  _outl+1,R31
; 0000 026D    }
; 0000 026E //   else {
; 0000 026F // outl=0;
; 0000 0270 // outr=0;
; 0000 0271 //   }
; 0000 0272    }
_0xE2:
_0xE1:
	RET
;
;
;void bt () {
; 0000 0275 void bt () {
_bt:
; 0000 0276        if (outr==1 || outl==1 ||  (adc[min]<60  && h<60  )|| r==1 || l==1   ) {
	LDS  R26,_outr
	LDS  R27,_outr+1
	SBIW R26,1
	BREQ _0xEC
	LDS  R26,_outl
	LDS  R27,_outl+1
	SBIW R26,1
	BREQ _0xEC
	CALL SUBOPT_0x16
	CALL SUBOPT_0x28
	SBIW R30,60
	BRGE _0xED
	LDS  R26,_h
	LDS  R27,_h+1
	SBIW R26,60
	BRLT _0xEC
_0xED:
	CALL SUBOPT_0x26
	SBIW R26,1
	BREQ _0xEC
	CALL SUBOPT_0x27
	SBIW R26,1
	BRNE _0xEB
_0xEC:
; 0000 0277        putchar1('2');
	LDI  R30,LOW(50)
	ST   -Y,R30
	CALL _putchar1
; 0000 0278         #asm("wdr") ;
	wdr
; 0000 0279        }
; 0000 027A        else {
	RJMP _0xF0
_0xEB:
; 0000 027B         putchar1('1');
	LDI  R30,LOW(49)
	ST   -Y,R30
	CALL _putchar1
; 0000 027C          #asm("wdr") ;
	wdr
; 0000 027D        }
_0xF0:
; 0000 027E        }
	RET
;
;void main(void)
; 0000 0281 {
_main:
; 0000 0282 // Declare your local variables here
; 0000 0283 
; 0000 0284 // Input/Output Ports initialization
; 0000 0285 // Port A initialization
; 0000 0286 // Func7=In Func6=Out Func5=Out Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0287 // State7=T State6=0 State5=0 State4=T State3=0 State2=0 State1=0 State0=0
; 0000 0288 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0289 DDRA=0x6F;
	LDI  R30,LOW(111)
	OUT  0x1A,R30
; 0000 028A 
; 0000 028B // Port B initialization
; 0000 028C // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 028D // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 028E PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 028F DDRB=0xF0;
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 0290 
; 0000 0291 // Port C initialization
; 0000 0292 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0293 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0294 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0295 DDRC=0x00;
	OUT  0x14,R30
; 0000 0296 
; 0000 0297 // Port D initialization
; 0000 0298 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 0299 // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 029A PORTD=0x00;
	OUT  0x12,R30
; 0000 029B DDRD=0xF0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 029C 
; 0000 029D // Port E initialization
; 0000 029E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 029F // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 02A0 PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 02A1 DDRE=0x00;
	OUT  0x2,R30
; 0000 02A2 
; 0000 02A3 // Port F initialization
; 0000 02A4 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 02A5 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 02A6 PORTF=0x00;
	STS  98,R30
; 0000 02A7 DDRF=0x00;
	STS  97,R30
; 0000 02A8 
; 0000 02A9 // Port G initialization
; 0000 02AA // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 02AB // State4=T State3=T State2=T State1=T State0=T
; 0000 02AC PORTG=0x00;
	STS  101,R30
; 0000 02AD DDRG=0x00;
	STS  100,R30
; 0000 02AE 
; 0000 02AF // Timer/Counter 0 initialization
; 0000 02B0 // Clock source: System Clock
; 0000 02B1 // Clock value: 172.800 kHz
; 0000 02B2 // Mode: Fast PWM top=FFh
; 0000 02B3 // OC0 output: Non-Inverted PWM
; 0000 02B4 ASSR=0x00;
	OUT  0x30,R30
; 0000 02B5 TCCR0=0x6C;
	LDI  R30,LOW(108)
	OUT  0x33,R30
; 0000 02B6 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 02B7 OCR0=0x00;
	OUT  0x31,R30
; 0000 02B8 
; 0000 02B9 // Timer/Counter 1 initialization
; 0000 02BA // Clock source: System Clock
; 0000 02BB // Clock value: 172.800 kHz
; 0000 02BC // Mode: Fast PWM top=00FFh
; 0000 02BD // OC1A output: Non-Inv.
; 0000 02BE // OC1B output: Non-Inv.
; 0000 02BF // OC1C output: Discon.
; 0000 02C0 // Noise Canceler: Off
; 0000 02C1 // Input Capture on Falling Edge
; 0000 02C2 // Timer 1 Overflow Interrupt: Off
; 0000 02C3 // Input Capture Interrupt: Off
; 0000 02C4 // Compare A Match Interrupt: Off
; 0000 02C5 // Compare B Match Interrupt: Off
; 0000 02C6 // Compare C Match Interrupt: Off
; 0000 02C7 TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 02C8 TCCR1B=0x0B;
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 02C9 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 02CA TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 02CB ICR1H=0x00;
	OUT  0x27,R30
; 0000 02CC ICR1L=0x00;
	OUT  0x26,R30
; 0000 02CD OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 02CE OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 02CF OCR1BH=0x00;
	OUT  0x29,R30
; 0000 02D0 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 02D1 OCR1CH=0x00;
	STS  121,R30
; 0000 02D2 OCR1CL=0x00;
	STS  120,R30
; 0000 02D3 
; 0000 02D4 // Timer/Counter 2 initialization
; 0000 02D5 // Clock source: System Clock
; 0000 02D6 // Clock value: 172.800 kHz
; 0000 02D7 // Mode: Fast PWM top=FFh
; 0000 02D8 // OC2 output: Non-Inverted PWM
; 0000 02D9 TCCR2=0x6B;
	LDI  R30,LOW(107)
	OUT  0x25,R30
; 0000 02DA TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 02DB OCR2=0x00;
	OUT  0x23,R30
; 0000 02DC 
; 0000 02DD // Timer/Counter 3 initialization
; 0000 02DE // Clock source: System Clock
; 0000 02DF // Clock value: Timer 3 Stopped
; 0000 02E0 // Mode: Normal top=FFFFh
; 0000 02E1 // Noise Canceler: Off
; 0000 02E2 // Input Capture on Falling Edge
; 0000 02E3 // OC3A output: Discon.
; 0000 02E4 // OC3B output: Discon.
; 0000 02E5 // OC3C output: Discon.
; 0000 02E6 // Timer 3 Overflow Interrupt: Off
; 0000 02E7 // Input Capture Interrupt: Off
; 0000 02E8 // Compare A Match Interrupt: Off
; 0000 02E9 // Compare B Match Interrupt: Off
; 0000 02EA // Compare C Match Interrupt: Off
; 0000 02EB TCCR3A=0x00;
	STS  139,R30
; 0000 02EC TCCR3B=0x00;
	STS  138,R30
; 0000 02ED TCNT3H=0x00;
	STS  137,R30
; 0000 02EE TCNT3L=0x00;
	STS  136,R30
; 0000 02EF ICR3H=0x00;
	STS  129,R30
; 0000 02F0 ICR3L=0x00;
	STS  128,R30
; 0000 02F1 OCR3AH=0x00;
	STS  135,R30
; 0000 02F2 OCR3AL=0x00;
	STS  134,R30
; 0000 02F3 OCR3BH=0x00;
	STS  133,R30
; 0000 02F4 OCR3BL=0x00;
	STS  132,R30
; 0000 02F5 OCR3CH=0x00;
	STS  131,R30
; 0000 02F6 OCR3CL=0x00;
	STS  130,R30
; 0000 02F7 
; 0000 02F8 // External Interrupt(s) initialization
; 0000 02F9 // INT0: Off
; 0000 02FA // INT1: Off
; 0000 02FB // INT2: Off
; 0000 02FC // INT3: Off
; 0000 02FD // INT4: Off
; 0000 02FE // INT5: Off
; 0000 02FF // INT6: Off
; 0000 0300 // INT7: Off
; 0000 0301 EICRA=0x00;
	STS  106,R30
; 0000 0302 EICRB=0x00;
	OUT  0x3A,R30
; 0000 0303 EIMSK=0x00;
	OUT  0x39,R30
; 0000 0304 
; 0000 0305 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0306 TIMSK=0x00;
	OUT  0x37,R30
; 0000 0307 ETIMSK=0x00;
	STS  125,R30
; 0000 0308 
; 0000 0309 // USART1 initialization
; 0000 030A // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 030B // USART1 Receiver: On
; 0000 030C // USART1 Transmitter: On
; 0000 030D // USART1 Mode: Asynchronous
; 0000 030E // USART1 Baud Rate: 9600
; 0000 030F UCSR1A=0x00;
	STS  155,R30
; 0000 0310 UCSR1B=0x98;
	LDI  R30,LOW(152)
	STS  154,R30
; 0000 0311 UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 0312 UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 0313 UBRR1L=0x47;
	LDI  R30,LOW(71)
	STS  153,R30
; 0000 0314 
; 0000 0315 // Analog Comparator initialization
; 0000 0316 // Analog Comparator: Off
; 0000 0317 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0318 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0319 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 031A 
; 0000 031B // ADC initialization
; 0000 031C // ADC Clock frequency: 691.200 kHz
; 0000 031D // ADC Voltage Reference: AVCC pin
; 0000 031E ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 031F ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 0320 
; 0000 0321 // I2C Bus initialization
; 0000 0322 i2c_init();
	CALL _i2c_init
; 0000 0323 
; 0000 0324 // LCD module initialization
; 0000 0325 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0326 
; 0000 0327 // Watchdog Timer initialization
; 0000 0328 // Watchdog Timer Prescaler: OSC/16k
; 0000 0329 #pragma optsize-
; 0000 032A WDTCR=0x18;
	LDI  R30,LOW(24)
	OUT  0x21,R30
; 0000 032B WDTCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x21,R30
; 0000 032C #ifdef _OPTIMIZE_SIZE_
; 0000 032D #pragma optsize+
; 0000 032E #endif
; 0000 032F 
; 0000 0330 // Global enable interrupts
; 0000 0331 #asm("sei")
	sei
; 0000 0332 if (PINA.4==1){
	LDI  R26,0
	SBIC 0x19,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xF1
; 0000 0333 c=compass_read(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _compass_read
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	LDI  R31,0
	CALL __EEPROMWRW
; 0000 0334 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0335 }
; 0000 0336 #asm("wdr") ;
_0xF1:
	wdr
; 0000 0337 
; 0000 0338 while (1)
_0xF2:
; 0000 0339       {
; 0000 033A 
; 0000 033B       compass();
	CALL SUBOPT_0x41
; 0000 033C       sensor();
; 0000 033D       sharp();
; 0000 033E       out();
	RCALL _out
; 0000 033F       bt();
	RCALL _bt
; 0000 0340 
; 0000 0341 
; 0000 0342 
; 0000 0343 
; 0000 0344        if(adc[min]<900 && (t==1 || t==0)  ){
	CALL SUBOPT_0x16
	CALL SUBOPT_0x28
	CPI  R30,LOW(0x384)
	LDI  R26,HIGH(0x384)
	CPC  R31,R26
	BRGE _0xF6
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	BREQ _0xF7
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BRNE _0xF6
_0xF7:
	RJMP _0xF9
_0xF6:
	RJMP _0xF5
_0xF9:
; 0000 0345        follow();
	RCALL _follow
; 0000 0346        #asm("wdr") ;}
	wdr
; 0000 0347       else if (adc[min]>900  || t==2 ){
	RJMP _0xFA
_0xF5:
	CALL SUBOPT_0x16
	CALL SUBOPT_0x28
	CPI  R30,LOW(0x385)
	LDI  R26,HIGH(0x385)
	CPC  R31,R26
	BRGE _0xFC
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0xFB
_0xFC:
; 0000 0348 
; 0000 0349        sahmi();
	CALL _sahmi
; 0000 034A 
; 0000 034B 
; 0000 034C 
; 0000 034D       }
; 0000 034E 
; 0000 034F 
; 0000 0350  //////////////////////////// //chap
; 0000 0351  while (l==1  || outl==1) {
_0xFB:
_0xFA:
_0xFE:
	CALL SUBOPT_0x27
	SBIW R26,1
	BREQ _0x101
	LDS  R26,_outl
	LDS  R27,_outl+1
	SBIW R26,1
	BREQ _0x101
	RJMP _0x100
_0x101:
; 0000 0352  //////////////////////////putchar1('2');
; 0000 0353  if(kaf[15]<400 ) {
	CALL SUBOPT_0x21
	BRGE _0x103
; 0000 0354 motor(0+cmp/2,0+cmp/2,0+cmp/2,0+cmp/2);
	MOVW R26,R4
	CALL SUBOPT_0xC
	ADIW R30,0
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x3F
	CALL _motor
; 0000 0355  #asm("wdr") ;
	wdr
; 0000 0356 }
; 0000 0357 
; 0000 0358  if(kaf[14]<400 ) {
_0x103:
	CALL SUBOPT_0x20
	BRGE _0x104
; 0000 0359 
; 0000 035A     motor(0+cmp/2,0+cmp/2,0+cmp/2,0+cmp/2);
	MOVW R26,R4
	CALL SUBOPT_0xC
	ADIW R30,0
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x3F
	CALL _motor
; 0000 035B  #asm("wdr") ;
	wdr
; 0000 035C }
; 0000 035D 
; 0000 035E 
; 0000 035F  if(( kaf[12]<400  || kaf[13]<400) &&( (min>=8 && min<16) || min==0) ){
_0x104:
	CALL SUBOPT_0x1E
	BRLT _0x106
	CALL SUBOPT_0x1F
	BRGE _0x108
_0x106:
	CALL SUBOPT_0x1B
	SBIW R26,8
	BRLT _0x109
	CALL SUBOPT_0x1B
	SBIW R26,16
	BRLT _0x10B
_0x109:
	CALL SUBOPT_0x1B
	SBIW R26,0
	BRNE _0x108
_0x10B:
	RJMP _0x10D
_0x108:
	RJMP _0x105
_0x10D:
; 0000 0360 motor((255+cmp)/4,(-255+cmp)/4,(-255+cmp)/4,(255+cmp)/4);
	CALL SUBOPT_0x42
	CALL SUBOPT_0x43
	CALL SUBOPT_0x43
	CALL SUBOPT_0x44
	CALL SUBOPT_0x3A
; 0000 0361 
; 0000 0362  #asm("wdr") ;
	wdr
; 0000 0363 
; 0000 0364  }
; 0000 0365 
; 0000 0366 
; 0000 0367  else if (min>0 && min<8   ) {
	RJMP _0x10E
_0x105:
	CALL SUBOPT_0x1B
	CALL __CPW02
	BRGE _0x110
	CALL SUBOPT_0x1B
	SBIW R26,8
	BRLT _0x111
_0x110:
	RJMP _0x10F
_0x111:
; 0000 0368    l=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x2C
; 0000 0369    outl=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _outl,R30
	STS  _outl+1,R31
; 0000 036A     sensor();
	CALL _sensor
; 0000 036B  follow();
	CALL _follow
; 0000 036C  #asm("wdr") ;
	wdr
; 0000 036D  }
; 0000 036E 
; 0000 036F 
; 0000 0370 
; 0000 0371  #asm("wdr") ;
_0x10F:
_0x10E:
	wdr
; 0000 0372  compass();
	CALL SUBOPT_0x41
; 0000 0373  sensor();
; 0000 0374  sharp();
; 0000 0375  }
	RJMP _0xFE
_0x100:
; 0000 0376 
; 0000 0377 
; 0000 0378 
; 0000 0379 
; 0000 037A  /////////////////////////// rast
; 0000 037B  while (r==1 || outr==1) {
_0x112:
	CALL SUBOPT_0x26
	SBIW R26,1
	BREQ _0x115
	LDS  R26,_outr
	LDS  R27,_outr+1
	SBIW R26,1
	BREQ _0x115
	RJMP _0x114
_0x115:
; 0000 037C 
; 0000 037D  if(kaf[3]<400 ) {
	CALL SUBOPT_0x25
	BRGE _0x117
; 0000 037E motor(0+cmp/2,0+cmp/2,0+cmp/2,0+cmp/2);
	MOVW R26,R4
	CALL SUBOPT_0xC
	ADIW R30,0
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x3F
	CALL _motor
; 0000 037F  #asm("wdr") ;
	wdr
; 0000 0380 }
; 0000 0381 
; 0000 0382  if(kaf[2]<400 ) {
_0x117:
	CALL SUBOPT_0x24
	BRGE _0x118
; 0000 0383 
; 0000 0384     motor(0+cmp/2,0+cmp/2,0+cmp/2,0+cmp/2);
	MOVW R26,R4
	CALL SUBOPT_0xC
	ADIW R30,0
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x3F
	CALL _motor
; 0000 0385  #asm("wdr") ;
	wdr
; 0000 0386 }
; 0000 0387 
; 0000 0388 
; 0000 0389  if(( kaf[0]<400  || kaf[1]<400) &&( min>=0 && min<=8) ){
_0x118:
	CALL SUBOPT_0x22
	BRLT _0x11A
	CALL SUBOPT_0x23
	BRGE _0x11C
_0x11A:
	LDS  R26,_min+1
	TST  R26
	BRMI _0x11D
	CALL SUBOPT_0x1B
	SBIW R26,9
	BRLT _0x11E
_0x11D:
	RJMP _0x11C
_0x11E:
	RJMP _0x11F
_0x11C:
	RJMP _0x119
_0x11F:
; 0000 038A motor((-255+cmp)/4,(255+cmp)/4,(255+cmp)/4,(-255+cmp)/4);
	MOVW R26,R4
	SUBI R26,LOW(-65281)
	SBCI R27,HIGH(-65281)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	CALL SUBOPT_0x44
	CALL SUBOPT_0x44
	CALL SUBOPT_0x43
	CALL SUBOPT_0x3A
; 0000 038B 
; 0000 038C  #asm("wdr") ;
	wdr
; 0000 038D 
; 0000 038E  }
; 0000 038F 
; 0000 0390 
; 0000 0391  else if (min>8 && min<16   ) {
	RJMP _0x120
_0x119:
	CALL SUBOPT_0x1B
	SBIW R26,9
	BRLT _0x122
	CALL SUBOPT_0x1B
	SBIW R26,16
	BRLT _0x123
_0x122:
	RJMP _0x121
_0x123:
; 0000 0392    r=0;
	CALL SUBOPT_0x2E
; 0000 0393    outr=0;
	STS  _outr,R30
	STS  _outr+1,R31
; 0000 0394     sensor();
	CALL _sensor
; 0000 0395  follow();
	CALL _follow
; 0000 0396  #asm("wdr") ;
	wdr
; 0000 0397  }
; 0000 0398 
; 0000 0399 
; 0000 039A 
; 0000 039B  #asm("wdr") ;
_0x121:
_0x120:
	wdr
; 0000 039C  compass();
	CALL SUBOPT_0x41
; 0000 039D  sensor();
; 0000 039E  sharp();
; 0000 039F  }
	RJMP _0x112
_0x114:
; 0000 03A0 
; 0000 03A1  while(f==1) {
_0x124:
	CALL SUBOPT_0x29
	SBIW R26,1
	BREQ PC+3
	JMP _0x126
; 0000 03A2            if(SB<190)
	CALL SUBOPT_0x9
	CPI  R26,LOW(0xBE)
	LDI  R30,HIGH(0xBE)
	CPC  R27,R30
	BRGE _0x127
; 0000 03A3            {
; 0000 03A4           motor(-128-RL+cmp,-255+RL+cmp,128+RL-cmp,255-RL+cmp);
	CALL SUBOPT_0x30
; 0000 03A5            #asm("wdr") ;
	wdr
; 0000 03A6            }
; 0000 03A7            /////////////////////////////////////////////////////
; 0000 03A8            else if(SB>190 && (RL>60 || RL<-60))
	RJMP _0x128
_0x127:
	CALL SUBOPT_0x31
	BRLT _0x12A
	CALL SUBOPT_0xE
	SBIW R26,61
	BRGE _0x12B
	CALL SUBOPT_0xE
	CPI  R26,LOW(0xFFC4)
	LDI  R30,HIGH(0xFFC4)
	CPC  R27,R30
	BRGE _0x12A
_0x12B:
	RJMP _0x12D
_0x12A:
	RJMP _0x129
_0x12D:
; 0000 03A9            {
; 0000 03AA            RL=RL*3;
	CALL SUBOPT_0xE
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __MULW12
	CALL SUBOPT_0xD
; 0000 03AB           motor(255-RL+cmp,255+RL+cmp,-255+RL+cmp,-255-RL+cmp);
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	SUB  R30,R26
	SBC  R31,R27
	CALL SUBOPT_0x45
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	CALL SUBOPT_0x45
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	ADD  R30,R4
	ADC  R31,R5
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xE
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	SUB  R30,R26
	SBC  R31,R27
	ADD  R30,R4
	ADC  R31,R5
	CALL SUBOPT_0x3A
; 0000 03AC           }
; 0000 03AD            ////////////////////////////////////////////////////
; 0000 03AE            else if(SB>160 && RL<-70 )
	RJMP _0x12E
_0x129:
	CALL SUBOPT_0x9
	CPI  R26,LOW(0xA1)
	LDI  R30,HIGH(0xA1)
	CPC  R27,R30
	BRLT _0x130
	CALL SUBOPT_0xE
	CPI  R26,LOW(0xFFBA)
	LDI  R30,HIGH(0xFFBA)
	CPC  R27,R30
	BRLT _0x131
_0x130:
	RJMP _0x12F
_0x131:
; 0000 03AF            {
; 0000 03B0            motor((255+cmp)*0.5,(-255+cmp)*0.5,(-255+cmp)*0.5,(255+cmp)*0.5);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	CALL SUBOPT_0x33
	CALL SUBOPT_0x32
	CALL _motor
; 0000 03B1            }
; 0000 03B2             else if(SB>160 && RL>70 )
	RJMP _0x132
_0x12F:
	CALL SUBOPT_0x9
	CPI  R26,LOW(0xA1)
	LDI  R30,HIGH(0xA1)
	CPC  R27,R30
	BRLT _0x134
	CALL SUBOPT_0xE
	CPI  R26,LOW(0x47)
	LDI  R30,HIGH(0x47)
	CPC  R27,R30
	BRGE _0x135
_0x134:
	RJMP _0x133
_0x135:
; 0000 03B3            {
; 0000 03B4            motor((-255+cmp)*0.5,(255+cmp)*0.5,(255+cmp)*0.5,(-255+cmp)*0.5);
	CALL SUBOPT_0x33
	CALL SUBOPT_0x32
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	CALL _motor
; 0000 03B5            if (adc[min]<60  &&( (adc[0]<60) || (adc[15]<60)|| (adc[1]<60)  )  )  t=0;}
	CALL SUBOPT_0x16
	CALL SUBOPT_0x28
	SBIW R30,60
	BRGE _0x137
	CALL SUBOPT_0x1A
	SBIW R26,60
	BRLT _0x138
	CALL SUBOPT_0x19
	SBIW R26,60
	BRLT _0x138
	__GETW2MN _adc,2
	SBIW R26,60
	BRGE _0x137
_0x138:
	RJMP _0x13A
_0x137:
	RJMP _0x136
_0x13A:
	CLR  R10
	CLR  R11
_0x136:
; 0000 03B6 
; 0000 03B7           else  {
	RJMP _0x13B
_0x133:
; 0000 03B8              motor(0+cmp,0+cmp,0+cmp,0+cmp);
	CALL SUBOPT_0x34
	CALL SUBOPT_0x34
	CALL SUBOPT_0x34
	CALL SUBOPT_0x34
	CALL _motor
; 0000 03B9           t=0;
	CLR  R10
	CLR  R11
; 0000 03BA           f=0 ;
	CALL SUBOPT_0x2D
; 0000 03BB 
; 0000 03BC           }
_0x13B:
_0x132:
_0x12E:
_0x128:
; 0000 03BD          sharp();
	CALL _sharp
; 0000 03BE          compass();
	CALL _compass
; 0000 03BF           #asm("wdr") ;
	wdr
; 0000 03C0           }
	RJMP _0x124
_0x126:
; 0000 03C1 
; 0000 03C2 
; 0000 03C3 
; 0000 03C4               if(SB>300){
	CALL SUBOPT_0x9
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	BRGE PC+3
	JMP _0x13C
; 0000 03C5             if (kaf[4]<400 || kaf[5]<400 || kaf[6]<400 ||  kaf[7]<400){
	__GETW2MN _kaf,8
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x13E
	__GETW2MN _kaf,10
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x13E
	__GETW2MN _kaf,12
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x13E
	__GETW2MN _kaf,14
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRGE _0x13D
_0x13E:
; 0000 03C6             motor(255+cmp,255+cmp,-255+cmp,-255+cmp);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x39
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3A
; 0000 03C7               delay_ms(30);
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 03C8             while (min>=4 && min<=12){
_0x140:
	CALL SUBOPT_0x1B
	SBIW R26,4
	BRLT _0x143
	CALL SUBOPT_0x1B
	SBIW R26,13
	BRLT _0x144
_0x143:
	RJMP _0x142
_0x144:
; 0000 03C9             motor(0+cmp,0+cmp,0+cmp,0+cmp);
	CALL SUBOPT_0x34
	CALL SUBOPT_0x34
	CALL SUBOPT_0x34
	CALL SUBOPT_0x34
	CALL _motor
; 0000 03CA 
; 0000 03CB               sensor(); }
	CALL _sensor
	RJMP _0x140
_0x142:
; 0000 03CC               }
; 0000 03CD               #asm("wdr") ;
_0x13D:
	wdr
; 0000 03CE               }
; 0000 03CF 
; 0000 03D0 
; 0000 03D1 
; 0000 03D2 
; 0000 03D3 
; 0000 03D4 //           while (b==1 ){
; 0000 03D5 //           if( (adc[0] || adc[1] || adc[2] || adc[3]) && (adc[12] || adc[13] || adc[14] || adc[15])){
; 0000 03D6 //           motor(255/2+cmp,255/2+cmp,-255/2+cmp,-255/2+cmp) ;
; 0000 03D7 //
; 0000 03D8 //           }
; 0000 03D9 //           if (kaf[7]<450)
; 0000 03DA //           motor(0+cmp,0+cmp,0+cmp,0+cmp);
; 0000 03DB //           if (kaf[6]<300)
; 0000 03DC //           motor(0+cmp,0+cmp,0+cmp,0+cmp);
; 0000 03DD //           if (( kaf[5]<300 || kaf[4]<300)  && min>=4 && min<=12 )
; 0000 03DE //           motor(255/3+cmp,255/3+cmp,-255/3+cmp,-255/3+cmp) ;
; 0000 03DF //
; 0000 03E0 //
; 0000 03E1 //           else if (min>12 || min<4){
; 0000 03E2 //           sensor();
; 0000 03E3 //           compass();
; 0000 03E4 //           follow();
; 0000 03E5 //           sharp();
; 0000 03E6 //
; 0000 03E7 //           b=0;
; 0000 03E8 //            #asm("wdr") ;
; 0000 03E9 //           }
; 0000 03EA //
; 0000 03EB //           sensor();
; 0000 03EC //           compass();
; 0000 03ED //           sharp();
; 0000 03EE //            #asm("wdr") ;
; 0000 03EF //
; 0000 03F0 //
; 0000 03F1 //          }
; 0000 03F2 
; 0000 03F3 
; 0000 03F4 
; 0000 03F5 
; 0000 03F6         #asm("wdr") ;
_0x13C:
	wdr
; 0000 03F7 
; 0000 03F8 
; 0000 03F9         //////////////////////////12 13 14 15 left
; 0000 03FA         /////////////////////////////0 1 2 3          right
; 0000 03FB         ///////////////////////////////// 4 5 6 7 back
; 0000 03FC         ///////////////////////////   8 9 10 11 front
; 0000 03FD 
; 0000 03FE 
; 0000 03FF 
; 0000 0400 
; 0000 0401 //                   if( SB>300){
; 0000 0402 //                motor(255-RL+cmp,255+RL+cmp,-255+RL-cmp,-255-RL+cmp);
; 0000 0403 //           }
; 0000 0404 //
; 0000 0405            //////////////////////////////////////////////////////////////
; 0000 0406 //           else if(SB>190 && RL<-70 )
; 0000 0407 //           {
; 0000 0408 //           motor((255+cmp)*0.5,(-255+cmp)*0.5,(-255+cmp)*0.5,(255+cmp)*0.5);
; 0000 0409 //           }
; 0000 040A //            else if(SB>190 && RL>70 )
; 0000 040B //           {
; 0000 040C //           motor((-255+cmp)*0.5,(255+cmp)*0.5,(255+cmp)*0.5,(-255+cmp)*0.5);
; 0000 040D //           if (adc[min]<60  &&( (adc[0]<60) || (adc[15]<60)|| (adc[1]<60)  )  )  t=0;}
; 0000 040E //            else  {  motor(0+cmp,0+cmp,0+cmp,0+cmp);
; 0000 040F //
; 0000 0410 //      b=0;
; 0000 0411 
; 0000 0412 
; 0000 0413       };
	RJMP _0xF2
; 0000 0414  }
_0x145:
	RJMP _0x145
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
	CALL SUBOPT_0x46
	CALL SUBOPT_0x46
	CALL SUBOPT_0x46
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	CALL SUBOPT_0x47
	LDI  R30,LOW(4)
	CALL SUBOPT_0x47
	LDI  R30,LOW(133)
	CALL SUBOPT_0x47
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
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	LDS  R26,_SR
	LDS  R27,_SR+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:63 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:85 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	ADIW R30,48
	ST   -Y,R30
	CALL _lcd_putchar
	LDI  R30,LOW(8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x9:
	LDS  R26,_SB
	LDS  R27,_SB+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	ADIW R30,48
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	STS  _RL,R30
	STS  _RL+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	RCALL SUBOPT_0xB
	LDS  R26,_RL
	LDS  R27,_RL+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0xE:
	LDS  R26,_RL
	LDS  R27,_RL+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0xE
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDS  R30,_RL
	LDS  R31,_RL+1
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	LDS  R26,_i
	LDS  R27,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	LDS  R30,_i
	LDS  R31,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x14:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x16:
	LDS  R30,_min
	LDS  R31,_min+1
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CP   R0,R30
	CPC  R1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x18:
	LDS  R30,_mini
	LDS  R31,_mini+1
	LDI  R26,LOW(_kaf)
	LDI  R27,HIGH(_kaf)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	__GETW2MN _adc,30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDS  R26,_adc
	LDS  R27,_adc+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 38 TIMES, CODE SIZE REDUCTION:71 WORDS
SUBOPT_0x1B:
	LDS  R26,_min
	LDS  R27,_min+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1C:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	MOVW R26,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1E:
	__GETW2MN _kaf,24
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1F:
	__GETW2MN _kaf,26
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	__GETW2MN _kaf,28
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	__GETW2MN _kaf,30
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x22:
	LDS  R26,_kaf
	LDS  R27,_kaf+1
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x23:
	__GETW2MN _kaf,2
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x24:
	__GETW2MN _kaf,4
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x25:
	__GETW2MN _kaf,6
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	LDS  R26,_r
	LDS  R27,_r+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	LDS  R26,_l
	LDS  R27,_l+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x28:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	LDS  R26,_f
	LDS  R27,_f+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _f,R30
	STS  _f+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	STS  _r,R30
	STS  _r+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	STS  _l,R30
	STS  _l+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _f,R30
	STS  _f+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x2B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	MOVW R30,R4
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x30:
	RCALL SUBOPT_0xE
	LDI  R30,LOW(65408)
	LDI  R31,HIGH(65408)
	SUB  R30,R26
	SBC  R31,R27
	ADD  R30,R4
	ADC  R31,R5
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_RL
	LDS  R31,_RL+1
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	ADD  R30,R4
	ADC  R31,R5
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_RL
	LDS  R31,_RL+1
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	SUB  R30,R4
	SBC  R31,R5
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0xE
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	SUB  R30,R26
	SBC  R31,R27
	ADD  R30,R4
	ADC  R31,R5
	ST   -Y,R31
	ST   -Y,R30
	JMP  _motor

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	RCALL SUBOPT_0x9
	CPI  R26,LOW(0xBF)
	LDI  R30,HIGH(0xBF)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:102 WORDS
SUBOPT_0x32:
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3F000000
	CALL __MULF12
	CALL __CFD1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:102 WORDS
SUBOPT_0x33:
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3F000000
	CALL __MULF12
	CALL __CFD1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x34:
	MOVW R30,R4
	ADIW R30,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x35:
	LDS  R26,_h
	LDS  R27,_h+1
	CPI  R26,LOW(0x96)
	LDI  R30,HIGH(0x96)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(65344)
	LDI  R31,HIGH(65344)
	SER  R31
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(192)
	LDI  R31,HIGH(192)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	SER  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(65408)
	LDI  R31,HIGH(65408)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	SER  R31
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x38:
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x39:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3A:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _motor

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3B:
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3C:
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	RJMP SUBOPT_0x39

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x3D:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3E:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3F:
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x40:
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x41:
	CALL _compass
	CALL _sensor
	JMP  _sharp

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x42:
	MOVW R26,R4
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x43:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R4
	SUBI R26,LOW(-65281)
	SBCI R27,HIGH(-65281)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	ADD  R30,R4
	ADC  R31,R5
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_RL
	LDS  R31,_RL+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x46:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x47:
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

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

;END OF CODE MARKER
__END_OF_CODE:
