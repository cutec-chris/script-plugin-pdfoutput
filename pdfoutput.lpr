library pdfoutput;

{$mode objfpc}{$H+}

uses
  Classes,SysUtils,
  fpPDF
  { you can add units after this };

var
  aDoc : TPDFDocument;
  aPage: TPDFPage;

function PDFCreatePage(Width,Height : Integer) : Boolean;stdcall;
var
  Paper : TPDFPaper;
begin
  if not Assigned(aDoc) then aDoc := TPDFDocument.Create(nil);
  aPage := aDoc.Pages.AddPage;
  Paper.H:=Height;
  Paper.W:=Width;
  aPage.Paper := Paper;
  Result := True;
end;
function PDFAddFont(aName : PChar) : Integer;stdcall;
begin
  try
    Result := aDoc.AddFont(aName,ExtractFileName(aName));
  except
    Result := -1;
  end;
end;
function PDFSetFont(FontIndex,FontSize : Integer) : Boolean;stdcall;
begin
  aPage.SetFont(FontIndex,FontSize);
  Result := True;
end;
function PDFSetColor(Color : Integer) : Boolean;stdcall;
begin
  aPage.SetColor(Color);
  Result := True;
end;
function PDFWriteText(x,y : double;Text : PChar) : Boolean;stdcall;
begin
  aPage.WriteText(x,y,Text,0,false,false);
  Result := True;
end;
function PDFSave(Filename : PChar) : Boolean;stdcall;
begin
  try
    aDoc.SaveToFile(Filename);
    Result := True;
  except
    Result := False;
  end;
end;
procedure ScriptCleanup;
begin
  FreeAndNil(aDoc);
end;
function ScriptDefinition : PChar;stdcall;
begin
  Result := 'function PDFCreatePage(Width,Height : Integer) : Boolean;stdcall;'
       +#10+'function PDFAddFont(aName : PChar) : Integer;stdcall;'
       +#10+'function PDFSetFont(FontIndex,FontSize : Integer) : Boolean;stdcall;'
       +#10+'function PDFSetColor(Color : Integer) : Boolean;stdcall;'
       +#10+'function PDFWriteText(x,y : double;Text : PChar) : Boolean;stdcall;'
       +#10+'function PDFSave(Filename : PChar) : Boolean;stdcall;'
            ;
end;

exports
  PDFCreatePage,
  PDFAddFont,
  PDFSave,
  PDFSetColor,
  PDFSetFont,
  PDFWriteText,

  ScriptCleanup,
  ScriptDefinition;

initialization
  aDoc := nil;
end.

