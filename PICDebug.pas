unit PICDebug;

interface

uses
  Windows, Messages, SysUtils,Serial, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ComCtrls, Mask, Menus, ExtCtrls;

type
  TPICForm = class(TForm)
    Button1: TButton;
    StepOwer: TButton;
    ResetBtn: TButton;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    Button5: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Button7: TButton;
    Edit8: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Button8: TButton;
    DataMemoryGrid: TStringGrid;
    ProgramFlashGrid: TStringGrid;
    Button9: TButton;
    StatusBar1: TStatusBar;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    CBPort: TComboBox;
    CBBaud: TComboBox;
    CBFlow: TComboBox;
    SerialPort1: TSerialPort;
    EEPROMGrid: TStringGrid;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Edit12: TEdit;
    Button16: TButton;
    Edit13: TEdit;
    WRegGrid: TStringGrid;
    Edit14: TEdit;
    StatusGrid: TStringGrid;
    TraceGrid: TStringGrid;
    SteckGrid: TStringGrid;
    Edit2: TEdit;
    ResetCLK: TButton;
    PortGrid: TStringGrid;
    Button4: TButton;
    Edit3: TEdit;
    Button17: TButton;
    Button18: TButton;
    Float32Grid: TStringGrid;
    Edit4: TEdit;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    OpenHEX1: TMenuItem;
    SaveHEX1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Edit16: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Past1: TMenuItem;
    Help1: TMenuItem;
    HelpPICLab1: TMenuItem;
    Abaut1: TMenuItem;
    Debug1: TMenuItem;
    Step1: TMenuItem;
    StepOver1: TMenuItem;
    Reset1: TMenuItem;
    Goto1: TMenuItem;
    RunF91: TMenuItem;
    Button3: TButton;
    Edit1: TEdit;
    SaveListing1: TMenuItem;
    Button2: TButton;
    Edit9: TEdit;
    SaveDialog1: TSaveDialog;
    Timer1: TTimer;
    Edit15: TEdit;
    SetBP1: TMenuItem;
    DelBP1: TMenuItem;
    Listing: TComboBox;
    procedure InitPort(Sender: TObject);
    procedure SerialPort1AfterReceive(Sender: TObject; data: String);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure StepOwerClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure UpDown1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UpDown1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DataMemoryGridKeyPress(Sender: TObject; var Key: Char);
    procedure DataMemoryGridClick(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure WFile(var bank,pcod,res: word);
    procedure RFile(var bank,pcod,res: word);
    procedure RRFile(var bank,pcod,res: word);
    procedure StepProc(var ower: word);
    procedure ResetBtnClick(Sender: TObject);
      procedure InitDataMemoryGrid(Sender: TObject);
      procedure DrawDataMemory(Sender: TObject);
      procedure DrawSteck(Sender: TObject);
      procedure PortState(Sender: TObject);
      procedure SelDrawSteck(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure SerialPort1Receive(Sender: TObject; data: String);
    procedure ResetCLKClick(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Button17Click(Sender: TObject);
    procedure OpenHEX1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure SerialPort1AfterTransmit(Sender: TObject; data: String);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button3Click(Sender: TObject);
    procedure CheckRFile(var rres: word);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

        Function disasm(var decod: word):string;
        Function Nfile(var bank,pcod: word):string;
var
  PICForm: TPICForm;
        var  FLASHPROG:array[0..$1fff] of word; //Programm flash
        var  DataEEPROM:array[0..255] of byte; // Datat from EEPROM
        var DataMemory:array[0..$7f*4] of byte; // Data special register
        var ProgSteck:array[0..9] of word;
        var CountCLK, OSC, PointStek, dsend: word;
        var DataRow,DataCol: integer;
// comset включение терминала
var comset:integer;
// nomsleep
var nomsleep:integer;
// redrflag = 0 not update  1 Program   2 EEPROM  4 DataRam 8 Steck
        var redrflag: byte;
// rdflag = 0 not data riceve or 1 if data is ready
        var rdflag: byte;
        var rxdata: byte;
// wdt time
        var wdtime: word;
// fltimer for run command
        var fltimer:integer;        
// flag reasembling
        var reasembling:integer;
// flag work with PCL
        var flagPCL: byte;
// flag transmit is ready
        var flagSend: byte;
// flag работы с битом
        var flbit: byte;
// flag status registr
        var flstatus:integer;
// номер бита
        var selbit: byte;
// flag porta
        var flport: byte;
// flagStek флаг переполнения стека
        var flagSteck: byte;
// flag stepower
        var flstekis:integer;
        var stpower:integer;
        var stpowerstart:integer;
//Наименование файлового регистра
        var namefile: string;
//Версия программы
        var version: string;
// Указатель на место изменения данных в таблице
        var fdist,tabpoz: word;

        var retflag, wreg, PCH, rdata: byte;
        var rdfile: word; // data from file register
        var asemb, nopcod, viewadr : word;
        var ff,fl,fw,fll,fb,freg,tclk,rtclk, rrecive,decod,work : word;
        var OpRegistr,opcod,operand,hexadr,coment,rstring,Msg: string;
        var step: integer; // если 1 при дизасемблирование выполнять соманду
        var  pKey:array[0..18] of char;
        var  pRead:array[0..28] of char;
        var lengthpRead:integer;
        var PortRect,TraceRect: TGridRect;
        var rfdel: integer;
  Const
HexChars : Array[0..15] of Char = '0123456789ABCDEF';
wdtdaley: word = 512;

implementation

{$R *.dfm}


Function Nfile(var bank,pcod: word):string;
var nfcod: word;
begin
nfcod:=pcod+bank;
case nfcod of
        $00,$80,$100,$180:      namefile:='INDF Indir addr';
        $01,$101:               namefile:='TMR0';
        $81,$181:               namefile:='OPTION_REG';
        $02,$82,$102,$182:      namefile:='PCL';
        $03,$83,$103,$183:      namefile:='STATUS';
        $04,$84,$104,$184:      namefile:='FSR';
        $05:                    namefile:='PORTA';
        $85:                    namefile:='TRISA';
        $06,$106:               namefile:='PORTB';
        $86,$186:               namefile:='TRISB';
        $07:                    namefile:='PORTC';
        $87:                    namefile:='TRISC';
        $0a,$8a,$10a,$18a:      namefile:='PCLATH';
        $0b,$8b,$10b,$18b:      namefile:='INTCON';
        $0C:                    namefile:='PIR1';
        $8C:                    namefile:='PIE1';
        $0D:                    namefile:='PIR2';
        $8D:                    namefile:='PIE2';
        $10C:                   namefile:='EEDATA';
        $18C:                   namefile:='EECON1';
        $10D:                   namefile:='EEADR';
        $18D:                   namefile:='EECON2';
        $10E:                   namefile:='EEDATH';
        $10F:                   namefile:='EEADRH';
        $0E:                    namefile:='TMR1L';
        $0F:                    namefile:='TMR1H';
        $8E:                    namefile:='PCON';
        $10:                    namefile:='T1CON';
        $12:                    namefile:='T2CON';
        $11:                    namefile:='TMR2';
        $13:                    namefile:='SSPBUF';
        $14:                    namefile:='SSPCON';
        $15:                    namefile:='CCPR1L';
        $16:                    namefile:='CCPR1H';
        $17:                    namefile:='CCP1CON';
        $91:                    namefile:='SSPCON2';
        $92:                    namefile:='PR2';
        $93:                    namefile:='SSPAD';
        $94:                    namefile:='SSPSTAT';
        $18:                    namefile:='RCSTA';
        $19:                    namefile:='TXREG';
        $98:                    namefile:='TXSTA';
        $99:                    namefile:='SPBRG';
        $1E:                    namefile:='ADRESH';
        $9E:                    namefile:='ADRESL';
        $1F:                    namefile:='ADCON0';
        $9F:                    namefile:='ADCON1';
        else                    namefile:='h'+IntToHex(pcod,3); end;
        Result:=namefile;
end;


procedure TPICForm.WFile(var bank,pcod,res: word);
var pcodWF,wfres:word;
begin
pcodWF:=bank+pcod;
wfres:=res and $ff;
case pcodWF of
        $00,$80,$100,$180: begin OpRegistr:='Inderect Adress';
        if DataMemory[4]<>0 then if (DataMemory[3] and $80)=0
        then DataMemory[DataMemory[4]]:=wfres
        else DataMemory[DataMemory[4]+$100]:=wfres;
                end;
        $01,$101:          begin OpRegistr:='TMR0';
        DataMemory[1]:=wfres;          DataMemory[$101]:=wfres;
                end;
        $81,$181:          begin OpRegistr:='OPTION_REG';
        DataMemory[$81]:=wfres;         DataMemory[$181]:=wfres;
                end;
        $02,$82,$102,$182: begin OpRegistr:='PCL';
        DataMemory[$2]:=wfres;          DataMemory[$102]:=wfres;
        DataMemory[$82]:=wfres;         DataMemory[$182]:=wfres;
        flagPCL:=1;
                end;
        $03,$83,$103,$183: begin OpRegistr:='STATUS';
        DataMemory[$3]:=wfres;          DataMemory[$103]:=wfres;
        DataMemory[$83]:=wfres;         DataMemory[$183]:=wfres;
        flstatus:=1;
                end;
        $04,$84,$104,$184: begin OpRegistr:='FSR';
        DataMemory[$4]:=wfres;          DataMemory[$104]:=wfres;
        DataMemory[$84]:=wfres;         DataMemory[$184]:=wfres;
                end;
        $10c:              begin OpRegistr:='EEDATA';
        DataMemory[$10c]:=wfres;
                end;
        $10d:              begin OpRegistr:='EEADR';
        DataMemory[$10d]:=wfres;
                end;
        $10e:              begin OpRegistr:='EEDATH';
        DataMemory[$10e]:=wfres;
                end;
        $10f:              begin OpRegistr:='EEADRH';
        DataMemory[$10f]:=wfres;
                end;
        $18c:              begin OpRegistr:='EECON1';
        DataMemory[$18c]:=wfres;
                end;
        $18d:              begin OpRegistr:='EECON2';
        DataMemory[$18d]:=wfres;
                end;
        $05:               begin OpRegistr:='PORTA';
        Timer1.Interval:=75;
        flport:=1;
        DataMemory[$05]:=wfres;
        pKey[0]:=Char($55);
        pKey[1]:=Char($05);
        pKey[2]:=Char(wfres);
        dsend:=3;
        if comset=1 then
        SerialPort1.SendData(pKey,3);
        if comset=1 then
        sleep(rfdel*3); nomsleep:=nomsleep+rfdel*3;
                end;
        $85:               begin OpRegistr:='TRISA';
        Timer1.Interval:=75;
        flport:=2;
        DataMemory[$85]:=wfres;
        pKey[0]:=Char($55);
        pKey[1]:=Char($85);
        pKey[2]:=Char(wfres);
        if comset=1 then
        SerialPort1.SendData(pKey,3);
        if comset=1 then
        sleep(rfdel*3); nomsleep:=nomsleep+rfdel*3;
                end;
        $06:               begin OpRegistr:='PORTB';
        Timer1.Interval:=75;
        flport:=3;
        DataMemory[6]:=wfres;
        pKey[0]:=Char($55);
        pKey[1]:=Char($06);
        pKey[2]:=Char(wfres);
        if comset=1 then
        SerialPort1.SendData(pKey,3);
        if comset=1 then
        sleep(rfdel*3); nomsleep:=nomsleep+rfdel*3;
                end;
        $86:               begin OpRegistr:='TRISB';
        Timer1.Interval:=75;
        flport:=4;
        DataMemory[$86]:=wfres;
        pKey[0]:=Char($55);
        pKey[1]:=Char($86);
        pKey[2]:=Char(wfres);
        if comset=1 then
        SerialPort1.SendData(pKey,3);
        if comset=1 then
        sleep(rfdel*3); nomsleep:=nomsleep+rfdel*3;
                end;
        $07:               begin OpRegistr:='PORTC';
        Timer1.Interval:=75;
        flport:=5;
        DataMemory[$07]:=wfres;
        pKey[0]:=Char($55);
        pKey[1]:=Char($07);
        pKey[2]:=Char(wfres);
        if comset=1 then
        SerialPort1.SendData(pKey,3);
        if comset=1 then
        sleep(rfdel*3); nomsleep:=nomsleep+rfdel*3;
                end;
        $87:               begin OpRegistr:='TRISC';
        Timer1.Interval:=75;
        flport:=6;
        DataMemory[$87]:=wfres;
        pKey[0]:=Char($55);
        pKey[1]:=Char($87);
        pKey[2]:=Char((wfres and $bf) or $40);
        if comset=1 then
        SerialPort1.SendData(pKey,3);
        if comset=1 then
        sleep(rfdel*3); nomsleep:=nomsleep+rfdel*3;
                end;
        $185,$105,$107..$109,$187..$189,$8f,
        $88,$89,$90,$18e,$18f,$95..$97,$9a..$9d,$8,$9:
                 OpRegistr:='NOT Work';
                else
                DataMemory[pcodWF]:=wfres;
                 end;
        Timer1.Interval:=5;
end;

procedure TPICForm.CheckRFile(var rres: word);
begin
if rdfile=0 then rdfile:=0 else rdfile:=1;
end;

procedure TPICForm.RRFile(var bank,pcod,res: word);
var ercountr:integer; md:string;
begin
rdflag := 0;
ercountr:=0;
RFile(bank,pcod,res);
if flport<>0 then begin
        if comset=1 then
        while rdflag = 0 do begin
                        md:=SerialPort1.GetData;
                        if length(md)<>0 then byte(pRead[0]):=byte(md[1]);
                        ercountr:=ercountr+1;
                        if ercountr=$f then  begin
        Msg:='Отладчик не отвечает, проверте соединение или питание.';
        MessageDlg(Msg,mtERROR,[mbOK],0);
                                                exit;
                                              end;
                            end;
        RFile(bank,pcod,res);
                Timer1.Interval:=5;
                  end;
end;

procedure TPICForm.RFile(var bank,pcod,res: word);
var resRF,pcodRF:word; d:string;
//ercount - timeout is error
begin
pcodRF:=bank+pcod;
rdflag:=0;
d:='';
        resRF:=DataMemory[pcodRF];
case pcodRF of
        $00,$80,$100,$180: begin OpRegistr:='Inderect Adress';
        if DataMemory[4]<>0 then if (DataMemory[3] and $80)=0
        then resRF:=DataMemory[DataMemory[4]]
        else resRF:=DataMemory[DataMemory[4]+$100];
                end;
        $01,$101:          begin OpRegistr:='TMR0';
        resRF:=DataMemory[1];
                end;
        $81,$181:          begin OpRegistr:='OPTION_REG';
        resRF:=DataMemory[$81];
                end;
        $02,$82,$102,$182: begin OpRegistr:='PCL';
        resRF:=DataMemory[$2];
                end;
        $03,$83,$103,$183: begin OpRegistr:='STATUS';
        resRF:=DataMemory[$3];
        flstatus:=1;
                end;
        $04,$84,$104,$184: begin OpRegistr:='FSR';
        resRF:=DataMemory[$4];
                end;
        $05:               begin OpRegistr:='PORTA';
        if flport = 0 then begin
        Timer1.Interval:=75;
        flport:=1;
        pKey[0]:=Char($AA);
        pKey[1]:=Char($05);
        if comset=1 then
        SerialPort1.SendData(pKey,2);
        if comset=1 then
         sleep(rfdel*2); nomsleep:=nomsleep+rfdel*2;
        end else begin
        if comset=1 then
        resRF:=byte(pRead[0]) else resRF:=DataMemory[pcodRF];
        end;
                end;
        $85:               begin OpRegistr:='TRISA';
        if flport = 0 then begin
        Timer1.Interval:=75;
        flport:=2;
        pKey[0]:=Char($AA);
        pKey[1]:=Char($85);
        if comset=1 then begin
        SerialPort1.SendData(pKey,2);end;
        if comset=1 then
         sleep(rfdel*2); nomsleep:=nomsleep+rfdel*2;
        end else begin
        if comset=1 then
        resRF:=byte(pRead[0]) else resRF:=DataMemory[pcodRF];
        end;
                end;
        $06:               begin OpRegistr:='PORTB';
        if flport = 0 then begin
        Timer1.Interval:=75;
        flport:=3;
        pKey[0]:=Char($AA);
        pKey[1]:=Char($06);
        if comset=1 then begin
        SerialPort1.SendData(pKey,2);end;
        if comset=1 then
         sleep(rfdel*2); nomsleep:=nomsleep+rfdel*2;
        end else begin
        if comset=1 then
        resRF:=byte(pRead[0]) else resRF:=DataMemory[pcodRF];
        end;
                end;
        $86:               begin OpRegistr:='TRISB';
        if flport = 0 then begin
        Timer1.Interval:=75;
        flport:=4;
        pKey[0]:=Char($AA);
        pKey[1]:=Char($86);
        if comset=1 then begin
        SerialPort1.SendData(pKey,2);end;
        if comset=1 then
         sleep(rfdel*2); nomsleep:=nomsleep+rfdel*2;
        end else begin
        if comset=1 then
        resRF:=byte(pRead[0]) else resRF:=DataMemory[pcodRF];
        end;
                end;
        $07:               begin OpRegistr:='PORTC';
        if flport = 0 then begin
        Timer1.Interval:=75;
        flport:=5;
        pKey[0]:=Char($AA);
        pKey[1]:=Char($07);
        if comset=1 then begin
        SerialPort1.SendData(pKey,2);end;
        if comset=1 then
         sleep(rfdel*2); nomsleep:=nomsleep+rfdel*2;
        end else begin
        if comset=1 then
        resRF:=byte(pRead[0]) else resRF:=DataMemory[pcodRF];
        end;
                end;
        $87:               begin OpRegistr:='TRISC';
        if flport = 0 then begin
        Timer1.Interval:=75;
        flport:=6;
        pKey[0]:=Char($AA);
        pKey[1]:=Char($87);
        if comset=1 then begin
        SerialPort1.SendData(pKey,2);end;
        if comset=1 then
         sleep(rfdel*2); nomsleep:=nomsleep+rfdel*2;
        end else begin
        if comset=1 then
        resRF:=byte(pRead[0]) else resRF:=DataMemory[pcodRF];
        end;
                end;
        $185,$105,$107..$109,$187..$189,$8f,
        $88,$89,$90,$18e,$18f,$95..$97,$9a..$9d,$8,$9:
                 begin OpRegistr:='NOT Work';
                 resRF:=0; end;
                else
                resRF:=DataMemory[pcodRF];
                end;
work:=resRF;
end;

//*******************************************************************
// Функция пошагового выполнения
// Если Flag=0 реальная трасировка
// Если Flag=1 трассировка без результата
// ower = 1 проход сквозь подпрограмму
// ower = 1 проход с заходом в подпрограмму

procedure TPICForm.StepProc(var ower: word);
var jampadr, lbit, bank, pcod,pozcod,literal,lliteral,b,res,rab: word;
   dres: word; // Для определения внутреннего переноса
// flags 0- не изменяются флаги
// flags 1- изменяется флаг Z
// flags 2- изменяется флаг C
// flags 3- изменяются флаги C, DC, Z
//  fladsub - 0- add, 1- sub
// flags 4- изменяются флаги TO, PD
        d: string;
begin
// decoding command
//rresive flag  флаг завершения приема данных отт отладчика
ff:=0; fw:=0; fl:=0; fll:=0; opcod:=''; operand:=''; tclk:=0; jampadr:=0;
fdist:=0;
flbit:=0;
flstatus:=0;
flport:=0;
res:=wreg;
dres:=res and $f;
decod:=FLASHPROG[PCH*256+DataMemory[2]];
pcod:=decod and $07f;
literal:=decod and $ff;
lbit:=decod and $80;
lliteral:=decod and $7ff;
b:=((decod and $380) shr 7);
bank:=(DataMemory[3] and $60) shl 2;
tabpoz:=0;
pozcod:=pcod;
rtclk:=1;
case decod of
        $0:             begin //NOP
                        end;
        $20, $40, $60:  begin //NOP+
                        end;
        $900..$9ff:    begin  //COMF
        redrflag:=4;
                        RRFile(bank,pcod,res);
                        res:=0-wreg;
                        if (res and $00ff)= 0
                            then   DataMemory[3]:=(DataMemory[3] or $4)
                            else   DataMemory[3]:=(DataMemory[3] and $fb);
                        fdist:= 1;
                        end;
        $A00..$Aff:    begin //INCF
        redrflag:=4;
                        RRFile(bank,pcod,res);
                        res:=work+1;
                        if (res and $00ff)= 0
                            then   DataMemory[3]:=(DataMemory[3] or $4)
                            else   DataMemory[3]:=(DataMemory[3] and $fb);
                        fdist:= 1;
                        end;
        $f00..$fff:    begin //INCFSZ
        redrflag:=4;
                        RRFile(bank,pcod,res);
                        res:=work+1;
                        if (res and $00ff)= 0
                          then begin
                            DataMemory[3]:=(DataMemory[3] or $4);
                            if DataMemory[2]=$ff then
                              begin DataMemory[2]:=0; PCH:=((PCH+1) and $1f);
                              end else  DataMemory[2]:=DataMemory[2]+1;
                            rtclk:=2;
                               end
                          else   DataMemory[3]:=(DataMemory[3] and $fb);
                       fdist:= 1;
                       end;
        $300..$3ff:    begin //DECF
        redrflag:=4;
                        RRFile(bank,pcod,res);
                        res:=work-1;
                        if (res and $00ff)= 0
                            then   DataMemory[3]:=(DataMemory[3] or $4)
                            else   DataMemory[3]:=(DataMemory[3] and $fb);
                        fdist:= 1;
                      end;
        $B00..$Bff:    begin //DECFSZ
        redrflag:=4;
                        RRFile(bank,pcod,res);
                        res:=work-1;
                        if (res and $00ff)= 0
                          then begin
                            DataMemory[3]:=(DataMemory[3] or $4);
                            if DataMemory[2]=$ff then
                              begin DataMemory[2]:=0; PCH:=((PCH+1) and $1f);
                              end else  DataMemory[2]:=DataMemory[2]+1;
                            rtclk:=2;
                               end
                          else   DataMemory[3]:=(DataMemory[3] and $fb);
                       fdist:= 1;
                       end;
        $700..$7ff:    begin //ADDWF
        redrflag:=4;
                        RRFile(bank,pcod,res);
                        res:=wreg+work;
                        if (res and $ff00)= 0
                            then   DataMemory[3]:=(DataMemory[3] and $fe)
                            else   DataMemory[3]:=(DataMemory[3] or $1);
                        if (res and $00ff)= 0
                            then   DataMemory[3]:=(DataMemory[3] or $4)
                            else   DataMemory[3]:=(DataMemory[3] and $fb);
                            dres:=dres+(work and $f);
                        if (dres and $f0)= 0
                            then   DataMemory[3]:=(DataMemory[3] and $fd)
                            else   DataMemory[3]:=(DataMemory[3] or $2);
                        fdist:= 1;
                      end;
        $200..$2ff:    begin //SUBWF
        redrflag:=4;
                        RRFile(bank,pcod,res);
                        res:=work-wreg;
                        if (res and $ff00)= 0
                            then   DataMemory[3]:=(DataMemory[3] and $fe)
                            else   DataMemory[3]:=(DataMemory[3] or $1);
                        if (res and $00ff)= 0
                            then   DataMemory[3]:=(DataMemory[3] or $4)
                            else   DataMemory[3]:=(DataMemory[3] and $fb);
                            dres:=(work and $f)-dres;
                        if (dres and $f0)= 0
                            then   DataMemory[3]:=(DataMemory[3] and $fd)
                            else   DataMemory[3]:=(DataMemory[3] or $2);
                        fdist:= 1;
                      end;
        $e00..$eff:    begin //SWAPF
        redrflag:=4;
                        RRFile(bank,pcod,res);
                        res:=work;
                        res:=(res  div  $10) and $f;
                        work:=(work shl 4) and $f0;
                        res:=res or work;
                        fdist:= 1;
                      end;
        $600..$6ff:    begin //XORWF
        redrflag:=4;
                        RRFile(bank,pcod,res);
                        res:=wreg xor work;
                        if (res and $00ff)= 0
                            then   DataMemory[3]:=(DataMemory[3] or $4)
                            else   DataMemory[3]:=(DataMemory[3] and $fb);
                        fdist:= 1;
                      end;
        $500..$5ff:    begin //ANDWF
        redrflag:=4;
                        RRFile(bank,pcod,res);
                        res:=wreg and work;
                        if (res and $00ff)= 0
                            then   DataMemory[3]:=(DataMemory[3] or $4)
                            else   DataMemory[3]:=(DataMemory[3] and $fb);
                        fdist:= 1;
                      end;
        $400..$4ff:    begin //IORWF
        redrflag:=4;
                        RRFile(bank,pcod,res);
                        res:=wreg or work;
                        if (res and $00ff)= 0
                            then   DataMemory[3]:=(DataMemory[3] or $4)
                            else   DataMemory[3]:=(DataMemory[3] and $fb);
                        fdist:= 1;
                      end;
        $d00..$dff:    begin //RLF
        redrflag:=4;
                        RRFile(bank,pcod,res);
                        res:=work shl 1 ;
                        if (DataMemory[3] and $1)=0 then res:=res and $fffe
                        else res:=res or 1;
                        if (res and $100)<>0
                            then   DataMemory[3]:=(DataMemory[3] or $1)
                            else   DataMemory[3]:=(DataMemory[3] and $fe);
                        fdist:= 1;
                       end;
        $c00..$cff:    begin //RRF
        redrflag:=4;
                        RRFile(bank,pcod,res);
                        if (DataMemory[3] and $1)=0 then work:=work and $feff
                        else work:=work or $100;
                        if (work and $100)<>0
                            then   DataMemory[3]:=(DataMemory[3] or $1)
                            else   DataMemory[3]:=(DataMemory[3] and $fe);
                        res:=work shr 1 ;
                        fdist:= 1;
                       end;
        $800..$8ff:    begin //MOVF
                        RRFile(bank,pcod,res);
                        if (work and $00ff)= 0
                            then   DataMemory[3]:=(DataMemory[3] or $4)
                            else   DataMemory[3]:=(DataMemory[3] and $fb);
                        if lbit=0 then wreg:=work and $ff;
                       end;
        $80..$ff:      begin //MOVWF
                redrflag:=4;
                        res:=wreg;
                        fdist:=1;
                        lbit:=1;
                       end;
        $180..$1ff:    begin //CLRF
        redrflag:=4;
                        res:=0;
                        DataMemory[3]:=(DataMemory[3] or $4);
                        fdist:=1;
                        lbit:=1;
                       end;
        $100:          begin //CLRW
                        res:=0;
                        DataMemory[3]:=(DataMemory[3] or $4);
                        wreg:=res and $ff;
                       end;
        $101..$17f:    begin //CLRW+
                        res:=0;
                        DataMemory[3]:=(DataMemory[3] or $4);
                       end;
        $1000..$13ff:   begin //BCF
                        flbit:=1;
                        selbit:=b;
        redrflag:=4;
                        RRFile(bank,pcod,res);
                        rab:=$ff7f shr (7-b);
                        res:=work and rab;
                        lbit:=1;
                        fdist:=1;
                        end;
        $1400..$17ff:   begin //BSF
                        flbit:=1;
                        selbit:=b;
        redrflag:=4;
                        RRFile(bank,pcod,res);
                        rab:=$0001 shl b;
                        res:=(work or rab);
                        lbit:=1;
                        fdist:=1;
                        end;
        $1800..$1bff:   begin //BTFSC
                        RRFile(bank,pcod,res);
                        if (work and ($1 shl b))=0 then
                          begin  if DataMemory[2]=$ff then
                             begin DataMemory[2]:=0; PCH:=((PCH+1) and $1f);
                             end else  DataMemory[2]:=DataMemory[2]+1;
                             rtclk:=2;
                          end;
                        end;
        $1c00..$1fff:   begin //BTFSS
                        RRFile(bank,pcod,res);
                        if (work and ($1 shl b))<>0 then begin
                                if DataMemory[2]=$ff then
                                begin DataMemory[2]:=0; PCH:=((PCH+1) and $1f);
                                end else DataMemory[2]:=DataMemory[2]+1;
                                rtclk:=2;
                          end;
                        end;
        $3e00..$3eff:   begin // ADDLW'
                        res:=res+literal;
                        if (res and $ff00)= 0
                            then   DataMemory[3]:=(DataMemory[3] and $fe)
                            else   DataMemory[3]:=(DataMemory[3] or $1);
                        if (res and $00ff)= 0
                            then   DataMemory[3]:=(DataMemory[3] or $4)
                            else   DataMemory[3]:=(DataMemory[3] and $fb);
                            dres:=dres+(literal and $f);
                        if (dres and $f0)= 0
                            then   DataMemory[3]:=(DataMemory[3] and $fd)
                            else   DataMemory[3]:=(DataMemory[3] or $2);
                        wreg:=res and $00ff;
                      end;
        $3f00..$3fff:   begin //ADDLW+
                        res:=res+literal;
                        if (res and $ff00)= 0
                            then   DataMemory[3]:=(DataMemory[3] and $fe)
                            else   DataMemory[3]:=(DataMemory[3] or $1);
                        if (res and $00ff)= 0
                            then   DataMemory[3]:=(DataMemory[3] or $4)
                            else   DataMemory[3]:=(DataMemory[3] and $fb);
                            dres:=dres+(literal and $f);
                        if (dres and $f0)= 0
                            then   DataMemory[3]:=(DataMemory[3] and $fd)
                            else   DataMemory[3]:=(DataMemory[3] or $2);
                        wreg:=res and $00ff;
                      end;
        $3900..$39ff:   begin //ANDLW
                        res:=res and literal;
                        if (res and $00ff)= 0
                            then   DataMemory[3]:=(DataMemory[3] or $4)
                            else   DataMemory[3]:=(DataMemory[3] and $fb);
                        wreg:=res and $00ff;
                        end;
        $3000..$30ff:   begin //MOVLW
                        res:=literal;
                        wreg:=res and $00ff;
                        end;
        $3100..$33ff:   begin //MOVLW+
                        res:=literal;
                        wreg:=res and $00ff;
                      end;
        $3800..$38ff:   begin //IORLW
                        res:=res or literal;
                        if (res and $00ff)= 0
                            then   DataMemory[3]:=(DataMemory[3] or $4)
                            else   DataMemory[3]:=(DataMemory[3] and $fb);
                        wreg:=res and $00ff;
                      end;
        $2000..$27ff:   begin //CALL
        redrflag:=8;
        if flstekis<>0 then  flstekis:=flstekis+1 else flstekis:=1; 
        if stpowerstart=1 then stpower := 1;
                        PointStek:=PointStek+1;
                        if PointStek > 7 then
                                begin PointStek:=0;
                                flagSteck:=1;
                          StatusBar1.Panels[0].Text:= 'Стек переполнен!!!';
                                end;
                        if DataMemory[2]=$ff then
                                begin DataMemory[2]:=0; PCH:=((PCH+1) and $1f); end
                                else DataMemory[2]:=DataMemory[2]+1;
                        ProgSteck[PointStek]:=PCH*256+DataMemory[2];
                        jampadr:=1;
                        rtclk:=2;
                        redrflag:=redrflag or 8;
                      end;
        $2800..$2fff:   begin //GOTO
                        jampadr:=1;
                        rtclk:=2;
                      end;
        $0064:          begin //CLRWDT
                        bank:=0; pcod:=3;
                        RFile(bank,pcod,res);
                        work:=work or $18;
                        WFile(bank,pcod,work);
                        wdtime:=0;
                      end;
        $0009:          begin //RETFIE
        redrflag:=8;
        if flstekis<>0 then flstekis:=flstekis-1;
                        bank:=0; pcod:=$b;
                        RFile(bank,pcod,res);
                        work:=work or $80;
                        res:=work;
                        WFile(bank,pcod,work);
                        lliteral:=ProgSteck[PointStek];
                        DataMemory[$a]:=(ProgSteck[PointStek] div $100);
                        if PointStek=0 then
                                begin PointStek:=7;
                                flagSteck:=1;
                          StatusBar1.Panels[0].Text:= 'Стек дважды опустошен!!!';
                                end
                                else PointStek:=PointStek-1;
                        jampadr:=1;
                        redrflag:=redrflag or 8;
                        rtclk:=2;
                      end;
        $3400..$37ff:   begin //RETLW
        redrflag:=8;
        if flstekis<>0 then flstekis:=flstekis-1;
                        wreg:=literal;
                        lliteral:=ProgSteck[PointStek];
                        DataMemory[$a]:=(ProgSteck[PointStek] div $100);
                        if PointStek=0 then
                                begin PointStek:=7;
                                flagSteck:=1;
                          StatusBar1.Panels[0].Text:= 'Стек дважды опустошен!!!';
                                end
                                else PointStek:=PointStek-1;
                        jampadr:=1;
                        redrflag:=redrflag or 8;
                        rtclk:=2;
                      end;
        $0008:          begin //RETURN
        redrflag:=8;
        if flstekis<>0 then flstekis:=flstekis-1;
                        lliteral:=ProgSteck[PointStek];
                        DataMemory[$a]:=(ProgSteck[PointStek] div $100);
                        if PointStek=0 then
                                begin PointStek:=7;
                                flagSteck:=1;
                          StatusBar1.Panels[0].Text:= 'Стек дважды опустошен!!!';
                                end
                                else PointStek:=PointStek-1;
                        jampadr:=1;
                        redrflag:=redrflag or 8;
                        rtclk:=2;
                      end;
        $0063:          begin //SLEEP
                      end;
        $3a00..$3aff:   begin //XORLW
                        res:=res xor literal;
                        if (res and $00ff)= 0
                            then   DataMemory[3]:=(DataMemory[3] or $4)
                            else   DataMemory[3]:=(DataMemory[3] and $fb);
                        wreg:=res and $00ff;
                      end;
        $3c00..$3cff:   begin //SUBLW
                        res:=literal-res;
                        if (res and $ff00)= 0
                            then   DataMemory[3]:=(DataMemory[3] and $fe)
                            else   DataMemory[3]:=(DataMemory[3] or $1);
                        if (res and $00ff)= 0
                            then   DataMemory[3]:=(DataMemory[3] or $4)
                            else   DataMemory[3]:=(DataMemory[3] and $fb);
                            dres:=(literal and $f)-dres;
                        if (dres and $f0)= 0
                            then   DataMemory[3]:=(DataMemory[3] and $fd)
                            else   DataMemory[3]:=(DataMemory[3] or $2);
                        wreg:=res and $00ff;
                      end;
        $3d00..$3dff:   begin //SUBLW+
                        res:=literal-res;
                        if (res and $ff00)= 0
                            then   DataMemory[3]:=(DataMemory[3] and $fe)
                            else   DataMemory[3]:=(DataMemory[3] or $1);
                        if (res and $00ff)= 0
                            then   DataMemory[3]:=(DataMemory[3] or $4)
                            else   DataMemory[3]:=(DataMemory[3] and $fb);
                            dres:=(literal and $f)-dres;
                        if (dres and $f0)= 0
                            then   DataMemory[3]:=(DataMemory[3] and $fd)
                            else   DataMemory[3]:=(DataMemory[3] or $2);
                        wreg:=res and $00ff;
                      end;
        else    d:='NOPcod';
        end;
res:=res and $FF;
if fdist = 1 then begin if lbit = 0 then wreg:=(res and $ff)
                                   else
                                   tabpoz:=bank+pozcod;
                                   WFile(bank,pozcod,res);
                                   if flagPCL<>0 then jampadr:=2;
                                   end;
case jampadr of
        0:  begin
        if DataMemory[2]=$ff then
        begin DataMemory[2]:=0; PCH:=((PCH+1) and $1f); end
        else DataMemory[2]:=DataMemory[2]+1;
        end;
        1:  begin
        DataMemory[2]:=lliteral and $ff;
        PCH:=(lliteral and $700) shr 8;
        PCH:=PCH or (DataMemory[$0a] and $18);
        end;
        2:  begin
        if DataMemory[2]=$ff then
        begin DataMemory[2]:=0; PCH:=((PCH+1) and $1f); end
        else DataMemory[2]:=DataMemory[2]+1;
{        if DataMemory[2]=$ff then
        begin DataMemory[2]:=0; PCH:=((PCH+1) and $1f); end
        else DataMemory[2]:=DataMemory[2]+1;}
        flagPCL:=0;
        end;
        else end;
CountCLK:= CountCLK+rtclk;
wdtime:=wdtime+1;
        if wdtime = wdtdaley then begin DataMemory[2]:=0; PCH:=0;
        DataMemory[$a]:=0;
        bank:=0; pcod:=3;
        RFile(bank,pcod,res); work:=work or $18;
        WFile(bank,pcod,work);
        end;
end; //Step proc


//Disasm
Function disasm(var decod: word):string;
var bank,pcod: word;
        d,o: string;
begin
// decoding command
ff:=0; fw:=0; fl:=0; fll:=0; fb:=0; opcod:=''; operand:='';
namefile:='';
pcod:=decod and $07f;
bank:=(DataMemory[3] and $60) shl 2;
case decod of
        $0:             begin d:='NOP';
                         coment:='No Operation';
                        end;
        $20, $40, $60:  begin d:='NOP+';
                         coment:='No Operation OR Reserved';
                        end;
        $900..$9ff:    begin
                        d:='COMF'; nopcod:=4;
                        ff:=1; fw:=1; tclk:=1;
                        coment:='Complement f';
                      end;
        $A00..$Aff:    begin
                        d:='INCF'; nopcod:=4;
                        ff:=1; fw:=1; tclk:=1;
                        coment:='Increment f';
                      end;
        $f00..$fff:    begin
                        d:='INCFSZ'; nopcod:=6;
                        ff:=1; fw:=1; tclk:=2;
                        coment:='Increment f, Skip if 0';
                      end;
        $300..$3ff:    begin
                        d:='DECF'; nopcod:=4;
                        ff:=1; fw:=1; tclk:=1;
                        coment:='Decrement f';
                      end;
        $B00..$Bff:    begin
                        d:='DECFSZ'; nopcod:=6;
                        ff:=1; fw:=1; tclk:=2;
                        coment:='Decrement f, Skip if 0';
                      end;
        $700..$7ff:    begin
                        d:='ADDWF'; nopcod:=5;
                        ff:=1; fw:=1; tclk:=1;
                        coment:='Add W and f';
                      end;
        $200..$2ff:    begin
                        d:='SUBWF'; nopcod:=5;
                        ff:=1; fw:=1; tclk:=1;
                        coment:='Subtract W from f';
                      end;
        $e00..$eff:    begin
                        d:='SWAPF'; nopcod:=5;
                        ff:=1; fw:=1; tclk:=1;
                        coment:='Swap nibbles in f';
                      end;
        $600..$6ff:    begin
                        d:='XORWF'; nopcod:=5;
                        ff:=1; fw:=1; tclk:=1;
                        coment:='Exclusive OR W with f';
                      end;
        $500..$5ff:    begin
                        d:='ANDWF'; nopcod:=5;
                        ff:=1; fw:=1; tclk:=1;
                        coment:='AND W with f';
                      end;
        $400..$4ff:    begin
                        d:='IORWF'; nopcod:=5;
                        ff:=1; fw:=1; tclk:=1;
                        coment:='Inclusive OR W with f';
                      end;
        $d00..$dff:    begin
                        d:='RLF'; nopcod:=3;
                        ff:=1; fw:=1; tclk:=1;
                        coment:='Rotate Left f through Carry';
                      end;
        $c00..$cff:    begin
                        d:='RRF'; nopcod:=3;
                        ff:=1; fw:=1; tclk:=1;
                        coment:='Rotate Right f through Carry';
                      end;
        $800..$8ff:    begin
                        d:='MOVF'; nopcod:=4;
                        ff:=1; fw:=1; tclk:=1;
                        coment:='Move f';
                      end;
        $80..$ff:    begin
                        d:='MOVWF'; nopcod:=5;
                        ff:=1; fw:=1; tclk:=1;
                        coment:='Move W to f';
                      end;
        $180..$1ff:    begin
                        d:='CLRF'; nopcod:=4;
                        ff:=1; fw:=1; tclk:=1;
                        coment:='Clear f';
                      end;
        $100:    begin
                        d:='CLRW'; nopcod:=4;
                        tclk:=1;  coment:='Clear W';
                      end;
        $101..$17f:    begin
                        d:='CLRW+'; nopcod:=5;
                        tclk:=1; coment:='Clear W OR Reserved';
                      end;
        $1000..$13ff:   begin
                        d:='BCF'; nopcod:=3;
                        ff:=1; fb:=1; tclk:=1;
                        coment:='Bit Clear f';
                      end;
        $1400..$17ff:   begin
                        d:='BSF'; nopcod:=3;
                        ff:=1; fb:=1; tclk:=1;
                        coment:='Bit Set f';
                        end;
        $1800..$1bff:   begin
                        d:='BTFSC'; nopcod:=5;
                        ff:=1; fb:=1; tclk:=1;
                        coment:='Bit Test f, Skip if Clear';
                        end;
        $1c00..$1fff:   begin
                        d:='BTFSS'; nopcod:=5;
                        ff:=1; fb:=1; tclk:=1;
                        coment:='Bit Test f, Skip if Set';
                        end;
        $3e00..$3eff:   begin
                        d:='ADDLW'; nopcod:=5;
                        fl:=1; tclk:=1;
                        coment:='Add literal and W';
                      end;
        $3f00..$3fff:   begin
                        d:='ADDLW+'; nopcod:=6;
                        fl:=1; tclk:=1;
                        coment:='Add literal and W OR Reserved';
                      end;
        $3900..$39ff:   begin
                        d:='ANDLW'; nopcod:=5;
                        fl:=1; tclk:=1;
                        coment:='AND literal with W';
                      end;
        $3000..$30ff:   begin
                        d:='MOVLW'; nopcod:=5;
                        fl:=1; tclk:=1;
                        coment:='Move literal to W';
                      end;
        $3100..$33ff:   begin
                        d:='MOVLW+'; nopcod:=6;
                        fl:=1; tclk:=1;
                        coment:='Move literal to W OR Reserved';
                      end;
        $3800..$38ff:   begin
                        d:='IORLW'; nopcod:=5;
                        fl:=1; tclk:=1;
                        coment:='Inclusive OR literal with W';
                      end;
        $2000..$27ff:   begin
                        d:='CALL'; nopcod:=4;
                        fll:=1; tclk:=2;
                        coment:='Call subroutine';
                      end;
        $2800..$2fff:   begin
                        d:='GOTO'; nopcod:=4;
                        fll:=1; tclk:=2;
                        coment:='Go to address';
                      end;
        $0064:          begin
                        d:='CLRWDT'; nopcod:=6;
                        tclk:=1;
                        coment:='Clear Watchdog Timer';
                      end;
        $0009:          begin
                        d:='RETFIE'; nopcod:=6;
                        tclk:=2;
                        coment:='Clear Watchdog Timer';
                      end;
        $3400..$37ff:   begin
                        d:='RETLW'; nopcod:=5;
                        fll:=1; tclk:=2;
                        coment:='Return with literal in W';
                      end;
        $0008:          begin
                        d:='RETURN'; nopcod:=6;
                        tclk:=2;
                        coment:='Return from Subroutine';
                      end;
        $0063:          begin
                        d:='SLEEP'; nopcod:=5;
                        tclk:=1;
                        coment:='Go into standby mode';
                      end;
        $3a00..$3aff:   begin
                        d:='XORLW'; nopcod:=5;
                        fl:=1; tclk:=1;
                        coment:='Exclusive OR literal with W';
                      end;
        $3c00..$3cff:   begin
                        d:='SUBLW'; nopcod:=5;
                        fl:=1; tclk:=1;
                        coment:='Subtract W from literal';
                      end;
        $3d00..$3dff:   begin
                        d:='SUBLW+'; nopcod:=6;
                        fl:=1; tclk:=1;
                        coment:='Subtract W from literal OR Reserved';
                      end;
        else    d:='NOPcod';
        end;
        opcod:=d;
        if ff=1 then
           begin o:=IntToHex((decod and $7f),2);
           namefile:=Nfile(bank,pcod);
           end;
        if fw=1 then if (decod and $80)=0 then o:=o+',W' else o:=o+',F';
        if fb=1 then o:=o+','+IntToHex(((decod and $380) shr 7),1);
        if fl=1 then o:=IntToHex((decod and $ff),2);
        if fll=1 then
        o:=IntToHex((decod and $7ff)+(DataMemory[$a] and $1800),4);
        operand:=o;
        disasm:=d+' '+o;
end;


procedure TPICForm.FormCreate(Sender: TObject);
var i: word;
begin
// Run setup
Timer1.Enabled:=False;
fltimer:=0;
comset:=0;
Button3.Caption:='Run';
//Init COM Port
reasembling:=1;
        rfdel:= 14;
        Edit1.Text:=IntToStr(rfdel);
  CBBaud.ItemIndex := 6;
  CBPort.ItemIndex := 0;
  CBFlow.ItemIndex := 0;
  stpowerstart:=0;
  retflag:=0;
  rstring:='';
  flagPCL:=0;
  flport:=0;
  flstatus:=0;
// Vrsion of PIC Lab
version:='PIC Lab V 00.00.02';
PICForm.Caption:=version;
// Start Initialisetion
DataCol:=1;
DataRow:=1;
redrflag:=8;
flagSteck:=0;
step:=0;
wdtime:=0;
CountCLK:=0;
viewadr:=0;

// Init mamory Flash, RAM, EEPROM
for i:=0 to 7 do begin
ProgSteck[i]:=0;
end;
for i:=0 to $1fff do begin
FLASHPROG[i]:=$3fff;
end;
for i:=0 to $1ff do begin
DataMemory[i]:=0;
end;
for i:=0 to $ff do begin
DataEEPROM[i]:=$ff;
end;
PointStek:=7;
PCH:=0;
// Test programm for PICLab
FLASHPROG[0]:=$3000;
FLASHPROG[1]:=$1683;
FLASHPROG[2]:=$0086;
FLASHPROG[3]:=$1283;
FLASHPROG[4]:=$3000;
FLASHPROG[5]:=$0086;
FLASHPROG[6]:=$30ff;
FLASHPROG[7]:=$0086;
FLASHPROG[8]:=$200A;
FLASHPROG[9]:=$2804;
FLASHPROG[$a]:=$0008;
FLASHPROG[$b]:=$200A;
FLASHPROG[$c]:=$2804;
FLASHPROG[$d]:=$2804;
FLASHPROG[$e]:=$2800;
DataMemory[20]:=$84;
DataMemory[21]:=$49;
DataMemory[22]:=$0f;
DataMemory[23]:=$db;
DataMemory[24]:=$7c;
DataMemory[25]:=$20;
DataMemory[26]:=$00;
DataMemory[27]:=$00;

 InitDataMemoryGrid(Nil);
 Button9Click(Nil);
 Button13Click(Nil);
// Button4Click(Nil);
 Button1Click(Nil);
 InitPort(Nil);
 EEPROMGrid.Cells[0,0]:='EROM';
 ProgramFlashGrid.Cells[0,0]:='Flash';
 DataMemoryGrid.Cells[0,0]:='ROM';
 DrawSteck(Nil);
 step:=1;
 PortState(Nil);
 Button14Click(Nil);
 end;

procedure TPICForm.PortState(Sender: TObject);
var k,i: word; d:string;
begin
// Таблица состояния портов
PortGrid.Cells[0,0]:='PORT Bit';
PortGrid.Cells[0,1]:='PORTA';
PortGrid.Cells[0,2]:='TRISA';
PortGrid.Cells[0,3]:='PORTB';
PortGrid.Cells[0,4]:='TRISB';
PortGrid.Cells[0,5]:='PORTC';
PortGrid.Cells[0,6]:='TRISC';
for k:=0 to 7 do Begin
 PortGrid.Cells[8-k,0]:=IntToHex(k,1);;
 end;
i:=DataMemory[05];  //PORTA
for k:=0 to 7 do Begin
 if (i and 1)=0 then d:='0' else d:='1';
 i:= i shr 1;
 PortGrid.Cells[8-k,1]:=d;
 end;
i:=DataMemory[85]; //TRISA
for k:=0 to 7 do Begin
 if (i and 1)=0 then d:='0' else d:='1';
 i:= i shr 1;
 PortGrid.Cells[8-k,2]:=d;
 end;
i:=DataMemory[06];  //PORTB
for k:=0 to 7 do Begin
 if (i and 1)=0 then d:='0' else d:='1';
 i:= i shr 1;
 PortGrid.Cells[8-k,3]:=d;
 end;
i:=DataMemory[86]; //TRISB
for k:=0 to 7 do Begin
 if (i and 1)=0 then d:='0' else d:='1';
 i:= i shr 1;
 PortGrid.Cells[8-k,4]:=d;
 end;
i:=DataMemory[07];   //PORTC
for k:=0 to 7 do Begin
 if (i and 1)=0 then d:='0' else d:='1';
 i:= i shr 1;
 PortGrid.Cells[8-k,5]:=d;
 end;
i:=DataMemory[87]; //TRISC
for k:=0 to 7 do Begin
 if (i and 1)=0 then d:='0' else d:='1';
 i:= i shr 1;
 PortGrid.Cells[8-k,6]:=d;
 end;
  PortRect.Left := 1;
  PortRect.Top := flport;
  PortRect.Right := 8;
  PortRect.Bottom := flport;
  PortGrid.Selection := PortRect;
 if flbit=1 then begin PortGrid.Col:= 8-selbit;
                 PortGrid.Row:=flport;
                 end;

end;

procedure TPICForm.Button1Click(Sender: TObject);
var i,k,w: word;
f:real;
d: string;
begin
nomsleep:=0;
if step=1 then begin if stpowerstart = 0 then StepProc(i) else
        begin
        StepProc(i);
                if stpower = 1 then begin
        if flstekis = 0 then begin Timer1.Enabled:=False; fltimer:=0; end;
        stpowerstart:=0; end;
        end;
        stpower:=0;
                end;
StatusBar1.Panels[2].Text:=
IntToStr(nomsleep)+' мкс';
f:= (1/StrToInt(Edit2.Text))*CountCLK*1000000*4;
if CountCLK <> 0 then StatusBar1.Panels[4].Text:=
                        FloatToStrF(f,ffFixed,7,2)+' мкс'
                 else StatusBar1.Panels[4].Text:='0 мкс';
i:=PCH*256+DataMemory[2];
StatusBar1.Panels[3].Text:='PC '+IntToHex(i,4);
StatusBar1.Panels[5].Text:=IntToStr(CountCLK);
                if fltimer = 1 then exit;
stpower:=0;
stpowerstart:=0;
viewadr:=i;
// Вывод времени выполнения программы
StatusBar1.Panels[5].Text:=IntToStr(CountCLK);
Edit5.text:=IntToHex(wreg,2);
Edit14.text:=IntToStr(wreg);
// Отобразить состояние регистра Work Register
w:=wreg;
for k:=0 to 7 do Begin
 WRegGrid.Cells[7-k,0]:=IntToStr(k);
 if (w and 1)=0 then d:='0' else d:='1';
 w:= w shr 1;
 WRegGrid.Cells[7-k,1]:=d;
 end;
// Отобразить состояние регистра STATUS
 w:=DataMemory[3];
 StatusGrid.Cells[0,0]:='IRP';
 StatusGrid.Cells[1,0]:='RP1';
 StatusGrid.Cells[2,0]:='RP0';
 StatusGrid.Cells[3,0]:='TO';
 StatusGrid.Cells[4,0]:='PD';
 StatusGrid.Cells[5,0]:='Z';
 StatusGrid.Cells[6,0]:='DC';
 StatusGrid.Cells[7,0]:='C';
for k:=0 to 7 do Begin
 if (w and 1)=0 then d:='0' else d:='1';
 w:= w shr 1;
 StatusGrid.Cells[7-k,1]:=d;
 end;     if flstatus = 1 then
 if flbit=1 then begin StatusGrid.Col:= 8-selbit;
                 StatusGrid.Row:=1;
                 end;
 if reasembling=1 then begin
TraceGrid.Cells[0,0]:='Addr';
TraceGrid.Cells[1,0]:='Hex';
TraceGrid.Cells[2,0]:='MnemoCod';
TraceGrid.Cells[3,0]:='Operand';
TraceGrid.Cells[4,0]:='Coment';
k:=1;
         for i:=0 to 8191 do begin
disasm(FLASHPROG[i]);
TraceGrid.Cells[0,k]:=IntToHex(i,4);
TraceGrid.Cells[1,k]:=IntToHex(FLASHPROG[i],4);
TraceGrid.Cells[2,k]:=opcod;
TraceGrid.Cells[3,k]:='0x'+operand;
TraceGrid.Cells[4,k]:='; '+coment;
TraceGrid.Cells[5,k]:=namefile;
k:=k+1;
        end;
reasembling:=0;
                        end;
TraceGrid.Col:=0;
TraceGrid.Row:=PCH*256+DataMemory[2]+1;
TraceGrid.Canvas.Pen.Color:=clRed;
  TraceRect.Left := 0;
  TraceRect.Top := PCH*256+DataMemory[2]+1;
  TraceRect.Right := 6;
  TraceRect.Bottom := PCH*256+DataMemory[2]+1;
  TraceGrid.Selection := TraceRect;

if (redrflag and 1)<>0 then
 ProgramFlashGrid.Cells[DataCol,DataRow]:=
        IntToHex(FLASHPROG[(DataRow-1)*16+(DataCol-1)],4);
if (redrflag and 2)<>0 then
 EEPROMGrid.Cells[DataCol,DataRow]:=IntToHex(DataEEPROM[(DataRow-1)*16+(DataCol-1)],2);
if (redrflag and 4)<>0 then
 DataMemoryGrid.Cells[DataCol,DataRow]:=IntToHex(DataMemory[(DataRow-1)*16+(DataCol-1)],2);
if (redrflag and 8)<>0 then
        DrawSteck(Nil);
if flport<>0 then
        PortState(Nil);
        redrflag:=0;
// Set Focus on Flash Grid
      DataCol:=((PCH*256+DataMemory[2]) and $f)+1;
      DataRow:=((PCH*256+DataMemory[2]) div 16)+1;
ProgramFlashGrid.Col:=DataCol;
ProgramFlashGrid.Row:=DataRow;
// Set focus on Data Mamory
if fdist=1 then begin
      DataCol:=(tabpoz and $f)+1;
      DataRow:=(tabpoz div 16)+1;
DataMemoryGrid.Cells[DataCol,DataRow]:=IntToHex(DataMemory[(DataRow-1)*16+(DataCol-1)],2);
DataMemoryGrid.Col:=DataCol;
DataMemoryGrid.Row:=DataRow;
                end;

end;


procedure TPICForm.Button5Click(Sender: TObject);
var f:textfile;
i,j:integer;
hadr,hdat: word;
tempstr,stmp:string;
begin
reasembling:=1;
for i:=0 to 8191 do begin
FLASHPROG[i]:=$3fff;
end;

OpenDialog1.Execute;
Edit6.Text:=OpenDialog1.FileName;
PICForm.Caption:=version+' File:'+Edit6.Text;
assignfile (f,Edit6.Text);
reset (f);
        while not Eof(f) do
  begin
        readln (f,tempstr);
        i:=length(tempstr);
   if i<>0 then begin
                stmp:=Copy(tempstr,2,2);
                i:=StrToInt('$'+stmp);
                stmp:=Copy(tempstr,4,4);
                hadr:=StrToInt('$'+stmp);
        if hadr < $4000 then begin
                for j:=0 to (i div 2)-1 do begin
                stmp:=Copy(tempstr,10+j*4+2,2)+Copy(tempstr,10+j*4,2);
                hdat:=StrToInt('$'+stmp);
                FLASHPROG[(hadr div 2)]:=hdat;
                hadr:=hadr+2;
                end;
                end
         else   if hadr = $400E then begin
                stmp:=Copy(tempstr,12,2)+Copy(tempstr,10,2);
                end
         else   if hadr >= $4200 then begin
                hadr:=(hadr-$4200) div 2;
                for j:=0 to i-1 do begin
                stmp:=Copy(tempstr,10+j*2,2);
                hdat:=StrToInt('$'+stmp);
                if (j and 1)=0 then begin
                DataEEPROM[hadr]:=hdat; hadr:= hadr+1; end;
                end;
                end;
    end;
 end;
//        Button9Click(Nil);
        closefile (f);
  ResetBtnClick(Nil);
end;

procedure TPICForm.Button6Click(Sender: TObject);
begin
Close;
end;

procedure TPICForm.StepOwerClick(Sender: TObject);
begin
stpowerstart:=1;
Button1Click(Nil);
end;

procedure TPICForm.Button8Click(Sender: TObject);
var i,j: word;
begin
for i:=0 to 33 do begin
        if i=0 then
         for j:=0 to 15 do DataMemoryGrid.Cells[j+1,i]:='0'+HexChars[j]
         else
        for j:=0 to 16 do begin
        if j=0 then  DataMemoryGrid.Cells[j,i]:=IntToHex(i-1,2)+'0' else
        DataMemoryGrid.Cells[j,i]:=IntToHex(DataMemory[(i-1)*16+(j-1)],2);
        end;
end;
DataMemoryGrid.Col:=3;
DataMemoryGrid.Row:=3;
end;


procedure TPICForm.Button9Click(Sender: TObject);
var i,j: word;
begin
for i:=0 to $200 do begin
        if i=0 then
         for j:=0 to 15 do ProgramFlashGrid.Cells[j+1,0]:='0'+HexChars[j]
         else
        for j:=0 to 16 do begin
        if j=0 then  ProgramFlashGrid.Cells[j,i]:=IntToHex(i*16-1,4) else
        ProgramFlashGrid.Cells[j,i]:=IntToHex(FLASHPROG[(i-1)*16+(j-1)],4);
        end;
end;
end;

procedure TPICForm.UpDown1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if viewadr= 0 then viewadr:=0 else viewadr:=viewadr-1;
 Button1Click(Nil);
end;

procedure TPICForm.UpDown1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if viewadr= $1fff then viewadr:=$1fff else viewadr:=viewadr+1;
 Button1Click(Nil);
end;

procedure TPICForm.DataMemoryGridKeyPress(Sender: TObject; var Key: Char);
var d: string;
begin
if not (Key in [#8,'0'..'9','A'..'F','a'..'f']) then
         Key := #0  else begin
        d:=DataMemoryGrid.Cells[DataMemoryGrid.Col,DataMemoryGrid.Row];
                if length(DataMemoryGrid.Cells[DataMemoryGrid.Col,DataMemoryGrid.Row])>1
                then
                DataMemoryGrid.Cells[DataMemoryGrid.Col,DataMemoryGrid.Row]:=Key
                else  DataMemoryGrid.Cells[DataMemoryGrid.Col,DataMemoryGrid.Row]:=
                d+Key;
                DataMemory[(DataMemoryGrid.Row-1)*16+DataMemoryGrid.Col-1]:=
                StrToInt('$'+DataMemoryGrid.Cells[DataMemoryGrid.Col,DataMemoryGrid.Row]);
        end;
end;

procedure TPICForm.DataMemoryGridClick(Sender: TObject);
begin
DataMemoryGrid.Selection;
end;

procedure TPICForm.Button13Click(Sender: TObject);
var i,j: word;
begin
for i:=0 to 33 do begin
        if i=0 then
         for j:=0 to 15 do EEPROMGrid.Cells[j+1,i]:='0'+HexChars[j]
         else
        for j:=0 to 16 do begin
        if j=0 then  EEPROMGrid.Cells[j,i]:=HexChars[i-1]+'0' else
        EEPROMGrid.Cells[j,i]:=IntToHex(DataEEPROM[(i-1)*16+(j-1)],2);
        end;
end;
end;

 // Процедура инициализации порта
 procedure TPICForm.InitPort(Sender: TObject);
 var bsport: word;
begin
  SerialPort1.ClosePort;
  StatusBar1.Panels[0].Text:= 'Терминал выключен';
  SerialPort1.CommPort := TCommPort(CBPort.ItemIndex);
  if SerialPort1.OpenPort(SerialPort1.CommPort) then
    StatusBar1.Panels[0].Text:= 'COM-порт открыт'
  else
   begin
    StatusBar1.Panels[0].Text:= 'Неправильно указан порт';
    exit;
   end;
  SerialPort1.BaudRate := TBaudRate(CBBaud.ItemIndex);
  if SerialPort1.LastErr = 0 then
    StatusBar1.Panels[0].Text:= 'Скорость передачи установлена'
  else
   begin
    StatusBar1.Panels[0].Text:= Format('Ошибка %d', [SerialPort1.LastErr]);
    exit;
   end;
  SerialPort1.FlowControl := TFlowControl(CBFlow.ItemIndex);
  if SerialPort1.LastErr = 0 then
    StatusBar1.Panels[0].Text := 'Тип контроля потока установлен'
  else
   begin
    StatusBar1.Panels[0].Text:= Format('Ошибка %d', [SerialPort1.LastErr]);
    exit;
   end;
  SerialPort1.DataBits := TDataBits(4);
  if SerialPort1.LastErr<>0 then
   begin
    StatusBar1.Panels[0].Text:= Format('Ошибка %d', [SerialPort1.LastErr]);
    exit;
   end;
  SerialPort1.StopBits := TStopBits(0);
  if SerialPort1.LastErr<>0 then
   begin
    StatusBar1.Panels[0].Text:= Format('Ошибка %d', [SerialPort1.LastErr]);
    exit;
   end;
  SerialPort1.ParityType := TParityType(0);
  if SerialPort1.LastErr<>0 then
   begin
    StatusBar1.Panels[0].Text:= Format('Ошибка %d', [SerialPort1.LastErr]);
    exit;
   end else
         begin    StatusBar1.Panels[0].Text:= 'Отладчик подключен';
        if CBPort.ItemIndex=0 then  bsport:=$3fc else
        if CBPort.ItemIndex=1 then  bsport:=$2fc else
        if CBPort.ItemIndex=2 then  bsport:=$3ec else
        if CBPort.ItemIndex=3 then  bsport:=$2ec else
        bsport:=0
         end;
   if bsport = 0 then bsport:=0 else
   begin     asm         //Установить отрицательное напряжение на DTR
        push    ax
        push    dx
        mov     dx,bsport
        in      al,dx
        xor     al,1
        out     dx,al
        pop     dx
        pop     ax
        end;
   end;

end;



procedure TPICForm.Button11Click(Sender: TObject);
begin
        pKey[0]:=Char($55);
        pKey[1]:=Char($86);
        pKey[2]:=Char($00);
        SerialPort1.SendData(pKey,3);
        pKey[0]:=Char($55);
        pKey[1]:=Char($06);
        pKey[2]:=Char($00);
        SerialPort1.SendData(pKey,3);
end;

procedure TPICForm.Button14Click(Sender: TObject);
var temp : string;
begin
InitPort(Nil);
        rdflag:=0;
        pKey[0]:=Char($00);
        SerialPort1.SendData(pKey,1);
        Button7.Visible:=False;
                StatusBar1.Panels[0].Text := 'Начало передачи';
        rdflag:=0;
        sleep(rfdel*5); nomsleep:=nomsleep+rfdel*5;
        rstring:=SerialPort1.GetData;
                StatusBar1.Panels[0].Text := 'Конец передачи';
        Button7.Visible:=True;
        temp:=copy(rstring,0,2);
        if temp = 'V.' then
        begin StatusBar1.Panels[0].Text := 'Отладчик подключен.'+rstring;
        pKey[0]:=Char($55);
        pKey[1]:=Char($05);
        pKey[2]:=Char($ff);
        DataMemory[$05]:=$ff;
        SerialPort1.SendData(pKey,3);
        sleep(rfdel*3); nomsleep:=nomsleep+rfdel*3;
        pKey[0]:=Char($55);
        pKey[1]:=Char($85);
        pKey[2]:=Char($ff);
        DataMemory[$85]:=$ff;
        SerialPort1.SendData(pKey,3);
        sleep(rfdel*3); nomsleep:=nomsleep+rfdel*3;
        pKey[0]:=Char($55);
        pKey[1]:=Char($06);
        pKey[2]:=Char($ff);
        DataMemory[$06]:=$ff;
        SerialPort1.SendData(pKey,3);
        sleep(rfdel*3); nomsleep:=nomsleep+rfdel*3;
        pKey[0]:=Char($55);
        pKey[1]:=Char($86);
        pKey[2]:=Char($ff);
        DataMemory[$86]:=$ff;
        SerialPort1.SendData(pKey,3);
        sleep(rfdel*3); nomsleep:=nomsleep+rfdel*3;
        pKey[0]:=Char($55);
        pKey[1]:=Char($07);
        pKey[2]:=Char($ff);
        DataMemory[$07]:=$ff;
        SerialPort1.SendData(pKey,3);
        sleep(rfdel*3); nomsleep:=nomsleep+rfdel*3;
        pKey[0]:=Char($55);
        pKey[1]:=Char($87);
        pKey[2]:=Char($ff);
        DataMemory[$87]:=$ff;
        SerialPort1.SendData(pKey,3);
        sleep(rfdel*3); nomsleep:=nomsleep+rfdel*3;
        comset:=1;
        end else begin
        comset:=0;
        StatusBar1.Panels[0].Text := 'Симулятор не отвечает!';
        Msg:='Отладчик не отвечает, проверте соединение или питание.';
        MessageDlg(Msg,mtERROR,[mbOK],0);
                 end;

end;

procedure TPICForm.Button7Click(Sender: TObject);
var i,l: word;
begin
        Edit13.Text:=SerialPort1.GetData;
        rdflag:=0;
 Edit13.Text:='';
        pKey[0]:=Char(0);
        SerialPort1.SendData(pKey,1);
        Button7.Visible:=False;
                StatusBar1.Panels[0].Text := 'Начало передачи';
//        RXByte(Nil);
        sleep(rfdel*6); nomsleep:=nomsleep+rfdel*6;
        Edit13.Text:=SerialPort1.GetData;
        rdflag:=0;
                StatusBar1.Panels[0].Text := 'Конец передачи';
        Button7.Visible:=True;
        rdflag:=0;
 Edit13.Text:='';
        pKey[0]:=Char($55);
        pKey[1]:=Char($86);
        pKey[2]:=Char($00);
        SerialPort1.SendData(pKey,3);
        pKey[0]:=Char($55);
        pKey[1]:=Char($06);
        pKey[2]:=Char($55);
        SerialPort1.SendData(pKey,3);
        pKey[0]:=Char($aa);
        pKey[1]:=Char($06);
        SerialPort1.SendData(pKey,2);
        Button7.Visible:=False;
                StatusBar1.Panels[0].Text := 'Начало передачи';
        sleep(rfdel*6); nomsleep:=nomsleep+rfdel*3;
        Edit13.Text:=SerialPort1.GetData;
        rdflag:=0;
                StatusBar1.Panels[0].Text := 'Конец передачи';
        Button7.Visible:=True;
        l:=1;
        i:=integer(Edit13.Text[l]);
 Edit12.Text:=IntToHex(i,2);
end;

procedure TPICForm.SerialPort1AfterReceive(Sender: TObject; data: String);
var  i,j:integer;
begin
if SerialPort1.LastErr <> 0
then StatusBar1.Panels[0].Text :=
        'Ошибка передачи'+IntToStr(SerialPort1.LastErr)
else    begin rstring:=data;
rdflag:=1;
j:=Length(data);
lengthpRead:=j;
Edit8.Text:= IntToStr(j);
Edit11.Text:= '';
if j=0 then Edit11.Text:= IntToHex(byte(pRead[0]),2)
else
for i:=0 to j-1 do begin
        pRead[i]:=char(data[i]);
        Edit11.Text:= Edit11.Text+' '+IntToHex(byte(pRead[i]),2);
        end;
        Edit10.Text:= rstring;
        end;
        data:='';
        rstring:='';
end;

procedure TPICForm.SerialPort1Receive(Sender: TObject; data: String);
var  i,j:integer;
begin
if SerialPort1.LastErr <> 0 then StatusBar1.Panels[0].Text := 'Ошибка передачи'
else    begin rstring:=data;
j:=Length(data);
Edit8.Text:= '';
for i:=0 to j-1 do begin
        rdata:=byte(data[i]);
        Edit8.Text:= Edit8.Text+IntToHex(rdata,2);
        end;
        Edit7.Text:= rstring;
        rdflag:=1;
        end;
end;


procedure TPICForm.Button12Click(Sender: TObject);
begin
        pKey[0]:=Char($55);
        pKey[1]:=Char($06);
        pKey[2]:=Char($00);
        SerialPort1.SendData(pKey,3);
end;

procedure TPICForm.Button15Click(Sender: TObject);
var bsport: word;
begin
   if CBPort.ItemIndex=0 then  bsport:=$3fc else
   if CBPort.ItemIndex=1 then  bsport:=$2fc else
   if CBPort.ItemIndex=2 then  bsport:=$3ec else
   if CBPort.ItemIndex=3 then  bsport:=$2ec else
   bsport:=0;
   if bsport = 0 then bsport:=0 else
   begin     asm         //Установить отрицательное напряжение на DTR
        push    ax
        push    dx
        mov     dx,bsport
        in      al,dx
        xor     al,1
        out     dx,al
        mov     bsport,ax
        pop     dx
        pop     ax
        end;
        if (bsport and 1) = 0 then Button15.Caption:='-' else
        Button15.Caption:='+';
    end;

end;
procedure TPICForm.ResetBtnClick(Sender: TObject);
var i: word;
begin
DataMemory[3]:=0;
wreg:=0;
step:=0;
//reasembling:=1;
rstring:='';
for i:=0 to 7 do begin
ProgSteck[i]:=0;
end;
for i:=0 to $1ff do begin
DataMemory[i]:=0;
end;
          PointStek:=0;
          DataMemory[$8A]:=0;
          CountCLK:=0;
          retflag:=0;
PCH:=0;
viewadr:=0;
 Button8Click(Nil);
 Button9Click(Nil);
 Button1Click(Nil);
 Button13Click(Nil);
{ i:=1;
 while i<>5 do begin
TraceGrid.Cells[0,i]:='';
TraceGrid.Cells[1,i]:='';
TraceGrid.Cells[2,i]:='';
TraceGrid.Cells[3,i]:='';
TraceGrid.Cells[4,i]:='';
TraceGrid.Cells[5,i]:='';
i:=i+1;
end;}
 step:=1;
end;

procedure TPICForm.InitDataMemoryGrid(Sender: TObject);
var i,j: word;
begin
for i:=0 to 33 do begin
        if i=0 then
         for j:=0 to 15 do DataMemoryGrid.Cells[j+1,i]:='0'+HexChars[j]
         else
        for j:=0 to 16 do begin
        if j=0 then  DataMemoryGrid.Cells[j,i]:=IntToHex(i-1,2)+'0' else
        DataMemoryGrid.Cells[j,i]:=IntToHex(DataMemory[(i-1)*16+(j-1)],2);
        end;
end;
end;

procedure TPICForm.DrawDataMemory(Sender: TObject);
var i,j: word;
begin
for i:=0 to 33 do begin
        if i<>0 then
        for j:=0 to 16 do begin
        if j<>0 then
        DataMemoryGrid.Cells[j,i]:=IntToHex(DataMemory[(i-1)*16+(j-1)],2);
        end;
end;
DataMemoryGrid.Col:=DataCol;
DataMemoryGrid.Row:=DataRow;
end;


procedure TPICForm.Button10Click(Sender: TObject);
var lliteral: word;
begin
lliteral:=StrToInt('$'+Edit3.Text);
        DataMemory[2]:=lliteral and $ff;
        PCH:=(lliteral and $1f00) shr 8;
        DataMemory[$0a]:=(lliteral and $1f00) shr 8;
        PCH:=PCH or (DataMemory[$0a] and $18);
        step:=0;
        Button1Click(Nil);
        step:=1;
end;

procedure TPICForm.ResetCLKClick(Sender: TObject);
begin
StatusBar1.Panels[5].Text:='0';
StatusBar1.Panels[4].Text:='0 мкс';
CountCLK:=0;
end;

procedure TPICForm.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
if not (Key in [#8,'0'..'9','A'..'F','a'..'f']) then Key := #0;
end;

procedure TPICForm.DrawSteck(Sender: TObject);
var i: word;
begin
SteckGrid.Cells[0,0]:='Steck';
for i:=1 to 8 do begin
        SteckGrid.Cells[0,i]:=IntToHex(ProgSteck[i-1],4);
        end;
SteckGrid.Col:=0;
SteckGrid.Row:=(PointStek and 7)+1;
end;

procedure TPICForm.SelDrawSteck(Sender: TObject);
var i: word;
begin
for i:=1 to 8 do begin
        SteckGrid.Cells[0,i]:=IntToHex(ProgSteck[i-1],4);
        end;
SteckGrid.Col:=0;
SteckGrid.Row:=(PointStek and 7)+1;
end;

procedure TPICForm.Button17Click(Sender: TObject);
var aexp,arg0,arg1,arg2: byte;
point,sign: word;
arg:dword;
res:extended;
d:string;
begin
point:=StrToInt('$'+Edit4.Text)and $1FF;
aexp:=DataMemory[point];
Float32Grid.Cells[0,0]:='ARG0';
arg0:=DataMemory[point+1];
arg1:=DataMemory[point+2];
arg2:=DataMemory[point+3];
Float32Grid.Cells[1,0]:=IntToHex(aexp,2)+' '+IntToHex(arg0,2)
                        +' '+IntToHex(arg1,2)+' '+IntToHex(arg2,2);
if (arg0 and $80)=0 then sign:=0
        else  sign:=1;
arg0:=arg0 or $80;
arg:=arg0*$10000+arg1*$100+arg2;
if (aexp-$7f)>0 then
res:=arg/$800000*(1 shl ((-$7f+aexp)and $7f)) else
res:=arg/$800000/(1 shl (($7f-aexp)and $7f));
Float32Grid.Cells[0,1]:='Float';
d:=FloatToStrF(res,ffFixed,8,4);
if sign = 0 then d:='+'+d else d:='-'+d;
Float32Grid.Cells[1,1]:=d;
end;

procedure TPICForm.OpenHEX1Click(Sender: TObject);
begin
Button5Click(Nil);
end;

procedure TPICForm.Exit1Click(Sender: TObject);
begin
Close;
end;

procedure TPICForm.SerialPort1AfterTransmit(Sender: TObject; data: String);
begin
flagSend:=0;
end;

procedure TPICForm.FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
begin
if Key = vk_F7 then StatusBar1.Panels[2].Text:='F7 down';
end;

procedure TPICForm.Button3Click(Sender: TObject);
begin
if Button3.Caption='Run' then
        begin
 nomsleep:=0;
        rfdel:=StrToInt(Edit1.Text);
        Timer1.Interval:=StrToInt(Edit15.Text);
Timer1.Enabled:=True;
fltimer:=1;
Button3.Caption:='Stop';
        end
else    begin
Timer1.Enabled:=False;
fltimer:=0;
Button3.Caption:='Run';
Button1Click(Nil);
StatusBar1.Panels[5].Text:=
IntToStr(nomsleep)+' мкс';
        end;
end;

procedure TPICForm.Timer1Timer(Sender: TObject);
begin
//;
end;

procedure TPICForm.Button2Click(Sender: TObject);
var f:textfile;
i,j:integer;
tempstr:string;
begin
SaveDialog1.Execute;
Edit9.Text:=SaveDialog1.FileName;
        assignfile (f,Edit9.Text);
        rewrite (f);
        j:=$09;
   for i:=0 to 8192 do begin
   if Listing.ItemIndex=0 then
tempstr:=Char(j)+TraceGrid.Cells[2,i]+Char(j)+Char(j)+
TraceGrid.Cells[3,i];
   if Listing.ItemIndex=1 then
tempstr:=TraceGrid.Cells[0,i]+Char(j)+
TraceGrid.Cells[1,i]+Char(j)+
TraceGrid.Cells[2,i]+Char(j)+Char(j)+
TraceGrid.Cells[3,i]+
TraceGrid.Cells[4,i]+' '+
TraceGrid.Cells[5,i];
   if Listing.ItemIndex=2 then
tempstr:=TraceGrid.Cells[0,i]+Char(j)+
TraceGrid.Cells[1,i]+Char(j)+
TraceGrid.Cells[2,i]+Char(j)+Char(j)+
TraceGrid.Cells[3,i]+
TraceGrid.Cells[4,i]+' '+
TraceGrid.Cells[5,i];
   if Listing.ItemIndex=3 then
tempstr:=Char(j)+TraceGrid.Cells[2,i]+Char(j)+Char(j)+
TraceGrid.Cells[3,i]+TraceGrid.Cells[4,i]+' '+
TraceGrid.Cells[5,i]+TraceGrid.Cells[0,i]+Char(j)+
TraceGrid.Cells[1,i];
   if Listing.ItemIndex=4 then
tempstr:=TraceGrid.Cells[0,i]+Char(j)+
TraceGrid.Cells[2,i]+Char(j)+Char(j)+
TraceGrid.Cells[3,i]+
TraceGrid.Cells[4,i]+' '+
TraceGrid.Cells[5,i];
writeln(f,tempstr);
        end;
        closefile (f);
end;

procedure TPICForm.Edit1Change(Sender: TObject);
begin
        rfdel:=StrToInt(Edit1.Text);
end;

end.
