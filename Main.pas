unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  SpeechRecognition, FMX.StdCtrls, FMX.Objects, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdCookieManager, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, FMX.Controls.Presentation,
  FMX.Edit, FMX.Colors;

type
  TForm1 = class(TForm)
    Speech: TSpeechRecognition;
    http: TIdHTTP;
    cookie: TIdCookieManager;
    iohandler: TIdSSLIOHandlerSocketOpenSSL;
    editip: TEdit;
    speechbtn: TButton;
    tempbtn: TButton;
    cmdline: TLabel;
    procedure SpeechRecognition(Sender: TObject; Guess: string);
    procedure speechbtnClick(Sender: TObject);
    procedure tempbtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  SmartHouseInterface = class
    class var ip : string;
    class procedure Send(where : string; value : integer);
  end;

var
  Form1: TForm1;
  StringList : TStrings;

implementation

{$R *.fmx}

procedure TForm1.tempbtnClick(Sender: TObject);
begin
  SmartHouseInterface.ip := editip.Text;
  editip.Visible := false;
  tempbtn.Visible := false;
end;

procedure TForm1.speechbtnClick(Sender: TObject);
begin
  speech.ListenFor(StringList);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  speechbtn.TintColor := TAlphaColorRec.Dodgerblue;
end;

procedure TForm1.SpeechRecognition(Sender: TObject; Guess: string);
begin
  Guess := AnsiLowerCase(Guess);

  if (Guess = 'включить свет') or (Guess = 'включи свет') then
  begin
    SmartHouseInterface.Send('/api/set/light', 1);
  end
  else
  if (Guess = 'выключить свет') or (Guess = 'выключи свет') then
  begin
    SmartHouseInterface.Send('/api/set/light', 0);
  end
  else
  if (Guess = 'открыть дверь') or (Guess = 'открой дверь') then
  begin
    SmartHouseInterface.Send('/api/set/door', 1);
  end
  else
  if (Guess = 'закрыть дверь') or (Guess = 'закрой дверь') then
  begin
    SmartHouseInterface.Send('/api/set/door', 0);
  end
  else
    cmdline.Text := 'Команда не распознана';
end;

{ SmartHouseInterface }

class procedure SmartHouseInterface.Send(where: string; value: integer);
var
  sl : TStringList;
begin
  sl := TStringList.Create;
  sl.Add('data={"value":' + inttostr(value) + '}');
  Form1.http.Post('https://' + SmartHouseInterface.ip + where, sl);
end;

end.
