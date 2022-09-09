unit MainForm;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Fretboard;

type
  TDynamicIntArray = array of Integer;

  TForm1 = class(TForm)
    cmbNotes: TComboBox;
    Label1: TLabel;
    cmbKey: TComboBox;
    txtScale: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Fretboard1: TFretboard;
    Fretboard2: TFretboard;
    procedure FormCreate(Sender: TObject);
    procedure cmbNotesChange(Sender: TObject);
  private
    function GetScale: String;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}




procedure TForm1.FormCreate(Sender: TObject);
var
  i: TNote;
begin
  for i := C to B do
    cmbNotes.Items.Add(Fretboard1.GetNoteName(i));
end;

procedure TForm1.cmbNotesChange(Sender: TObject);
begin
  txtScale.Text := GetScale;
end;



function TForm1.GetScale: String;
var
  i: Integer;
  notes: TNotesArray;
  key: TNote;
  tones: TTonesArray;
begin
  Result := '';
  key := IntToNote(cmbNotes.ItemIndex);
  if cmbNotes.ItemIndex <> -1 then
  begin
    case cmbKey.ItemIndex of
      0: tones := Fretboard1.GetKnownScale(ksMajor);
      1: tones := Fretboard1.GetKnownScale(ksMinor);
      2: tones := Fretboard1.GetKnownScale(ksPentatonic);
      else
        Exit;
    end;
    notes := Fretboard1.FormScale(key, tones);
    for i := 0 to Length(notes) - 2 do
      Result := Result + Fretboard1.GetNoteName(notes[i]) + ' - ';
    Result := Result + Fretboard1.GetNoteName(notes[Length(notes) - 1]);

    Fretboard2.Filter := FormScaleSet(key, tones);
  end;
end;


end.
