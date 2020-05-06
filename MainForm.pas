unit MainForm;

interface
{$DEFINE NEW}
{$DEFINE ALTCHECK}
{$DEFINE NOCHECK}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ThreadedSolver, SyncObjs;

const
  clOpponent = $00CAA6F0;
  clPlayer = clSkyBlue;

type
  TfMain = class(TForm)
    gCardBox1: TGroupBox;
    gCardBox2: TGroupBox;
    gCard1: TGroupBox;
    sCardColor1: TShape;
    lLeft1: TLabel;
    lUp1: TLabel;
    lRight1: TLabel;
    lDown1: TLabel;
    lElement1: TLabel;
    gCard2: TGroupBox;
    sCardColor2: TShape;
    lLeft2: TLabel;
    lUp2: TLabel;
    lRight2: TLabel;
    lDown2: TLabel;
    lElement2: TLabel;
    gCard3: TGroupBox;
    sCardColor3: TShape;
    lLeft3: TLabel;
    lUp3: TLabel;
    lRight3: TLabel;
    lDown3: TLabel;
    lElement3: TLabel;
    gCard4: TGroupBox;
    sCardColor4: TShape;
    lLeft4: TLabel;
    lUp4: TLabel;
    lRight4: TLabel;
    lDown4: TLabel;
    lElement4: TLabel;
    gCard5: TGroupBox;
    sCardColor5: TShape;
    lLeft5: TLabel;
    lUp5: TLabel;
    lRight5: TLabel;
    lDown5: TLabel;
    lElement5: TLabel;
    gCard10: TGroupBox;
    sCardColor10: TShape;
    lLeft10: TLabel;
    lUp10: TLabel;
    lRight10: TLabel;
    lDown10: TLabel;
    lElement10: TLabel;
    gCard9: TGroupBox;
    sCardColor9: TShape;
    lLeft9: TLabel;
    lUp9: TLabel;
    lRight9: TLabel;
    lDown9: TLabel;
    lElement9: TLabel;
    gCard8: TGroupBox;
    sCardColor8: TShape;
    lLeft8: TLabel;
    lUp8: TLabel;
    lRight8: TLabel;
    lDown8: TLabel;
    lElement8: TLabel;
    gCard7: TGroupBox;
    sCardColor7: TShape;
    lLeft7: TLabel;
    lUp7: TLabel;
    lRight7: TLabel;
    lDown7: TLabel;
    lElement7: TLabel;
    gCard6: TGroupBox;
    sCardColor6: TShape;
    lLeft6: TLabel;
    lUp6: TLabel;
    lRight6: TLabel;
    lDown6: TLabel;
    lElement6: TLabel;
    gFieldBox: TGroupBox;
    Field13: TGroupBox;
    Field23: TGroupBox;
    Field33: TGroupBox;
    Field12: TGroupBox;
    Field22: TGroupBox;
    Field32: TGroupBox;
    Field11: TGroupBox;
    Field21: TGroupBox;
    Field31: TGroupBox;
    gRules: TGroupBox;
    cElemental: TCheckBox;
    cSame: TCheckBox;
    cPlus: TCheckBox;
    cSameWall: TCheckBox;
    lScore1: TLabel;
    lScore2: TLabel;
    bMove1: TButton;
    bMove2: TButton;
    lElement13: TLabel;
    lElement23: TLabel;
    lElement33: TLabel;
    lElement12: TLabel;
    lElement22: TLabel;
    lElement32: TLabel;
    lElement11: TLabel;
    lElement21: TLabel;
    lElement31: TLabel;
    lEffect13: TLabel;
    lEffect23: TLabel;
    lEffect33: TLabel;
    lEffect12: TLabel;
    lEffect22: TLabel;
    lEffect32: TLabel;
    lEffect11: TLabel;
    lEffect21: TLabel;
    lEffect31: TLabel;
    bReset: TButton;
    bStatistics: TButton;
    cRandomize: TCheckBox;
    bCardEditor: TButton;
    cMT: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure FormDockDrop(Sender: TObject; Source: TDragDockObject; X, Y: Integer);
    procedure SelectCard(Sender: TObject);
    procedure bCardEditorClick(Sender: TObject);
    procedure SelectElement(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cSameWallClick(Sender: TObject);
    procedure cElementalClick(Sender: TObject);
    procedure MakeMove(var game: TGameInfo; const x, y: byte; var Score: TScore; var Stat: TStat; const combo: boolean = False);
    procedure RefreshField;
    procedure FindMove(const game: TGameInfo; const score: TScore; plh, oph: THandInfo; const plmove: boolean; var stat: TStat; const lvl: byte);
    procedure bMove1Click(Sender: TObject);
    procedure bMove2Click(Sender: TObject);
    procedure bStatisticsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cSameClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMain: TfMain;
  ProposeStr, MoveToID, MoveToCardID: String;
  Thinking: Boolean;
  CurHandStat: THandStat;
  CurGameStat: TGameInfo;
  WriteLock: TCriticalSection;

implementation

uses INIFiles, ShellAPI, CardEditorForm, CardSelectForm, ElementSelectForm, StatsForm;
{$R *.dfm}
{$R manifest.res}

const
  ToElement: array [0..8] of string[1] = ('', 'F', 'I', 'T', 'W', 'w', 'E', 'P', 'H');
  CellToWord: array [1..3, 1..3] of string = (('lower left corner', 'left middle cell', 'upper left corner'),
                                              ('bottom middle cell', 'center cell', 'top middle cell'),
                                              ('lower right corner', 'middle right cell', 'upper right corner'));

var
  OpponentHand, PlayerHand, LastHand: THandInfo;
  CurrentGame: TGameInfo;
  CurrentStat: TStat = (0, 0, 0, 0);
  Score: TScore = (5, 5);
  ToInt: array ['1'..'A'] of byte;
  FirstPass: Boolean = true;

procedure TfMain.FormCreate(Sender: TObject);
var
  myini: TINIFile;
  i, j, k: byte;
  id, tmp: string;
  tmp2: TStrings;
begin
  Randomize;
  WriteLock := TCriticalSection.Create;
  Thinking := false;
  for i := 1 to 9 do
    ToInt[Chr(Ord('0') + i)] := i;
  ToInt['A'] := 10;
  for j := 0 to 4 do
    begin
      CurrentGame.Field_Cell[j, 0].Card.Up := 'A';
      CurrentGame.Field_Cell[j, 4].Card.Down := 'A';
      CurrentGame.Field_Cell[0, j].Card.Right := 'A';
      CurrentGame.Field_Cell[4, j].Card.Left := 'A'
    end;
{$IFDEF NEW}
  gRules.Enabled := True;
  for i := 1 to 3 do
    for j := 1 to 3 do
      begin
        id := IntToStr(i) + IntToStr(j);
        with CurrentGame.Field_Cell[i, j] do
          begin
            if cRandomize.Checked and cElemental.Checked and (Random > 0.66) then
              Element := ToElement[Random(fSelectElement.pElement.Items.Count)]
            else
              Element := '';
            CardID := '';
            Card.Used := False
          end;
        (FindComponent('lElement' + id) as TLabel).Caption := CurrentGame.Field_Cell[i, j].Element;
        (FindComponent('Field' + id) as TGroupBox).Enabled := True
      end;

  for j := 1 to 10 do
    begin
      id := IntToStr(j);
      with (FindComponent('gCard' + id) as TGroupBox) do
        begin
          Caption := '';
          DragMode := dmManual;
          if j < 6 then
            ManualDock(gCardBox1)
          else
            ManualDock(gCardBox2);
          Top := 16 + ((j - 1) mod 5) * (Height + 8);
          Left := 8;
        end;
      (FindComponent('lLeft' + id) as TLabel).Caption := '';
      (FindComponent('lUp' + id) as TLabel).Caption := '';
      (FindComponent('lRight' + id) as TLabel).Caption := '';
      (FindComponent('lDown' + id) as TLabel).Caption := '';
      (FindComponent('lElement' + id) as TLabel).Caption := '';
      if j < 6 then
        (FindComponent('sCardColor' + id) as TShape).Brush.Color := clOpponent
      else
        (FindComponent('sCardColor' + id) as TShape).Brush.Color := clPlayer
    end;
    Score[True] := 5;
    Score[False] := 5;
    for j := 1 to 5 do
      begin
        OpponentHand[j].Used := False;
        PlayerHand[j].Used := False
      end;

  if cRandomize.Checked then
    begin
      tmp2 := TStringList.Create;
      myini := TINIFile.Create(ExtractFilePath(Application.ExeName) + 'Cards.ini');
      myini.ReadSections(tmp2);
      for i := 1 to 10 do
        begin
          id := IntToStr(i);
          k := Random(tmp2.Count);
          tmp := tmp2[k];
          with (FindComponent('gCard' + id) as TGroupBox) do
            begin
              Caption := StringReplace(tmp, '&', '&&', []);
              DragMode := dmAutomatic
            end;
          (FindComponent('lLeft' + id) as TLabel).Caption := myini.ReadString(tmp, 'Left', '');
          (FindComponent('lUp' + id) as TLabel).Caption := myini.ReadString(tmp, 'Up', '');
          (FindComponent('lRight' + id) as TLabel).Caption := myini.ReadString(tmp, 'Right', '');
          (FindComponent('lDown' + id) as TLabel).Caption := myini.ReadString(tmp, 'Down', '');
          (FindComponent('lElement' + id) as TLabel).Caption := ToElement[myini.ReadInteger(tmp, 'Element', 0)];
          if i > 5 then
            begin
              with PlayerHand[i - 5] do
                begin
                  ID := tmp;
                  Used := False;
                  Our := True;
                  Bonus := 0;
                  Left := myini.ReadString(tmp, 'Left', '');
                  Up := myini.ReadString(tmp, 'Up', '');
                  Right := myini.ReadString(tmp, 'Right', '');
                  Down := myini.ReadString(tmp, 'Down', '');
                  Element := ToElement[myini.ReadInteger(tmp, 'Element', 0)]
                end;
              LastHand[i - 5] := PlayerHand[i - 5];
            end
          else
            with OpponentHand[i] do
              begin
                ID := tmp;
                Used := False;
                Our := False;
                Bonus := 0;
                Left := myini.ReadString(tmp, 'Left', '');
                Up := myini.ReadString(tmp, 'Up', '');
                Right := myini.ReadString(tmp, 'Right', '');
                Down := myini.ReadString(tmp, 'Down', '');
                Element := ToElement[myini.ReadInteger(tmp, 'Element', 0)]
              end
        end;
        tmp2.Free;
        myini.Free
    end
  else if not FirstPass then
    for i := 1 to 5 do
      begin
          id := IntToStr(i + 5);
          with (FindComponent('gCard' + id) as TGroupBox) do
            begin
              Caption := StringReplace(LastHand[i].ID, '&', '&&', []);
              DragMode := dmAutomatic
            end;
          (FindComponent('lLeft' + id) as TLabel).Caption := LastHand[i].Left;
          (FindComponent('lUp' + id) as TLabel).Caption := LastHand[i].Up;
          (FindComponent('lRight' + id) as TLabel).Caption := LastHand[i].Right;
          (FindComponent('lDown' + id) as TLabel).Caption := LastHand[i].Down;
          (FindComponent('lElement' + id) as TLabel).Caption := LastHand[i].Element;
      end;
  if FirstPass then
    begin
      cRandomize.Checked := false;
      FirstPass := false
    end;
  bMove1.Enabled := true;
  bMove2.Enabled := true;
  CurrentGame.Cells_Used := 0;
  RefreshField
{$ENDIF}
end;

procedure TfMain.bCardEditorClick(Sender: TObject);
begin
  fCardEditor.ShowModal
end;


procedure TfMain.cSameClick(Sender: TObject);
begin
  if not cSame.Checked then
    cSameWall.Checked := False;
end;

procedure TfMain.cSameWallClick(Sender: TObject);
var
  j: byte;
begin
  //Move w/ or w/o Same Wall Rule
  if (cSameWall.Checked) then
    cSame.Checked := True;
  for j := 1 to 3 do
    begin
      CurrentGame.Field_Cell[j, 0].Card.Used := cSameWall.Checked;
      CurrentGame.Field_Cell[j, 4].Card.Used := cSameWall.Checked;
      CurrentGame.Field_Cell[0, j].Card.Used := cSameWall.Checked;
      CurrentGame.Field_Cell[4, j].Card.Used := cSameWall.Checked
    end
end;

procedure TfMain.cElementalClick(Sender: TObject);
begin
  RefreshField
end;

procedure TfMain.SelectCard(Sender: TObject);
var
  myini: TINIFile;
  id, tmp: string;
  i: byte;
begin
  fSelectCard.Left := Mouse.CursorPos.X;
  fSelectCard.Top := Mouse.CursorPos.Y;
  fSelectCard.ShowModal;
  myini := TINIFile.Create(ExtractFilePath(Application.ExeName) + 'Cards.ini');

  id := IntToStr((Sender as TLabel).Tag);
  tmp := fSelectCard.pCardName.Text;
  with (FindComponent('gCard' + id) as TGroupBox) do
    begin
      Caption := StringReplace(tmp, '&', '&&', []);
      DragMode := dmAutomatic
    end;
  (FindComponent('lLeft' + id) as TLabel).Caption := myini.ReadString(tmp, 'Left', '');
  (FindComponent('lUp' + id) as TLabel).Caption := myini.ReadString(tmp, 'Up', '');
  (FindComponent('lRight' + id) as TLabel).Caption := myini.ReadString(tmp, 'Right', '');
  (FindComponent('lDown' + id) as TLabel).Caption := myini.ReadString(tmp, 'Down', '');
  (FindComponent('lElement' + id) as TLabel).Caption := ToElement[myini.ReadInteger(tmp, 'Element', 0)];

  if (Sender as TLabel).Tag > 5 then
    begin
      i := (Sender as TLabel).Tag - 5;
      with PlayerHand[i] do
        begin
          ID := tmp;
          Used := False;
          Our := True;
          Bonus := 0;
          Left := myini.ReadString(tmp, 'Left', '');
          Up := myini.ReadString(tmp, 'Up', '');
          Right := myini.ReadString(tmp, 'Right', '');
          Down := myini.ReadString(tmp, 'Down', '');
          Element := ToElement[myini.ReadInteger(tmp, 'Element', 0)]
        end;
      LastHand[i] := PlayerHand[i]
    end
  else
    with OpponentHand[(Sender as TLabel).Tag] do
      begin
        ID := tmp;
        Used := False;
        Our := False;
        Bonus := 0;
        Left := myini.ReadString(tmp, 'Left', '');
        Up := myini.ReadString(tmp, 'Up', '');
        Right := myini.ReadString(tmp, 'Right', '');
        Down := myini.ReadString(tmp, 'Down', '');
        Element := ToElement[myini.ReadInteger(tmp, 'Element', 0)]
      end;

  myini.Free
end;

procedure TfMain.SelectElement(Sender: TObject);
var
  x, y: byte;
begin
  fSelectElement.Left := Mouse.CursorPos.X;
  fSelectElement.Top := Mouse.CursorPos.Y;
  fSelectElement.ShowModal;
  x := (Sender as TLabel).Tag div 10;
  y := (Sender as TLabel).Tag mod 10;
  CurrentGame.Field_Cell[x, y].Element := ToElement[fSelectElement.pElement.ItemIndex];
  (Sender as TLabel).Caption := CurrentGame.Field_Cell[x, y].Element
end;

procedure TfMain.bStatisticsClick(Sender: TObject);
begin
  if fStat.Visible then
    fStat.Hide
  else
    fStat.Show;
  fStat.Timer1.Enabled := fStat.Visible;
  if fStat.Visible then
    Left := (Screen.Width - (Width + fStat.Width)) div 2
  else
    Left := (Screen.Width - Width) div 2
end;

procedure TfMain.FormDockDrop(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer);
var
  i: byte;
  _x, _y: byte;
begin
  Inc(CurrentGame.Cells_Used);
  _x := (Sender as TGroupBox).Tag div 10;
  _y := (Sender as TGroupBox).Tag mod 10;
  with (Source.Control as TGroupBox) do
    begin
      Top := ((Sender as TGroupBox).ClientHeight - Height) div 2;
      Left := ((Sender as TGroupBox).ClientWidth - Width) div 2;
      (Sender as TGroupBox).Enabled := False;

      if Tag > 5 then
        for i := 1 to 5 do
          if (PlayerHand[i].ID = Caption) and not(PlayerHand[i].Used) then
            begin
              PlayerHand[i].Used := True;
              CurrentGame.Field_Cell[_x, _y].CardID := IntToStr(Tag);
              CurrentGame.Field_Cell[_x, _y].Card := PlayerHand[i];
              break
            end
          else
      else
        for i := 1 to 5 do
          if (OpponentHand[i].ID = Caption) and not(OpponentHand[i].Used) then
            begin
              OpponentHand[i].Used := True;
              CurrentGame.Field_Cell[_x, _y].CardID := IntToStr(Tag);
              CurrentGame.Field_Cell[_x, _y].Card := OpponentHand[i];
              break
            end;
      if CurrentGame.Field_Cell[_x, _y].Element <> '' then
        if CurrentGame.Field_Cell[_x, _y].Element = CurrentGame.Field_Cell[_x, _y].Card.Element then
          CurrentGame.Field_Cell[_x, _y].Card.Bonus := 1
        else
          CurrentGame.Field_Cell[_x, _y].Card.Bonus := -1;
      MakeMove(CurrentGame, _x, _y, Score, CurrentStat);
{$IFDEF ALTCHECK}
      //Checking End condition
      if CurrentGame.Cells_Used = 9 then
        if Score[False] < Score[True] then
          Inc(CurrentStat[3])
        else if Score[False] = Score[True] then
          Inc(CurrentStat[2])
        else
          Inc(CurrentStat[1]);
{$ENDIF}
      RefreshField;
      if CurrentGame.Cells_Used = 9 then
        if Score[True] < Score[False] then
          MessageBox(Handle, 'You''ve been defeated', 'Game Over', MB_OK + MB_ICONINFORMATION)
        else if Score[True] = Score[False] then
          MessageBox(Handle, 'It''s a draw', 'Game Over', MB_OK + MB_ICONINFORMATION)
        else
          MessageBox(Handle, 'You won', 'Game Over', MB_OK + MB_ICONINFORMATION)
    end
end;

procedure TfMain.MakeMove(var game: TGameInfo; const x, y: byte; var Score: TScore; var Stat: TStat; const combo: boolean = False);
begin
  //Move w/ Same Rule
  if (not combo) and cSame.Checked then
    begin
{\..} with game.Field_Cell[x - 1, y].Card do
{.*.}   if Used and game.Field_Cell[x, y + 1].Card.Used then
{...}     if (Right = game.Field_Cell[x, y].Card.Left) and (game.Field_Cell[x, y + 1].Card.Down = game.Field_Cell[x, y].Card.Up) then
            begin
              if (x > 1) and (Our <> game.Field_Cell[x, y].Card.Our) then
                begin
                  Our := game.Field_Cell[x, y].Card.Our;
                  Inc(Score[Our]);
                  Dec(Score[not Our]);
                  MakeMove(game, x - 1, y, Score, Stat, True)
                end;
              with game.Field_Cell[x, y + 1].Card do
                if (y < 3) and (Our <> game.Field_Cell[x, y].Card.Our) then
                  begin
                    Our := game.Field_Cell[x, y].Card.Our;
                    Inc(Score[Our]);
                    Dec(Score[not Our]);
                    MakeMove(game, x, y + 1, Score, Stat, True)
                  end
            end;
{...} with game.Field_Cell[x - 1, y].Card do
{.*.}   if Used and game.Field_Cell[x, y - 1].Card.Used then
{/..}     if (Right = game.Field_Cell[x, y].Card.Left) and (game.Field_Cell[x, y - 1].Card.Up = game.Field_Cell[x, y].Card.Down) then
            begin
              if (x > 1) and (Our <> game.Field_Cell[x, y].Card.Our) then
                begin
                  Our := game.Field_Cell[x, y].Card.Our;
                  Inc(Score[Our]);
                  Dec(Score[not Our]);
                  MakeMove(game, x - 1, y, Score, Stat, True)
                end;
              with game.Field_Cell[x, y - 1].Card do
                if (y > 1) and (Our <> game.Field_Cell[x, y].Card.Our) then
                  begin
                    Our := game.Field_Cell[x, y].Card.Our;
                    Inc(Score[Our]);
                    Dec(Score[not Our]);
                    MakeMove(game, x, y - 1, Score, Stat, True)
                  end
            end;
{../} with game.Field_Cell[x, y + 1].Card do
{.*.}   if Used and game.Field_Cell[x + 1, y].Card.Used then
{...}     if (Down = game.Field_Cell[x, y].Card.Up) and (game.Field_Cell[x + 1, y].Card.Left = game.Field_Cell[x, y].Card.Right) then
            begin
              if (y < 3) and (Our <> game.Field_Cell[x, y].Card.Our) then
                begin
                  Our := game.Field_Cell[x, y].Card.Our;
                  Inc(Score[Our]);
                  Dec(Score[not Our]);
                  MakeMove(game, x, y + 1, Score, Stat, True)
                end;
              with game.Field_Cell[x + 1, y].Card do
                if (x < 3) and (Our <> game.Field_Cell[x, y].Card.Our) then
                  begin
                    Our := game.Field_Cell[x, y].Card.Our;
                    Inc(Score[Our]);
                    Dec(Score[not Our]);
                    MakeMove(game, x + 1, y, Score, Stat, True)
                  end
            end;
{...} with game.Field_Cell[x + 1, y].Card do
{.*.}   if Used and game.Field_Cell[x, y - 1].Card.Used then
{..\}     if (Left = game.Field_Cell[x, y].Card.Right) and (game.Field_Cell[x, y - 1].Card.Up = game.Field_Cell[x, y].Card.Down) then
            begin
              if (x < 3) and (Our <> game.Field_Cell[x, y].Card.Our) then
                begin
                  Our := game.Field_Cell[x, y].Card.Our;
                  Inc(Score[Our]);
                  Dec(Score[not Our]);
                  MakeMove(game, x + 1, y, Score, Stat, True)
                end;
              with game.Field_Cell[x, y - 1].Card do
                if (y > 1) and (Our <> game.Field_Cell[x, y].Card.Our) then
                  begin
                    Our := game.Field_Cell[x, y].Card.Our;
                    Inc(Score[Our]);
                    Dec(Score[not Our]);
                    MakeMove(game, x, y - 1, Score, Stat, True)
                  end
            end;
{...} with game.Field_Cell[x - 1, y].Card do
{-*-}   if Used and game.Field_Cell[x + 1, y].Card.Used then
{...}     if (Right = game.Field_Cell[x, y].Card.Left) and (game.Field_Cell[x + 1, y].Card.Left = game.Field_Cell[x, y].Card.Right) then
            begin
              if (x > 1) and (Our <> game.Field_Cell[x, y].Card.Our) then
                begin
                  Our := game.Field_Cell[x, y].Card.Our;
                  Inc(Score[Our]);
                  Dec(Score[not Our]);
                  MakeMove(game, x - 1, y, Score, Stat, True)
                end;
              with game.Field_Cell[x + 1, y].Card do
                if (x < 3) and (Our <> game.Field_Cell[x, y].Card.Our) then
                  begin
                    Our := game.Field_Cell[x, y].Card.Our;
                    Inc(Score[Our]);
                    Dec(Score[not Our]);
                    MakeMove(game, x + 1, y, Score, Stat, True)
                  end
            end;
{.|.} with game.Field_Cell[x, y + 1].Card do
{.*.}   if Used and game.Field_Cell[x, y - 1].Card.Used then
{.|.}     if (Down = game.Field_Cell[x, y].Card.Up) and (game.Field_Cell[x, y - 1].Card.Up = game.Field_Cell[x, y].Card.Down) then
            begin
              if (y < 3) and (Our <> game.Field_Cell[x, y].Card.Our) then
                begin
                  Our := game.Field_Cell[x, y].Card.Our;
                  Inc(Score[Our]);
                  Dec(Score[not Our]);
                  MakeMove(game, x, y + 1, Score, Stat, True)
                end;
              with game.Field_Cell[x, y - 1].Card do
                if (y > 1) and (Our <> game.Field_Cell[x, y].Card.Our) then
                  begin
                    Our := game.Field_Cell[x, y].Card.Our;
                    Inc(Score[Our]);
                    Dec(Score[not Our]);
                    MakeMove(game, x, y - 1, Score, Stat, True)
                  end
            end
    end;

  //Move w/ Plus Rule
  if (not combo) and cPlus.Checked then
    begin
      if (x > 1) and (y < 3) then
{</\} with game.Field_Cell[x - 1, y].Card do
        if Used and game.Field_Cell[x, y + 1].Card.Used then
          if (ToInt[Right[1]] + ToInt[game.Field_Cell[x, y].Card.Left[1]]) = (ToInt[game.Field_Cell[x, y + 1].Card.Down[1]] + ToInt[game.Field_Cell[x, y].Card.Up[1]]) then
            begin
              if (x > 1) and (Our <> game.Field_Cell[x, y].Card.Our) then
                begin
                  Our := game.Field_Cell[x, y].Card.Our;
                  Inc(Score[Our]);
                  Dec(Score[not Our]);
                  MakeMove(game, x - 1, y, Score, Stat, True)
                end;
              with game.Field_Cell[x, y + 1].Card do
                if (y < 3) and (Our <> game.Field_Cell[x, y].Card.Our) then
                  begin
                    Our := game.Field_Cell[x, y].Card.Our;
                    Inc(Score[Our]);
                    Dec(Score[not Our]);
                    MakeMove(game, x, y + 1, Score, Stat, True)
                  end
            end;
      if (x > 1) and (y > 1) then
{<\/} with game.Field_Cell[x - 1, y].Card do
        if Used and game.Field_Cell[x, y - 1].Card.Used then
          if (ToInt[Right[1]] + ToInt[game.Field_Cell[x, y].Card.Left[1]]) = (ToInt[game.Field_Cell[x, y - 1].Card.Up[1]] + ToInt[game.Field_Cell[x, y].Card.Down[1]]) then
            begin
              if (x > 1) and (Our <> game.Field_Cell[x, y].Card.Our) then
                begin
                  Our := game.Field_Cell[x, y].Card.Our;
                  Inc(Score[Our]);
                  Dec(Score[not Our]);
                  MakeMove(game, x - 1, y, Score, Stat, True)
                end;
              with game.Field_Cell[x, y - 1].Card do
                if (y > 1) and (Our <> game.Field_Cell[x, y].Card.Our) then
                  begin
                    Our := game.Field_Cell[x, y].Card.Our;
                    Inc(Score[Our]);
                    Dec(Score[not Our]);
                    MakeMove(game, x, y - 1, Score, Stat, True)
                  end
            end;
      if (x < 3) and (y < 3) then
{/\>} with game.Field_Cell[x, y + 1].Card do
        if Used and game.Field_Cell[x + 1, y].Card.Used then
          if (ToInt[Down[1]] + ToInt[game.Field_Cell[x, y].Card.Up[1]]) = (ToInt[game.Field_Cell[x + 1, y].Card.Left[1]] + ToInt[game.Field_Cell[x, y].Card.Right[1]]) then
            begin
              if (y < 3) and (Our <> game.Field_Cell[x, y].Card.Our) then
                begin
                  Our := game.Field_Cell[x, y].Card.Our;
                  Inc(Score[Our]);
                  Dec(Score[not Our]);
                  MakeMove(game, x, y + 1, Score, Stat, True)
                end;
              with game.Field_Cell[x + 1, y].Card do
                if (x < 3) and (Our <> game.Field_Cell[x, y].Card.Our) then
                  begin
                    Our := game.Field_Cell[x, y].Card.Our;
                    Inc(Score[Our]);
                    Dec(Score[not Our]);
                    MakeMove(game, x + 1, y, Score, Stat, True)
                  end
            end;
      if (x < 3) and (y > 1) then
{>\/} with game.Field_Cell[x + 1, y].Card do
        if Used and game.Field_Cell[x, y - 1].Card.Used then
          if (ToInt[Left[1]] + ToInt[game.Field_Cell[x, y].Card.Right[1]]) = (ToInt[game.Field_Cell[x, y - 1].Card.Up[1]] + ToInt[game.Field_Cell[x, y].Card.Down[1]]) then
            begin
              if (x < 3) and (Our <> game.Field_Cell[x, y].Card.Our) then
                begin
                  Our := game.Field_Cell[x, y].Card.Our;
                  Inc(Score[Our]);
                  Dec(Score[not Our]);
                  MakeMove(game, x + 1, y, Score, Stat, True)
                end;
              with game.Field_Cell[x, y - 1].Card do
                if (y > 1) and (Our <> game.Field_Cell[x, y].Card.Our) then
                  begin
                    Our := game.Field_Cell[x, y].Card.Our;
                    Inc(Score[Our]);
                    Dec(Score[not Our]);
                    MakeMove(game, x, y - 1, Score, Stat, True)
                  end
            end;
      if x = 2 then
{<>}  with game.Field_Cell[x - 1, y].Card do
        if Used and game.Field_Cell[x + 1, y].Card.Used then
          if (ToInt[Right[1]] + ToInt[game.Field_Cell[x, y].Card.Left[1]]) = (ToInt[game.Field_Cell[x + 1, y].Card.Left[1]] + ToInt[game.Field_Cell[x, y].Card.Right[1]]) then
            begin
              if (x > 1) and (Our <> game.Field_Cell[x, y].Card.Our) then
                begin
                  Our := game.Field_Cell[x, y].Card.Our;
                  Inc(Score[Our]);
                  Dec(Score[not Our]);
                  MakeMove(game, x - 1, y, Score, Stat, True)
                end;
              with game.Field_Cell[x + 1, y].Card do
                if (x < 3) and (Our <> game.Field_Cell[x, y].Card.Our) then
                  begin
                    Our := game.Field_Cell[x, y].Card.Our;
                    Inc(Score[Our]);
                    Dec(Score[not Our]);
                    MakeMove(game, x + 1, y, Score, Stat, True)
                  end
            end;
      if y = 2 then
{/\\/}with game.Field_Cell[x, y + 1].Card do
        if Used and game.Field_Cell[x, y - 1].Card.Used then
          if (ToInt[Down[1]] + ToInt[game.Field_Cell[x, y].Card.Up[1]]) = (ToInt[game.Field_Cell[x, y - 1].Card.Up[1]] + ToInt[game.Field_Cell[x, y].Card.Down[1]]) then
            begin
              if (y < 3) and (Our <> game.Field_Cell[x, y].Card.Our) then
                begin
                  Our := game.Field_Cell[x, y].Card.Our;
                  Inc(Score[Our]);
                  Dec(Score[not Our]);
                  MakeMove(game, x, y + 1, Score, Stat, True)
                end;
              with game.Field_Cell[x, y - 1].Card do
                if (y > 1) and (Our <> game.Field_Cell[x, y].Card.Our) then
                  begin
                    Our := game.Field_Cell[x, y].Card.Our;
                    Inc(Score[Our]);
                    Dec(Score[not Our]);
                    MakeMove(game, x, y - 1, Score, Stat, True)
                  end
            end
    end;

  //Simple move (w/ or w/o Elemental Rule)
  if cElemental.Checked then
    begin
      with game.Field_Cell[x - 1, y].Card do
        if Used and (Our <> game.Field_Cell[x, y].Card.Our) and (x > 1) then
          if (ToInt[Right[1]] + Bonus) < (ToInt[game.Field_Cell[x, y].Card.Left[1]] + game.Field_Cell[x, y].Card.Bonus) then
            begin
              Our := game.Field_Cell[x, y].Card.Our;
              Inc(Score[Our]);
              Dec(Score[not Our]);
              if combo then
                MakeMove(game, x - 1, y, Score, Stat, True)
            end;
      with game.Field_Cell[x + 1, y].Card do
        if Used and (Our <> game.Field_Cell[x, y].Card.Our) and (x < 3) then
          if (ToInt[Left[1]] + Bonus) < (ToInt[game.Field_Cell[x, y].Card.Right[1]] + game.Field_Cell[x, y].Card.Bonus) then
            begin
              Our := game.Field_Cell[x, y].Card.Our;
              Inc(Score[Our]);
              Dec(Score[not Our]);
              if combo then
                MakeMove(game, x + 1, y, Score, Stat, True)
            end;
      with game.Field_Cell[x, y - 1].Card do
        if Used and (Our <> game.Field_Cell[x, y].Card.Our) and (y > 1) then
          if (ToInt[Up[1]] + Bonus) < (ToInt[game.Field_Cell[x, y].Card.Down[1]] + game.Field_Cell[x, y].Card.Bonus) then
            begin
              Our := game.Field_Cell[x, y].Card.Our;
              Inc(Score[Our]);
              Dec(Score[not Our]);
              if combo then
                MakeMove(game, x, y - 1, Score, Stat, True)
            end;
      with game.Field_Cell[x, y + 1].Card do
        if Used and (Our <> game.Field_Cell[x, y].Card.Our) and (y < 3) then
          if (ToInt[Down[1]] + Bonus) < (ToInt[game.Field_Cell[x, y].Card.Up[1]] + game.Field_Cell[x, y].Card.Bonus) then
            begin
              Our := game.Field_Cell[x, y].Card.Our;
              Inc(Score[Our]);
              Dec(Score[not Our]);
              if combo then
                MakeMove(game, x, y + 1, Score, Stat, True)
            end
    end
  else
    begin
      with game.Field_Cell[x - 1, y].Card do
        if Used and (Our <> game.Field_Cell[x, y].Card.Our) and (x > 1) then
          if Right < game.Field_Cell[x, y].Card.Left then
            begin
              Our := game.Field_Cell[x, y].Card.Our;
              Inc(Score[Our]);
              Dec(Score[not Our]);
              if combo then
                MakeMove(game, x - 1, y, Score, Stat, True)
            end;
      with game.Field_Cell[x + 1, y].Card do
        if Used and (Our <> game.Field_Cell[x, y].Card.Our) and (x < 3) then
          if Left < game.Field_Cell[x, y].Card.Right then
            begin
              Our := game.Field_Cell[x, y].Card.Our;
              Inc(Score[Our]);
              Dec(Score[not Our]);
              if combo then
                MakeMove(game, x + 1, y, Score, Stat, True)
            end;
      with game.Field_Cell[x, y - 1].Card do
        if Used and (Our <> game.Field_Cell[x, y].Card.Our) and (y > 1) then
          if Up < game.Field_Cell[x, y].Card.Down then
            begin
              Our := game.Field_Cell[x, y].Card.Our;
              Inc(Score[Our]);
              Dec(Score[not Our]);
              if combo then
                MakeMove(game, x, y - 1, Score, Stat, True)
            end;
      with game.Field_Cell[x, y + 1].Card do
        if Used and (Our <> game.Field_Cell[x, y].Card.Our) and (y < 3) then
          if Down < game.Field_Cell[x, y].Card.Up then
            begin
              Our := game.Field_Cell[x, y].Card.Our;
              Inc(Score[Our]);
              Dec(Score[not Our]);
              if combo then
                MakeMove(game, x, y + 1, Score, Stat, True)
            end
    end
{$IFNDEF ALTCHECK}
      ;//Checking End condition
      if (not combo) and (game.Cells_Used = 9) then
        if Score[False] < Score[True] then
          Inc(Stat[3])
        else if Score[False] = Score[True] then
          Inc(Stat[2])
        else
          Inc(Stat[1]);
{$ENDIF}
end;

procedure TfMain.RefreshField;
var
  i, j: byte;
  id: string;
begin
  lScore1.Caption := IntToStr(Score[False]);
  lScore2.Caption := IntToStr(Score[True]);
  for i := 1 to 3 do
    for j := 1 to 3 do
      if CurrentGame.Field_Cell[i, j].Card.Used then
        with CurrentGame.Field_Cell[i, j] do
          begin
            id := IntToStr(i * 10 + j);
            if (cElemental.Checked) and (Element <> '') then
              if (Element = Card.Element) then
                (FindComponent('lEffect' + id) as TLabel).Caption := '+1'
              else
                (FindComponent('lEffect' + id) as TLabel).Caption := '-1'
            else
              (FindComponent('lEffect' + id) as TLabel).Caption := '';
            if Card.Our then
              (FindComponent('sCardColor' + CurrentGame.Field_Cell[i, j].CardID) as TShape).Brush.Color := clPlayer
            else
              (FindComponent('sCardColor' + CurrentGame.Field_Cell[i, j].CardID) as TShape).Brush.Color := clOpponent
          end
        else
          (FindComponent('lEffect' + IntToStr(i * 10 + j)) as TLabel).Caption := ''
end;

procedure TfMain.FindMove(const game: TGameInfo; const score: TScore; plh, oph: THandInfo; const plmove: boolean; var stat: TStat; const lvl: byte);
var
  i, j, k, l: byte;
  local_game: TGameInfo;
  local_score: TScore;
begin
  CurGameStat := game;
  Application.ProcessMessages;
  if plmove then
    for i := 1 to 5 do
      if not plh[i].Used then
        for j := 1 to 3 do
          for k := 1 to 3 do
            if not game.Field_Cell[j ,k].Card.Used then
              begin
                local_game := game;
                local_score := score;
                plh[i].Used := true;
                local_game.Field_Cell[j ,k].Card := plh[i];
                Inc(local_game.Cells_Used);
                if lvl = 0 then
                  begin
                    for l := 1 to 3 do
                      stat[l] := 0;
                    stat[0] := j * 10 + k
                  end;
                MakeMove(local_game, j, k, local_score, stat);
{$IFDEF ALTCHECK}
                //Checking End condition
                if local_game.Cells_Used = 9 then
                  if local_score[False] < local_score[True] then
                    Inc(stat[3])
                  else if local_score[False] = local_score[True] then
                    Inc(stat[2])
                  else
                    Inc(stat[1]);
{$ENDIF}
                if local_game.Cells_Used < 9 then
                  FindMove(local_game, local_score, plh, oph, not plmove, stat, lvl + 1);
                plh[i].Used := False;
                if lvl = 0 then
                  if CurHandStat[i][0] <> 0 then
                    if (stat[1] < CurHandStat[i][1]) or (stat[3] > CurHandStat[i][3]) then
                      for l := 0 to 3 do
                        CurHandStat[i][l] := stat[l]
                    else
                  else
                    for l := 0 to 3 do
                      CurHandStat[i][l] := stat[l]
              end
            else
      else
  else
    for i := 1 to 5 do
      if not oph[i].Used then
        for j := 1 to 3 do
          for k := 1 to 3 do
            if not game.Field_Cell[j ,k].Card.Used then
              begin
                local_game := game;
                local_score := score;
                oph[i].Used := true;
                local_game.Field_Cell[j ,k].Card := oph[i];
                Inc(local_game.Cells_Used);
                if lvl = 0 then
                  begin
                    for l := 1 to 3 do
                      stat[l] := 0;
                    stat[0] := j * 10 + k
                  end;
                MakeMove(local_game, j, k, local_score, stat);
{$IFDEF ALTCHECK}
                //Checking End condition
                if local_game.Cells_Used = 9 then
                  if local_score[False] < local_score[True] then
                    Inc(stat[3])
                  else if local_score[False] = local_score[True] then
                    Inc(stat[2])
                  else
                    Inc(stat[1]);
{$ENDIF}
                if local_game.Cells_Used < 9 then
                  FindMove(local_game, local_score, plh, oph, not plmove, stat, lvl + 1);
                oph[i].Used := False;
                if lvl = 0 then
                  if CurHandStat[i][0] <> 0 then
                    if (stat[3] < CurHandStat[i][3]) or (stat[1] > CurHandStat[i][1]) then
                      for l := 0 to 3 do
                        CurHandStat[i][l] := stat[l]
                    else
                  else
                    for l := 0 to 3 do
                      CurHandStat[i][l] := stat[l]
              end
end;

procedure TfMain.bMove1Click(Sender: TObject);
var
  local_game: TGameInfo;
  local_score: TScore;
  local_stat: TStat;
  i, j, k: byte;
  f: boolean;
begin
  f := false;
  for i := 1 to 5 do
    f := f or (OpponentHand[i].ID = '') or (PlayerHand[i].ID = '');
  if f or (CurrentGame.Cells_Used = 9) then
    Exit;

  gCardBox1.Enabled := False;
  gCardBox2.Enabled := False;
  gFieldBox.Enabled := False;
  gRules.Enabled := False;
  bMove1.Enabled := False;
  bMove2.Enabled := False;
  bReset.Enabled := False;
  Thinking := true;

  local_game := CurrentGame;
  local_score := Score;
  for i := 1 to 5 do
    for j := 0 to 3 do
      CurHandStat[i][j] := 0;
  ProposeStr := '';
  MoveToID := '';
  FindMove(local_game, local_score, PlayerHand, OpponentHand, False, local_stat, 0);

  for k := 1 to 5 do
    if not OpponentHand[k].Used then
      begin
        local_stat := CurHandStat[k];
        break
      end;
  for i := k to 5 do
    if not OpponentHand[i].Used and ((local_stat[1] < CurHandStat[i][1]) or ((local_stat[1] = CurHandStat[i][1]) and (local_stat[3] > CurHandStat[i][3]))) then
      begin
        local_stat := CurHandStat[i];
        k := i
      end;
  (FindComponent('gCard' + IntToStr(k)) as TGroupBox).ManualDock(FindComponent('Field' + IntToStr(local_stat[0])) as TGroupBox);

  gCardBox1.Enabled := True;
  gCardBox2.Enabled := True;
  gFieldBox.Enabled := True;
  gRules.Enabled := True;
  bMove1.Enabled := True;
  bMove2.Enabled := True;
  bReset.Enabled := True;
  Thinking := false;
end;

procedure TfMain.bMove2Click(Sender: TObject);
var
  local_game: TGameInfo;
  local_score: TScore;
  local_stat: TStat;
  i, j, k: byte;
  f: boolean;
  threads: array [1..5] of TMyThread;
begin
  f := false;
  for i := 1 to 5 do
    f := f or (OpponentHand[i].ID = '') or (PlayerHand[i].ID = '');
  if f or (CurrentGame.Cells_Used = 9) then
    Exit;

  gCardBox1.Enabled := False;
  gCardBox2.Enabled := False;
  gFieldBox.Enabled := False;
  gRules.Enabled := False;
  bMove1.Enabled := False;
  bMove2.Enabled := False;
  bReset.Enabled := False;
  Thinking := true;

  local_game := CurrentGame;
  local_score := Score;
  for i := 1 to 5 do
    for j := 0 to 3 do
      CurHandStat[i][j] := 0;
  ProposeStr := '';
  MoveToID := '';
  MoveToCardID := '';
  if cMT.Checked then
    begin
      for i := 1 to 5 do
        begin
          threads[i] := TMyThread.Create(local_game, local_score, PlayerHand, OpponentHand, True, local_stat, 0, i, cPlus.Checked, cSame.Checked, cSameWall.Checked, cElemental.Checked);
          threads[i].WaitFor;
        end;
      for i := 1 to 5 do
        begin
          while not threads[i].Completed do
            begin
              Application.ProcessMessages;
              SysUtils.Sleep(10);
            end;
          threads[i].WaitFor;
          //local_stat := threads[i].LocalStat;
          //threads[i].Free;
        end
    end
  else
    FindMove(local_game, local_score, PlayerHand, OpponentHand, True, local_stat, 0);

  for k := 1 to 5 do
    if not PlayerHand[k].Used then
      begin
        local_stat := CurHandStat[k];
        break
      end;
  for i := k to 5 do
    if not PlayerHand[i].Used and ((local_stat[1] > CurHandStat[i][1]) or ((local_stat[1] = CurHandStat[i][1]) and (local_stat[3] < CurHandStat[i][3]))) then
      begin
        local_stat := CurHandStat[i];
        k := i
      end;
  Thinking := False;
  MoveToID := IntToStr(local_stat[0] div 10) + IntToStr(local_stat[0] mod 10);
  MoveToCardID := PlayerHand[k].ID;
  ProposeStr := MoveToCardID + ' into the ' + CellToWord[local_stat[0] div 10, local_stat[0] mod 10];

  gCardBox1.Enabled := True;
  gCardBox2.Enabled := True;
  gFieldBox.Enabled := True;
  gRules.Enabled := True;
  bMove1.Enabled := True;
  bMove2.Enabled := True;
  bReset.Enabled := True
end;

procedure TfMain.FormShow(Sender: TObject);
begin
  Top := (Screen.Height - Height) div 2;
  Left := (Screen.Width - (Width + fStat.Width)) div 2
end;

end.
