{$mode objfpc}
program fbauditor;
{    $Id: fbauditor,v 1.0.1 2005/07/03 07:35:05 Juan Carbajal $
    (c) 2005,2006,2007 Juan Carbajal Paxi (juancarbajal@gmail.com)
    Auditor de Base de Datos Firebird 
 ********************************************************************** 
Modificar Zeos.inc y añadir $mode delphi
Licencia GPL v2.1
}
{$ifdef unix}
 {$ifndef BSD}
  {$linklib dl}
 {$Endif}
{$linklib crypt}
{$Endif}

{$IFDEF FREEBSD}
  {$DEFINE UNIX}
{$ENDIF}

{$IFDEF LINUX}
  {$DEFINE UNIX}
{$ENDIF}

Uses
SysUtils,Classes,
db,
{$IFDEF UNIX} //Linux
ZConnection in 'zeoslib/component/ZConnection',

ZDbcDbLib in 'zeoslib/dbc/ZDbcDbLib',
ZSysUtils in 'zeoslib/core/ZSysUtils',
ZClasses in 'zeoslib/core/ZClasses',
ZVariant in 'zeoslib/core/ZVariant',
ZCollections in 'zeoslib/core/ZCollections',
ZTokenizer in 'zeoslib/core/ZTokenizer',
ZSelectSchema in 'zeoslib/parsesql/ZSelectSchema',
ZGenericSqlAnalyser in 'zeoslib/parsesql/ZGenericSqlAnalyser',
ZGenericSqlToken in 'zeoslib/parsesql/ZGenericSqlToken',
ZPlainDbLibDriver in 'zeoslib/plain/ZPlainDbLibDriver',
ZSybaseToken in 'zeoslib/parsesql/ZSybaseToken',
ZSybaseAnalyser in 'zeoslib/parsesql/ZSybaseAnalyser',
ZDbcMySql in 'zeoslib/dbc/ZDbcMySql',
ZPlainMySqlDriver in 'zeoslib/plain/ZPlainMySqlDriver',
ZMySqlToken in 'zeoslib/parsesql/ZMySqlToken',
ZMySqlAnalyser in 'zeoslib/parsesql/ZMySqlAnalyser',

ZDbcPostgreSql in 'zeoslib/dbc/ZDbcPostgreSql',
ZPlainPostgreSqlDriver in 'zeoslib/plain/ZPlainPostgreSqlDriver',
ZPostgreSqlToken in 'zeoslib/parsesql/ZPostgreSqlToken',
ZPostgreSqlAnalyser in 'zeoslib/parsesql/ZPostgreSqlAnalyser',

ZDbcInterbase6 in 'zeoslib/dbc/ZDbcInterbase6',
ZPlainInterbaseDriver in 'zeoslib/plain/ZPlainInterbaseDriver',
ZInterbaseToken in 'zeoslib/parsesql/ZInterbaseToken',
ZInterbaseAnalyser in 'zeoslib/parsesql/ZInterbaseAnalyser',
ZPlainFirebirdDriver in 'zeoslib/plain/ZPlainFirebirdDriver',

ZDbcSqLite in 'zeoslib/dbc/ZDbcSqLite',
ZPlainSqLiteDriver in 'zeoslib/plain/ZPlainSqLiteDriver',
ZSqLiteToken in 'zeoslib/parsesql/ZSqLiteToken',
ZSqLiteAnalyser in 'zeoslib/parsesql/ZSqLiteAnalyser',

ZDbcOracle in 'zeoslib/dbc/ZDbcOracle',
ZPlainOracleDriver in 'zeoslib/plain/ZPlainOracleDriver',
ZOracleToken in 'zeoslib/parsesql/ZOracleToken',
ZOracleAnalyser in 'zeoslib/parsesql/ZOracleAnalyser',

ZDbcASA in 'zeoslib/dbc/ZDbcASA',
ZPlainASADriver in 'zeoslib/plain/ZPlainASADriver',
ZExpression in 'zeoslib/core/ZExpression',

ZDataset in 'zeoslib/component/ZDataset';
{$ELSE} //Windows
ZConnection in 'zeoslib\component\ZConnection',

ZDbcDbLib in 'zeoslib\dbc\ZDbcDbLib',
ZSysUtils in 'zeoslib\core\ZSysUtils',
ZClasses in 'zeoslib\core\ZClasses',
ZVariant in 'zeoslib\core\ZVariant',
ZCollections in 'zeoslib\core\ZCollections',
ZTokenizer in 'zeoslib\core\ZTokenizer',
ZSelectSchema in 'zeoslib\parsesql\ZSelectSchema',
ZGenericSqlAnalyser in 'zeoslib\parsesql\ZGenericSqlAnalyser',
ZGenericSqlToken in 'zeoslib\parsesql\ZGenericSqlToken',
ZPlainDbLibDriver in 'zeoslib\plain\ZPlainDbLibDriver',
ZSybaseToken in 'zeoslib\parsesql\ZSybaseToken',
ZSybaseAnalyser in 'zeoslib\parsesql\ZSybaseAnalyser',
ZDbcMySql in 'zeoslib\dbc\ZDbcMySql',
ZPlainMySqlDriver in 'zeoslib\plain\ZPlainMySqlDriver',
ZMySqlToken in 'zeoslib\parsesql\ZMySqlToken',
ZMySqlAnalyser in 'zeoslib\parsesql\ZMySqlAnalyser',

ZDbcPostgreSql in 'zeoslib\dbc\ZDbcPostgreSql',
ZPlainPostgreSqlDriver in 'zeoslib\plain\ZPlainPostgreSqlDriver',
ZPostgreSqlToken in 'zeoslib\parsesql\ZPostgreSqlToken',
ZPostgreSqlAnalyser in 'zeoslib\parsesql\ZPostgreSqlAnalyser',

ZDbcInterbase6 in 'zeoslib\dbc\ZDbcInterbase6',
ZPlainInterbaseDriver in 'zeoslib\plain\ZPlainInterbaseDriver',
ZInterbaseToken in 'zeoslib\parsesql\ZInterbaseToken',
ZInterbaseAnalyser in 'zeoslib\parsesql\ZInterbaseAnalyser',
ZPlainFirebirdDriver in 'zeoslib\plain\ZPlainFirebirdDriver',

ZDbcSqLite in 'zeoslib\dbc\ZDbcSqLite',
ZPlainSqLiteDriver in 'zeoslib\plain\ZPlainSqLiteDriver',
ZSqLiteToken in 'zeoslib\parsesql\ZSqLiteToken',
ZSqLiteAnalyser in 'zeoslib\parsesql\ZSqLiteAnalyser',

ZDbcOracle in 'zeoslib\dbc\ZDbcOracle',
ZPlainOracleDriver in 'zeoslib\plain\ZPlainOracleDriver',
ZOracleToken in 'zeoslib\parsesql\ZOracleToken',
ZOracleAnalyser in 'zeoslib\parsesql\ZOracleAnalyser',

ZDbcASA in 'zeoslib\dbc\ZDbcASA',
ZPlainASADriver in 'zeoslib\plain\ZPlainASADriver',
ZExpression in 'zeoslib\core\ZExpression',

ZDataset in 'zeoslib\component\ZDataset';
{$ENDIF}
const

{$IFDEF UNIX}
	ENDLINE=#10;
{$ELSE}
	ENDLINE=#10#13;
{$ENDIF}
	FBAUDITOR_TABLENAME='FA_TA_AUDITOR';
	QTABLES='select rdb$relation_name as tabla from rdb$relations where rdb$relation_name not like ''%RDB%'' and rdb$relation_name not like ''VW%'' and rdb$relation_name not like '''+FBAUDITOR_TABLENAME+'%'' order by rdb$relation_name';
	QPRIMARY='SELECT I.RDB$Field_NAME FROM RDB$INDICES T, RDB$INDEX_SEGMENTS I WHERE (T.RDB$INDEX_NAME LIKE ''RDB$PRIMARY%%'' OR T.RDB$INDEX_NAME LIKE ''%%PK_%%'') AND T.RDB$INDEX_NAME=I.RDB$INDEX_NAME AND RDB$RELATION_NAME=''%s''';
	QEMPTY='select * from %s where user='''';';
	
	FBAUDITOR_TABLE:WideString='Create table '+FBAUDITOR_TABLENAME+'('+ENDLINE+'VC_TABLA varchar(32),'+ENDLINE+'VC_CAMPO varchar(32),'+ENDLINE+'CH_ACCION char(1),'+ENDLINE+'VC_USUARIO varchar(128) default CURRENT_USER,'+ENDLINE+'DA_FEC_REGISTRO timestamp default ''now'','+ENDLINE+'VC_LLAVES varchar(255),'+ENDLINE+'VC_VAL_ANT varchar(255),'+ENDLINE+'VC_VAL_POST varchar(255),'+ENDLINE+'VC_COD_MAQUINA varchar(20));'+ENDLINE;
	FBAUDITOR_INSERT='INSERT INTO '+FBAUDITOR_TABLENAME+'(VC_TABLA, VC_CAMPO, CH_ACCION, VC_LLAVES, VC_VAL_ANT, VC_VAL_POST)'+ENDLINE+'VALUES( ''%s'',''%s'',''%s'',%s,%s,%s);'+ENDLINE;
Type
	TTypeRestrict=set of TFieldType;
	TFbAuditor=class	
	OutputFile:String;	
	CodSistema:String;
	TypeRestrict:TTypeRestrict;	
	Constructor Create(AHost:String;ADatabaseName:string;AUserName:string;APassword:string;AOutputFile:String);
	Destructor Destroy;override;
	Procedure Run;
	Protected	
	Db:TZConnection;
	//Trans:TJvUIBTransaction;
	Tables:TZQuery;
	Procedure WriteLine(Line:WideString);	
	Private
	F:System.Text;
	Procedure OpenFile;
	Procedure CloseFile;		
	End;
const TypeRestrict:TTypeRestrict=[ftBlob, ftGraphic, ftFmtMemo, ftUnknown, ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor, ftADT, ftReference, ftArray, ftOraBlob, ftOraClob, ftIDispatch, ftGuid, ftFMTBcd];
constructor tfbAuditor.Create(AHost:string;ADatabaseName:string;AUsername:string;APassword:string;AOutputFile:String);
begin
	DB:=TZConnection.Create(nil);
	with DB do
	begin
		Protocol:='firebird-1.5';//1.0 2.0
		Hostname:=AHost;
		Database:=ADatabaseName;
		User:=AUserName;
		Password:=APassword;
		Readonly:=true;
	end;
	DB.Connect();	
	DB.DisConnect();
	
	Tables:=TZQuery.Create(nil);
	Tables.Connection:=DB;
	Tables.SQL.Text:=QTABLES;
	Tables.Open();

	OutputFile:=AOutputFile;	
end;
destructor TFbAuditor.Destroy;
begin	
	Tables.Close();	
	Db.Disconnect();
	inherited Destroy;
end;
Procedure TFbAuditor.OpenFile;
Begin
	Assign(F,OutputFile);
	Rewrite(F);
End;
Procedure TFbAuditor.CloseFile;
Begin
	Close(F);
End;
Procedure TFbAuditor.WriteLine(Line:WideString);
Begin
	Writeln(F,Line);
End;
Procedure TFbAuditor.Run;
var 
Query,Primary:TZQuery;
ProcesoInsert,ProcesoDelete,ProcesoUpdate:WideString;
ProcesoPrimary,ProcesoPrimaryDelete:String;
PrimaryField:String;
TableName:string;
i:integer;
Begin
	OpenFile;
	Query:=TZQuery.Create(nil);  
	Query.Connection:=DB;  

	Primary:=TZQuery.Create(nil);
	Primary.Connection:=Db;

	If (Db.Connected) Then
	Begin	
		WriteLine(FBAUDITOR_TABLE);
		WriteLine('SET TERM !!;');		
		While (Not Tables.EOF) do //Todas las Tablas
		Begin
			TableName:=Trim(Tables.Fields[0].AsString);
			Try
			ProcesoInsert:='';
			ProcesoDelete:='';
			ProcesoUpdate:='';
			ProcesoPrimary:='';
			ProcesoPrimaryDelete:='';
			
			Primary.Close;	
			Primary.Sql.Text:=Format(QPRIMARY,[TableName]);
			Primary.Open;
			//writeln(Primary.Sql.Text);
			While (Not Primary.EOF) do
			Begin
				PrimaryField:=trim(Primary.Fields[0].AsString);				
				ProcesoPrimary:=ProcesoPrimary+''''+PrimaryField+'=''||NEW.'+PrimaryField+'||'',''||';				
				ProcesoPrimaryDelete:=ProcesoPrimaryDelete+''''+PrimaryField+'=''||OLD.'+PrimaryField+'||'',''||';	
				Primary.Next;
			End; //While
			ProcesoPrimary:=copy(ProcesoPrimary,1,length(ProcesoPrimary)-7);
			ProcesoPrimaryDelete:=copy(ProcesoPrimaryDelete,1,length(ProcesoPrimaryDelete)-7);
			//Writeln(ProcesoPrimary);

			Query.Close;
			Query.Sql.Text:=Format(QEMPTY,[TableName]);
			Query.Open;
			For i:=0 To Query.FieldCount-1 Do //Para todos los campos de la consulta
			Begin
				If (not (Query.Fields[i].DataType in TypeRestrict)) Then //Para los campos q no son Blob
				Begin
					ProcesoInsert:=ProcesoInsert+'IF (NEW.'+Query.Fields[i].FieldName+' IS NOT NULL) THEN'+ENDLINE
					+Format(FBAUDITOR_INSERT,[TableName, Query.Fields[i].FieldName,'I',ProcesoPrimary,'NULL','NEW.'+Query.Fields[i].FieldName ]);

					ProcesoUpdate:=ProcesoUpdate+'IF (NEW.'+Query.Fields[i].FieldName+'<>OLD.'+Query.Fields[i].FieldName+') THEN '+ENDLINE
					+Format(FBAUDITOR_INSERT,[TableName, Query.Fields[i].FieldName,'U',ProcesoPrimary,'OLD.'+Query.Fields[i].FieldName ,'NEW.'+Query.Fields[i].FieldName]);	
				End; //IF	
			End; //For
			ProcesoDelete:=ProcesoDelete+Format(FBAUDITOR_INSERT,[TableName, '','D',ProcesoPrimaryDelete,'NULL' ,'NULL']);
			
			WriteLine('CREATE TRIGGER FA_TG_'+TableName+'_AI FOR '+TableName+' AFTER INSERT POSITION 100 AS'+ENDLINE+'BEGIN'+ENDLINE+ProcesoInsert+ENDLINE+'END!!'+ENDLINE);	
			WriteLine('CREATE TRIGGER FA_TG_'+TableName+'_AU FOR '+TableName+' AFTER UPDATE POSITION 100 AS'+ENDLINE+'BEGIN'+ENDLINE+ProcesoUpdate+ENDLINE+'END!!'+ENDLINE);
			WriteLine('CREATE TRIGGER FA_TG_'+TableName+'_AD FOR '+TableName+' AFTER DELETE POSITION 100 AS'+ENDLINE+'BEGIN'+ENDLINE+ProcesoDelete+ENDLINE+'END!!'+ENDLINE);
			Except
				On E:Exception do writeln(E.Message);
			End;
			Tables.Next;
		End;//While
		WriteLine('SET TERM ;!!')
	End;
	CloseFile;
end;
var 
Auditor:TFbAuditor;
Host:String;
Filename:String;
Username:String;
Password:String;
Begin
Writeln('FBAuditor 1.0.1');
Writeln('By Juan Carbajal (juancarbajal@gmail.com)');
Writeln('GPL v2.1 License');
Write('Host...:');Readln(Host);
Write('Database...:');Readln(Filename);
Write('Username...:');Readln(Username);
Write('Password...:');Readln(Password);
Auditor:=TFbAuditor.Create(Host,Filename,Username,Password,'fbauditor.sql');
Auditor.Run;
Writeln('Generate...: fbauditor.sql');
Auditor.Destroy;	
End.
