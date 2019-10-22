library pdfoutput;

{$mode objfpc}{$H+}

uses
  Classes,SysUtils,
  fpPDF
  { you can add units after this };

var
  aDoc : TPDFDocument;
  aPage: TPDFPage;
  aSection: TPDFSection;

function PDFCreatePage(Width,Height : Integer) : Boolean;stdcall;
var
  Paper : TPDFPaper;
begin
  if not Assigned(aDoc) then
    begin
      aDoc := TPDFDocument.Create(nil);
      aDoc.StartDocument;
      aSection := aDoc.Sections.AddSection
    end;
  aPage := aDoc.Pages.AddPage;
  aPage.UnitOfMeasure := uomMillimeters;
  //aPage.PaperType:=ptA4;
  Paper.H:=round(mmToPDF(Height));
  Paper.W:=round(mmToPDF(Width));
  aPage.Paper := Paper;
  aSection.AddPage(aPage);
  Result := True;
end;
function PDFAddFont(aName : PChar) : Integer;stdcall;
begin
  try
    if (pos('.ttf',lowercase(aName))>0) or (pos('.otf',lowercase(aName))>0) then
      Result := aDoc.AddFont(aName,ExtractFileName(aName))
    else
      Result := aDoc.AddFont(aName);
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
  try
    aPage.WriteText(x,y,Text,0,false,false);
    Result := True;
  except
    Result := False;
  end;
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

