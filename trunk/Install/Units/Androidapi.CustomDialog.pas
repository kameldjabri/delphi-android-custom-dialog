unit Androidapi.CustomDialog;
{- Unit Info----------------------------------------------------------------------------
Unit Name  : Androidapi.CustomDialog
Created By : Bar�� Atalay 16/09/2014
Last Change By :

Web Site: http://brsatalay.blogspot.com.tr/

Notes:
----------------------------------------------------------------------------------------}

interface
Uses System.Classes, System.UITypes, System.Actions, System.SysUtils, System.Types,
     FMX.Edit, FMX.Objects, FMX.Layouts, FMX.Controls, FMX.Forms, FMX.Types, FMX.StdCtrls, FMX.ListBox
     {$IFDEF ANDROID}
     ,Androidapi.JNI.GraphicsContentViewText
     {$ENDIF}
     ;

Type

  TCustomType = (Edit,ComboBox,TrackBar);

  TComboSettings = class(TPersistent)
    private
      FItems    : TStringList;
      FIndex    : Integer;
      FReturn   : Boolean;

      procedure SetWrite(const Value: TStringList);
      function GetIndex:Integer;
    public
      FCombo    : TComboBox;
      constructor Create();
      destructor Destroy;         override;
      procedure Assign(Source     : TPersistent); override;
      property ItemIndex   : Integer      read GetIndex write FIndex;
    published
      property Items        : TStringList read FItems  write SetWrite;
      property ReturnText   : Boolean     read FReturn write FReturn;//  default True;
  end;

  TTrackSettings = class(TPersistent)
    private
      FMin,
      FMax,
      FValue    : Single;
      FReturn      : Boolean;
    procedure SetWrite(const Value: Single);
    public
      constructor Create;
      destructor Destroy;         override;
      procedure Assign(Source     : TPersistent); override;
    published
      property Minimum     : Single     read FMin     write FMin;
      property Maximum     : Single     read FMax     write FMax;
      property Value       : Single     read FValue   write SetWrite;
      property ReturnText  : Boolean    read FReturn  write FReturn;//  default True;
  end;

  TEditSettings = class(TPersistent)
    private
      FText: String;
    public
      constructor Create;
      destructor Destroy;         override;
      procedure Assign(Source     : TPersistent); override;
    published
      property Text               : String     read FText   write FText;
  end;


  TCustomDialogs = class(TComponent)
  private
    FComboSetting: TComboSettings;
    FTrackSetting: TTrackSettings;
    FEditSettings: TEditSettings;
    FForm        : TForm;
    FEdit        : TCustomEdit;
    BG,
    Bot,
    Ic,
    Center       : TRectangle;
    TamamBut,
    IptalBut     : TButton;
    Baslik       : TText;
    FRes         : TCustomEdit;
    FCom         : TComboBox;
    FTrack       : TTrackBar;
    Lay          : TLayout;
    FTitle       : String;
    FKind        : TCustomType;
    FValue       : Single;
    FColor       : TAlphaColor;
    function  GetComboSetting: TComboSettings;
    procedure SetComboSetting(const Value: TComboSettings);
    procedure FreeNil;
    procedure SetComponent(const Value: TCustomEdit);
    procedure FClick(Sender: TObject);
    procedure TamamClick(Sender: TObject);
    procedure IptalClick(Sender: TObject);
    procedure ClosePopup(Sender: TObject);
    procedure SetComboSet(const Value: TComboSettings);
    function  GetComboSet:TComboSettings;
    function GetTrackSet: TTrackSettings;
    procedure SetTrackSet(const Value: TTrackSettings);
    function GetEditSet: TEditSettings;
    procedure SetEditSet(const Value: TEditSettings);
    function GetColor: TAlphaColor;
    procedure SetColor(const Value: TAlphaColor);
  public
    ResultText  : String;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Execute;
  published
    property Parentx          : TCustomEdit    read FEdit       write SetComponent;
    property Title            : String         read FTitle      write FTitle;
    property Types            : TCustomType    read FKind       write FKind;
    property TrackValue       : Single         read FValue      write FValue;
    property ComboBoxSettings : TComboSettings read GetComboSet write SetComboSet;
    property TrackBarSettings : TTrackSettings read GetTrackSet write SetTrackSet;
    property EditSettings     : TEditSettings  read GetEditSet  write SetEditSet;
    property BackgroundColor  : TAlphaColor    read GetColor    write SetColor default TAlphaColorRec.Black;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Android', [TCustomDialogs]);
end;

{ TCustomDialogs }

procedure TCustomDialogs.ClosePopup(Sender: TObject);
begin
  if Assigned(FCom) then
    if FCom.ItemIndex <> -1 then
      FComboSetting.ItemIndex := FCom.ItemIndex;
end;

constructor TCustomDialogs.Create(AOwner: TComponent);
begin
  inherited;
  FForm := AOwner AS TForm;
  FComboSetting := TComboSettings.Create;
  FTrackSetting := TTrackSettings.Create;
  FEditSettings := TEditSettings.Create;
end;

destructor TCustomDialogs.Destroy;
begin
  FComboSetting.Free;
  FTrackSetting.Free;
  FEditSettings.Free;
  FreeNil;
  inherited;
end;

procedure TCustomDialogs.Execute;
begin
  BG := TRectangle.Create(FForm);
  with Bg do
  begin
    Parent     := FForm AS TForm;
    Align      := TAlignLayout.Contents;
    Fill.Color := TAlphaColorRec.Black;
    Opacity    := 0.5;
    Sides      := [];

    Center := TRectangle.Create(FForm);
    with Center do
    begin
      Parent       := FForm AS TForm;
      Height       := 164;
      Width        := 270;
      Stroke.Color := $FFB1B1B1;
      Fill.Color   := TAlphaColorRec.Black;//FColor
      Align        := TAlignLayout.None;
      Position.Y   := ((FForm.Height / 2){/ 2}) - 164;
      Position.X   := (FForm.Width / 2) - 135;

      Baslik := TText.Create(Center);
      with Baslik do
      begin
        Parent       := Center;
        Text         := Title;
        Align        := TAlignLayout.Top;
        Height       := 50;
        Margins.Left := 10;
        HorzTextAlign := TTextAlign.Leading;
        with TextSettings do
        begin
          FontColor := TAlphaColorRec.White;
          Font.Size := 20;
        end;
      end;

      Bot := TRectangle.Create(Center);
      with Bot do
      begin
        Parent       := Center;
        Align        := TAlignLayout.Bottom;
        Fill.Color   := $FFC3C3C3;
        Sides        := [];
        Height       := 50;

        IptalBut := TButton.Create(Bot);
        with IptalBut do
        begin
          Parent  := Bot;
          Align   := TAlignLayout.Left;
          Text    := '�ptal';
          Height  := 45;
          Width   := 129;
          OnClick := IptalClick;
          with Margins do
          begin
            Left   := 3;
            Top    := 3;
            Bottom := 3;
          end;
        end;

        TamamBut := TButton.Create(Bot);
        with TamamBut do
        begin
          Parent  := Bot;
          Align   := TAlignLayout.Left;
          Text    := 'Tamam';
          Height  := 45;
          Width   := 129;
          OnClick := TamamClick;
          with Margins do
          begin
            Left   := 3;
            Top    := 3;
            Bottom := 3;
          end;
        end;

        Lay := TLayout.Create(Center);
        with Lay do
        begin
          Parent := Center;
          Align := TAlignLayout.Client;

          IC := TRectangle.Create(Lay);
          with IC do
          begin
            Parent     := Lay;
            Align      := TAlignLayout.Center;
            Height     := 40;
            Width      := 233;
            Fill.Color := $FFE0E0E0;
            XRadius    := 6;
            YRadius    := 6;

            if FKind = TCustomType.Edit then
            begin
              FRes := TEdit.Create(IC);
              with FRes do
              begin
                Parent   := IC;
                Align    := TAlignLayout.Client;
                with Margins Do
                begin
                  Left  := 5;
                  Right := 5;
                end;
              end;
            end else
            if FKind = TCustomType.ComboBox then
            begin
              FCom := TComboBox.Create(IC);
              with FCom do
              begin
                Parent        := IC;
                Align         := TAlignLayout.Client;
                if Items.Count > 0 then
                  Items.Clear;
                Items.Assign(FComboSetting.FItems);
                FComboSetting.FCombo := FCom;
                OnClosePopup  := ClosePopup;
                with Margins Do
                begin
                  Left  := 5;
                  Right := 5;
                end;
              end;
            end else
            begin
              FTrack := TTrackBar.Create(IC);
              with FTrack do
              begin
                Parent  := IC;
                Align   := TAlignLayout.Top;
                with Margins Do
                begin
                  Left  := 5;
                  Right := 5;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TCustomDialogs.FClick(Sender: TObject);
begin
  Inherited;
  Execute;
  Parentx.ClearSelection;

  if FKind = TCustomType.Edit then
  begin
    FRes.Text := FEdit.Text;
    FRes.SetFocus;
  end else
  if FKind = TCustomType.ComboBox then
  begin
    if FComboSetting.FItems.Count = 0 then
      raise EActionError.CreateFMT('Combobox items not found!', ['']);

    if FCom.Items.IndexOf(Parentx.Text) > 0 then
      FCom.ItemIndex := FCom.Items.IndexOf(Parentx.Text)
    else
      FCom.ItemIndex := -1;

    FCom.SetFocus;
  end else
  if FKind = TCustomType.TrackBar then
    FTrack.Value := FValue;
end;

procedure TCustomDialogs.FreeNil;
begin
  if Assigned(BG) then
    if BG.Visible then
      BG.Visible := False;

  if Assigned(Center) then
    if Center.Visible then
      Center.Visible := False;

  if FKind = TCustomType.ComboBox then
    if Assigned(FCom) then FCom.Free;

  if FKind = TCustomType.Edit then
    if Assigned(FRes) then FRes.Free;

  if FKind = TCustomType.TrackBar then
    if Assigned(FTrack) then FTrack.Free;

  TamamBut.Free;
  IptalBut.Free;

  IC.Free;
  Lay.Free;
  Bot.Free;
  Center.Free;
  BG.Free;
end;

function TCustomDialogs.GetColor: TAlphaColor;
begin
  Result := FColor;
end;

function TCustomDialogs.GetComboSet: TComboSettings;
begin
  Result := FComboSetting;
end;

function TCustomDialogs.GetComboSetting: TComboSettings;
begin
  Result := FComboSetting;
end;

function TCustomDialogs.GetEditSet: TEditSettings;
begin
  Result := FEditSettings;
end;

function TCustomDialogs.GetTrackSet: TTrackSettings;
begin
  Result := FTrackSetting;
end;

procedure TCustomDialogs.IptalClick(Sender: TObject);
begin
  ResultText := '';
  FreeNil;
end;

procedure TCustomDialogs.SetColor(const Value: TAlphaColor);
begin
  if FColor <> Value then
    FColor := Value;
end;

procedure TCustomDialogs.SetComboSet(const Value: TComboSettings);
begin
  if FComboSetting <> Value then
    FComboSetting := Value;
end;

procedure TCustomDialogs.SetComboSetting(const Value: TComboSettings);
begin
  if FComboSetting <> Value then
    FComboSetting := Value;
end;

procedure TCustomDialogs.SetComponent(const Value: TCustomEdit);
begin
  if Value <> nil then
    if Value <> FEdit then
    begin
      FEdit := Value;
      FEdit.OnClick := FClick;
    end
  else
    FEdit := nil;
end;

procedure TCustomDialogs.SetEditSet(const Value: TEditSettings);
begin
  if FEditSettings <> Value then
    FEditSettings := Value;
end;

procedure TCustomDialogs.SetTrackSet(const Value: TTrackSettings);
begin
  if FTrackSetting <> Value then
    FTrackSetting := Value;
end;

procedure TCustomDialogs.TamamClick(Sender: TObject);
begin
  BG.Visible     := False;
  Center.Visible := False;

  if FKind = TCustomType.Edit then
    if ResultText <> FRes.Text then
    begin
      ResultText := FRes.Text;
      FEdit.Text := ResultText;
    end;

  if FKind = TCustomType.ComboBox then
  begin
    if FCom.Selected <> nil then
      if ResultText <> FCom.Selected.Text then
      begin
        if FCom.ItemIndex <> -1 then
        begin
          ResultText := FCom.Selected.Text;
          if FComboSetting.ReturnText then
            FEdit.Text := ResultText;
        end
      end;
  end;

  if FKind = TCustomType.TrackBar then
  begin
    if FValue <> FTrack.Value then
      FValue := FTrack.Value;

    if FTrackSetting.ReturnText then
      FEdit.Text := FValue.ToString;
  end;
  FreeNil;
end;

{ TComboSettings }

procedure TComboSettings.Assign(Source: TPersistent);
var
  xItems: TStringList;
  xIndex: Integer;
begin
  if (Source is TComboSettings) and (not Assigned(Source)) then
  begin
    if Assigned(Source) then
    begin
      xItems.Assign(TComboSettings(Source).FItems);
      xIndex := TComboSettings(Source).FIndex;
    end else
    begin
      FItems.Assign(TComboSettings(Source).FItems);
      FIndex := TComboSettings(Source).FIndex;
    end;

    if (FItems <> xItems) or
       (FIndex <> xIndex) then
    begin
      FItems.Assign(xItems);
      FIndex := xIndex;
    end;
  end else
    inherited;
end;

constructor TComboSettings.Create;
begin
  FItems := TStringList.Create;
  FReturn := True;
end;

destructor TComboSettings.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TComboSettings.GetIndex: Integer;
begin
  if FCombo <> nil then
    Result := FCombo.ItemIndex
  else
    Result := -1;
end;

procedure TComboSettings.SetWrite(const Value: TStringList);
begin
  FItems.Assign(Value);
end;

{ TTrackSettings }

procedure TTrackSettings.Assign(Source: TPersistent);
var
  xValue,
  xMax,
  xMin: Single;
begin
  if (Source is TTrackSettings) and (not Assigned(Source)) then
  begin
    if Assigned(Source) then
    begin
      xValue :=(TTrackSettings(Source).FValue);
      xMax   :=(TTrackSettings(Source).FMax);
      xMin   :=(TTrackSettings(Source).FMin);
    end else
    begin
      FMin   := TTrackSettings(Source).FMin;
      FMax   := TTrackSettings(Source).FMax;
      FValue := TTrackSettings(Source).FValue;
    end;

    if (FMin <> FMin) or
       (FMax <> FMax) or
       (FValue <> FValue)  then
    begin
      FMin   := xMin;
      FMax   := xMax;
      FValue := xValue;
    end;
  end else
    inherited;
end;

constructor TTrackSettings.Create;
begin
  FReturn := True;
end;

destructor TTrackSettings.Destroy;
begin

  inherited;
end;

procedure TTrackSettings.SetWrite(const Value: Single);
begin
  if FValue <> Value then
    if Value > FMax then
      raise EActionError.CreateFMT('This value bigger from Maximum value', [''])
    else
      FValue := Value;
end;

{ TEditSettings }

procedure TEditSettings.Assign(Source: TPersistent);
var
  xText: String;
begin
  if (Source is TEditSettings) and (not Assigned(Source)) then
  begin
    if Assigned(Source) then
    begin
      xText :=(TEditSettings(Source).FText);
    end else
    begin
      FText   := TEditSettings(Source).FText;
    end;

    if (FText <> FText)  then
    begin
      FText := xText;
    end;
  end else
    inherited;
end;

constructor TEditSettings.Create;
begin
end;

destructor TEditSettings.Destroy;
begin
  inherited;
end;

end.
