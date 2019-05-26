program Windows10ThemeChanger;

uses
  Vcl.Forms,
  Menu in 'Forms\Menu.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
