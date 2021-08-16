
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
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

	#pragma AVRPART ADMIN PART_NAME ATmega16
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
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  _ext_int1_isr
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
	.DB  0x75,0x73,0x65,0x20,0x6B,0x65,0x79,0x70
	.DB  0x61,0x64,0x3A,0x20,0x20,0x0
_0x20004:
	.DB  0x57,0x65,0x6C,0x63,0x6F,0x6D,0x65,0x20
	.DB  0x74,0x6F,0x20,0x74,0x68,0x65,0x20,0x6F
	.DB  0x6E,0x6C,0x69,0x6E,0x65,0x20,0x6C,0x61
	.DB  0x62,0x20,0x63,0x6C,0x61,0x73,0x73,0x65
	.DB  0x73,0x20,0x64,0x75,0x65,0x20,0x74,0x6F
	.DB  0x20,0x43,0x6F,0x72,0x6F,0x6E,0x61,0x20
	.DB  0x64,0x69,0x73,0x65,0x61,0x73,0x65,0x2E
	.DB  0x0
_0x20008:
	.DB  0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37
	.DB  0x38,0x39,0x41,0x42,0x43,0x44,0x45,0x46
_0x20000:
	.DB  0x45,0x72,0x66,0x61,0x6E,0x20,0x42,0x61
	.DB  0x68,0x72,0x61,0x6D,0x69,0x0,0x39,0x36
	.DB  0x32,0x34,0x35,0x31,0x33,0x0,0x53,0x70
	.DB  0x65,0x65,0x64,0x3F,0x3F,0x28,0x30,0x2D
	.DB  0x35,0x30,0x29,0x0,0x45,0x45,0x0,0x54
	.DB  0x69,0x6D,0x65,0x3A,0x3F,0x3F,0x28,0x30
	.DB  0x2D,0x39,0x39,0x73,0x29,0x0,0x57,0x65
	.DB  0x69,0x67,0x74,0x3A,0x3F,0x3F,0x28,0x30
	.DB  0x2D,0x39,0x39,0x46,0x29,0x0,0x54,0x65
	.DB  0x6D,0x70,0x3A,0x3F,0x3F,0x28,0x32,0x30
	.DB  0x2D,0x38,0x30,0x43,0x29,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x0E
	.DW  _0x8
	.DW  _0x0*2

	.DW  0x0E
	.DW  _0x20003
	.DW  _0x20000*2

	.DW  0x08
	.DW  _0x20003+14
	.DW  _0x20000*2+14

	.DW  0x0E
	.DW  _0x20025
	.DW  _0x20000*2+22

	.DW  0x03
	.DW  _0x20025+14
	.DW  _0x20000*2+36

	.DW  0x0F
	.DW  _0x20025+17
	.DW  _0x20000*2+39

	.DW  0x03
	.DW  _0x20025+32
	.DW  _0x20000*2+36

	.DW  0x10
	.DW  _0x20025+35
	.DW  _0x20000*2+54

	.DW  0x03
	.DW  _0x20025+51
	.DW  _0x20000*2+36

	.DW  0x10
	.DW  _0x20025+54
	.DW  _0x20000*2+70

	.DW  0x03
	.DW  _0x20025+70
	.DW  _0x20000*2+36

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

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
;Date    : 2020-10-19
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;#include <mega16.h>
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
;#include <string.h>
;#include <delay.h>
;#include <Subroutines.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0023 {

	.CSEG
_ext_int1_isr:
; .FSTART _ext_int1_isr
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
; 0000 0024     PORTC.0 = 1;
	SBI  0x15,0
; 0000 0025     Subroutine_3();
	RCALL _Subroutine_3
; 0000 0026 }
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
;void main(void)
; 0000 0029 {
_main:
; .FSTART _main
; 0000 002A init();
	RCALL _init
; 0000 002B 
; 0000 002C while (1)
_0x5:
; 0000 002D       {
; 0000 002E             Subroutine_1();
	RCALL _Subroutine_1
; 0000 002F             Subroutine_2();
	RCALL _Subroutine_2
; 0000 0030             lcd_puts("use keypad:  ");
	__POINTW2MN _0x8,0
	CALL _lcd_puts
; 0000 0031             lcd_putchar(Subroutine_3());
	RCALL _Subroutine_3
	MOV  R26,R30
	CALL _lcd_putchar
; 0000 0032             delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0033             Subroutine_5();
	RCALL _Subroutine_5
; 0000 0034             lcd_clear();
	CALL _lcd_clear
; 0000 0035       }
	RJMP _0x5
; 0000 0036 }
_0x9:
	RJMP _0x9
; .FEND

	.DSEG
_0x8:
	.BYTE 0xE
;#include <mega16.h>
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
;#include <alcd.h>
;#include <string.h>
;// ba komak az site https://www.electronicwings.com/avr-atmega/4x4-keypad-interfacing-with-atmega1632
;#define KEY_PRT        PORTB
;#define KEY_DDR        DDRB
;#define KEY_PIN        PINB
;
;void init ( void )
; 0001 000B {

	.CSEG
_init:
; .FSTART _init
; 0001 000C     // Declare your local variables here
; 0001 000D 
; 0001 000E // Input/Output Ports initialization
; 0001 000F // Port A initialization
; 0001 0010 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0001 0011 DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0001 0012 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0001 0013 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0001 0014 
; 0001 0015 // Port B initialization
; 0001 0016 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 0017 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0001 0018 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 0019 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0001 001A 
; 0001 001B // Port C initialization
; 0001 001C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 001D DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0001 001E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 001F PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0001 0020 
; 0001 0021 // Port D initialization
; 0001 0022 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0001 0023 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0001 0024 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0001 0025 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0001 0026 
; 0001 0027 // External Interrupt(s) initialization
; 0001 0028 // INT0: Off
; 0001 0029 // INT1: On
; 0001 002A // INT1 Mode: Rising Edge
; 0001 002B // INT2: Off
; 0001 002C GICR|=(1<<INT1) | (0<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0001 002D MCUCR=(1<<ISC11) | (1<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(12)
	OUT  0x35,R30
; 0001 002E MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0001 002F GIFR=(1<<INTF1) | (0<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0001 0030 
; 0001 0031 // Alphanumeric LCD initialization
; 0001 0032 // Connections are specified in the
; 0001 0033 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0001 0034 // RS - PORTA Bit 0
; 0001 0035 // RD - PORTA Bit 1
; 0001 0036 // EN - PORTA Bit 2
; 0001 0037 // D4 - PORTA Bit 4
; 0001 0038 // D5 - PORTA Bit 5
; 0001 0039 // D6 - PORTA Bit 6
; 0001 003A // D7 - PORTA Bit 7
; 0001 003B // Characters/line: 16
; 0001 003C lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0001 003D 
; 0001 003E // Global enable interrupts
; 0001 003F #asm("sei")
	sei
; 0001 0040 }
	RET
; .FEND
;
;void Subroutine_1(void)
; 0001 0043 {
_Subroutine_1:
; .FSTART _Subroutine_1
; 0001 0044       lcd_gotoxy(0, 0);
	CALL SUBOPT_0x0
; 0001 0045       lcd_puts("Erfan Bahrami");
	__POINTW2MN _0x20003,0
	CALL SUBOPT_0x1
; 0001 0046       lcd_gotoxy(0, 1);
; 0001 0047       lcd_puts("9624513");
	__POINTW2MN _0x20003,14
	CALL _lcd_puts
; 0001 0048       delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0001 0049 }
	RET
; .FEND

	.DSEG
_0x20003:
	.BYTE 0x16
;
;void Subroutine_2(void)
; 0001 004C {

	.CSEG
_Subroutine_2:
; .FSTART _Subroutine_2
; 0001 004D         char string[] = "Welcome to the online lab classes due to Corona disease.";
; 0001 004E         char show[16];
; 0001 004F          //  char show2[] = "---------------";
; 0001 0050         int counter = 0;
; 0001 0051         delay_ms(500);
	SBIW R28,63
	SBIW R28,10
	LDI  R24,57
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	LDI  R30,LOW(_0x20004*2)
	LDI  R31,HIGH(_0x20004*2)
	CALL __INITLOCB
	ST   -Y,R17
	ST   -Y,R16
;	string -> Y+18
;	show -> Y+2
;	counter -> R16,R17
	__GETWRN 16,17,0
	CALL SUBOPT_0x2
; 0001 0052         for(counter = 0; counter<strlen(string); counter++)
	__GETWRN 16,17,0
_0x20006:
	MOVW R26,R28
	ADIW R26,18
	CALL _strlen
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x20007
; 0001 0053         {
; 0001 0054             lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0001 0055             strncpy(show, &string[counter], 16);
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,20
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(16)
	CALL _strncpy
; 0001 0056          //   lcd_gotoxy(0, 0);
; 0001 0057          //   lcd_puts(show2);
; 0001 0058             lcd_puts(show);
	MOVW R26,R28
	ADIW R26,2
	CALL _lcd_puts
; 0001 0059             delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0001 005A             lcd_clear();
	CALL _lcd_clear
; 0001 005B         }
	__ADDWRN 16,17,1
	RJMP _0x20006
_0x20007:
; 0001 005C }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,63
	ADIW R28,12
	RET
; .FEND
;unsigned char Subroutine_3(void)
; 0001 005E {
_Subroutine_3:
; .FSTART _Subroutine_3
; 0001 005F         unsigned char col, row , temp;
; 0001 0060         unsigned char array[4][4] = {   {'0','1','2','3'},
; 0001 0061                                         {'4','5','6','7'},
; 0001 0062                                         {'8','9','A','B'},
; 0001 0063                                         {'C','D','E','F'}};
; 0001 0064         KEY_DDR = 0xf0;
	SBIW R28,16
	LDI  R24,16
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x20008*2)
	LDI  R31,HIGH(_0x20008*2)
	CALL __INITLOCB
	CALL __SAVELOCR4
;	col -> R17
;	row -> R16
;	temp -> R19
;	array -> Y+4
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0001 0065         KEY_PRT = 0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0001 0066         /*  check for columns */
; 0001 0067         do {
_0x2000A:
; 0001 0068             KEY_PRT = 0xff;
	LDI  R30,LOW(255)
	CALL SUBOPT_0x3
; 0001 0069             col= (KEY_PIN & 0x0f);
; 0001 006A         } while (col != 0x00);
	CPI  R17,0
	BRNE _0x2000A
; 0001 006B 
; 0001 006C         do {
_0x2000D:
; 0001 006D             KEY_PRT = 0xff;
	LDI  R30,LOW(255)
	CALL SUBOPT_0x3
; 0001 006E             col= (KEY_PIN & 0x0f);
; 0001 006F         } while (col == 0x00);
	CPI  R17,0
	BREQ _0x2000D
; 0001 0070 
; 0001 0071         do {
_0x20010:
; 0001 0072             do {
_0x20013:
; 0001 0073                   delay_ms(20);
	CALL SUBOPT_0x4
; 0001 0074                   col = (KEY_PIN & 0x0f);
; 0001 0075             } while (col == 0x00);
	CPI  R17,0
	BREQ _0x20013
; 0001 0076 
; 0001 0077             delay_ms(20);
	CALL SUBOPT_0x4
; 0001 0078             col = (KEY_PIN & 0x0f);
; 0001 0079 
; 0001 007A         } while (col == 0x00);
	CPI  R17,0
	BREQ _0x20010
; 0001 007B 
; 0001 007C         /* now check for rows */
; 0001 007D         while(1)
_0x20015:
; 0001 007E         {
; 0001 007F                 KEY_PRT = 0x1f;
	LDI  R30,LOW(31)
	CALL SUBOPT_0x3
; 0001 0080                 col = (KEY_PIN & 0x0f);
; 0001 0081                 if (col != 0x00)
	CPI  R17,0
	BREQ _0x20018
; 0001 0082                 {
; 0001 0083                     row=0;
	LDI  R16,LOW(0)
; 0001 0084                     break;
	RJMP _0x20017
; 0001 0085                 }
; 0001 0086 
; 0001 0087                 KEY_PRT = 0x2f;
_0x20018:
	LDI  R30,LOW(47)
	CALL SUBOPT_0x3
; 0001 0088                 col = (KEY_PIN & 0x0f);
; 0001 0089                 if (col != 0x00)
	CPI  R17,0
	BREQ _0x20019
; 0001 008A                 {
; 0001 008B                     row=1;
	LDI  R16,LOW(1)
; 0001 008C                     break;
	RJMP _0x20017
; 0001 008D                 }
; 0001 008E 
; 0001 008F                 KEY_PRT = 0x4f;
_0x20019:
	LDI  R30,LOW(79)
	CALL SUBOPT_0x3
; 0001 0090                 col = (KEY_PIN & 0x0f);
; 0001 0091                 if (col != 0x00)
	CPI  R17,0
	BREQ _0x2001A
; 0001 0092                 {
; 0001 0093                     row=2;
	LDI  R16,LOW(2)
; 0001 0094                     break;
	RJMP _0x20017
; 0001 0095                 }
; 0001 0096 
; 0001 0097                 KEY_PRT = 0x8f;
_0x2001A:
	LDI  R30,LOW(143)
	CALL SUBOPT_0x3
; 0001 0098                 col = (KEY_PIN & 0x0f);
; 0001 0099                 if (col != 0x00)
	CPI  R17,0
	BREQ _0x2001B
; 0001 009A                 {
; 0001 009B                     row=3;
	LDI  R16,LOW(3)
; 0001 009C                     break;
	RJMP _0x20017
; 0001 009D                 }
; 0001 009E       }
_0x2001B:
	RJMP _0x20015
_0x20017:
; 0001 009F 
; 0001 00A0         if (col == 0x01)
	CPI  R17,1
	BRNE _0x2001C
; 0001 00A1                 temp = (array[row][0]);
	CALL SUBOPT_0x5
	ADD  R26,R30
	ADC  R27,R31
	LD   R19,X
; 0001 00A2         else if (col == 0x02)
	RJMP _0x2001D
_0x2001C:
	CPI  R17,2
	BRNE _0x2001E
; 0001 00A3                 temp =(array[row][1]);
	CALL SUBOPT_0x5
	ADD  R30,R26
	ADC  R31,R27
	LDD  R19,Z+1
; 0001 00A4         else if (col == 0x04)
	RJMP _0x2001F
_0x2001E:
	CPI  R17,4
	BRNE _0x20020
; 0001 00A5                 temp =(array[row][2]);
	CALL SUBOPT_0x5
	ADD  R30,R26
	ADC  R31,R27
	LDD  R19,Z+2
; 0001 00A6         else
	RJMP _0x20021
_0x20020:
; 0001 00A7                 temp =(array[row][3]);
	CALL SUBOPT_0x5
	ADD  R30,R26
	ADC  R31,R27
	LDD  R19,Z+3
; 0001 00A8         return temp ;
_0x20021:
_0x2001F:
_0x2001D:
	MOV  R30,R19
	CALL __LOADLOCR4
	ADIW R28,20
	RET
; 0001 00A9 }
; .FEND
;
;void Subroutine_5(void)
; 0001 00AC {
_Subroutine_5:
; .FSTART _Subroutine_5
; 0001 00AD         unsigned char first_number, second_number , number;
; 0001 00AE 
; 0001 00AF          while(1)
	CALL __SAVELOCR4
;	first_number -> R17
;	second_number -> R16
;	number -> R19
_0x20022:
; 0001 00B0         {
; 0001 00B1                 lcd_clear();
	CALL SUBOPT_0x6
; 0001 00B2                 lcd_gotoxy(0, 0);
; 0001 00B3                 lcd_puts("Speed??(0-50)");
	__POINTW2MN _0x20025,0
	CALL SUBOPT_0x1
; 0001 00B4                 lcd_gotoxy(0, 1);
; 0001 00B5 
; 0001 00B6                 first_number = Subroutine_3();
	CALL SUBOPT_0x7
; 0001 00B7                 lcd_putchar(first_number);
; 0001 00B8 
; 0001 00B9                 second_number = Subroutine_3();
; 0001 00BA                 lcd_putchar(second_number);
; 0001 00BB 
; 0001 00BC                 number = (int)(first_number)*10  +  (int)(second_number) ;
; 0001 00BD                 delay_ms(500);
; 0001 00BE 
; 0001 00BF                 if ( number >= 0 && number <=50 )
	CPI  R19,0
	BRLO _0x20027
	CPI  R19,51
	BRLO _0x20028
_0x20027:
	RJMP _0x20026
_0x20028:
; 0001 00C0                 {
; 0001 00C1 
; 0001 00C2                         delay_ms(1500);
	CALL SUBOPT_0x8
; 0001 00C3                         break;
	RJMP _0x20024
; 0001 00C4                 }
; 0001 00C5                 else
_0x20026:
; 0001 00C6                 {
; 0001 00C7                         lcd_clear();
	CALL SUBOPT_0x6
; 0001 00C8                         lcd_gotoxy(0, 0);
; 0001 00C9                         lcd_puts("EE");
	__POINTW2MN _0x20025,14
	CALL SUBOPT_0x9
; 0001 00CA                         delay_ms(1500);
; 0001 00CB                 }
; 0001 00CC       }
	RJMP _0x20022
_0x20024:
; 0001 00CD 
; 0001 00CE         while(1)
_0x2002A:
; 0001 00CF         {
; 0001 00D0                 lcd_clear();
	CALL SUBOPT_0x6
; 0001 00D1                 lcd_gotoxy(0, 0);
; 0001 00D2                 lcd_puts("Time:??(0-99s)");
	__POINTW2MN _0x20025,17
	CALL SUBOPT_0x1
; 0001 00D3                 lcd_gotoxy(0, 1);
; 0001 00D4 
; 0001 00D5                 first_number = Subroutine_3();
	CALL SUBOPT_0x7
; 0001 00D6                 lcd_putchar(first_number);
; 0001 00D7 
; 0001 00D8                 second_number = Subroutine_3();
; 0001 00D9                 lcd_putchar(second_number);
; 0001 00DA 
; 0001 00DB                 number = (int)(first_number)*10  +  (int)(second_number) ;
; 0001 00DC                 delay_ms(500);
; 0001 00DD 
; 0001 00DE                 if ( number >= 0 && number <=99 )
	CPI  R19,0
	BRLO _0x2002E
	CPI  R19,100
	BRLO _0x2002F
_0x2002E:
	RJMP _0x2002D
_0x2002F:
; 0001 00DF                 {
; 0001 00E0                         lcd_putchar(first_number);
	CALL SUBOPT_0xA
; 0001 00E1                         lcd_putchar(second_number);
; 0001 00E2                         delay_ms(1500);
; 0001 00E3                         break;
	RJMP _0x2002C
; 0001 00E4                 }
; 0001 00E5                 else
_0x2002D:
; 0001 00E6                 {
; 0001 00E7                         lcd_clear();
	CALL SUBOPT_0x6
; 0001 00E8                         lcd_gotoxy(0, 0);
; 0001 00E9                         lcd_puts("EE");
	__POINTW2MN _0x20025,32
	CALL SUBOPT_0x9
; 0001 00EA                         delay_ms(1500);
; 0001 00EB                 }
; 0001 00EC       }
	RJMP _0x2002A
_0x2002C:
; 0001 00ED 
; 0001 00EE       while(1)
_0x20031:
; 0001 00EF         {
; 0001 00F0                 lcd_clear();
	CALL SUBOPT_0x6
; 0001 00F1                 lcd_gotoxy(0, 0);
; 0001 00F2                 lcd_puts("Weigt:??(0-99F)");
	__POINTW2MN _0x20025,35
	CALL SUBOPT_0x1
; 0001 00F3                 lcd_gotoxy(0, 1);
; 0001 00F4 
; 0001 00F5                 first_number = Subroutine_3();
	CALL SUBOPT_0x7
; 0001 00F6                 lcd_putchar(first_number);
; 0001 00F7 
; 0001 00F8                 second_number = Subroutine_3();
; 0001 00F9                 lcd_putchar(second_number);
; 0001 00FA 
; 0001 00FB                 number = (int)(first_number)*10  +  (int)(second_number) ;
; 0001 00FC                 delay_ms(500);
; 0001 00FD 
; 0001 00FE                 if ( number >= 0 && number <=99 )
	CPI  R19,0
	BRLO _0x20035
	CPI  R19,100
	BRLO _0x20036
_0x20035:
	RJMP _0x20034
_0x20036:
; 0001 00FF                 {
; 0001 0100                         lcd_putchar(first_number);
	CALL SUBOPT_0xA
; 0001 0101                         lcd_putchar(second_number);
; 0001 0102                         delay_ms(1500);
; 0001 0103                         break;
	RJMP _0x20033
; 0001 0104                 }
; 0001 0105                 else
_0x20034:
; 0001 0106                 {
; 0001 0107                         lcd_clear();
	CALL SUBOPT_0x6
; 0001 0108                         lcd_gotoxy(0, 0);
; 0001 0109                         lcd_puts("EE");
	__POINTW2MN _0x20025,51
	CALL SUBOPT_0x9
; 0001 010A                         delay_ms(1500);
; 0001 010B                 }
; 0001 010C       }
	RJMP _0x20031
_0x20033:
; 0001 010D 
; 0001 010E        while(1)
_0x20038:
; 0001 010F         {
; 0001 0110                 lcd_clear();
	CALL SUBOPT_0x6
; 0001 0111                 lcd_gotoxy(0, 0);
; 0001 0112                 lcd_puts("Temp:??(20-80C)");
	__POINTW2MN _0x20025,54
	CALL SUBOPT_0x1
; 0001 0113                 lcd_gotoxy(0, 1);
; 0001 0114 
; 0001 0115                 first_number = Subroutine_3();
	CALL SUBOPT_0x7
; 0001 0116                 lcd_putchar(first_number);
; 0001 0117 
; 0001 0118                 second_number = Subroutine_3();
; 0001 0119                 lcd_putchar(second_number);
; 0001 011A 
; 0001 011B                 number = (int)(first_number)*10  +  (int)(second_number) ;
; 0001 011C                 delay_ms(500);
; 0001 011D 
; 0001 011E                 if ( number >= 20 && number <=80 )
	CPI  R19,20
	BRLO _0x2003C
	CPI  R19,81
	BRLO _0x2003D
_0x2003C:
	RJMP _0x2003B
_0x2003D:
; 0001 011F                 {
; 0001 0120                         lcd_putchar(first_number);
	CALL SUBOPT_0xA
; 0001 0121                         lcd_putchar(second_number);
; 0001 0122                         delay_ms(1500);
; 0001 0123                         break;
	RJMP _0x2003A
; 0001 0124                 }
; 0001 0125                 else
_0x2003B:
; 0001 0126                 {
; 0001 0127                         lcd_clear();
	CALL SUBOPT_0x6
; 0001 0128                         lcd_gotoxy(0, 0);
; 0001 0129                         lcd_puts("EE");
	__POINTW2MN _0x20025,70
	CALL SUBOPT_0x9
; 0001 012A                         delay_ms(1500);
; 0001 012B                 }
; 0001 012C       }
	RJMP _0x20038
_0x2003A:
; 0001 012D 
; 0001 012E 
; 0001 012F }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND

	.DSEG
_0x20025:
	.BYTE 0x49

	.CSEG
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
_strncpy:
; .FSTART _strncpy
	ST   -Y,R26
    ld   r23,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strncpy0:
    tst  r23
    breq strncpy1
    dec  r23
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strncpy0
strncpy2:
    tst  r23
    breq strncpy1
    dec  r23
    st   x+,r22
    rjmp strncpy2
strncpy1:
    movw r30,r24
    ret
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
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2040001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x2040001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0xB
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0xB
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020005
	CP   R5,R7
	BRLO _0x2020004
_0x2020005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020007
	RJMP _0x2040001
_0x2020007:
_0x2020004:
	INC  R5
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2040001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xC
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
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
_0x2040001:
	ADIW R28,1
	RET
; .FEND

	.DSEG
__base_y_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1:
	RCALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	OUT  0x18,R30
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x6:
	RCALL _lcd_clear
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0x7:
	CALL _Subroutine_3
	MOV  R17,R30
	MOV  R26,R17
	RCALL _lcd_putchar
	CALL _Subroutine_3
	MOV  R16,R30
	MOV  R26,R16
	RCALL _lcd_putchar
	LDI  R26,LOW(10)
	MULS R17,R26
	MOVW R30,R0
	ADD  R30,R16
	MOV  R19,R30
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	RCALL _lcd_puts
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	MOV  R26,R17
	RCALL _lcd_putchar
	MOV  R26,R16
	RCALL _lcd_putchar
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
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

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
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

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
