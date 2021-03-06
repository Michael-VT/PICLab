;*********************************************************************************************
;*������: "safirmx.asm"
;*����������: ������� ������ �������. ���������� �� ������������� ����������� ����������� �
;*������ ������.
;*********************************************************************************************
;*********************************************************************************************
;*		�������M��� ���������� ��� PIC16F876
;* �����		:����� �.�.	
;* ������		:5.01b ������ �������������� ����������� ��������	
;* �������� �������	:"SafirMX"	
;* �����������	:����������� ����������� ��� ������� ���i� ��	
;* ����		:1.03.2002�.	
;*********************************************************************************************
	LIST    p=PIC16f876	
	#include "P16f876.inc"	;�������� ������: "P16f876.inc"
	#include "SafirMX.inc"	;�������� ������: "SafirMX.inc"
__CONFIG H'3D3D'
;*
;*********************************************************************************************
;-----------------------------------------------------------------------------
;Macros to select the register bank
;Many bank changes can be optimised when only one STATUS bit changes
;EXPAND
#define ClkFreq 1843200 ; input clock frequency = 1,8432 MHz
#define baud(X) ((10*ClkFreq/(64*X))+5)/10 - 1
Bank0		MACRO			;macro to select data RAM bank 0
		bcf	STATUS,RP0
		bcf	STATUS,RP1
		ENDM

Bank1		MACRO			;macro to select data RAM bank 1
		bsf	STATUS,RP0
		bcf	STATUS,RP1
		ENDM

Bank2		MACRO			;macro to select data RAM bank 2
		bcf	STATUS,RP0
		bsf	STATUS,RP1
		ENDM

Bank3		MACRO			;macro to select data RAM bank 3
		bsf	STATUS,RP0
		bsf	STATUS,RP1
		ENDM

;*********************************************************************************************
	ORG	0x0000	;����� �������� ����: 0x0000
;*********************************************************************************************
;*********************************************************************************************
	goto	INSTALL	;������� �� ������ INSTALL
;*********************************************************************************************
	ORG	0x10	;����� �������� ����: 0x1000
;*********************************************************************************************
;*********************************************************************************************
;*������������: INSTALL
;*����������: ���������� ��������� ������ ����������������, �������� ��������� ��������,
;*����������� ���������� ���������.
;*������������ ������: "PORT.ASM", "CONST.ASM"
;*������������ ������������: �OMINSTALL, CONSTANTS, ADCSETUP, DEMPFCON, DAC, BOTHLED
;*������������ ��������: OPTION_REG, JOBREG, STORE0, DACL, DACH, T2CON, PR2, PRS1BUF1,
;*PRS2BUF1, TMPBUF1
;*********************************************************************************************
INSTALL				;0-OUTPUT, 1-INPUT
	
	clrwdt			;������� ����������� �������
	movlw	0x0F		;�������� � ����������� ����� 0x0F
	iorwf	OPTION_REG,1	;���������� �������� �������� OPTION_REG � ������������
	;++ ���������������� �������� TMR0 PS2:PS0 Prescaller Rate  1/128 WDT
	bcf	STATUS,RP0	;�������� ��� RP0 � �������� STATUS
	movlw	B'11111000'	;++ �������� � ����������� ����� B'11111000'
	movwf	PORTB		;��������� ����������� � ������� PORTB
	movlw	B'11111111'	;�������� � ����������� ����� B'11111111'
	movwf	PORTC		;��������� ����������� � ������� PORTC
	bsf	STATUS,RP0	;���������� ��� RP0 � �������� STATUS
	movlw	B'11111000'	;++ �������� � ����������� ����� B'11111011'
	movwf	TRISB		;��������� ����������� � ������� TRISB
	movlw	B'10000101'	;++ �������� � ����������� ����� B'10000101'
	movwf	TRISC		;��������� ����������� � ������� TRISC
	call	COMINSTALL	;++ ��������� ����������������� ����������
;*********************************************************************************************
;*������: "testbug.asm"
;*����������: �������� ������������ ��� �������� ������ ����������������.
;*********************************************************************************************
;*********************************************************************************************
;*������������: PORTINSTALL
;*����������: ���������� ������������ ������ ����������������.
;*������������ ������������:
;*������������ ��������: ADCON1, PORTA, TRISA, PORTB, TRISB, PORTC, TRISC
;*********************************************************************************************
test
	bcf	STATUS,7
	Bank0
	clrwdt		;������� ����������� �������
	bcf	RCSTA,CREN	;�������� ��� CREN � �������� RCSTA
	bsf	RCSTA,CREN	;���������� ��� CREN � �������� RCSTA
	movlw	'V'
	movwf	TXD
	call	BYTEOUT
	movlw	'.'
	movwf	TXD
	call	BYTEOUT
	movlw	'1'
	movwf	TXD
	call	BYTEOUT
	movlw	'0'
	movwf	TXD
	call	BYTEOUT
test00
	clrwdt		;������� ����������� �������
	bcf	RCSTA,CREN	;�������� ��� CREN � �������� RCSTA
	bsf	RCSTA,CREN	;���������� ��� CREN � �������� RCSTA
	bcf	JOBREG,RXER
	call	BYTEIN
	btfsc	JOBREG,RXER
	goto	test00
	movlw	0x55
	subwf	RXD,0
	btfss	STATUS,2
	goto	CommandAA
Command55
	call	BYTEIN
	btfsc	JOBREG,RXER
	goto	test00
	movf	RXD,0
	movwf	FSR
	call	BYTEIN
	btfsc	JOBREG,RXER
	goto	test00
	movlw	0x87
	subwf	FSR,0
	btfss	STATUS,2
	goto	next
	bsf	RXD,7		;++ RXD ��������� �� ����
	bcf	RXD,6		;++ TXD ��������� �� �����
next
	movf	RXD,0
	movwf	INDF	
	goto	test00	
CommandAA
	movlw	0xAA
	subwf	RXD,0
	btfss	STATUS,2
	goto	Command00	
	call	BYTEIN
	btfsc	JOBREG,RXER
	goto	test00
	movf	RXD,0
	movwf	FSR
	movf	INDF,0
	movwf	TXD
	call	BYTEOUT
	goto	test00
Command00
	movlw	0x00
	subwf	RXD,0
	btfss	STATUS,2
	goto	test
	movlw	0
	movwf	PCLATH
	goto	0
;*********************************************************************************************
;*********************************************************************************************
;*������: "COMPORT.ASM"
;*����������: �������� ������������ ����� ������� � �� �� COM-�����
;*********************************************************************************************
;********************************************************************************************* 
;*������������: COMINSTALL
;*����������: ���������� ����������� COM-����� (��������: 9600 ��� ��� Fclk=1.843200 MHz)
;*������������ ������������: 
;*������������ ��������: SPBRG, TXSTA, RCSTA
;*********************************************************************************************
COMINSTALL	
	bsf	STATUS,RP0	;���������� ��� RP0 � �������� STATUS 	Bank1
	movlw	2	;++ ����������� ��� �������� ������ �� 	RS232 9600 bps

	movwf	SPBRG		;��������� ����������� � ������� SPBRG
	bcf	TXSTA,BRGH	;�������� ��� BRGH � �������� TXSTA 	Low speed
	bcf	TXSTA,SYNC	;�������� ��� SYNC � �������� TXSTA	Asynch mode
	bsf	TXSTA,TXEN	;���������� ��� TXEN � �������� TXSTA	Transmit enabled
	bcf	STATUS,RP0	;�������� ��� RP0 � �������� STATUS	Bank0
	bsf	RCSTA,SPEN	;���������� ��� SPEN � �������� RCSTA	Serial enable
	bsf	RCSTA,CREN	;���������� ��� CREN � �������� RCSTA	Contin,receive enable
	bsf	TRISC,7		;++ RXD ��������� �� ����
	bcf	TRISC,6		;++ TXD ��������� �� �����
	bcf	RCSTA,CREN	;�������� ��� CREN � �������� RCSTA
	bsf	RCSTA,CREN	;���������� ��� CREN � �������� RCSTA
	Bank0
	return		
;*********************************************************************************************
;********************************************************************************************* 
;*������������: INQUIRY
;*����������: ������������ ������ ������� �� �� �����.
;*������������ ������������: BYTEOUT, DECODE
;*������������ ��������: RCSTA, PIR1, RCREG, RXD, TXD
;*********************************************************************************************
INQUIRY	
	clrwdt		;������� ����������� �������
	bcf	RCSTA,CREN	;�������� ��� CREN � �������� RCSTA
	bsf	RCSTA,CREN	;���������� ��� CREN � �������� RCSTA
	btfss	PIR1,RCIF	;���������� �������, ���� ��� RCIF � �������� PIR1 ����� 1
	return		;������� �� ������������
	movf	RCREG,0	;��������� ������� RCREG � �����������
	movwf	RXD	;��������� ����������� � ������� RXD
	movwf	TXD	;��������� ����������� � ������� TXD
	call	BYTEOUT	;����� ������������ BYTEOUT
	return		;������� �� ������������
;********************************************************************************************* 
;********************************************************************************************* 
;*������������: BYTEOUT
;*����������: ������������ ������ ����� ������ �� COM-�����.
;*������������ ������������: 
;*������������ ��������: TXSTA, TXD, TXREG
;*********************************************************************************************
BYTEOUT	bsf	STATUS,RP0	;++ ���������� Bank1
txd1	btfss	TXSTA,TRMT	;���������� �������, ���� ��� TRMT � �������� TXSTA ����� 1
	goto	txd1	;������� �� ������ txd1
	bcf	STATUS,RP0	;++ ���������� Bank0
	movf	TXD,0	;��������� ������� TXD � �����������
	movwf	TXREG	;��������� ����������� � ������� TXREG
	clrwdt		;������� ����������� �������
	return		;������� �� ������������
;********************************************************************************************* 
;********************************************************************************************* 
;*������������: BYTEIN
;*����������: ������������ ���� ����� ������ �� COM-�����.
;*������������ ������������: 
;*������������ ��������: JOBREG, CNT0, CNT1, PIR1, TXREG, RCREG, RXD
;*********************************************************************************************

BYTEIN	bcf	JOBREG,RXER	;�������� ��� RXER � �������� JOBREG
	movlw	0xFF	;�������� � ����������� ����� 0xFF
	movwf	CNT1	;��������� ����������� � ������� CNT1
rxd0	clrwdt		;������� ����������� �������
	movlw	0xFF	;�������� � ����������� ����� 0xFF
	movwf	CNT0	;��������� ����������� � ������� CNT0
rxd1	btfsc	PIR1,RCIF	;���������� �������, ���� ��� RCIF � �������� PIR1 ����� 0
	goto	rxd2	;������� �� ������ rxd2
	decfsz	CNT0,1	;��������� �������� CNT0, ���������� ������� ���� 0
	goto	rxd1	;������� �� ������ rxd1
	decfsz	CNT1,1	;��������� �������� CNT1, ���������� ������� ���� 0
	goto	rxd0	;������� �� ������ rxd0
	bsf	JOBREG,RXER	;���������� ��� RXER � �������� JOBREG
	return		;������� �� ������������
rxd2	movf	RCREG,0	;��������� ������� RCREG � �����������
	movwf	RXD	;��������� ����������� � ������� RXD
;	movwf	TXREG	;��������� ����������� � ������� TXREG
	clrwdt		;������� ����������� �������
	return		;������� �� ������������
;********************************************************************************************* 
;********************************************************************************************* 
;*������������: READNBYTE
;*����������: ������������ ���� ���������� (�� 256) ���� ������ �� COM-�����
;*������������ ������������: BYTEIN
;*������������ ��������: DLY0, DLY1, TEMPB0, TEMPB1, STORE0, JOBREG, RXD
;*********************************************************************************************
READNBYTE	movlw	0x07	;�������� � ����������� ����� 0x07
	andwf	DLY0,0	;���������� ��������� ������������ � �������� DLY0
	movwf	DLY0	;��������� ����������� � ������� DLY0
	movwf	DLY1	;��������� ����������� � ������� DLY1
	movf	FSR,0	;��������� ������� FSR � �����������
	movwf	TEMPB0	;��������� ����������� � ������� TEMPB0
	movlw	STORE0	;�������� � ����������� ����� STORE0
	movwf	FSR	;��������� ����������� � ������� FSR
rnb0	call	BYTEIN	;����� ������������ BYTEIN
	btfsc	JOBREG,RXER	;���������� �������, ���� ��� RXER � �������� JOBREG ����� 0
	return		;������� �� ������������
	movf	RXD,0	;��������� ������� RXD � �����������
	movwf	INDF	;��������� ����������� � ������� INDF
	incf	FSR,1	;��������� �������� FSR, ��������� � ��������
	decfsz	DLY0,1	;��������� �������� DLY0, ���������� ������� ���� 0
	goto	rnb0	;������� �� ������ rnb0
	movlw	STORE0	;�������� � ����������� ����� STORE0
	movwf	FSR	;��������� ����������� � ������� FSR
	movwf	TEMPB1	;��������� ����������� � ������� TEMPB1
rnb1	movf	INDF,0	;��������� ������� INDF � �����������
	movwf	DLY0	;��������� ����������� � ������� DLY0
	movf	TEMPB0,0	;��������� ������� TEMPB0 � �����������
	movwf	FSR	;��������� ����������� � ������� FSR
	movf	DLY0,0	;��������� ������� DLY0 � �����������
	movwf	INDF	;��������� ����������� � ������� INDF
	decf	FSR,0	;��������� �������� FSR, ��������� � ������������
	movwf	TEMPB0	;��������� ����������� � ������� TEMPB0
	incf	TEMPB1,0	;��������� �������� TEMPB1, ��������� � ������������
	movwf	TEMPB1	;��������� ����������� � ������� TEMPB1
	movwf	FSR	;��������� ����������� � ������� FSR
	decfsz	DLY1,1	;��������� �������� DLY1, ���������� ������� ���� 0
	goto	rnb1	;������� �� ������ rnb1
	return		;������� �� ������������
;********************************************************************************************* 
;********************************************************************************************* 
;*������������: WRITENBYTE
;*����������: ������������ ������ ���������� (�� 256) ���� ������ �� COM-�����. 
;*������������ ������������: BYTEOUT.
;*������������ ��������: TXD, DLY0, (STORE0:STORE7).
;*********************************************************************************************
WRITENBYTE	movf	INDF,0	;��������� ������� INDF � �����������
	movwf	TXD	;��������� ����������� � ������� TXD
	call	BYTEOUT	;����� ������������ BYTEOUT
	decf	FSR,1	;��������� �������� FSR, ��������� � ��������
	decfsz	DLY0,1	;��������� �������� DLY0, ���������� ������� ���� 0
	goto	WRITENBYTE	;������� �� ������ WRITENBYTE
	return		;������� �� ������������
;*********************************************************************************************
;*********************************************************************************************
	end
;*********************************************************************************************
;*********************************************************************************************
