unit Unit6;

interface
uses
  Classes;
type
  TCardInfo = record
    ID: string[14];
    Used, Our: Boolean;
    Bonus: Shortint;
    Left, Up, Right, Down, Element: string[1];
  end;
  TCellInfo = record
    Element: string[1];
    CardID: string[2];
    Card: TCardInfo;
  end;
  TGameInfo = record
    Cells_Used: byte;
    Field_Cell: array [0..4, 0..4] of TCellInfo;
  end;
  TStat = array [0..3] of LongWord; //(id, Loses, Draws, Wins)
  TScore = array [False..True] of byte;
  THandStat = array [1..5] of TStat;
  THandInfo = array [1..5] of TCardInfo;

type
  TMyThread = class(TThread)
  private
    LocalScore: TScore;
    PlayerHand, OpponentHand: THandInfo;
    PlayerMove: boolean;
    LocalStat: TStat;
    LocalLvl, LocalThreadId: byte;
    RulePlus, RuleSame, RuleSameWall, RuleElemental: boolean;
  protected
    procedure Execute; override;
    procedure FindMove(const game: TGameInfo; const score: TScore; plh, oph: THandInfo; const plmove: boolean; var stat: TStat; const lvl: byte);
    procedure MakeMove(var game: TGameInfo; const x, y: byte; var Score: TScore; var Stat: TStat; const combo: boolean = False);
  public
    constructor Create(const game: TGameInfo; const score: TScore; plh, oph: THandInfo; const plmove: boolean; var stat: TStat; const lvl, tid: byte; const rpl, rs, rsw, re: boolean);
  end;

var
  ToInt: array ['1'..'A'] of byte;

implementation

uses Unit1;

constructor TMyThread.Create(const game: TGameInfo; const score: TScore; plh, oph: THandInfo; const plmove: boolean; var stat: TStat; const lvl, tid: byte; const rpl, rs, rsw, re: boolean);
var
  i: byte;
begin
  inherited Create(false);
  LocalScore := score;
  PlayerHand := plh;
  OpponentHand := oph;
  PlayerMove := plmove;
  LocalStat := stat;
  LocalLvl := lvl;
  LocalThreadId := tid;
  RulePlus := rpl;
  RuleSame := rs;
  RuleSameWall := rsw;
  RuleElemental := re;
  for i := 1 to 9 do
    ToInt[Chr(Ord('0') + i)] := i;
  ToInt['A'] := 10;
end;

procedure TMyThread.Execute;
begin
  FindMove(CurGameStat, LocalScore, PlayerHand, OpponentHand, PlayerMove, LocalStat, LocalLvl);
end;

procedure TMyThread.FindMove(const game: TGameInfo; const score: TScore; plh, oph: THandInfo; const plmove: boolean; var stat: TStat; const lvl: byte);
var
  i, j, k, l: byte;
  local_game: TGameInfo;
  local_score: TScore;
begin
  //CurGameStat := game;
  if plmove then
    for i := 1 to 5 do
      if (not plh[i].Used) and ((lvl > 0) or (i = LocalThreadId)) then
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
      if (not oph[i].Used) and ((lvl > 0) or (i = LocalThreadId)) then
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

procedure TMyThread.MakeMove(var game: TGameInfo; const x, y: byte; var Score: TScore; var Stat: TStat; const combo: boolean = False);
begin
  //Move w/ Same Rule
  if (not combo) and RuleSame then
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
  if (not combo) and RulePlus then
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
  if RuleElemental then
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

end.
