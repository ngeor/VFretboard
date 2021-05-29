{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit VFretboardComp;

{$warn 5023 off : no warning about unused units}
interface

uses
  Fretboard, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('Fretboard', @Fretboard.Register);
end;

initialization
  RegisterPackage('VFretboardComp', @Register);
end.
