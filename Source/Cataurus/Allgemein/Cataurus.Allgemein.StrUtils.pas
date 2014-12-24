unit Cataurus.Allgemein.StrUtils;

interface

  //entfernt geschweifte Klammer am Anfang und Ende eines String solange wie
  //welche gefunden werden
  function StringClearFromGeschweiftenKlammern(Source : string) : string;
  // entfernt alle Leerzeichen aus einem string
  function StrClearFromAllSpaces(Source : string) : string;



implementation

  function StringClearFromGeschweiftenKlammern(Source : string) : string;
  begin
    result := '';
    while Pos('{', Source) > 0 do
    begin
      Delete(Source, 1, 1);
    end;
    while Pos('}', Source, Length(Source)) > 0 do
    begin
      Delete(Source, Length(Source), 1);
    end;
    result := Source;
  end;

function StrClearFromAllSpaces(Source : string) : string;
var
  _Name : string;
begin
  _Name := Source;
  while Pos(' ', _Name) > 0 do
  begin
    Delete(_Name, Pos(' ', _Name), 1);
  end;
  result := _Name;
end;

end.
