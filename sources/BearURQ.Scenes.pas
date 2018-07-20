unit BearURQ.Scenes;

interface

uses
  BearURQ.Terminal,
  BearURQ.Buttons;

type
  TSceneEnum = (scTitle, scGame);

type
  TScene = class(TObject)
  private
    FTerminal: TTerminal;
    FButtons: TButtons;
    procedure Print(const X, Y: Word; const S: string); overload;
    procedure Print(const Y: Word; const S: string); overload;
  public
    constructor Create(ATerminal: TTerminal; AButtons: TButtons);
    property Terminal: TTerminal read FTerminal;
    procedure Render; virtual; abstract;
    procedure Update(var Key: Word); virtual; abstract;
  end;

type
  TScenes = class(TScene)
  private
    FSceneEnum: TSceneEnum;
    FScene: array [TSceneEnum] of TScene;
    FPrevSceneEnum: TSceneEnum;
  public
    constructor Create(ATerminal: TTerminal; AButtons: TButtons);
    destructor Destroy; override;
    procedure Render; override;
    procedure Update(var Key: Word); override;
    property SceneEnum: TSceneEnum read FSceneEnum write FSceneEnum;
    property PrevSceneEnum: TSceneEnum read FPrevSceneEnum;
    function GetScene(I: TSceneEnum): TScene;
    procedure SetScene(ASceneEnum: TSceneEnum); overload;
    procedure SetScene(ASceneEnum, CurrSceneEnum: TSceneEnum); overload;
    property PrevScene: TSceneEnum read FPrevSceneEnum write FPrevSceneEnum;
    procedure GoBack;
  end;

type
  TSceneTitle = class(TScene)
  public
    constructor Create(ATerminal: TTerminal; AButtons: TButtons);
    procedure Render; override;
    procedure Update(var Key: Word); override;
  end;

type
  TSceneGame = class(TScene)
  public
    constructor Create(ATerminal: TTerminal; AButtons: TButtons);
    procedure Render; override;
    procedure Update(var Key: Word); override;
  end;

var
  Scenes: TScenes;

implementation

uses
  Math,
  SysUtils,
  BearLibTerminal;

{ TScene }

procedure TScene.Print(const X, Y: Word; const S: string);
begin
  terminal_print(X, Y, S);
end;

constructor TScene.Create(ATerminal: TTerminal; AButtons: TButtons);
begin
  FTerminal := ATerminal;
  FButtons := AButtons;
end;

procedure TScene.Print(const Y: Word; const S: string);
begin
  terminal_print(FTerminal.Width div 2, Y, TK_ALIGN_CENTER, S);
end;

{ TScenes }

constructor TScenes.Create(ATerminal: TTerminal; AButtons: TButtons);
var
  I: TSceneEnum;
begin
  inherited Create(ATerminal, AButtons);
  for I := Low(TSceneEnum) to High(TSceneEnum) do
    case I of
      scTitle:
        FScene[I] := TSceneTitle.Create(ATerminal, AButtons);
      scGame:
        FScene[I] := TSceneGame.Create(ATerminal, AButtons);
    end;
  SceneEnum := scGame;
end;

destructor TScenes.Destroy;
var
  I: TSceneEnum;
begin
  for I := Low(TSceneEnum) to High(TSceneEnum) do
    FreeAndNil(FScene[I]);
  inherited;
end;

function TScenes.GetScene(I: TSceneEnum): TScene;
begin
  Result := FScene[I];
end;

procedure TScenes.GoBack;
begin
  Self.SceneEnum := FPrevSceneEnum;
end;

procedure TScenes.Render;
begin
  if (FScene[SceneEnum] <> nil) then
    FScene[SceneEnum].Render;
end;

procedure TScenes.SetScene(ASceneEnum, CurrSceneEnum: TSceneEnum);
begin
  FPrevSceneEnum := CurrSceneEnum;
  SetScene(ASceneEnum);
end;

procedure TScenes.SetScene(ASceneEnum: TSceneEnum);
begin
  SceneEnum := ASceneEnum;
  Render;
end;

procedure TScenes.Update(var Key: Word);
begin
  if (FScene[SceneEnum] <> nil) then
  begin
    FScene[SceneEnum].Update(Key);
  end;
end;

{ TSceneTitle }

constructor TSceneTitle.Create(ATerminal: TTerminal; AButtons: TButtons);
begin
  inherited Create(ATerminal, AButtons);
end;

procedure TSceneTitle.Render;
begin
  Self.Print(10, '����� ���������� � BearURQ!');
end;

procedure TSceneTitle.Update(var Key: Word);
begin

end;

{ TSceneGame }

constructor TSceneGame.Create(ATerminal: TTerminal; AButtons: TButtons);
begin
  inherited Create(ATerminal, AButtons);
end;

procedure TSceneGame.Render;
var
  I: Integer;
begin
  // ����� �������
  Print(0, 0, 'Text');
  // ���������
  // ������
  for I := 0 to FButtons.Count - 1 do
  begin
    Print(0, Terminal.Height - (FButtons.Count - I),
      IntToStr(I + 1) + '. ' + FButtons.GetName(I));
  end;
end;

procedure TSceneGame.Update(var Key: Word);
begin

end;

end.