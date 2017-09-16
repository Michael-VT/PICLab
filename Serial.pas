unit Serial;
// DomIS Internet Solutions http://www.domis.de
// This Source may be used for any legal purpose, except military use!!!
// Any changes should be marked and this header should remain here

// Usage
// You have to register this component with the Delphi funktion "Component/New"
// create a new component library and add this component
// the TSerial component appears in the "Samples" part of the component toolbar 

// The Base of this unit is taken from "TSerialPort: Basic Serial Communications in Delphi"
// created by Jason "Wedge" Perry, but I could not find him again
// The advantage from the original are

// Threaddriven receiver. 
//   Receiving is possible during the Main program is busy.
//   In the original source, the Program stopped during receiving. 
//   If Handshake was enabled the programm waits until a charachter was received.
// Receive and Send Time-Outs
//   The implementation of Time outs get work now.
//   In the original source Timeout stopped the program or the result was
//   random like 

// Usage of events
// fOnTransmit, fAfterTransmit
// Usage not neccessary, this event is fired when Data is placed in the Outqueue
// Original usage: possibly implementing some blinking stuff

// fOnReceive, fAfterReceive
// usage: this event is fired when a TimeOut occoure and data are received
// The receiver Thread check every 200ms for Data in the Queue and if no new
// Data received the event is fired. If Timeout is specified the Windows
// API Read function will wait the TimeOut and then 200ms wait is added!
// Dont use the GetData function direct (Garbage will received)

// Install:
// To get this Software running, You must install the component.
// To do so please follow the instuction below:
// Enter Delphis Component Menu and select "install component"
// In the "Install Component"-Dialog select the section "Into new Package". 
// Enter "serial.pas" into the the "Unit Filename" Editfield or use the "Browse"-Button. 
// Enter a Filename (e.g. "sercom") into the "Package Filename" Editfield. 
// Enter a Description (e.g. "Serial tools") into the "Description" Editfield. 
// Click to the "OK"-Button and the Component will be installed in the "Samples" section of the Component-bar.
// After that You may load the "serialtest.dpr" and compile the whole stuff into the "serialtest.exe".


interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs;

type
  // You can't do anything without a comm port.
  TCommPort = (cpCOM1, cpCOM2, cpCOM3, cpCOM4,
               cpCOM5, cpCOM6, cpCOM7, cpCOM8);

  // All of the baud rates that the DCB supports.
  TBaudRate = (br110, br300, br600, br1200,
               br2400, br4800, br9600, br14400,
               br19200, br38400, br56000, br115200,
               br128000, br256000);

  // Parity types for parity error checking
  TParityType = (pcNone, pcEven, pcOdd,
                 pcMark, pcSpace);

  TStopBits = (sbOne, sbOnePtFive, sbTwo);

  TDataBits = (db4, db5, db6, db7, db8);

  TFlowControl = (fcNone, fcXON_XOFF,
                  fcRTS_CTS, fsDSR_DTR);

  // Two new notify events.
  TNotifyTXEvent = procedure(Sender : TObject;
                   data : string) of object;
  TNotifyRXEvent = procedure(Sender : TObject;
                   data : string) of object;

  // Set some constant defaults.
// These are the qquivalent of
// COM2:9600,N,8,1;
const
  d100p = 20;
  dflt_CommPort = cpCOM2;
  dflt_BaudRate = br9600;
  dflt_ParityType = pcNone;
  dflt_ParityErrorChecking = False;
  dflt_ParityErrorChar = 0;
  dflt_ParityErrorReplacement = False;
  dflt_StopBits = sbOne;
  dflt_DataBits = db8;
  dflt_XONChar = $11;  {ASCII 11h}
  dflt_XOFFChar = $13; {ASCII 13h}
  dflt_XONLim = 1024;
  dflt_XOFFLim = 2048;
  dflt_ErrorChar = 0; // For parity checking.
  dflt_FlowControl = fcNone;
  dflt_StripNullChars = False;
  dflt_EOFChar = 0;
  dflt_ReadTO = 5000; // 5000msec
  dflt_WriteTO = 5000; // 5000msec
type
  TSerialPort = class(TComponent)
  private
    hCommPort : THandle; // Handle to the port.
    fCommPort : TCommPort;
    fBaudRate : TBaudRate;
    fParityType : TParityType;
    fParityErrorChecking : Boolean;
    fParityErrorChar : Byte;
    fParityErrorReplacement : Boolean;
    fStopBits : TStopBits;
    fDataBits : TDataBits;
    fXONChar : byte;  {0..255}
    fXOFFChar : byte; {0..255}
    fXONLim : word;  {0..65535}
    fXOFFLim : word; {0..65535}
    fErrorChar : byte;
    fFlowControl : TFlowControl;
    fStripNullChars : Boolean;  // Strip null chars?
    fEOFChar : Byte;
    fOnTransmit : TNotifyTXEvent;
    fOnReceive : TNotifyRXEvent;
    fAfterTransmit : TNotifyTXEvent;
    fAfterReceive : TNotifyRXEvent;
    fReadTO : Word;
    fWriteTO : Word;
    ReadBuffer : String;
    RecThread : TThread;
    ThreadIsRunning : Boolean;
    procedure SetCommPort(value : TCommPort);
    procedure SetBaudRate(value : TBaudRate);
    procedure SetParityType(value : TParityType);
    procedure SetParityErrorChecking(value : Boolean);
    procedure SetParityErrorChar(value : Byte);
    procedure SetParityErrorReplacement(value : Boolean);
    procedure SetStopBits(value : TStopBits);
    procedure SetDataBits(value : TDataBits);
    procedure SetXONChar(value : byte);
    procedure SetXOFFChar(value : byte);
    procedure SetXONLim(value : word);
    procedure SetXOFFLim(value : word);
    procedure SetErrorChar(value : byte);
    procedure SetFlowControl(value : TFlowControl);
    procedure SetStripNullChars(value : Boolean);
    procedure SetEOFChar(value : Byte);
    procedure SetReadTO(value : Word);
    procedure SetWriteTO(value : Word);
    procedure Initialize_DCB;
    procedure ThreadDone(Sender: TObject);
  protected
  public
    LastErr : Integer;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function OpenPort(MyCommPort : TCommPort) : Boolean;
    function ClosePort : boolean;
    procedure SendData(data : PChar; size : DWord);
    function GetData : String;
    function PortIsOpen : boolean;
    procedure FlushTX;
    procedure FlushRX;
  published
    property ComHandle   :
             THandle read hCommPort
                     default INVALID_HANDLE_VALUE;
    property CommPort :
             TCommport read fCommPort
                       write SetCommPort
                       default dflt_CommPort;
    property BaudRate :
             TBaudRate read fBaudRate
                       write SetBaudRate
                       default dflt_BaudRate;
    property ParityType :
             TParityType read fParityType
                         write SetParityType
                         default dflt_ParityType;
    property ParityErrorChecking :
             Boolean read fParityErrorChecking
                     write SetParityErrorChecking
                     default dflt_ParityErrorChecking;
    property ParityErrorChar :
             Byte read fParityErrorChar
             write SetParityErrorChar
             default dflt_ParityErrorChar;
    property ParityErrorReplacement :
             Boolean read fParityErrorReplacement
                     write SetParityErrorReplacement
                     default dflt_ParityErrorReplacement;
    property StopBits :
             TStopBits read fStopBits
                       write SetStopBits
                       default dflt_StopBits;
    property DataBits :
             TDataBits read fDataBits
                       write SetDataBits
                       default dflt_DataBits;
    property XONChar :
             byte read fXONChar
                  write SetXONChar
                  default dflt_XONChar;
    property XOFFChar :
             byte read fXOFFChar
                  write SetXOFFChar
                  default dflt_XOFFChar;
    property XONLim :
             word read fXONLim
                  write SetXONLim
                  default dflt_XONLim;
    property XOFFLim :
             word read fXOFFLim
                  write SetXOFFLim
                  default dflt_XOFFLim;
    property ErrorChar :
             byte read fErrorChar
                  write SetErrorChar
                  default dflt_ErrorChar;
    property FlowControl :
             TFlowControl read fFlowControl
                                        write SetFlowControl
                                        default dflt_FlowControl;
    property StripNullChars : Boolean read fStripNullChars
                                      write SetStripNullChars
                                      default dflt_StripNullChars;
    property EOFChar : byte read fEOFChar
                            write SetEOFChar
                            default dflt_EOFChar;
    property ReadTO : Word read fReadTO
                                      write SetReadTO
                                      default dflt_ReadTO;
    property WriteTO : Word read fWriteTO
                                      write SetWriteTO
                                      default dflt_WriteTO;
    property OnTransmit : TNotifyTXEvent read fOnTransmit
                                         write fOnTransmit;
    property OnReceive : TNotifyRXEvent read fOnReceive
                                        write fOnReceive;
    property AfterTransmit : TNotifyTXEvent read fAfterTransmit
                                            write fAfterTransmit;
    property AfterReceive : TNotifyRXEvent read fAfterReceive
                                            write fAfterReceive;
  end;

  TRecThread = class(TThread)
  private
    Owner : TSerialPort;
    procedure DoReceiving;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner : TSerialPort);
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TSerialPort]);
end;

procedure TSerialPort.SetCommPort(value : TCommPort);
begin
  if value <> fCommPort then
    begin
      fCommPort := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetBaudRate(value : TBaudRate);
begin
  if value <> fBaudRate then
    begin
      fBaudRate := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetParityType(value : TParityType);
begin
  if value <> fParityType then
    begin
      fParityType := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetParityErrorChecking(value : Boolean);
begin
  if value <> fParityErrorChecking then
    begin
      fParityErrorChecking := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetParityErrorChar(value : Byte);
begin
  if value <> fParityErrorChar then
    begin
      fParityErrorChar := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetParityErrorReplacement(value : Boolean);
begin
  if value <> fParityErrorReplacement then
    begin
      fParityErrorReplacement := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetStopBits(value : TStopBits);
begin
  if value <> fStopBits then
    begin
      fStopBits := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetDataBits(value : TDataBits);
begin
  if value <> fDataBits then
    begin
      fDataBits := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetXONChar(value : byte);
begin
  if value <> fXONChar then
    begin
      fXONChar := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetXOFFChar(value : byte);
begin
  if value <> fXOFFChar then
    begin
      fXOFFChar := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetXONLim(value : word);
begin
  if value <> fXONLim then
    begin
      fXONLim := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetXOFFLim(value : word);
begin
  if value <> fXOFFLim then
    begin
      fXOFFLim := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetErrorChar(value : byte);
begin
  if value <> fErrorChar then
    begin
      fErrorChar := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetFlowControl(value : TFlowControl);
begin
  if value <> fFlowControl then
    begin
      fFlowControl := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetStripNullChars(value : Boolean);
begin
  if value <> fStripNullChars then
    begin
      fStripNullChars := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetEOFChar(value : Byte);
begin
  if value <> fEOFChar then
    begin
      fEOFChar := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetReadTO(value : Word);
begin
  if value <> fReadTO then
    begin
      fReadTO := value;
      Initialize_DCB;
    end;
end;

procedure TSerialPort.SetWriteTO(value : Word);
begin
  if value <> fWriteTO then
    begin
      fWriteTO := value;
      Initialize_DCB;
    end;
end;

// Create method.
constructor TSerialPort.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  // Initalize the handle to the port as
  // an invalid handle value.  We do this
  // because the port hasn't been opened
  // yet, and it allows us to test for
  // this condition in some functions,
  // thereby controlling the behavior
  // of the function.

  hCommPort := INVALID_HANDLE_VALUE;

  // Set initial settings.  Even though
  // the default parameter was specified
  // in the property, if you were to
  // create a component at runtime, the
  // defaults would not get set.  So it
  // is important to call them again in
  // the create of the component.
  fCommPort := dflt_CommPort;
  fBaudRate := dflt_BaudRate;
  fParityType := dflt_ParityType;
  fStopBits := dflt_StopBits;
  fDataBits := dflt_DataBits;
  fXONChar := dflt_XONChar;
  fXOFFChar := dflt_XOFFChar;
  fXONLim := dflt_XONLim;
  fXOFFLim := dflt_XOFFLim;
  fErrorChar := dflt_ErrorChar;
  fFlowControl := dflt_FlowControl;
  fReadTO := dflt_ReadTO;
  fWriteTO := dflt_WriteTO;
  fOnTransmit := nil;
  fOnReceive := nil;
  LastErr := 0;
  RecThread := TRecThread.Create(Self);
  ThreadIsRunning := True;
  RecThread.OnTerminate := ThreadDone;
end;

// Destroy method.
destructor TSerialPort.Destroy;
var DestroyCtr : Integer;
begin
  // Close the port first;
  ClosePort;
  RecThread.Terminate;
  DestroyCtr := 0;
  while (DestroyCtr < 5) and (ThreadIsRunning) do
    begin
      Sleep(d100p);
      Inc(DestroyCtr);
    end;
  RecThread.Destroy;
  Sleep(d100p);
  inherited Destroy;
end;

// Public function to check if the port is open.
function TSerialPort.PortIsOpen : boolean;
begin
  Result := hCommPort <> INVALID_HANDLE_VALUE;
end;
// Public method to open the port and
// assign the handle to it.
function TSerialPort.OpenPort(MyCommPort :
              TCommPort) : Boolean;
var
  MyPort : PChar;
begin
  // Make sure that the port is Closed first.
  ClosePort;

  MyPort := PChar('COM' + 
            IntToStr(ord(MyCommPort)+1));
  hCommPort := CreateFile(MyPort,
            GENERIC_READ OR GENERIC_WRITE,
            0,
            nil,
            OPEN_EXISTING,
            0,0);
  // Initialize the port.
  Initialize_DCB;
  // Was successful if not and invalid handle.
  result := hCommPort <> INVALID_HANDLE_VALUE;
end;

// Public method to Close the port.
function TSerialPort.ClosePort : boolean;
begin
  FlushTX;
  FlushRX;
  // Close the handle to the port.
  result := CloseHandle(hCommPort);
  hCommPort := INVALID_HANDLE_VALUE;
end;

// Public method to cancel and
// flush the receive buffer.
procedure TSerialPort.FlushRx;
begin
  if hCommPort = INVALID_HANDLE_VALUE then
    begin
      LastErr := 999;
      Exit;
    end;
  PurgeComm(hCommPort,
         PURGE_RXABORT or PURGE_RXCLEAR);
  ReadBuffer := '';
end;

// Public method to cancel and flush the transmit buffer.
procedure TSerialPort.FlushTx;
begin
  if hCommPort = INVALID_HANDLE_VALUE then exit;
  PurgeComm(hCommPort,
       PURGE_TXABORT or PURGE_TXCLEAR);
end;
// Initialize the device control block.
procedure TSerialPort.Initialize_DCB;
var
  MyDCB : TDCB;
  MyCommTimeouts : TCommTimeouts;
begin
  LastErr := 0;
  // Only want to perform the setup
  // if the port has been opened and
  // the handle assigned.
  if hCommPort = INVALID_HANDLE_VALUE then
    begin
      LastErr := 999;
      exit;
    end;
  // The GetCommState function fills in a
  // device-control block (a DCB structure)
  // with the current control settings for
  // a specified communications device.
  // (Win32 Developers Reference)
  // Get a default fill of the DCB.
  GetCommState(hCommPort, MyDCB);

  case fBaudRate of
    br110 : MyDCB.BaudRate := 110;
    br300 : MyDCB.BaudRate := 300;
    br600 : MyDCB.BaudRate := 600;
    br1200 : MyDCB.BaudRate := 1200;
    br2400 : MyDCB.BaudRate := 2400;
    br4800 : MyDCB.BaudRate := 4800;
    br9600 : MyDCB.BaudRate := 9600;
    br14400 : MyDCB.BaudRate := 14400;
    br19200 : MyDCB.BaudRate := 19200;
    br38400 : MyDCB.BaudRate := 38400;
    br56000 : MyDCB.BaudRate := 56000;
    br115200 : MyDCB.BaudRate := 115200;
    br128000 : MyDCB.BaudRate := 128000;
    br256000 : MyDCB.BaudRate := 256000;
  end;

  // Parity error checking parameters.
  case fParityType of
    pcNone : MyDCB.Parity := NOPARITY;
    pcEven : MyDCB.Parity := EVENPARITY;
    pcOdd : MyDCB.Parity := ODDPARITY;
    pcMark : MyDCB.Parity := MARKPARITY;
    pcSpace : MyDCB.Parity := SPACEPARITY;
  end;
  if fParityErrorChecking then 
       inc(MyDCB.Flags, $0002);
  if fParityErrorReplacement then 
       inc(MyDCB.Flags, $0021);
  MyDCB.ErrorChar := char(fErrorChar);

  case fStopBits of
    sbOne : MyDCB.StopBits := ONESTOPBIT;
    sbOnePtFive : MyDCB.StopBits := ONE5STOPBITS;
    sbTwo : MyDCB.StopBits := TWOSTOPBITS;
  end;

  case fDataBits of
    db4 : MyDCB.ByteSize := 4;
    db5 : MyDCB.ByteSize := 5;
    db6 : MyDCB.ByteSize := 6;
    db7 : MyDCB.ByteSize := 7;
    db8 : MyDCB.ByteSize := 8;
  end;

  // The 'flags' are bit flags,
  // which means that the flags
  // either turn on or off the
  // desired flow control type.
  case fFlowControl of
    fcXON_XOFF : MyDCB.Flags :=
        MyDCB.Flags or $0020 or $0018;
    fcRTS_CTS : MyDCB.Flags :=
        MyDCB.Flags or $0004 or
        $0024*RTS_CONTROL_HANDSHAKE;
    fsDSR_DTR : MyDCB.Flags :=
        MyDCB.Flags or $0008 or 
        $0010*DTR_CONTROL_HANDSHAKE;
  end;

  if fStripNullChars then inc(MyDCB.Flags,$0022);

  MyDCB.XONChar := Char(fXONChar);
  MyDCB.XOFFChar := Char(fXONChar);

  // The XON Limit is the number of
  // bytes that the data in the
  // receive buffer must fall below
  // before sending the XON character,
  // there for resuming the flow
  // of data.
  MyDCB.XONLim := fXONLim;
  // The XOFF limit is the max number
  // of bytes that the receive buffer
  // can contain before sending the
  // XOFF character, therefore
  // stopping the flow of data.
  MyDCB.XOFFLim := fXOFFLim;

  // Character that signals the end of file.
  if fEOFChar <> 0 then MyDCB.EOFChar := char(EOFChar);

  // The SetCommTimeouts function sets
  // the time-out parameters for all
  // read and write operations on a
  // specified communications device.
  // (Win32 Developers Reference)
  // The GetCommTimeouts function retrieves
  // the time-out parameters for all read
  // and write operations on a specified
  // communications device.
  GetCommTimeouts(hCommPort, MyCommTimeouts);
  //For each read, time out after fReadTO msec regardles how many chars
  MycommTimeouts.ReadIntervalTimeout := 0;
  MycommTimeouts.ReadTotalTimeoutMultiplier := 500;
  MycommTimeouts.ReadTotalTimeoutConstant := fReadTO;
  //For each write, time out after fWriteTO regardless of size
  MycommTimeouts.WriteTotalTimeoutMultiplier := 0; // andere Werte als 0 gehen nicht!!!
  MycommTimeouts.WriteTotalTimeoutConstant := fWriteTO;
  if Not SetCommTimeouts(hCommPort, MyCommTimeouts) then
    LastErr := GetLastError;
  if Not SetCommState(hCommPort, MyDCB) then
    LastErr := GetLastError;
end;
// Public Send data method.
procedure TSerialPort.SendData(data : PChar;
           size : DWord);
var
  NumBytesWritten : DWord;
begin
  LastErr := 0;
  if hCommPort = INVALID_HANDLE_VALUE then
    begin
      LastErr := 999;
      exit;
    end;
  if assigned(fOnTransmit) then
        fONTransmit(self, Data);
  if not WriteFile(hCommPort,
            Data^,
            Size,
            NumBytesWritten,
            nil) then
    LastErr := GetLastError;
  // Fire the transmit event.
  if assigned(fAfterTransmit) then
        fAfterTransmit(self, Data);
end;

// Public Get data method.
function TSerialPort.GetData : String;
begin
  if assigned(fOnReceive) then
         fONReceive(self, ReadBuffer);
  if assigned(fAfterReceive) then
         fAfterReceive(self, ReadBuffer);
  result := ReadBuffer;
  ReadBuffer := '';
end;

procedure TSerialPort.ThreadDone(Sender: TObject);
begin
  ThreadIsRunning := False;
end;

procedure TRecThread.DoReceiving;
begin
  Owner.GetData;
end;

procedure TRecThread.Execute;
var TempBuf : String;
  NumBytesRead : DWord;
  BytesInQueue : LongInt;
  oStatus: TComStat;
  dwErrorCode: DWord;
  BytesReceived : Boolean;
begin
  BytesReceived := False;
  while not Terminated do
    begin
      Sleep(d100p); //My comment
      if owner.hCommPort <> INVALID_HANDLE_VALUE then
        begin
          ClearCommError(owner.hCommPort, dwErrorCode, @oStatus);
            BytesInQueue := oStatus.cbInQue;
          if BytesInQueue > 0 then
            begin
              SetLength(TempBuf, 4096);
              ReadFile(owner.hCommPort,
                     PChar(TempBuf)^,
                     BytesInQueue,
                     NumBytesRead,
                     nil);
              SetLength(TempBuf, NumBytesRead);
              owner.ReadBuffer := owner.ReadBuffer + TempBuf;
              BytesReceived := True;
            end
          else
            begin
              if BytesReceived then
                Synchronize(DoReceiving);
              BytesReceived := False;
            end;
        end;
    end;
  // Signal to the Owner that the Execute Loop has finishd 02-Feb-2000
  Owner.ThreadIsRunning := False;  
end;

constructor TRecThread.Create(AOwner : TSerialPort);
begin
  Owner := AOwner;
  inherited Create(False);
end;

end.
