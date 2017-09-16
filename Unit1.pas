unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ComCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Button3: TButton;
    Edit3: TEdit;
    Button4: TButton;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    Button5: TButton;
    Edit4: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Button6: TButton;
    Button7: TButton;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    ListBox3: TListBox;
    ListBox4: TListBox;
    Button8: TButton;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    Button9: TButton;
    StatusBar1: TStatusBar;
    Button10: TButton;
    ListBox5: TListBox;
    UpDown1: TUpDown;
    Button11: TButton;
    Button12: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  var  FLASHPROG:array[0..$1fff] of word;
  var  DataEEPROM:array[0..255] of byte;
  var DataMemory:array[0..$1ff] of byte;
  var ProgSteck:array[0..7] of word;
  var CountCLK, OSC, PointStek: word;
  var retflag, wreg, PCH: byte;
   var asemb, nopcod : word;
   var ff,fl,fw,fll,fb,freg, tclk : word;
   var opcod,operand,hexadr,coment: string;
   {  const mnemocod: array[0..35,] of string =
//Byte - oriented file register operetions
'ADDWF','ANDWF','CLRF','CLRW','COMF','DECF','DECFSZ',
'INCF','INCFSZ','IORWF','MOVF','MOVWF','NOP','RLF',
'RRF','SUBWF','SWAPF','XORWF',
//Bit - oriented file registr operetion
'BCF','BSF','BTFSC','BTFSS',
//Literal and control operation
'ADDLW','ANDLW','CALL','CLRWDT','GOTO',
'IORLW','MOVLW','RETFIE','RETLW',
'RETURN','SLEEP','SUBLW','XORLW';}
        Function disasm(var decod: word):string;
        Function ReadFReg(var codes: word):integer;
        Function WriteFReg(var filereg: byte):byte;
        Function EpromDump(var index: word):integer;
        Function StepProc(var decod: word):string;
implementation

{$R *.dfm}

Function ReadFReg(var codes: word):integer;
var i: word;
begin
codes:=codes and $7f;
ReadFReg:=DataMemory[codes];
end;

Function EpromDump(var index: word):integer;
var i,j: word; d:string;
begin
for i:=0 to 15 do begin
d:='';
for j:=0 to 15 do begin
d:=d+IntToHex(DataMemory[i*16+j],4);
end;
//ListBox5.Items.Add(d);
end;
end;

Function WriteFReg(var filereg: byte):byte;
var i: word;
begin

end;
// Функция пошагового выполнения
// Если Flag=0 реальная трасировка
// Если Flag=1 трассировка без результата
Function StepProc(var decod: word):string;
var adr, lbit, bank,pcod,literal,lliteral,err,b,i,res: word;
        d,f,l,o: string;
begin
// decoding command
ff:=0; fw:=0; fl:=0; fll:=0; opcod:=''; operand:=''; tclk:=0;
decod:=FLASHPROG[DataMemory[10]*256+DataMemory[2]];
pcod:=decod and $07f;
literal:=decod and $ff;
lliteral:=decod and $fff;
b:=((decod and $380) shr 7);
bank:=(DataMemory[3] and $60) shl 2;
case decod of
        $0:             begin //NOP
                        tclk:=1; end;
        $20, $40, $60:  begin //NOP+
                        tclk:=1; end;
        $900..$9ff:    begin  //COMF

                        tclk:=1;  end;
        $A00..$Aff:    begin
                        d:='INCF'; nopcod:=4;
tclk:=1;
                      end;
        $f00..$fff:    begin
                        d:='INCFSZ'; nopcod:=6;
tclk:=2;
                      end;
        $300..$3ff:    begin
                        d:='DECF'; nopcod:=4;
tclk:=1;
                      end;
        $B00..$Bff:    begin
                        d:='DECFSZ'; nopcod:=6;
tclk:=2;
                      end;
        $700..$7ff:    begin
                        d:='ADDWF'; nopcod:=5;
tclk:=1;
                      end;
        $200..$2ff:    begin
                        d:='SUBWF';
tclk:=1;
                      end;
        $e00..$eff:    begin
                        d:='SWAPF';
tclk:=1;
                      end;
        $600..$6ff:    begin //XORWF
                        tclk:=1;
                      end;
        $500..$5ff:    begin //ANDWF
                        tclk:=1;
                      end;
        $400..$4ff:    begin //IORWF
                        tclk:=1;
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
        $3e00..$3eff:   begin // ADDLW'
                        wreg:=wreg+literal;
                        if (wreg and $100)= 0
                            then   DataMemory[3]:=(DataMemory[3] and $fe)
                            else   DataMemory[3]:=(DataMemory[3] or $1);
                        if (wreg and $100)= 0
                            then   DataMemory[3]:=(DataMemory[3] and $fb)
                            else   DataMemory[3]:=(DataMemory[3] or $4);


                        tclk:=1;
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
        if ff=1 then o:='0x'+IntToHex((decod and $7f),2);
        if fw=1 then if (decod and $80)=0 then o:=o+',W' else o:=o+',F';
        if fb=1 then o:=o+'0x'+IntToHex(((decod and $380) shr 7),1);
        if fl=1 then o:='0x'+IntToHex((decod and $ff),2);
        if fll=1 then o:='0x'+IntToHex((decod and $7ff),3);
        operand:=o;
        StepProc:=d+' '+o;
        CountCLK:=CountCLK+tclk;

end; //Step proc

//Disasm
Function disasm(var decod: word):string;
var bank,pcod,err, i, res: word;
        d,f,b,l,o: string;
begin
// decoding command
ff:=0; fw:=0; fl:=0; fll:=0; opcod:=''; operand:='';
//decod:=FLASHPROG[DataMemory[10]*256+DataMemory[2]];
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
        if ff=1 then o:='0x'+IntToHex((decod and $7f),2);
        if fw=1 then if (decod and $80)=0 then o:=o+',W' else o:=o+',F';
        if fb=1 then o:=o+'0x'+IntToHex(((decod and $380) shr 7),1);
        if fl=1 then o:='0x'+IntToHex((decod and $ff),2);
        if fll=1 then o:='0x'+IntToHex((decod and $7ff),3);
        operand:=o;
        disasm:=d+' '+o;
end;

procedure TForm1.Button7Click(Sender: TObject);
var bank,i: word;
begin
i:=$42;
i:=ReadFReg(i);
bank:=(DataMemory[3] and $60) shl 2;
 Edit6.Text:=IntToHex(i,2);
 asemb:=0;
Edit8.Text:=disasm(i);
end;

procedure TForm1.FormCreate(Sender: TObject);
var i: word;
begin
for i:=0 to 7 do begin
ProgSteck[i]:=0;
end;
for i:=0 to $1fff do begin
FLASHPROG[i]:=$3fff;
end;
for i:=0 to $1ff do begin
DataMemory[i]:=i;
end;
          DataMemory[2]:=0;
          ProgSteck[0]:=0;
          PointStek:=0;
          DataMemory[$8A]:=0;
          CountCLK:=0;
          retflag:=0;
PCH:=0; DataMemory[10]:=0; DataMemory[2]:=0;
FLASHPROG[0]:=$700;
FLASHPROG[1]:=$7ff;
FLASHPROG[2]:=$600;
FLASHPROG[3]:=$6ff;
FLASHPROG[4]:=$180;
FLASHPROG[5]:=$1ff;
FLASHPROG[6]:=$100;
FLASHPROG[7]:=$17f;

end;

procedure TForm1.Button1Click(Sender: TObject);
var i,k: word; d: string;
begin
Edit9.text:=IntToStr(CountCLK);
ListBox1.Clear;
ListBox2.Clear;
ListBox3.Clear;
ListBox4.Clear;
d:=StepProc(i);
Edit5.Text:=IntToHex(wreg,2);
        i:=PCH*256+DataMemory[2];
        k:=i;
         disasm(FLASHPROG[i]);
 Edit1.Text:=IntToHex(i,4);
 Edit2.Text:=IntToHex(FLASHPROG[i],4);
 Edit3.Text:=opcod;
 Edit4.Text:=operand;
 i:=i+1;
 for i:=i to i+14 do begin
disasm(FLASHPROG[i]);
ListBox1.Items.Add(IntToHex(i,4));
ListBox2.Items.Add(IntToHex(FLASHPROG[i],4));
ListBox3.Items.Add(opcod);
ListBox4.Items.Add(operand);
end;

if DataMemory[2]=$ff then
        begin DataMemory[2]:=0; PCH:=((PCH+1) and $1f); end
        else DataMemory[2]:=DataMemory[2]+1;
end;


procedure TForm1.Button5Click(Sender: TObject);
var FileName: string;
begin
OpenDialog1.Create(Nil);
FileName:=OpenDialog1.FileName;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
Close;
end;


procedure TForm1.Button2Click(Sender: TObject);
begin
//EpromDump(1);
end;

procedure TForm1.Button8Click(Sender: TObject);
var i,j: word;
Const
HexChars : Array[0..15] of Char = '0123456789ABCDEF';
begin
for i:=0 to 16 do begin
        if i=0 then
         for j:=0 to 15 do StringGrid1.Cells[j+1,0]:='0'+HexChars[j]
         else
        for j:=0 to 16 do begin
        if j=0 then  StringGrid1.Cells[j,i]:=HexChars[i-1]+'0' else
        StringGrid1.Cells[j,i]:=IntToHex(DataMemory[(i-1)*16+(j-1)],2);
        end;
end;
end;


procedure TForm1.Button9Click(Sender: TObject);
var i,j: word;
Const
HexChars : Array[0..15] of Char = '0123456789ABCDEF';
begin
for i:=0 to $200 do begin
        if i=0 then
         for j:=0 to 15 do StringGrid2.Cells[j+1,0]:='0'+HexChars[j]
         else
        for j:=0 to 16 do begin
        if j=0 then  StringGrid2.Cells[j,i]:=IntToHex(i*16-1,4) else
        StringGrid2.Cells[j,i]:=IntToHex(FLASHPROG[(i-1)*16+(j-1)],4);
        end;
end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var i,pcod,regfile,workreg,errord: word;
begin
errord:=0;
ListBox5.Clear;
ListBox5.Items.Add('Steck');
for i:=0 to 7 do
ListBox5.Items.Add(IntToHex(i,1)+'  '+IntToHex(ProgSteck[PointStek],3));
end;


procedure TForm1.Button11Click(Sender: TObject);
begin
//ListBox5.Items;
end;

end.
