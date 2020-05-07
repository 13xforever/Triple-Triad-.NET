program Triple_Triad;

{$MODE Delphi}

uses
  Forms, Interfaces,
  MainForm in 'MainForm.pas' {fMain},
  CardEditorForm in 'CardEditorForm.pas' {fCardEditor},
  CardSelectForm in 'CardSelectForm.pas' {fSelectCard},
  ElementSelectForm in 'ElementSelectForm.pas' {fSelectElement},
  StatsForm in 'StatsForm.pas' {fStat},
  ThreadedSolver in 'ThreadedSolver.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Triple Triad';
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfCardEditor, fCardEditor);
  Application.CreateForm(TfSelectCard, fSelectCard);
  Application.CreateForm(TfSelectElement, fSelectElement);
  Application.CreateForm(TfStat, fStat);
  Application.Run;
end.
