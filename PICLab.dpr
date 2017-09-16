program PICLab;

uses
  Forms,
  PICDebug in 'PICDebug.pas' {PICForm},
  Serial in 'Serial.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'PIC Debug';
  Application.CreateForm(TPICForm, PICForm);
  Application.Run;
end.
