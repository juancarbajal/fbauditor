{*********************************************************}
{                                                         }
{                 Zeos Database Objects                   }
{              Database Sequence Component                }
{                                                         }
{        Originally written by Stefan Glienke             }
{                                                         }
{*********************************************************}

{@********************************************************}
{    Copyright (c) 1999-2006 Zeos Development Group       }
{                                                         }
{ License Agreement:                                      }
{                                                         }
{ This library is distributed in the hope that it will be }
{ useful, but WITHOUT ANY WARRANTY; without even the      }
{ implied warranty of MERCHANTABILITY or FITNESS FOR      }
{ A PARTICULAR PURPOSE.  See the GNU Lesser General       }
{ Public License for more details.                        }
{                                                         }
{ The source code of the ZEOS Libraries and packages are  }
{ distributed under the Library GNU General Public        }
{ License (see the file COPYING / COPYING.ZEOS)           }
{ with the following  modification:                       }
{ As a special exception, the copyright holders of this   }
{ library give you permission to link this library with   }
{ independent modules to produce an executable,           }
{ regardless of the license terms of these independent    }
{ modules, and to copy and distribute the resulting       }
{ executable under terms of your choice, provided that    }
{ you also meet, for each linked independent module,      }
{ the terms and conditions of the license of that module. }
{ An independent module is a module which is not derived  }
{ from or based on this library. If you modify this       }
{ library, you may extend this exception to your version  }
{ of the library, but you are not obligated to do so.     }
{ If you do not wish to do so, delete this exception      }
{ statement from your version.                            }
{                                                         }
{                                                         }
{ The project web site is located on:                     }
{   http://zeos.firmos.at  (FORUM)                        }
{   http://zeosbugs.firmos.at (BUGTRACKER)                }
{   svn://zeos.firmos.at/zeos/trunk (SVN Repository)      }
{                                                         }
{   http://www.sourceforge.net/projects/zeoslib.          }
{   http://www.zeoslib.sourceforge.net                    }
{                                                         }
{                                                         }
{                                                         }
{                                 Zeos Development Group. }
{********************************************************@}

unit ZSequence;

interface

{$I ZComponent.inc}

uses
  SysUtils, Classes, ZDbcIntfs, ZConnection;

type
  {** Represents a component which wraps a sequence to database. }
  TZSequence = class(TComponent)
  private
    FSequence: IZSequence;
    FConnection: TZConnection;
    FSequenceName: string;
    FBlockSize: Integer;
    procedure SetConnection(const Value: TZConnection);
    procedure SetBlockSize(const Value: Integer);
    procedure SetSequenceName(const Value: string);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function GetSequence: IZSequence;
  public
    constructor Create(AOwner: TComponent); override;

    function GetCurrentValue: Int64;
    function GetNextValue: Int64;
    function  GetCurrentValueSQL: string; // Get the Sequence as SQL-Text
    function  GetNextValueSQL: string;   // Get the Sequence as SQL-Text

  published
    property BlockSize: Integer read FBlockSize write SetBlockSize default 1;
    property Connection: TZConnection read FConnection write SetConnection;
    property SequenceName: string read FSequenceName write SetSequenceName;
  end;

implementation

{ TZSequence }

constructor TZSequence.Create(AOwner: TComponent);
begin
  inherited;
  FBlockSize := 1;
end;

{**
  Gets the current unique key generated by this sequence.
  @param the next generated unique key.
}
function TZSequence.GetCurrentValue: Int64;
begin
  GetSequence;
  if Assigned(FSequence) then
    Result := FSequence.GetCurrentValue
  else
    Result := 0;
end;

function TZSequence.GetCurrentValueSQL: string;
begin
  GetSequence;
  if Assigned(FSequence) then begin
    Result := FSequence.GetCurrentValueSQL;
  end else begin
    Result := 'IMPLEMENT';
  end;
end;

{**
  Gets the next unique key generated by this sequence.
  @param the next generated unique key.
}
function TZSequence.GetNextValue: Int64;
begin
  GetSequence;
  if Assigned(FSequence) then
    Result := FSequence.GetNextValue
  else
    Result := 0;
end;

function TZSequence.GetNextValueSQL: string;
begin
  GetSequence;
  if Assigned(FSequence) then begin
    Result := FSequence.GetNextValueSQL;
  end else begin
    Result := 'IMPLEMENT';
  end;
end;

function TZSequence.GetSequence: IZSequence;
begin
  if not Assigned(FSequence) then
  begin
    if Assigned(FConnection) and Assigned(FConnection.DbcConnection) then
      FSequence := FConnection.DbcConnection.CreateSequence(
        FSequenceName, FBlockSize);
  end;
  Result := FSequence;
end;

{**
  Processes component notifications.
  @param AComponent a changed component object.
  @param Operation a component operation code.
}
procedure TZSequence.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (AComponent = FConnection) then
  begin
    FConnection := nil;
    FreeAndNil(FSequence);
  end;
end;

procedure TZSequence.SetBlockSize(const Value: Integer);
begin
  FBlockSize := Value;
  GetSequence;
  if Assigned(FSequence) then
    FSequence.SetBlockSize(FBlockSize);
end;

procedure TZSequence.SetConnection(const Value: TZConnection);
begin
  if FConnection <> Value then
  begin
    if Assigned(FSequence) then
      FSequence := nil;
    FConnection := Value;
    GetSequence;
  end;
end;

procedure TZSequence.SetSequenceName(const Value: string);
begin
  FSequenceName := Value;
  GetSequence;
  if Assigned(FSequence) then
    FSequence.SetName(FSequenceName);
end;

end.
