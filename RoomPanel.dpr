program RoomPanel;

uses
  Forms,
  loganalizer in 'loganalizer.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'eHouse Room Control Panel';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
