
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
;Global 'const' stored in FLASH: No
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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x2002A:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F
_0x2005A:
	.DB  0xBF,0x86,0xDB,0xCF,0xE6,0xED,0xFD,0x87
	.DB  0xFF,0xEF,0x3F,0x6,0x5B,0x4F,0x66,0x6D
	.DB  0x7D,0x7,0x7F,0x6F
_0x20000:
	.DB  0x4F,0x75,0x74,0x20,0x6F,0x66,0x20,0x72
	.DB  0x61,0x6E,0x67,0x65,0x0,0x6F,0x75,0x74
	.DB  0x20,0x6F,0x66,0x20,0x72,0x61,0x6E,0x67
	.DB  0x65,0x0,0x45,0x72,0x72,0x6F,0x72,0x0
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
;/*
; * 6.c
; *
; * Created: 2020-10-11 2:33:20 PM
; * Author: KPS
; */
;
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
;#include <stdio.h>
;#include <all_of_subroutins.h>
;
;#define portA 1
;#define portB 2
;#define portC 3
;#define portD 4
;
;
;void main(void)
; 0000 0014 {

	.CSEG
_main:
; .FSTART _main
; 0000 0015 while (1)
_0x3:
; 0000 0016     {
; 0000 0017         Subroutine_1(4, portB, 500);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _Subroutine_1
; 0000 0018 	    Subroutine_2(3, 3000);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	RCALL _Subroutine_2
; 0000 0019 	    Subroutine_3(portA, portB);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _Subroutine_3
; 0000 001A 	    Subroutine_4(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _Subroutine_4
; 0000 001B 	    Subroutine_5(0.3);
	__GETD2N 0x3E99999A
	RCALL _Subroutine_5
; 0000 001C     }
	RJMP _0x3
; 0000 001D }
_0x6:
	RJMP _0x6
; .FEND
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
;#include <stdio.h>
;
;#define portA 1
;#define portB 2
;#define portC 3
;#define portD 4
;void Subroutine_1(int number , char selectPort , int time)
; 0001 000A {

	.CSEG
_Subroutine_1:
; .FSTART _Subroutine_1
; 0001 000B     int counter = 0;
; 0001 000C     delay_ms(500);
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	number -> Y+5
;	selectPort -> Y+4
;	time -> Y+2
;	counter -> R16,R17
	__GETWRN 16,17,0
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0001 000D     switch (selectPort)
	LDD  R30,Y+4
	CALL SUBOPT_0x0
; 0001 000E     {
; 0001 000F         case(portA):
	BRNE _0x20006
; 0001 0010         DDRA = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0001 0011         for (counter = 0; counter < number; counter++)
	__GETWRN 16,17,0
_0x20008:
	CALL SUBOPT_0x1
	BRGE _0x20009
; 0001 0012         {
; 0001 0013             PORTA = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0001 0014             delay_ms(time);
	CALL SUBOPT_0x2
; 0001 0015             PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0001 0016             delay_ms(time);
	CALL SUBOPT_0x2
; 0001 0017         }
	__ADDWRN 16,17,1
	RJMP _0x20008
_0x20009:
; 0001 0018         break;
	RJMP _0x20005
; 0001 0019 
; 0001 001A         case(portB):
_0x20006:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2000A
; 0001 001B         DDRB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0001 001C         for (counter = 0; counter < number; counter++)
	__GETWRN 16,17,0
_0x2000C:
	CALL SUBOPT_0x1
	BRGE _0x2000D
; 0001 001D         {
; 0001 001E             PORTB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0001 001F             delay_ms(time);
	CALL SUBOPT_0x2
; 0001 0020             PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0001 0021             delay_ms(time);
	CALL SUBOPT_0x2
; 0001 0022         }
	__ADDWRN 16,17,1
	RJMP _0x2000C
_0x2000D:
; 0001 0023         break;
	RJMP _0x20005
; 0001 0024 
; 0001 0025         case(portC):
_0x2000A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2000E
; 0001 0026         DDRC = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0001 0027         for (counter = 0; counter < number; counter++)
	__GETWRN 16,17,0
_0x20010:
	CALL SUBOPT_0x1
	BRGE _0x20011
; 0001 0028         {
; 0001 0029             PORTC = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0001 002A             delay_ms(time);
	CALL SUBOPT_0x2
; 0001 002B             PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0001 002C             delay_ms(time);
	CALL SUBOPT_0x2
; 0001 002D         }
	__ADDWRN 16,17,1
	RJMP _0x20010
_0x20011:
; 0001 002E         break;
	RJMP _0x20005
; 0001 002F 
; 0001 0030         case(portD):
_0x2000E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20016
; 0001 0031         DDRD = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0001 0032         for (counter = 0; counter < number; counter++)
	__GETWRN 16,17,0
_0x20014:
	CALL SUBOPT_0x1
	BRGE _0x20015
; 0001 0033         {
; 0001 0034             PORTD = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0001 0035             delay_ms(time);
	CALL SUBOPT_0x2
; 0001 0036             PORTD = 0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0001 0037             delay_ms(time);
	CALL SUBOPT_0x2
; 0001 0038         }
	__ADDWRN 16,17,1
	RJMP _0x20014
_0x20015:
; 0001 0039         break;
	RJMP _0x20005
; 0001 003A 
; 0001 003B         default:
_0x20016:
; 0001 003C         printf("Out of range");
	__POINTW1FN _0x20000,0
	CALL SUBOPT_0x3
; 0001 003D         break;
; 0001 003E     }
_0x20005:
; 0001 003F }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
; .FEND
;
;void Subroutine_2(int location , int time)
; 0001 0042 {
_Subroutine_2:
; .FSTART _Subroutine_2
; 0001 0043     int counter = location-1;
; 0001 0044     int d = (time / ( 8 - location ));
; 0001 0045     DDRB = 0xFF;
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	location -> Y+6
;	time -> Y+4
;	counter -> R16,R17
;	d -> R18,R19
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,1
	MOVW R16,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	SUB  R30,R26
	SBC  R31,R27
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __DIVW21
	MOVW R18,R30
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0001 0046     while ( counter < 8 )
_0x20017:
	__CPWRN 16,17,8
	BRGE _0x20019
; 0001 0047     {
; 0001 0048         PORTB |= 1 << counter;
	IN   R1,24
	MOV  R30,R16
	CALL SUBOPT_0x4
	OUT  0x18,R30
; 0001 0049         delay_ms(d);
	MOVW R26,R18
	CALL _delay_ms
; 0001 004A         PORTB &= ~(1 << counter);
	IN   R1,24
	MOV  R30,R16
	CALL SUBOPT_0x5
	OUT  0x18,R30
; 0001 004B         counter++;
	__ADDWRN 16,17,1
; 0001 004C     }
	RJMP _0x20017
_0x20019:
; 0001 004D }
	CALL __LOADLOCR4
	ADIW R28,8
	RET
; .FEND
;
;void Subroutine_3(char select_input , char select_output)
; 0001 0050 {
_Subroutine_3:
; .FSTART _Subroutine_3
; 0001 0051     int value;
; 0001 0052     switch(select_input)
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	select_input -> Y+3
;	select_output -> Y+2
;	value -> R16,R17
	LDD  R30,Y+3
	CALL SUBOPT_0x0
; 0001 0053     {
; 0001 0054         case(portA):
	BRNE _0x2001D
; 0001 0055             DDRA = 0x00; value = PINA; break;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	IN   R16,25
	CLR  R17
	RJMP _0x2001C
; 0001 0056 
; 0001 0057         case(portB):
_0x2001D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2001E
; 0001 0058             DDRB = 0x00; value = PINB; break;
	LDI  R30,LOW(0)
	OUT  0x17,R30
	IN   R16,22
	CLR  R17
	RJMP _0x2001C
; 0001 0059 
; 0001 005A         case(portC):
_0x2001E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2001F
; 0001 005B             DDRC = 0x00; value = PINC; break;
	LDI  R30,LOW(0)
	OUT  0x14,R30
	IN   R16,19
	CLR  R17
	RJMP _0x2001C
; 0001 005C 
; 0001 005D         case(portD):
_0x2001F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20021
; 0001 005E             DDRD = 0x00; value = PIND; break;
	LDI  R30,LOW(0)
	OUT  0x11,R30
	IN   R16,16
	CLR  R17
	RJMP _0x2001C
; 0001 005F 
; 0001 0060         default:
_0x20021:
; 0001 0061             printf("out of range");
	__POINTW1FN _0x20000,13
	CALL SUBOPT_0x3
; 0001 0062             break;
; 0001 0063     }
_0x2001C:
; 0001 0064 
; 0001 0065     switch(select_output)
	LDD  R30,Y+2
	CALL SUBOPT_0x0
; 0001 0066     {
; 0001 0067         case(portA):
	BRNE _0x20025
; 0001 0068             DDRA = 0xFF; PORTA = value; break;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	OUT  0x1B,R16
	RJMP _0x20024
; 0001 0069 
; 0001 006A         case(portB):
_0x20025:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20026
; 0001 006B             DDRB = 0xFF; PORTB = value; break;
	LDI  R30,LOW(255)
	OUT  0x17,R30
	OUT  0x18,R16
	RJMP _0x20024
; 0001 006C 
; 0001 006D         case(portC):
_0x20026:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20027
; 0001 006E             DDRC = 0xFF; PORTC = value; break;
	LDI  R30,LOW(255)
	OUT  0x14,R30
	OUT  0x15,R16
	RJMP _0x20024
; 0001 006F 
; 0001 0070         case(portD):
_0x20027:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20029
; 0001 0071             DDRD = 0xFF; PORTD = value; break;
	LDI  R30,LOW(255)
	OUT  0x11,R30
	OUT  0x12,R16
	RJMP _0x20024
; 0001 0072 
; 0001 0073         default:
_0x20029:
; 0001 0074             printf("out of range");
	__POINTW1FN _0x20000,13
	CALL SUBOPT_0x3
; 0001 0075             break;
; 0001 0076     }
_0x20024:
; 0001 0077 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;
;void Subroutine_4(char incDec , char syncAsinc)
; 0001 007A {
_Subroutine_4:
; .FSTART _Subroutine_4
; 0001 007B     int counter = 0 , which;
; 0001 007C     char array[] = {    0b00111111,      // 9  7_segment
; 0001 007D                         0b00000110,      // 8  7_segment
; 0001 007E                         0b01011011,      // 7  7_segment
; 0001 007F                         0b01001111,      // 6  7_segment
; 0001 0080                         0b01100110,      // 5  7_segment
; 0001 0081                         0b01101101,      // 4  7_segment
; 0001 0082                         0b01111101,      // 3  7_segment
; 0001 0083                         0b00000111,      // 2  7_segment
; 0001 0084                         0b01111111,      // 1  7_segment
; 0001 0085                         0b01101111       // 0  7_segment
; 0001 0086                         };
; 0001 0087     DDRC = 0xFF;
	ST   -Y,R26
	SBIW R28,10
	LDI  R24,10
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x2002A*2)
	LDI  R31,HIGH(_0x2002A*2)
	CALL __INITLOCB
	CALL __SAVELOCR4
;	incDec -> Y+15
;	syncAsinc -> Y+14
;	counter -> R16,R17
;	which -> R18,R19
;	array -> Y+4
	__GETWRN 16,17,0
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0001 0088     DDRD = 0xFF;
	OUT  0x11,R30
; 0001 0089     switch(syncAsinc)
	LDD  R30,Y+14
	LDI  R31,0
; 0001 008A     {
; 0001 008B 		case(0):            // 0 for Synchronous
	SBIW R30,0
	BRNE _0x2002E
; 0001 008C             PORTD.0 = 0; PORTD.1 = 0; PORTD.2 = 0; PORTD.3 = 0;
	CBI  0x12,0
	CBI  0x12,1
	CBI  0x12,2
	CBI  0x12,3
; 0001 008D 			switch(incDec)
	LDD  R30,Y+15
	LDI  R31,0
; 0001 008E             {
; 0001 008F 				case(0):    // 0 for increasing
	SBIW R30,0
	BRNE _0x2003A
; 0001 0090 				    for (counter = 0; counter < 10; counter++)
	__GETWRN 16,17,0
_0x2003C:
	__CPWRN 16,17,10
	BRGE _0x2003D
; 0001 0091                     {
; 0001 0092 						PORTC = array[counter];
	CALL SUBOPT_0x6
; 0001 0093 						delay_ms(1000);
; 0001 0094 					}
	__ADDWRN 16,17,1
	RJMP _0x2003C
_0x2003D:
; 0001 0095 					break;
	RJMP _0x20039
; 0001 0096 
; 0001 0097 				case(1):    // 1 for decreasing
_0x2003A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20042
; 0001 0098 					for (counter = 9; counter >= 0; counter--)
	__GETWRN 16,17,9
_0x20040:
	TST  R17
	BRMI _0x20041
; 0001 0099                     {
; 0001 009A 						PORTC = array[counter];
	CALL SUBOPT_0x6
; 0001 009B 						delay_ms(1000);
; 0001 009C 					}
	__SUBWRN 16,17,1
	RJMP _0x20040
_0x20041:
; 0001 009D 					break;
	RJMP _0x20039
; 0001 009E 
; 0001 009F 				default:
_0x20042:
; 0001 00A0                     printf("Error");
	__POINTW1FN _0x20000,26
	CALL SUBOPT_0x3
; 0001 00A1 					break;
; 0001 00A2 			}
_0x20039:
; 0001 00A3 			break;
	RJMP _0x2002D
; 0001 00A4 
; 0001 00A5         case(1):	        // 1 for Asynchronous
_0x2002E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x2002D
; 0001 00A6 			switch(incDec)
	LDD  R30,Y+15
	LDI  R31,0
; 0001 00A7             {
; 0001 00A8 				PORTD.0 = 1; PORTD.1 = 1; PORTD.2 = 1; PORTD.3 = 1;
	SBI  0x12,0
	SBI  0x12,1
	SBI  0x12,2
	SBI  0x12,3
; 0001 00A9                 which = 0;
	__GETWRN 18,19,0
; 0001 00AA 				case(0):    // 0 for increasing
	SBIW R30,0
	BRNE _0x2004F
; 0001 00AB 					for (counter = 0; counter < 10; counter++)
	__GETWRN 16,17,0
_0x20051:
	__CPWRN 16,17,10
	BRGE _0x20052
; 0001 00AC                     {
; 0001 00AD                         if (which == 4)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x20053
; 0001 00AE 							which = 0;
	__GETWRN 18,19,0
; 0001 00AF 
; 0001 00B0 						PORTD &= ~(1 << which);
_0x20053:
	IN   R1,18
	MOV  R30,R18
	CALL SUBOPT_0x5
	OUT  0x12,R30
; 0001 00B1 						PORTC = array[counter];
	CALL SUBOPT_0x6
; 0001 00B2 						delay_ms(1000);
; 0001 00B3 						PORTD |= 1 << which;
	IN   R1,18
	MOV  R30,R18
	CALL SUBOPT_0x4
	OUT  0x12,R30
; 0001 00B4 
; 0001 00B5 						which++;
	__ADDWRN 18,19,1
; 0001 00B6 					}
	__ADDWRN 16,17,1
	RJMP _0x20051
_0x20052:
; 0001 00B7 					break;
	RJMP _0x20046
; 0001 00B8 
; 0001 00B9 				case(1):     // 1 for decreasing
_0x2004F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20059
; 0001 00BA 					for (counter = 9; counter >= 0; counter--)
	__GETWRN 16,17,9
_0x20056:
	TST  R17
	BRMI _0x20057
; 0001 00BB                     {
; 0001 00BC                         if (which == 4)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x20058
; 0001 00BD 							which = 0;
	__GETWRN 18,19,0
; 0001 00BE 
; 0001 00BF 						PORTD &= ~(1 << which);
_0x20058:
	IN   R1,18
	MOV  R30,R18
	CALL SUBOPT_0x5
	OUT  0x12,R30
; 0001 00C0 						PORTC = array[counter];
	CALL SUBOPT_0x6
; 0001 00C1 						delay_ms(1000);
; 0001 00C2 						PORTD |= 1 << which;
	IN   R1,18
	MOV  R30,R18
	CALL SUBOPT_0x4
	OUT  0x12,R30
; 0001 00C3 
; 0001 00C4 						which++;
	__ADDWRN 18,19,1
; 0001 00C5 					}
	__SUBWRN 16,17,1
	RJMP _0x20056
_0x20057:
; 0001 00C6 					break;
	RJMP _0x20046
; 0001 00C7 
; 0001 00C8 				default:
_0x20059:
; 0001 00C9                     printf("Error");
	__POINTW1FN _0x20000,26
	CALL SUBOPT_0x3
; 0001 00CA 					break;
; 0001 00CB 			}
_0x20046:
; 0001 00CC 			break;
; 0001 00CD 	}
_0x2002D:
; 0001 00CE }
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
;
;void Subroutine_5(float deghat)
; 0001 00D1 {
_Subroutine_5:
; .FSTART _Subroutine_5
; 0001 00D2       char arr[] = {    0b00111111,      // 9  7_segment
; 0001 00D3                         0b00000110,      // 8  7_segment
; 0001 00D4                         0b01011011,      // 7  7_segment
; 0001 00D5                         0b01001111,      // 6  7_segment
; 0001 00D6                         0b01100110,      // 5  7_segment
; 0001 00D7                         0b01101101,      // 4  7_segment
; 0001 00D8                         0b01111101,      // 3  7_segment
; 0001 00D9                         0b00000111,      // 2  7_segment
; 0001 00DA                         0b01111111,      // 1  7_segment
; 0001 00DB                         0b01101111       // 0  7_segment
; 0001 00DC                         };
; 0001 00DD       char arr2[] = {   0b10111111,      // 9  7_segment with dip points
; 0001 00DE                         0b10000110,      // 8  7_segment with dip points
; 0001 00DF                         0b11011011,      // 7  7_segment with dip points
; 0001 00E0                         0b11001111,      // 6  7_segment with dip points
; 0001 00E1                         0b11100110,      // 5  7_segment with dip points
; 0001 00E2                         0b11101101,      // 4  7_segment with dip points
; 0001 00E3                         0b11111101,      // 3  7_segment with dip points
; 0001 00E4                         0b10000111,      // 2  7_segment with dip points
; 0001 00E5                         0b11111111,      // 1  7_segment with dip points
; 0001 00E6                         0b11101111       // 0  7_segment with dip points
; 0001 00E7                         };
; 0001 00E8       int number = 0 , counter = 0 , deghat_10 = deghat*10;
; 0001 00E9       unsigned int a0 , a1, a2, a3;
; 0001 00EA       unsigned int b0 , b1 , b2 , b3;
; 0001 00EB       number = PINA;
	CALL __PUTPARD2
	SBIW R28,36
	LDI  R24,20
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	LDI  R30,LOW(_0x2005A*2)
	LDI  R31,HIGH(_0x2005A*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	deghat -> Y+42
;	arr -> Y+32
;	arr2 -> Y+22
;	number -> R16,R17
;	counter -> R18,R19
;	deghat_10 -> R20,R21
;	a0 -> Y+20
;	a1 -> Y+18
;	a2 -> Y+16
;	a3 -> Y+14
;	b0 -> Y+12
;	b1 -> Y+10
;	b2 -> Y+8
;	b3 -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETD2S 42
	__GETD1N 0x41200000
	CALL __MULF12
	CALL __CFD1U
	MOVW R20,R30
	IN   R16,25
	CLR  R17
; 0001 00EC       number = number * 10;
	MOVW R30,R16
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R16,R30
; 0001 00ED       DDRA = 0x00000000;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0001 00EE       DDRD = 0b00001111;
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0001 00EF 
; 0001 00F0       while (number >= 0)
_0x2005B:
	TST  R17
	BRPL PC+2
	RJMP _0x2005D
; 0001 00F1       {
; 0001 00F2             a0 = number % 10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0001 00F3             b0 = number / 10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0001 00F4 
; 0001 00F5             a1 = b0 % 10;
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x7
	STD  Y+18,R30
	STD  Y+18+1,R31
; 0001 00F6             b1 = b0 / 10;
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x8
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0001 00F7 
; 0001 00F8             a2 = b1 % 10;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x7
	STD  Y+16,R30
	STD  Y+16+1,R31
; 0001 00F9             b2 = b1 / 10;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x8
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 00FA 
; 0001 00FB             a3 = b2 % 10;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL SUBOPT_0x7
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0001 00FC             b3 = b2 / 10;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL SUBOPT_0x8
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 00FD 
; 0001 00FE             PORTC = arr[a3];
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CALL SUBOPT_0x9
; 0001 00FF             PORTD = 0b00001110; delay_ms(5);  PORTD = 0b00001111;
	LDI  R30,LOW(14)
	CALL SUBOPT_0xA
; 0001 0100 
; 0001 0101             PORTC = arr[a2];
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	CALL SUBOPT_0x9
; 0001 0102             PORTD = 0b00001101; delay_ms(5);  PORTD = 0b00001111;
	LDI  R30,LOW(13)
	CALL SUBOPT_0xA
; 0001 0103 
; 0001 0104             PORTC = arr2[a1];
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	MOVW R26,R28
	ADIW R26,22
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x15,R30
; 0001 0105             PORTD = 0b00001011; delay_ms(5);  PORTD = 0b00001111;
	LDI  R30,LOW(11)
	CALL SUBOPT_0xA
; 0001 0106 
; 0001 0107             PORTC = arr[a0];
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	CALL SUBOPT_0x9
; 0001 0108             PORTD = 0b00000111; delay_ms(5);  PORTD = 0b00001111;
	LDI  R30,LOW(7)
	CALL SUBOPT_0xA
; 0001 0109 
; 0001 010A             counter = counter + 1;
	__ADDWRN 18,19,1
; 0001 010B             if (counter == 20)
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x2005E
; 0001 010C             {
; 0001 010D                   number  = number - deghat_10;
	__SUBWRR 16,17,20,21
; 0001 010E                   counter = 0;
	__GETWRN 18,19,0
; 0001 010F             }
; 0001 0110       }
_0x2005E:
	RJMP _0x2005B
_0x2005D:
; 0001 0111 }
	CALL __LOADLOCR6
	ADIW R28,46
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
	ADIW R28,3
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0xB
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0xB
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0xC
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xD
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0xC
	CALL SUBOPT_0xE
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0xC
	CALL SUBOPT_0xE
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0xC
	CALL SUBOPT_0xF
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0xC
	CALL SUBOPT_0xF
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0xB
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0xB
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0xD
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0xB
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0xD
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
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

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	CP   R16,R30
	CPC  R17,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(1)
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x6:
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	OUT  0x15,R30
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	MOVW R26,R28
	ADIW R26,32
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x15,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xA:
	OUT  0x12,R30
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(15)
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xB:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
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

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
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
