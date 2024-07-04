/* Script para inserir novo registro na tabela 'tb_pessoas' com a possibilidade de replicação nas tabelas 
dependentes 'tb_arbitros' | 'tb_tecnicos' | 'tb_jogadores', validando o cadastro das cidades, estados e países
informados, além da pessoa que está sendo informada. Caso a cidade digitada não esteja cadastrada, o script 
verifica e já insere na tabela 'tb_cidades' */

declare @cadastra_arbitro varchar(1)  = 'N'
declare @cadastra_tecnico varchar(1)  = 'N'
declare @cadastra_jogador varchar(1)  = 'S'

declare @nome_completo nvarchar(120)  = 'Oliver Rolf Kahn'
declare @nome_reduzido varchar(60)	  = 'Oliver Kahn' 
declare @altura numeric(15,2)		      = 1.88
declare @cidade_nasc varchar(60)      = 'Karlsruhe'
declare @estado varchar(60)           = null
declare @pais_nasc varchar(100)       = 'Alemanha'
declare @dupla_cidadania varchar(100) = null
declare @pais_preferencial int        =  1  /* 1-Nascimento | 2-Dupla Cidadania */
declare @data_nascimento varchar(10)  = '15/06/1969'
declare @data_obito varchar(10)		    = null

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

if @id_dupla_cidadania is null
and @dupla_cidadania is not null
begin
  select 'País de dupla cidadania informado não cadastrado.'
  return
end

if @id_cidade_nasc is null
begin
  insert into tb_cidades
             (Nome_Cidade
			       ,ID_Estado
		      	 ,ID_Pais)

       select @cidade_nasc  as Nome_Cidade
            , @id_estado    as ID_Estado
			      , @id_pais_nasc as ID_Pais
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
insert into tb_pessoas
           (Nome_Completo
		       ,Nome_Reduzido
		       ,Altura
		       ,ID_Cidade_Nascimento
		       ,Dupla_Cidadania
		       ,Pais_Preferencial
		       ,Data_Nascimento
		       ,Data_Obito)

     select @nome_completo                         as Nome_Completo
          , isnull(@nome_reduzido, @nome_completo) as Nome_Reduzido
		      , @altura                                as Altura
		      , @id_cidade_nasc                        as ID_Cidade_Nascimento
		      , @dupla_cidadania                       as Dupla_Cidadania
		      , case when @pais_preferencial = 1
                 then @id_pais_nasc
			        	 when @pais_preferencial = 2
			        	 then @id_dupla_cidadania
			        	 else null
            end                                    as Pais_Preferencial
          , @data_nascimento                       as Data_Nascimento
		      , @data_obito                            as Data_Obito

  set @id_pessoa = scope_identity()

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
             (ID_Pessoa
			       ,Pe_Preferencial
			       ,Ambidestro
			       ,Lado_Oposto
			       ,Dois_Lados)

       select @id_pessoa       as ID_Pessoa
	          , @pe_preferencial as Pe_Preferencial
			      , @ambidestro      as Ambidestro
			      , @lado_oposto     as Lado_Oposto
			      , @dois_lados      as Dois_Lados
  end

end
