unit Fretboard;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs;

type
  TNote = (C, CSharp, D, DSharp, E, F, FSharp, G, GSharp, A, ASharp, B);
  TNotesArray = array of TNote;
  TTone = 1..12;
  TTonesArray = array of TTone;
  TKnownScale = (ksMajor, ksMinor, ksPentatonic);
  TNotesSet = set of TNote;

const
  nsChromatic = [C, CSharp, D, DSharp, E, F, FSharp, G, GSharp, A, ASharp, B];

// component
type
  TFretboard = class(TGraphicControl)
  private
    FFilter: TNotesSet;
    FFretCount: Integer;
    FFirstFret: Integer;
    procedure SetFilter(Value: TNotesSet);
    procedure SetFretCount(Value: Integer);
    procedure SetFirstFret(Value: Integer);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    function FormScale(Key: TNote; tones: array of TTone): TNotesArray; overload;
    function GetNoteName(Note: TNote): String;
    function GetKnownScale(ks: TKnownScale): TTonesArray;
    class function CreateTonesArray(ta: array of Integer): TTonesArray;
  published
    property Anchors;
    property Filter: TNotesSet read FFilter write SetFilter default nsChromatic;
    property FretCount: Integer read FFretCount write SetFretCount default 12;
    property FirstFret: Integer read FFirstFret write SetFirstFret;
  end;

procedure Register;
function IntToNote(i: Integer): TNote;
function FormScaleSet(Key: TNote; tones: TTonesArray): TNotesSet;


implementation

uses Types;

const
  T = 2;
  H = 1;
  noteNames: array [TNote] of String = ('C', 'C#/Db', 'D', 'D#/Eb', 'E', 'F',
    'F#/Gb', 'G', 'G#/Ab', 'A', 'A#/Bb', 'B');

var
  ksTones: array [TKnownScale] of TTonesArray;

function IntToNote(i: Integer): TNote;
begin
  FillChar(Result, 1, i mod 12);
end;

procedure Register;
begin
  RegisterComponents('Custom', [TFretboard]);
end;

procedure TFretboard.Paint;
const
  chordKey: array [1..6] of TNote = (E, B, G, D, A, E);
var
  x, y: Integer;
  fretWidth, fretHeight: Integer;
  note: TNote;
  rect: TRect;
  txtRect: TRect;
  sz: TSize;
begin
  fretHeight := Height div 6;
  fretWidth := Width div fretCount;
  Canvas.Pen.Width := 2;
  //Canvas.Pen.Style := psInsideFrame;
  Canvas.Brush.Color := clWhite;
  for y := 1 to 6 do
  begin
    note := IntToNote(Ord(chordKey[y]) + FFirstFret);
    rect.top := (y - 1) * fretHeight;
    rect.bottom := y * fretHeight;
    for x := 1 to fretCount do
    begin
      rect.left := (x - 1) * fretWidth;
      rect.right := x * fretWidth;
      Canvas.Rectangle(rect);
      if note in FFilter then
      begin
        sz := Canvas.TextExtent(notenames[note]);
        txtRect.left := (rect.right + rect.left - sz.cx) div 2;
        txtRect.top := (rect.bottom + rect.top - sz.cy) div 2;
        txtRect.right := txtRect.left + sz.cx;
        txtRect.bottom := txtRect.top + sz.cy;
        Canvas.TextRect(txtRect, txtRect.left, txtRect.top, notenames[note]);
      end;
      note := IntToNote(Ord(Note) + 1);
    end;
  end;
end;

function TFretboard.FormScale(Key: TNote; tones: array of TTone): TNotesArray;
var
  i: Integer;
begin
  SetLength(Result, Length(tones) + 1);
  Result[0] := Key;
  for i := 1 to Length(Result) - 1 do
    Result[i] := IntToNote(Ord(Result[i - 1]) + tones[i - 1]);
end;

function FormScaleSet(Key: TNote; tones: TTonesArray): TNotesSet;
var
  i: Integer;
  note: TNote;
begin
  Result := [Key];
  note := Key;
  for i := 0 to Length(tones) - 1 do
  begin
    note := IntToNote(Ord(note) + tones[i]);
    Result := Result + [note];
  end;
end;

function TFretboard.GetNoteName(Note: TNote): String;
begin
  Result := noteNames[Note];
end;

function TFretboard.GetKnownScale(ks: TKnownScale): TTonesArray;
begin
  Result := ksTones[ks];
end;

class function TFretboard.CreateTonesArray(ta: array of Integer): TTonesArray;
var
  i: Integer;
begin
  SetLength(Result, Length(ta));
  for i := 0 to Length(ta) - 1 do
    Result[i] := ta[i];
end;

procedure TFretboard.SetFilter(Value: TNotesSet);
begin
  FFilter := Value;
  Invalidate;
end;

procedure TFretboard.SetFretCount(Value: Integer);
begin
  if Value <> FFretCount then
  begin
    FFretCount := Value;
    Invalidate;
  end;
end;

procedure TFretboard.SetFirstFret(Value: Integer);
begin
  if Value <> FFirstFret then
  begin
    FFirstFret := Value;
    Invalidate;
  end;
end;

constructor TFretboard.Create(AOwner: TComponent);
begin
  inherited;
  FFilter := nsChromatic;
  FFretCount := 12;
end;

initialization
  ksTones[ksMajor] := TFretboard.CreateTonesArray([T, T, H, T, T, T, H]);
  ksTones[ksMinor] := TFretboard.CreateTonesArray([T, H, T, T, H, T, T]);
  ksTones[ksPentatonic] := TFretboard.CreateTonesArray([T + H, T, T, T + H, T]);

end.
