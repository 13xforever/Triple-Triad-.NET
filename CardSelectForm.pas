unit CardSelectForm;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfSelectCard = class(TForm)
    pCardName: TComboBox;
    bOK: TButton;
    lLeft: TLabel;
    lup: TLabel;
    lRight: TLabel;
    lDown: TLabel;
    lElement: TLabel;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure pCardNameChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure pCardNameKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSelectCard: TfSelectCard;

implementation
{$R *.lfm}
uses
  INIFiles, MainForm;

var
  myini: TINIFile;

procedure TfSelectCard.FormShow(Sender: TObject);
begin
  pCardName.ItemIndex := -1;
  pCardName.SetFocus;
  lLeft.Caption := '';
  lUp.Caption := '';
  lRight.Caption := '';
  lDown.Caption := '';
  lElement.Caption := '';
  bOK.Enabled := False;
  myini := TINIFile.Create(ExtractFilePath(Application.ExeName) + 'Cards.ini');
  myini.ReadSections(pCardName.Items)
end;

procedure TfSelectCard.bOKClick(Sender: TObject);
begin
  myini.Free;
  Close
end;

procedure TfSelectCard.pCardNameChange(Sender: TObject);
var
  el: TElement;
begin
  lLeft.Caption := myini.ReadString(pCardName.Text, 'Left', '');
  lUp.Caption := myini.ReadString(pCardName.Text, 'Up', '');
  lRight.Caption := myini.ReadString(pCardName.Text, 'Right', '');
  lDown.Caption := myini.ReadString(pCardName.Text, 'Down', '');
  el := ToElement[myini.ReadInteger(pCardName.Text, 'Element', 0)];
  lElement.Caption := el.Text;
  lElement.Font.Color := el.Color;
  bOK.Enabled := True
end;

procedure TfSelectCard.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if bOK.Enabled then
    CanClose := True
  else
    CanClose := False
end;

procedure TfSelectCard.pCardNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    begin
      Key := #0;
      if bOK.Enabled then
        bOKClick(Self)
    end
end;

end.
