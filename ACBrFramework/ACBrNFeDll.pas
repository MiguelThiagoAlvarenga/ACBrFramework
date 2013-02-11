unit ACBrNFeDll;

{$mode delphi}

interface

uses
  Classes,
  ACBrNFe,
  pcnConversao,
  ACBrNFeNotasFiscais,
  SysUtils;

type TEventHandlersNFE = class
end;

{Handle para o componente TACBrNFE}
type TNFEHandle = record
  UltimoErro : String;
  NFE : TACBrNFE;
  EventHandlers : TEventHandlersNFE;
end;

type TNFHandle = record
  UltimoErro : String;
  NF : NotaFiscal;
  NFEHandle : ^TNFEHandle;
end;

{Ponteiro para o Handle }
type PNFEHandle = ^TNFEHandle;
type PNFHandle = ^TNFHandle;

implementation

{%region Constructor/Destructor/Erro}
{
PADRONIZAÇÃO DAS FUNÇÕES:

        PARÂMETROS:
        Todas as funções recebem o parâmetro "handle" que é o ponteiro
        para o componente instanciado; Este ponteiro deve ser armazenado
        pela aplicação que utiliza a DLL;

        RETORNO:
        Todas as funções da biblioteca retornam um Integer com as possíveis Respostas:

                MAIOR OU IGUAL A ZERO: SUCESSO
                Outos retornos maior que zero indicam sucesso, com valor específico de cada função.

                MENOR QUE ZERO: ERROS

                  -1 : Erro ao executar;
                       Vide UltimoErro

                  -2 : ACBr não inicializado.

                  Outros retornos negativos indicam erro específico de cada função;

                  A função "UltimoErro" retornará a mensagem da última exception disparada pelo componente.
}


{
CRIA um novo componente TACBrNFE retornando o ponteiro para o objeto criado.
Este ponteiro deve ser armazenado pela aplicação que utiliza a DLL e informado
em todas as chamadas de função relativas ao TACBrNFE
}
Function NFE_Create(var nfeHandle: PNFEHandle): Integer; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF}  export;
begin

  try
     New(nfeHandle);
     nfeHandle^.NFE := TACBrNFE.Create(nil);
     nfeHandle^.EventHandlers := TEventHandlersNFE.Create();
     nfeHandle^.UltimoErro := '';
     Result := 0;
  except
     on exception : Exception do
     begin
        Result := -1;
        nfeHandle^.UltimoErro := exception.Message;
     end
  end;

end;

{
DESTRÓI o objeto TACBrNFE e libera a memória utilizada.
Esta função deve SEMPRE ser chamada pela aplicação que utiliza a DLL
quando o componente não mais for utilizado.
}
Function NFE_Destroy(var nfeHandle: PNFEHandle): Integer; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF}  export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try

    nfeHandle^.NFE.Destroy;
    nfeHandle^.NFE := nil;

    Dispose(nfeHandle);
    nfeHandle := nil;
    Result := 0;

  except
     on exception : Exception do
     begin
        Result := -1;
        nfeHandle^.UltimoErro := exception.Message;
     end
  end;

end;

Function NFE_GetUltimoErro(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.UltimoErro, BufferLen);
     Result := length(nfeHandle^.UltimoErro);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

{%endregion}

{%region Configurações }

{%region Geral}

Function NFE_CFG_Geral_GetFormaEmissao(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     Result := Integer(nfeHandle^.NFE.Configuracoes.Geral.FormaEmissao);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Geral_SetFormaEmissao(const nfeHandle: PNFEHandle;const value : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Geral.FormaEmissao := TpcnTipoEmissao(value);
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Geral_GetFormaEmissaoCodigo(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     Result := nfeHandle^.NFE.Configuracoes.Geral.FormaEmissaoCodigo;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Geral_GetSalvar(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     if nfeHandle^.NFE.Configuracoes.Geral.Salvar then
     Result := 1
     else
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Geral_SetSalvar(const nfeHandle: PNFEHandle;const value : Boolean) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Geral.Salvar := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Geral_GetAtualizarXMLCancelado(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     if nfeHandle^.NFE.Configuracoes.Geral.AtualizarXMLCancelado then
     Result := 1
     else
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Geral_SetAtualizarXMLCancelado(const nfeHandle: PNFEHandle;const value : Boolean) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Geral.AtualizarXMLCancelado := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Geral_GetPathSalvar(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.NFE.Configuracoes.Geral.PathSalvar, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Geral_SetPathSalvar(const nfeHandle: PNFEHandle;const value : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Geral.PathSalvar := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Geral_GetPathSchemas(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.NFE.Configuracoes.Geral.PathSchemas, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Geral_SetPathSchemas(const nfeHandle: PNFEHandle;const value : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Geral.PathSchemas := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Geral_GetIniFinXMLSECAutomatico(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     if nfeHandle^.NFE.Configuracoes.Geral.IniFinXMLSECAutomatico then
     Result := 1
     else
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Geral_SetIniFinXMLSECAutomatico(const nfeHandle: PNFEHandle;const value : Boolean) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Geral.IniFinXMLSECAutomatico := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Geral_Save(const nfeHandle: PNFEHandle;const AXMLName, AXMLFile, aPath : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
var
  ret : Boolean;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     ret := nfeHandle^.NFE.Configuracoes.Geral.Save(AXMLName, AXMLFile, aPath);
     if ret then
     Result := 1
     else
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

{%endregion}

{%region Arquivo}

Function NFE_CFG_Arquivos_GetAdicionarLiteral(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  try
     if (nfeHandle = nil) then
     begin
     Result := -2;
     Exit;
     end;

     if nfeHandle^.NFE.Configuracoes.Arquivos.AdicionarLiteral then
     Result := 1
     else
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_SetAdicionarLiteral(const nfeHandle: PNFEHandle;const value : Boolean) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  try
     if (nfeHandle = nil) then
     begin
     Result := -2;
     Exit;
     end;

     nfeHandle^.NFE.Configuracoes.Arquivos.AdicionarLiteral := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_GetEmissaoPathNFe(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  try
     if (nfeHandle = nil) then
     begin
     Result := -2;
     Exit;
     end;

     if nfeHandle^.NFE.Configuracoes.Arquivos.EmissaoPathNFe then
     Result := 1
     else
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_SetEmissaoPathNFe(const nfeHandle: PNFEHandle;const value : Boolean) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Arquivos.EmissaoPathNFe := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_GetSalvar(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     if nfeHandle^.NFE.Configuracoes.Arquivos.Salvar then
     Result := 1
     else
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_SetSalvar(const nfeHandle: PNFEHandle;const value : Boolean) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Arquivos.Salvar := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_GetPastaMensal(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     if nfeHandle^.NFE.Configuracoes.Arquivos.PastaMensal then
     Result := 1
     else
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_SetPastaMensal(const nfeHandle: PNFEHandle;const value : Boolean) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Arquivos.PastaMensal := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_GetPathNFe(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.NFE.Configuracoes.Arquivos.PathNFe, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_SetPathNFe(const nfeHandle: PNFEHandle;const value : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Arquivos.PathNFe := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_GetPathCan(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.NFE.Configuracoes.Arquivos.PathCan, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_SetPathCan(const nfeHandle: PNFEHandle;const value : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Arquivos.PathCan := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_GetPathInu(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.NFE.Configuracoes.Arquivos.PathInu, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_SetPathInu(const nfeHandle: PNFEHandle;const value : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Arquivos.PathInu := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_GetPathDPEC(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.NFE.Configuracoes.Arquivos.PathDPEC, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_SetPathDPEC(const nfeHandle: PNFEHandle;const value : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Arquivos.PathDPEC := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_GetPathCCe(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.NFE.Configuracoes.Arquivos.PathCCe, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_SetPathCCe(const nfeHandle: PNFEHandle;const value : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Arquivos.PathCCe := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_GetPathMDe(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.NFE.Configuracoes.Arquivos.PathMDe, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_SetPathMDe(const nfeHandle: PNFEHandle;const value : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Arquivos.PathMDe := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_GetPathEvento(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.NFE.Configuracoes.Arquivos.PathEvento, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_SetPathEvento(const nfeHandle: PNFEHandle;const value : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Arquivos.PathEvento := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_FGetPathCan(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
var
  strTemp : string;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     strTemp := nfeHandle^.NFE.Configuracoes.Arquivos.GetPathCan;
     StrPLCopy(Buffer, strTemp, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_FGetPathDPEC(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
var
  strTemp : string;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     strTemp := nfeHandle^.NFE.Configuracoes.Arquivos.GetPathDPEC;
     StrPLCopy(Buffer, strTemp, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_FGetPathInu(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
var
  strTemp : string;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     strTemp := nfeHandle^.NFE.Configuracoes.Arquivos.GetPathInu;
     StrPLCopy(Buffer, strTemp, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_FGetPathNFe(const nfeHandle: PNFEHandle;const value : Double ; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
var
  strTemp : string;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     strTemp := nfeHandle^.NFE.Configuracoes.Arquivos.GetPathNFe(value);
     StrPLCopy(Buffer, strTemp, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_FGetPathCCe(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
var
  strTemp : string;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     strTemp := nfeHandle^.NFE.Configuracoes.Arquivos.GetPathCCe;
     StrPLCopy(Buffer, strTemp, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_FGetPathMDe(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
var
  strTemp : string;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     strTemp := nfeHandle^.NFE.Configuracoes.Arquivos.GetPathMDe;
     StrPLCopy(Buffer, strTemp, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Arquivos_FGetPathEvento(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
var
  strTemp : string;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     strTemp := nfeHandle^.NFE.Configuracoes.Arquivos.GetPathEvento;
     StrPLCopy(Buffer, strTemp, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

{%endregion}

{%region Certificados}

Function NFE_CFG_Certificados_GetCertificado(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.NFE.Configuracoes.Certificados.Certificado, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Certificados_SetCertificado(const nfeHandle: PNFEHandle;const value : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Certificados.Certificado := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Certificados_GetSenha(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.NFE.Configuracoes.Certificados.Senha, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_Certificados_SetSenha(const nfeHandle: PNFEHandle;const value : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.Certificados.Senha := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

{%endregion}

{%region WebServices}

Function NFE_CFG_WebServices_GetVisualizar(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     if nfeHandle^.NFE.Configuracoes.WebServices.Visualizar then
     Result := 1
     else
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_SetVisualizar(const nfeHandle: PNFEHandle;const value : Boolean) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.WebServices.Visualizar := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_GetUF(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.NFE.Configuracoes.WebServices.UF, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_SetUF(const nfeHandle: PNFEHandle;const value : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.WebServices.UF := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_GetUFCodigo(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     Result := nfeHandle^.NFE.Configuracoes.WebServices.UFCodigo;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_GetAmbiente(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     Result := Integer(nfeHandle^.NFE.Configuracoes.WebServices.Ambiente);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_SetAmbiente(const nfeHandle: PNFEHandle; const value : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.WebServices.Ambiente := TpcnTipoAmbiente(value);
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_GetAmbienteCodigo(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     Result := nfeHandle^.NFE.Configuracoes.WebServices.AmbienteCodigo;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_GetProxyHost(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.NFE.Configuracoes.WebServices.ProxyHost, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_SetProxyHost(const nfeHandle: PNFEHandle; const value : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.WebServices.ProxyHost := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_GetProxyPort(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.NFE.Configuracoes.WebServices.ProxyPort, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_SetProxyPort(const nfeHandle: PNFEHandle; const value : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.WebServices.ProxyPort := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_GetProxyUser(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.NFE.Configuracoes.WebServices.ProxyUser, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_SetProxyUser(const nfeHandle: PNFEHandle; const value : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.WebServices.ProxyUser := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_GetProxyPass(const nfeHandle: PNFEHandle; Buffer : pChar; const BufferLen : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     StrPLCopy(Buffer, nfeHandle^.NFE.Configuracoes.WebServices.ProxyPass, BufferLen);
     Result := length(Buffer);
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_SetProxyPass(const nfeHandle: PNFEHandle; const value : pChar) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.WebServices.ProxyPass := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_GetAguardarConsultaRet(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     Result := nfeHandle^.NFE.Configuracoes.WebServices.AguardarConsultaRet;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_SetAguardarConsultaRet(const nfeHandle: PNFEHandle;const value : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.WebServices.AguardarConsultaRet := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_GetTentativas(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     Result := nfeHandle^.NFE.Configuracoes.WebServices.Tentativas;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_SetTentativas(const nfeHandle: PNFEHandle;const value : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.WebServices.Tentativas := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_GetIntervaloTentativas(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     Result := nfeHandle^.NFE.Configuracoes.WebServices.IntervaloTentativas;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_SetIntervaloTentativas(const nfeHandle: PNFEHandle; const value : Integer) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.WebServices.IntervaloTentativas := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end
end;

Function NFE_CFG_WebServices_GetAjustaAguardaConsultaRet(const nfeHandle: PNFEHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     if nfeHandle^.NFE.Configuracoes.WebServices.AjustaAguardaConsultaRet then
     Result := 1
     else
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

Function NFE_CFG_WebServices_SetAjustaAguardaConsultaRet(const nfeHandle: PNFEHandle; const value : Boolean) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.Configuracoes.WebServices.AjustaAguardaConsultaRet := value;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end
end;

{%endregion}

{%endregion}

{%region NotasFiscais }

Function NFE_NotasFiscais_ADD(const nfeHandle: PNFEHandle; const nfHandle : PNFHandle) : Integer ; {$IFDEF STDCALL} stdcall; {$ENDIF} {$IFDEF CDECL} cdecl; {$ENDIF} export;
begin

  if (nfeHandle = nil) then
  begin
     Result := -2;
     Exit;
  end;

  try
     nfeHandle^.NFE.NotasFiscais.Add(nfHandle^.NF);
     nfHandle^.NF := nfeHandle^.NFE.NotasFiscais[nfHandle^.NF := nfeHandle^.NFE.NotasFiscais.Count - 1];
     nfHandle^.NFEHandle := nfeHandle;
     Result := 0;
  except
     on exception : Exception do
     begin
        nfeHandle^.UltimoErro := exception.Message;
        Result := -1;
     end
  end;
end;

{%endregion}

exports

{ Constructor/Destructor/Erro }
NFE_Create,
NFE_Destroy,
NFE_GetUltimoErro,

{%region Configurações }

{ Geral }
NFE_CFG_Geral_GetFormaEmissao, NFE_CFG_Geral_SetFormaEmissao,
NFE_CFG_Geral_GetSalvar, NFE_CFG_Geral_SetSalvar,
NFE_CFG_Geral_GetAtualizarXMLCancelado, NFE_CFG_Geral_SetAtualizarXMLCancelado,
NFE_CFG_Geral_GetPathSalvar, NFE_CFG_Geral_SetPathSalvar,
NFE_CFG_Geral_GetPathSchemas, NFE_CFG_Geral_SetPathSchemas,
NFE_CFG_Geral_GetIniFinXMLSECAutomatico, NFE_CFG_Geral_SetIniFinXMLSECAutomatico,
NFE_CFG_Geral_GetFormaEmissaoCodigo, NFE_CFG_Geral_Save,

{ Arquivo }
NFE_CFG_Arquivos_GetAdicionarLiteral, NFE_CFG_Arquivos_SetAdicionarLiteral,
NFE_CFG_Arquivos_GetEmissaoPathNFe, NFE_CFG_Arquivos_SetEmissaoPathNFe,
NFE_CFG_Arquivos_GetSalvar, NFE_CFG_Arquivos_SetSalvar,
NFE_CFG_Arquivos_GetPastaMensal, NFE_CFG_Arquivos_SetPastaMensal,
NFE_CFG_Arquivos_GetPathNFe, NFE_CFG_Arquivos_SetPathNFe,
NFE_CFG_Arquivos_GetPathCan, NFE_CFG_Arquivos_SetPathCan,
NFE_CFG_Arquivos_GetPathInu, NFE_CFG_Arquivos_SetPathInu,
NFE_CFG_Arquivos_GetPathDPEC, NFE_CFG_Arquivos_SetPathDPEC,
NFE_CFG_Arquivos_GetPathCCe, NFE_CFG_Arquivos_SetPathCCe,
NFE_CFG_Arquivos_GetPathMDe, NFE_CFG_Arquivos_SetPathMDe,
NFE_CFG_Arquivos_GetPathEvento, NFE_CFG_Arquivos_SetPathEvento,
NFE_CFG_Arquivos_FGetPathNFe, NFE_CFG_Arquivos_FGetPathCan,
NFE_CFG_Arquivos_FGetPathInu, NFE_CFG_Arquivos_FGetPathDPEC,
NFE_CFG_Arquivos_FGetPathCCe, NFE_CFG_Arquivos_FGetPathMDe,
NFE_CFG_Arquivos_FGetPathEvento,

{ Certificados }
NFE_CFG_Certificados_GetCertificado, NFE_CFG_Certificados_SetCertificado,
NFE_CFG_Certificados_GetSenha, NFE_CFG_Certificados_SetSenha,

{ WebServices }
NFE_CFG_WebServices_GetVisualizar, NFE_CFG_WebServices_SetVisualizar,
NFE_CFG_WebServices_GetUF, NFE_CFG_WebServices_SetUF,
NFE_CFG_WebServices_GetAmbiente, NFE_CFG_WebServices_SetAmbiente,
NFE_CFG_WebServices_GetUFCodigo, NFE_CFG_WebServices_GetAmbienteCodigo,
NFE_CFG_WebServices_GetProxyHost, NFE_CFG_WebServices_SetProxyHost,
NFE_CFG_WebServices_GetProxyPort, NFE_CFG_WebServices_SetProxyPort,
NFE_CFG_WebServices_GetProxyUser, NFE_CFG_WebServices_SetProxyUser,
NFE_CFG_WebServices_GetProxyPass, NFE_CFG_WebServices_SetProxyPass,
NFE_CFG_WebServices_GetAguardarConsultaRet, NFE_CFG_WebServices_SetAguardarConsultaRet,
NFE_CFG_WebServices_GetTentativas, NFE_CFG_WebServices_SetTentativas,
NFE_CFG_WebServices_GetIntervaloTentativas, NFE_CFG_WebServices_SetIntervaloTentativas,
NFE_CFG_WebServices_GetAjustaAguardaConsultaRet, NFE_CFG_WebServices_SetAjustaAguardaConsultaRet;

{%endregion}


end.

