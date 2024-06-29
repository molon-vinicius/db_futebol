declare @Nome_Cidade  varchar(60) = 'Santos'
declare @Sigla_Estado varchar(2)  = 'SP'
declare @Nome_Pais    varchar(60) = 'Brasil'

declare @ID_Cidade int
declare @ID_Estado int
declare @ID_Pais   int

set @ID_Pais   = (select ID_Pais   from tb_paises  where Nome_Pais    = @Nome_Pais)
set @ID_Cidade = (select ID_Cidade from tb_cidades where Nome_Cidade  = @Nome_Cidade and ID_Pais = @ID_Pais)
set @ID_Estado = (select ID_Estado from tb_estados where Sigla_Estado = @Sigla_Estado)

if @ID_Cidade is not null
begin
  select 'A cidade informada já foi cadastrada.'
  return
end

if @Sigla_Estado is not null
and @ID_Estado is null
begin
  select 'O estado informado não está cadastrado.'
  return
end

if @ID_Pais is null
begin
  select 'O país informado não está cadastrado.'
  return
end

if @Nome_Pais = 'Brasil'
and @ID_Estado is null
begin
  select 'Para cadastrar cidades brasileiras é necessário informar o estado.'
  return
end

insert into tb_cidades
           (Nome_Cidade
		   ,ID_Pais
		   ,ID_Estado)

     select @Nome_Cidade  as Nome_Cidade
          , @ID_Pais      as ID_Pais
		  , @ID_Estado    as ID_Estado

if @@rowcount > 0 
begin
  select concat('A cidade ''', @Nome_Cidade, ''', localizada no país:''', @Nome_Pais, ''' foi cadastrada com sucesso.')
end
