program VFretboard;

{$MODE Delphi}

uses
  Forms,
  Interfaces,
  MainForm in 'MainForm.pas' {Form1},
  Fretboard;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
