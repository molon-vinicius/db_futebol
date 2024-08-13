use db_futebol
  
declare @cadastra_arbitro varchar(1)  = 'N'
declare @cadastra_tecnico varchar(1)  = 'N'
declare @cadastra_jogador varchar(1)  = 'S'

declare @nome_completo nvarchar(120)  = 'Dixie Dean'
declare @nome_reduzido varchar(60)	  = null
declare @altura numeric(15,2)		      = 1.78
declare @cidade_nasc varchar(60)      = 'Birkenhead'
declare @estado varchar(60)           = null
declare @pais_nasc varchar(100)       = 'Inglaterra'
declare @dupla_cidadania varchar(100) = null
declare @pais_preferencial int        =  1 /* 1-Nascimento | 2-Dupla Cidadania */
declare @data_nascimento varchar(10)  = '22/01/1907'
declare @data_obito varchar(10)		    = '01/03/1980'

declare @pe_preferencial varchar(1)   = 'R'
declare @ambidestro      varchar(1)   = 'N'
declare @lado_oposto     varchar(1)   = 'N'
declare @dois_lados      varchar(1)   = 'N'

declare @id_cidade_nasc int
declare @id_estado int
declare @id_pais_nasc int
declare @id_dupla_cidadania int
declare @id_pessoa int

set @id_cidade_nasc = (select ID_Cidade from tb_cidades with(nolock) where Nome_Cidade = @cidade_nasc)
set @id_estado = (select ID_Estado from tb_estados with(nolock) where Nome_Estado = @estado)
set @id_pais_nasc = (select ID_Pais from tb_paises with(nolock) where Nome_Pais = @pais_nasc)
set @id_dupla_cidadania = (select ID_Pais from tb_paises with(nolock) where Nome_Pais = @dupla_cidadania)

set @id_pessoa = (select ID_Pessoa from tb_pessoas with(nolock) where Nome_Completo = @nome_completo or Nome_Reduzido = @nome_reduzido)

if @id_pais_nasc is null
begin
  select 'País de nascimento informado não cadastrado.'
  return
end

if @pais_preferencial = 2 /* País Dupla Cidadania */
and @dupla_cidadania is null
begin
  select 'Não é possível inserir o país de dupla cidadania na tabela, pois o mesmo não foi informado.'
  return
end

if @id_dupla_cidadania is null
and @dupla_cidadania is not null
begin
  select 'País de dupla cidadania informado não cadastrado.'
  return
end

if @id_cidade_nasc is null
and @cidade_nasc is not null
begin
  insert into tb_cidades
             (Nome_Cidade
			       ,ID_Estado
			       ,ID_Pais)

       select @cidade_nasc  as Nome_Cidade
            , @id_estado    as ID_Estado
			      , @id_pais_nasc as ID_Pais
   
   set @id_cidade_nasc = scope_identity()
end

if @id_pessoa is not null
and @nome_completo is not null
begin
  select 'Pessoa já cadastrada.'
  return
end 

if @id_pessoa is null
and @nome_completo is not null
begin

  /* caso queira inserir uma pessoa com um ID específico */
--set identity_insert tb_pessoas on

insert into tb_pessoas 
           (--ID_Pessoa,
		        Nome_Completo
		       ,Nome_Reduzido
		       ,Altura
		       ,ID_Cidade_Nascimento
		       ,Dupla_Cidadania
		       ,Pais_Preferencial
		       ,Data_Nascimento
		       ,Data_Obito)


     select --292                                    as ID_Pessoa ,
	          @nome_completo                         as Nome_Completo
          , isnull(@nome_reduzido, @nome_completo) as Nome_Reduzido
		      , @altura                                as Altura
		      , @id_cidade_nasc                        as ID_Cidade_Nascimento
		      , @id_dupla_cidadania                    as Dupla_Cidadania
		      , case when @pais_preferencial = 1
                 then @id_pais_nasc
				         when @pais_preferencial = 2
				         then @id_dupla_cidadania
				         else null
            end                                    as Pais_Preferencial
          , @data_nascimento                       as Data_Nascimento
		      , @data_obito                            as Data_Obito

  set @id_pessoa = scope_identity()
end

/* para inserir com um ID específico */
--set identity_insert tb_pessoas off
--set identity_insert tb_jogadores on
--set identity_insert tb_tecnicos on
--set identity_insert tb_arbitros on


if isnull(@cadastra_arbitro,'N') = 'S'
  begin
  insert into tb_arbitros
             (ID_Pessoa)
       select @id_pessoa as ID_Pessoa
  end

if isnull(@cadastra_tecnico,'N') = 'S'
  begin
  insert into tb_tecnicos
             (ID_Pessoa)
       select @id_pessoa as ID_Pessoa
  end

if isnull(@cadastra_jogador,'N') = 'S'
  begin
  insert into tb_jogadores
             (--ID_Jogador,
			        ID_Pessoa
			       ,Pe_Preferencial
			       ,Ambidestro
			       ,Lado_Oposto
			       ,Dois_Lados)
			 select --268              as ID_Jogador ,
              @id_pessoa       as ID_Pessoa
	          , @pe_preferencial as Pe_Preferencial
			      , @ambidestro      as Ambidestro
			      , @lado_oposto     as Lado_Oposto
			      , @dois_lados      as Dois_Lados

end
  
--set identity_insert tb_jogadores off
--set identity_insert tb_tecnicos off
--set identity_insert tb_arbitros off

/* visualizar informações inseridas */  
    select a.*, b.ID_arbitro, c.ID_tecnico, d.ID_jogador 
      from tb_pessoas       a with(nolock)
 left join tb_arbitros      b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
 left join tb_tecnicos      c with(nolock)on c.ID_Pessoa = a.ID_Pessoa
 left join tb_jogadores     d with(nolock)on d.ID_Pessoa = a.ID_Pessoa
     where a.ID_Pessoa = @id_pessoa
