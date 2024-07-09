alter trigger tr_selecoes_elencos on tb_selecoes_elencos
for insert, update 
 
as 

begin

declare @ID_camp_edicao int
declare @ID_selecao int
declare @ID_jogador int
declare @camisa varchar(2)
declare @nome_camisa varchar(20)
declare @retorno varchar(100)
declare @ID_selecao_dupla_cidadania int
declare @ID_selecao_pais_nasc int

    select @ID_camp_edicao = ID_Campeonato_Edicao
         , @ID_selecao     = ID_Selecao
         , @ID_jogador     = ID_Jogador
         , @camisa         = Camisa 
  	 , @nome_camisa    = Nome_Camisa
      from inserted    with(nolock)

    select @ID_selecao_pais_nasc       = e.ID_Selecao
         , @ID_selecao_dupla_cidadania = g.ID_Selecao
      from tb_jogadores  a with(nolock)
      join tb_pessoas    b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
      join tb_cidades    c with(nolock)on c.ID_Cidade = b.ID_Cidade_Nascimento
      join tb_paises     d with(nolock)on d.ID_Pais = c.ID_Pais
      join tb_selecoes   e with(nolock)on e.Nome_Selecao = d.Nome_Pais
 left join tb_paises     f with(nolock)on f.ID_Pais = b.Dupla_Cidadania
 left join tb_selecoes   g with(nolock)on g.Nome_Selecao = f.Nome_Pais
     where a.ID_Jogador = @ID_jogador

   if (
      select count(distinct a.ID_Selecao) as qtd
        from inserted                             a with(nolock)
        join tb_campeonatos_edicoes_selecoes_part b with(nolock)on b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
                                                               and b.ID_Selecao = a.ID_Selecao
       where b.ID_Campeonato_Edicao = @ID_camp_edicao
         and b.ID_Selecao = @ID_selecao   ) = 0
   begin
      raiserror ('Seleção não participante dessa edição do campeonato.', 11, 127)
	  rollback transaction      
   end

   if  ( isnull(@ID_selecao_dupla_cidadania,0) <> @ID_selecao ) 
   and ( @ID_selecao_pais_nasc <> @ID_selecao ) 
   begin
      set @retorno = (
      select concat('O jogador ''', b.Nome_Reduzido ,''' não pode ser inserido nessa seleção, pois não possui essa nacionalidade.')
        from tb_jogadores a with(nolock)
        join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
       where a.ID_Jogador = @ID_jogador
	  )
      raiserror (@retorno, 11, 127)
	  rollback transaction
   end

   if isnumeric(@camisa) = 0
   begin  
      raiserror ('A coluna ''Camisa'' só aceita caracteres numéricos.', 11, 127)
	  rollback transaction
   end

   if @camisa = 0
   begin  
      raiserror ('A coluna ''Camisa'' não pode ser preenchida com o número zero.', 11, 127)
	  rollback transaction
   end

   if (select dbo.fn_valida_string(@nome_camisa)) is not null
   begin
      set @retorno = (select dbo.fn_valida_string(@nome_camisa))
      raiserror (@retorno, 11, 127)
      rollback transaction
   end
   
end 
