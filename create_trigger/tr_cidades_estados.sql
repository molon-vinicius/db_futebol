/* A priori só coloquei a validação de obrigação de preenchimento da coluna 'ID_Estado' para cidades do Brasil, que são as únicas informações da tabela referência
até então. Posteriormente, caso haja interesse de cadastramento de estados de outros países, a trigger abaixo irá validar se o estado informado corresponde ao país
no momento do INSERT ou UPDATE. Para tornar obrigatório o cadastramento de estados, basta alterar o primeiro bloco 'IF', trocando o '=' por IN, adicionando o nome 
dos países desejados */

create trigger tr_cidades_estados on tb_cidades
for insert, update 
 
as

begin

declare @ID_Pais   int
declare @ID_Estado int
declare @Nome_Cidade varchar(120)
declare @Nome_Pais varchar(100)  

    select @ID_Pais     = b.ID_Pais
         , @ID_Estado   = a.ID_Estado
		     , @Nome_Cidade = a.Nome_Cidade
         , @Nome_Pais   = b.Nome_Pais
      from Inserted    a with(nolock)
	    join tb_paises   b with(nolock)on b.ID_Pais = a.ID_Pais

  if @Nome_Pais = 'Brasil'
  begin
     if @ID_Estado is null
        begin
           raiserror ('Para cadastrar cidades do Brasil é necessário informar o Estado pertencente.', 11, 127)
	         rollback transaction
        end
  end

  if @ID_Estado is not null
  begin
     if not exists 
     (  select b.ID_Pais
          from tb_estados a with(nolock)
          join tb_paises  b with(nolock)on b.ID_Pais = a.ID_Pais
         where a.ID_Estado = @ID_Estado
           and b.ID_Pais = @ID_Pais  )
     begin
       raiserror ('Estado não pertencente ao país informado.', 11, 127)
	     rollback transaction
     end
  end
 
end
