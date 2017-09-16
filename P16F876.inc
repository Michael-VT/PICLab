;*********************************************************************************************
;*Модуль: "p16f876.inc"
;*Назначение: Описывает регистры внутренних устройств микроконтроллера PIC16F876.
;*Примечание: Все комментарии к данному модулю находятся в технической документации фирмы 
;*Microchip Inc.
;*********************************************************************************************
;*********************************** Битовые переменные **************************************
W	equ	0
F	equ	1
;****************************** Регистровые переменные Банк 0 ********************************
INDF	equ	0x00
TMR0	equ	0x01
PCL	equ	0x02
STATUS	equ	0x03
FSR	equ	0x04
PORTA	equ	0x05
PORTB	equ	0x06
PORTC	equ	0x07
PCLATH	equ	0x0A
INTCON	equ	0x0B
PIR1	equ	0x0C
PIR2	equ	0x0D
TMR1L	equ	0x0E
TMR1H	equ	0x0F
T1CON	equ	0x10
TMR2	equ	0x11
T2CON	equ	0x12
SSPBUF	equ	0x13
SSPCON	equ	0x14
CCPR1L	equ	0x15
CCPR1H	equ	0x16
CCP1CON	equ	0x17
RCSTA	equ	0x18
TXREG	equ	0x19
RCREG	equ	0x1A
CCPR2L	equ	0x1B
CCPR2H	equ	0x1C
CCP2CON	equ	0x1D
ADRESH	equ	0x1E
ADCON0	equ	0x1F
;****************************** Регистровые переменные Банк 1 ********************************
OPTION_REG	equ	0x81
TRISA	equ	0x85
TRISB	equ	0x86
TRISC	equ	0x87
PIE1	equ	0x8C
PIE2	equ	0x8D
PCON	equ	0x8E
SSPCON2	equ	0x91
PR2	equ	0x92
SSPADD	equ	0x93
SSPSTAT	equ	0x94
TXSTA	equ	0x98
SPBRG	equ	0x99
ADRESL	equ	0x9E
ADCON1	equ	0x9F
;****************************** Регистровые переменные Банк 2 ********************************
EEDATA	equ	0x10C
EEADR	equ	0x10D
EEDATH	equ	0x10E
EEADRH	equ	0x10F
;****************************** Регистровые переменные Банк 3 ********************************
EECON1	equ	0x18C
EECON2	equ	0x18D
;*************************** Битовые переменные регистра STATUS ******************************
IRP	equ	7
RP1	equ	6
RP0	equ	5
NOT_TO	equ	4
NOT_PD	equ	3
Z	equ	2
DC	equ	1
C	equ	0
;*************************** Битовые переменные регистра INTCON ******************************
GIE	equ	7
PEIE	equ	6
T0IE	equ	5
INTE	equ	4
RBIE	equ	3
T0IF	equ	2
INTF	equ	1
RBIF	equ	0
;***************************** Битовые переменные регистра PIR1 ******************************
PSPIF	equ	7
ADIF	equ	6
RCIF	equ	5
TXIF	equ	4
SSPIF	equ	3
CCP1IF	equ	2
TMR2IF	equ	1
TMR1IF	equ	0
;***************************** Битовые переменные регистра PIR2 ******************************
EEIF	equ	4
BCLIF	equ	3
CCP2IF	equ	0
;**************************** Битовые переменные регистра T1CON ******************************
T1CKPS1	equ	5
T1CKPS0	equ	4
T1OSCEN	equ	3
NOT_T1SYNC	equ	2
T1INSYNC	equ	2
TMR1CS	equ	1
TMR1ON	equ	0
;**************************** Битовые переменные регистра T2CON ******************************
TOUTPS3	equ	6
TOUTPS2	equ	5
TOUTPS1	equ	4
TOUTPS0	equ	3
TMR2ON	equ	2
T2CKPS1	equ	1
T2CKPS0	equ	0
;*************************** Битовые переменные регистра SSPCON ******************************
WCOL	equ	7
SSPOV	equ	6
SSPEN	equ	5
CKP	equ	4
SSPM3	equ	3
SSPM2	equ	2
SSPM1	equ	1
SSPM0	equ	0
;*************************** Битовые переменные регистра CCP1CON *****************************
CCP1X	equ	5
CCP1Y	equ	4
CCP1M3	equ	3
CCP1M2	equ	2
CCP1M1	equ	1
CCP1M0	equ	0
;**************************** Битовые переменные регистра RCSTA ******************************
SPEN	equ	7
RX9	equ	6
RC9	equ	6
NOT_RC8	equ	6
RC8_9	equ	6
SREN	equ	5
CREN	equ	4
ADDEN	equ	3
FERR	equ	2
OERR	equ	1
RX9D	equ	0
RCD8	equ	0
;*************************** Битовые переменные регистра CCP2CON *****************************
CCP2X	equ	5
CCP2Y	equ	4
CCP2M3	equ	3
CCP2M2	equ	2
CCP2M1	equ	1
CCP2M0	equ	0
;*************************** Битовые переменные регистра ADCON0 ******************************
ADCS1	equ	7
ADCS0	equ	6
CHS2	equ	5
CHS1	equ	4
CHS0	equ	3
GO	equ	2
NOT_DONE	equ	2
GO_DONE	equ	2
CHS3	equ	1
ADON	equ	0
;*************************** Битовые переменные регистра OPTION ******************************
NOT_RBPU	equ	7
INTEDG	equ	6
T0CS	equ	5
T0SE	equ	4
PSA	equ	3
PS2	equ	2
PS1	equ	1
PS0	equ	0
;***************************** Битовые переменные регистра PIE1 ******************************
PSPIE	equ	7
ADIE	equ	6
RCIE	equ	5
TXIE	equ	4
SSPIE	equ	3
CCP1IE	equ	2
TMR2IE	equ	1
TMR1IE	equ	0
;***************************** Битовые переменные регистра PIE2 ******************************
EEIE	equ	4
BCLIE	equ	3
CCP2IE	equ	0
;***************************** Битовые переменные регистра PCON ******************************
NOT_POR	equ	1
NOT_BO	equ	0
NOT_BOR	equ	0
;*************************** Битовые переменные регистра SSPCON2 *****************************
GCEN	equ	7
ACKSTAT	equ	6
ACKDT	equ	5
ACKEN	equ	4
RCEN	equ	3
PEN	equ	2
RSEN	equ	1
SEN	equ	0
;*************************** Битовые переменные регистра SSPSTAT *****************************
SMP	equ	7
CKE	equ	6
D	equ	5
I2C_DATA	equ	5
NOT_A	equ	5
NOT_ADDRESS	equ	5
D_A	equ	5
DATA_ADDRESS	equ	5
P	equ	4
I2C_STOP	equ	4
S	equ	3
I2C_START	equ	3
R	equ	2
I2C_READ	equ	2
NOT_W	equ	2
NOT_WRITE	equ	2
R_W	equ	2
READ_WRITE	equ	2
UA	equ	1
BF	equ	0
;**************************** Битовые переменные регистра TXSTA ******************************
CSRC	equ	7
TX9	equ	6
NOT_TX8	equ	6
TX8_9	equ	6
TXEN	equ	5
SYNC	equ	4
BRGH	equ	2
TRMT	equ	1
TX9D	equ	0
TXD8	equ	0
;*************************** Битовые переменные регистра ADCON1 ******************************
ADFM	equ	5
PCFG3	equ	3
PCFG2	equ	2
PCFG1	equ	1
PCFG0	equ	0
;*************************** Битовые переменные регистра EECON1 ******************************
EEPGD	equ	7
WRERR	equ	3
WREN	equ	2
WR	equ	1
RD	equ	0
;****************************************** ОЗУ **********************************************
	__MAXRAM 0x1FF
	__BADRAM 0x08-0x09
	__BADRAM 0x88-0x89, 0x8F-0x90, 0x95-0x97, 0x9A-0x9D
	__BADRAM 0x105, 0x107-0x109
	__BADRAM 0x185, 0x187-0x189, 0x18E-0x18F
;*********************************** Биты конфигурации ***************************************
_BODEN_ON		equ	0x3FFF
_BODEN_OFF		equ	0x3FBF
_CP_ALL		equ	0x0FCF
_CP_HALF		equ	0x1FDF
_CP_UPPER_256	equ	0x2FEF
_CP_OFF		equ	0x3FFF
_WRT_ENABLE_ON	equ	0x3FFF
_WRT_ENABLE_OFF	equ	0x3DFF
_PWRTE_OFF		equ	0x3FFF
_PWRTE_ON		equ	0x3FF7
_WDT_ON		equ	0x3FFF
_WDT_OFF		equ	0x3FFB
_LP_OSC		equ	0x3FFC
_XT_OSC		equ	0x3FFD
_HS_OSC		equ	0x3FFE
_RC_OSC		equ	0x3FFF
_DEBUG_ON		equ	0x37FF
_DEBUG_OFF		equ	0x3FFF
_CPD_ON		equ	0x3EFF
_CPD_OFF		equ	0x3FFF
_LVP_ON		equ	0x3FFF
_LVP_OFF		equ	0x3F7F
;*********************************************************************************************
;*********************************************************************************************
