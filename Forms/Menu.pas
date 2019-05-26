unit Menu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Registry, ShellAPI, Vcl.Buttons;

type
  TForm1 = class(TForm)
    Theme: TComboBox;
    Change: TButton;
    Header: TImage;
    Maximizar: TImage;
    Fechar: TImage;
    Minimizar: TImage;
    Footer: TImage;
    Version: TLabel;
    WindowsLogo: TImage;
    Preview: TButton;
    ImagePreview: TImage;
    SystemSettings: TSpeedButton;
    procedure ChangeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ThemeChange(Sender: TObject);
    procedure PreviewClick(Sender: TObject);
    procedure SystemSettingsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//== Função da Versão do Aplicativo ============================================
Function VersaoExe: String;
type
   PFFI = ^vs_FixedFileInfo;
var
   F       : PFFI;
   Handle  : Dword;
   Len     : Longint;
   Data    : Pchar;
   Buffer  : Pointer;
   Tamanho : Dword;
   Parquivo: Pchar;
   Arquivo : String;
begin
   Arquivo  := Application.ExeName;
   Parquivo := StrAlloc(Length(Arquivo) + 1);
   StrPcopy(Parquivo, Arquivo);
   Len := GetFileVersionInfoSize(Parquivo, Handle);
   Result := '';
   if Len > 0 then
   begin
      Data:=StrAlloc(Len+1);
      if GetFileVersionInfo(Parquivo,Handle,Len,Data) then
      begin
         VerQueryValue(Data, '',Buffer,Tamanho);
         F := PFFI(Buffer);
         Result := Format('%d.%d.%d.%d',
                          [HiWord(F^.dwFileVersionMs),
                           LoWord(F^.dwFileVersionMs),
                           HiWord(F^.dwFileVersionLs),
                           Loword(F^.dwFileVersionLs)]
                         );
      end;
      StrDispose(Data);
   end;
   StrDispose(Parquivo);
end;
//==============================================================================

//=== Função para verificar o tema =============================================
Function ThemeChecker:string;
var reg: TRegistry;
begin
reg := TRegistry.Create;//Criar e Escolher o caminho
reg.RootKey:=HKEY_CURRENT_USER;
//Criar o registro e abrir
reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize',True);
//Light Theme
if reg.ReadInteger('AppsUseLightTheme')=1 then
        Result:='Light Theme';
//Dark Theme
if reg.ReadInteger('AppsUseLightTheme')=0 then
        Result:='Dark Theme';
reg.CloseKey();
//Liberar
reg.Free;
end;
//==============================================================================

//=== Abrir Configurações ======================================================
procedure TForm1.SystemSettingsClick(Sender: TObject);
begin
winexec('explorer.exe shell:Appsfolder\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel',SW_SHOW);
end;
//=== Trocar Tema ==============================================================
procedure TForm1.ChangeClick(Sender: TObject);
var reg: TRegistry;
begin
reg := TRegistry.Create;//Criar e Escolher o caminho
reg.RootKey:=HKEY_CURRENT_USER;
//Criar o registro e abrir
reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize',True);
//Light Theme
if Theme.Text='Windows 10 Light Theme' then
  begin
    reg.WriteInteger('AppsUseLightTheme',1);
    reg.WriteInteger('SystemUseLightTheme',1);
  end;
//Dark Theme
if Theme.Text='Windows 10 Dark Theme' then
  begin
    reg.WriteInteger('AppsUseLightTheme',0);
    reg.WriteInteger('SystemUseLightTheme',0);
  end;
reg.CloseKey();
//Liberar
reg.Free;
//verificar tema
Version.Caption:=ThemeChecker+' | ['+VersaoExe+' ]';
end;
//=== Criação do Form ==========================================================
procedure TForm1.FormCreate(Sender: TObject);
begin
//verificar tema
Version.Caption:=ThemeChecker+' | ['+VersaoExe+' ]';
if ThemeChecker='Dark Theme' then Theme.ItemIndex:=1;
if ThemeChecker='Light Theme' then Theme.ItemIndex:=0;
ThemeChange(Self);

end;
//=== Botão Preview ============================================================
procedure TForm1.PreviewClick(Sender: TObject);
begin
if (Form1.Height=190)and(Form1.Width=370) then
  begin
    Form1.Height:=555;
    Form1.Width:=1176;
    Preview.Caption:='<';
  end
else
  begin
    Form1.Height:=190;
    Form1.Width :=370;
    Preview.Caption:='>';
  end;
end;
//=== Efeitos visuais e imagem ao trocar de tema ===============================
procedure TForm1.ThemeChange(Sender: TObject);
begin
//Light Theme
if Theme.Text='Windows 10 Light Theme' then
  begin
    Form1.Color:=ClBtnFace;
    ImagePreview.Picture.LoadFromFile(ExtractFilePath(ParamStr(0))+'Preview\Light Theme.PNG');
  end;
//Dark Theme
if Theme.Text='Windows 10 Dark Theme' then
  begin
    Form1.Color:=$353535;
    ImagePreview.Picture.LoadFromFile(ExtractFilePath(ParamStr(0))+'Preview\Dark Theme.PNG');
  end;
end;

end.
