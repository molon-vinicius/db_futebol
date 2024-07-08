create trigger tr_selecoes_elencos on tb_selecoes_elencos
for insert, update 
 
as

begin

declare @ID_camp_edicao int
declare @ID_selecao int
declare @ID_jogador int
declare @camisa varchar(2)
declare @nome_camisa varchar(20)
declare @retorno varchar(100)

    select @ID_camp_edicao = ID_Campeonato_Edicao
         , @ID_selecao     = ID_Selecao
         , @ID_jogador     = ID_Jogador
         , @camisa         = Camisa 
		     , @nome_camisa    = Nome_Camisa
      from inserted    with(nolock)

   if not exists (
      select a.ID_Selecao
        from inserted                             a with(nolock)
        join tb_campeonatos_edicoes_selecoes_part b with(nolock)on b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
       where b.ID_Campeonato_Edicao = @ID_camp_edicao
   )
   begin
      raiserror ('Seleção não participante dessa edição do campeonato.', 11, 127)
	  rollback transaction      
   end

   if not exists (
      select isnull(d.ID_Pais, g.ID_Pais)
        --from inserted             a with(nolock)
		from tb_selecoes_elencos  a with(nolock)
    join tb_jogadores         b	with(nolock)on b.ID_Jogador = a.ID_Jogador
    join tb_pessoas           c with(nolock)on c.ID_Pessoa = b.ID_Pessoa
         /* Verifica país de dupla cidadania */
		join tb_paises            d with(nolock)on d.ID_Pais = c.Dupla_Cidadania
		join tb_selecoes          e with(nolock)on e.Nome_Selecao = d.Nome_Pais
         /* Verifica país de nascimento */
    join tb_cidades           f with(nolock)on f.ID_Cidade = c.ID_Cidade_Nascimento
		join tb_paises            g with(nolock)on g.ID_Pais = f.ID_Pais
		join tb_selecoes          h with(nolock)on h.Nome_Selecao = g.Nome_Pais
   where b.ID_Jogador = @ID_jogador )
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
