{*
 * Object Tree: Object tree written in Pascal/Delphi
 * Jonas Raoni Soares da Silva <http://raoni.org>
 * https://github.com/jonasraoni/object-tree
 *}

unit ObjectTree;

interface

uses
  SysUtils, Classes;

type
  TObjectTree = class;

  TObjectTree = class
  private
    FData: TObject;
    FOwner: TObjectTree;
    FList: TList;
    FOwnData: Boolean;

    function GetItem(const Index: Integer): TObjectTree;
    function GetCount: Integer;
    function GetObject(const Index: Integer): TObject;

  public
    constructor Create( const AOwnData: Boolean = False ); overload;
    constructor Create( AOwner: TObjectTree; const AOwnData: Boolean = False ); overload;
    destructor Destroy; override;

    property Data: TObject read FData write FData;
    property Owner: TObjectTree read FOwner;
    property Items[ const Index: Integer ]: TObjectTree read GetItem; default;
    property Objects[ const Index: Integer ]: TObject read GetObject;
    property Count: Integer read GetCount;
    property OwnData: Boolean read FOwnData write FOwnData;

    function Add( AObject: TObject ): Integer;

    procedure Insert( AObject: TObject; const Index: Integer );
    procedure Move( const CurIndex, NewIndex: Integer );
    procedure Exchange( const OldIndex, NewIndex: Integer );
    procedure Delete( const Index: Integer);
    procedure Clear;
  end;

implementation

{ TObjectTree }

function TObjectTree.Add( AObject: TObject ): Integer;
begin
  TObjectTree( FList[ FList.Add( TObjectTree.Create( Self, FOwnData ) ) ] ).Data := AObject;
end;

procedure TObjectTree.Clear;
begin
  while FList.Count > 0 do
    Delete( 0 );
end;

constructor TObjectTree.Create( AOwner: TObjectTree; const AOwnData: Boolean );
begin
  FOwner := AOwner;
  Create( AOwnData );
end;

constructor TObjectTree.Create( const AOwnData: Boolean );
begin
  FOwnData := AOwnData;
  FList := TList.Create;
end;

procedure TObjectTree.Delete(const Index: Integer);
begin
  try
    with Items[ Index ] do begin
      if OwnData and Assigned( Data ) then
        Data.Free;
      Free;
    end;
    FList.Delete( Index );
  except
    raise Exception.Create( ClassName + '.Delete :: Error while removing the item.' );
  end;
end;

destructor TObjectTree.Destroy;
begin
  if FOwnData and Assigned( FData ) then
    FData.Free;
  Clear;
  FList.Free;
  inherited;
end;

procedure TObjectTree.Exchange(const OldIndex, NewIndex: Integer);
begin
  FList.Exchange( OldIndex, NewIndex );
end;

function TObjectTree.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TObjectTree.GetItem(const Index: Integer): TObjectTree;
begin
  Result := FList[ Index ];
end;

function TObjectTree.GetObject(const Index: Integer): TObject;
begin
  Result := Items[ Index ];
  if Assigned( Result ) then
    Result := TObjectTree( Result ).Data;
end;

procedure TObjectTree.Insert( AObject: TObject; const Index: Integer);
begin
  FList.Insert( Index, TObjectTree.Create( Self, FOwnData ) );
  TObjectTree( FList[ Index ] ).Data := AObject;
end;

procedure TObjectTree.Move(const CurIndex, NewIndex: Integer);
begin
  FList.Move( CurIndex, NewIndex );
end;

end.