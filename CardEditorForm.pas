unit CardEditorForm;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfCardEditor = class(TForm)
    pName: TEdit;
    bAddCard: TButton;
    pElement: TComboBox;
    pRight: TEdit;
    pUp: TEdit;
    pLeft: TEdit;
    pDown: TEdit;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure bAddCardClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCardEditor: TfCardEditor;

implementation
{$R *.lfm}
uses
  INIFiles;

var
  myini: TINIFile;

procedure TfCardEditor.FormShow(Sender: TObject);
begin
  myini := TINIFile.Create(ExtractFilePath(Application.ExeName) + 'Cards.ini');
  pLeft.SetFocus
end;

procedure TfCardEditor.FormHide(Sender: TObject);
begin
  myini.Free
end;

procedure TfCardEditor.bAddCardClick(Sender: TObject);
begin
  myini.WriteString(pName.Text, 'Left', pLeft.Text);
  myini.WriteString(pName.Text, 'Up', pUp.Text);
  myini.WriteString(pName.Text, 'Right', pRight.Text);
  myini.WriteString(pName.Text, 'Down', pDown.Text);
  myini.WriteInteger(pName.Text, 'Element', pElement.ItemIndex + 1)
end;

end.
