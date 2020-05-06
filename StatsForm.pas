unit StatsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TfStat = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lStat11: TLabel;
    lStat21: TLabel;
    lStat31: TLabel;
    lStat41: TLabel;
    lStat51: TLabel;
    lStat12: TLabel;
    lStat22: TLabel;
    lStat32: TLabel;
    lStat42: TLabel;
    lStat52: TLabel;
    lStat13: TLabel;
    lStat23: TLabel;
    lStat33: TLabel;
    lStat43: TLabel;
    lStat53: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Bevel1: TBevel;
    lStat10: TLabel;
    lStat20: TLabel;
    lStat30: TLabel;
    lStat40: TLabel;
    lStat50: TLabel;
    Label11: TLabel;
    Timer1: TTimer;
    Bevel2: TBevel;
    lPropose: TLabel;
    gb13: TGroupBox;
    gb23: TGroupBox;
    gb33: TGroupBox;
    gb12: TGroupBox;
    gb22: TGroupBox;
    gb32: TGroupBox;
    gb11: TGroupBox;
    gb21: TGroupBox;
    gb31: TGroupBox;
    color13: TShape;
    color23: TShape;
    color33: TShape;
    color12: TShape;
    color22: TShape;
    color32: TShape;
    color11: TShape;
    color21: TShape;
    color31: TShape;
    l13: TLabel;
    l23: TLabel;
    l33: TLabel;
    l12: TLabel;
    l22: TLabel;
    l32: TLabel;
    l11: TLabel;
    l21: TLabel;
    l31: TLabel;
    cbRefresh: TCheckBox;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fStat: TfStat;

implementation

uses MainForm;

{$R *.dfm}

procedure TfStat.Timer1Timer(Sender: TObject);
var
  i, j: byte;
  t: Int64;
  id, tmp: string;
begin
  for i := 1 to 5 do
    begin
      t := 0;
      for j := 1 to 3 do
        t := t + CurHandStat[i][j];
      for j := 0 to 3 do
        begin
          id := IntToStr(i * 10 + j);
          if (j > 0) and (t > 0) and (CurHandStat[i][j] > 0) then
            tmp := FloatToStrF(CurHandStat[i][j] * 100.0 / t, ffGeneral, 3, 1) + '%'
          else if (CurHandStat[i][j] > 0) then
            tmp := IntToStr(CurHandStat[i][j])
          else
            tmp := '-';
          (FindComponent('lStat' + id) as TLabel).Caption := tmp
        end
    end;
  if cbRefresh.Checked then
    if Thinking then
      for i := 1 to 3 do
        for j := 1 to 3 do
          begin
            id := IntToStr(i * 10 + j);
            if CurGameStat.Field_Cell[i, j].Card.Used then
              begin
                if CurGameStat.Field_Cell[i, j].Card.Our then
                  (FindComponent('color' + id) as TShape).Brush.Color := clPlayer
                else
                  (FindComponent('color' + id) as TShape).Brush.Color := clOpponent;
                (FindComponent('l' + id) as TLabel).Caption := StringReplace(CurGameStat.Field_Cell[i, j].Card.ID, '&', '&&', [])
              end
            else
              begin
                (FindComponent('color' + id) as TShape).Brush.Color := clBtnFace;
                (FindComponent('l' + id) as TLabel).Caption := ''
              end
          end
    else
      for i := 1 to 3 do
        for j := 1 to 3 do
          begin
            id := IntToStr(i * 10 + j);
            if id = MoveToID then
              begin
                (FindComponent('color' + id) as TShape).Brush.Color := clPlayer;
                (FindComponent('l' + id) as TLabel).Caption := StringReplace(MoveToCardID, '&', '&&', [])
              end
            else
              begin
                (FindComponent('color' + id) as TShape).Brush.Color := clBtnFace;
                (FindComponent('l' + id) as TLabel).Caption := ''
              end
          end;
  lPropose.Caption := ProposeStr
end;

procedure TfStat.FormCreate(Sender: TObject);
begin
  Left := (Screen.Width + fMain.Width - Width) div 2;
  Top := (Screen.Height - Height) div 2
end;

procedure TfStat.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False
end;

procedure TfStat.FormHide(Sender: TObject);
begin
  Timer1.Enabled := False
end;

procedure TfStat.FormShow(Sender: TObject);
begin
  Timer1.Enabled := True
end;

end.
