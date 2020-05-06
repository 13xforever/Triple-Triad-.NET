unit ElementSelectForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfSelectElement = class(TForm)
    pElement: TComboBox;
    bOK: TButton;
    procedure bOKClick(Sender: TObject);
    procedure pElementKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSelectElement: TfSelectElement;

implementation
{$R *.dfm}

procedure TfSelectElement.bOKClick(Sender: TObject);
begin
  Close
end;

procedure TfSelectElement.pElementKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    begin
      Key := #0;
      if bOK.Enabled then
        bOKClick(Self)
    end
end;

procedure TfSelectElement.FormShow(Sender: TObject);
begin
  pElement.ItemIndex := 0;
  pElement.SetFocus
end;

end.
