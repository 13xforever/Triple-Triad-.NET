program Triple_Triad;

uses
  Forms,
  Unit1 in 'Unit1.pas' {fMain},
  Unit2 in 'Unit2.pas' {fCardEditor},
  Unit3 in 'Unit3.pas' {fSelectCard},
  Unit4 in 'Unit4.pas' {fSelectElement},
  Unit5 in 'Unit5.pas' {fStat};

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
