﻿unit BearURQ.Utils;

interface

type
  TSplitResult = array of string;

type
  TKeyAndValue = record
    Key, Value: string;
  end;

function StrLeft(S: string; I: Integer): string;
function StrRight(S: string; I: Integer): string;
function GetINIKey(S, Key: string): string;
function GetINIValue(S, Key: string; Default: string = ''): string;

implementation

// Копия строки слева
function StrLeft(S: string; I: Integer): string;
begin
  Result := Copy(S, 1, I);
end;

// Копия строки справа
function StrRight(S: string; I: Integer): string;
var
  L: Integer;
begin
  L := Length(S);
  Result := Copy(S, L - I + 1, L);
end;

// Ключ
function GetINIKey(S, Key: string): string;
var
  P: Integer;
begin
  P := Pos(Key, S);
  if (P <= 0) then
  begin
    Result := S;
    Exit;
  end;
  Result := StrLeft(S, P - 1);
end;

// Значение ключа
function GetINIValue(S, Key: string; Default: string = ''): string;
var
  L, P, K: Integer;
begin
  P := Pos(Key, S);
  if (P <= 0) then
  begin
    Result := Default;
    Exit;
  end;
  L := Length(S);
  K := Length(Key);
  Result := StrRight(S, L - P - K + 1);
end;

end.
