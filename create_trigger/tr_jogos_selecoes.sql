create trigger tr_jogos_selecoes
            on tb_jogos_selecoes
for insert, update 
  
as

begin

declare @id_camp_ed int
declare @id_arb     int
declare @id_arb_1   int
declare @id_arb_2   int
declare @id_arb_3   int
declare @id_arb_4   int
declare @id_anf     int
declare @id_vis     int
declare @retorno    varchar(150)

        select @id_camp_ed = ID_Campeonato_Edicao
             , @id_arb     = ID_Arbitro
             , @id_arb_1   = ID_Arbitro_Aux_1
             , @id_arb_2   = ID_Arbitro_Aux_2
             , @id_arb_3   = ID_Arbitro_Aux_3
             , @id_arb_4   = ID_Arbitro_Aux_4
             , @id_anf     = ID_Selecao_Anfitriao
             , @id_vis     = ID_Selecao_Visitante
          from inserted

    if (
	   select 1
         from tb_campeonatos_edicoes_selecoes_part
        where ID_Campeonato_Edicao = @id_camp_ed
          and ID_Selecao = @id_anf
    ) is null
    begin
       raiserror ('Seleção anfitriã informada não é um participante deste campeonato.', 11, 127)
       rollback transaction
    end

    if (
	   select 1
         from tb_campeonatos_edicoes_selecoes_part
        where ID_Campeonato_Edicao = @id_camp_ed
          and ID_Selecao = @id_vis
    ) is null
    begin
       raiserror ('Seleção visitante informada não é um participante deste campeonato.', 11, 127)
       rollback transaction
    end

  if @id_arb = @id_arb_1
	or @id_arb = @id_arb_2
	or @id_arb = @id_arb_3
	or @id_arb = @id_arb_4
	begin
       set @retorno = (
           select concat('O árbitro ', b.Nome_Reduzido, ' foi inserido mais de uma vez.')
             from tb_arbitros  a with(nolock)
             join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
            where a.ID_Arbitro = @id_arb
	   )
       raiserror (@retorno, 11, 127)
       rollback transaction
	end

  if @id_arb_1 = @id_arb_2
	or @id_arb_1 = @id_arb_3
	or @id_arb_1 = @id_arb_4
	begin
       set @retorno = (
           select concat('O árbitro ', b.Nome_Reduzido, ' foi inserido mais de uma vez.')
             from tb_arbitros  a with(nolock)
             join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
            where a.ID_Arbitro = @id_arb_1
	   )
       raiserror (@retorno, 11, 127)
       rollback transaction
	end

  if @id_arb_2 = @id_arb_3
	or @id_arb_2 = @id_arb_4
	begin
       set @retorno = (
           select concat('O árbitro ', b.Nome_Reduzido, ' foi inserido mais de uma vez.')
             from tb_arbitros  a with(nolock)
             join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
            where a.ID_Arbitro = @id_arb_2
	   )
       raiserror (@retorno, 11, 127)
       rollback transaction
	end

  if @id_arb_3 = @id_arb_4
	begin
       set @retorno = (
           select concat('O árbitro ', b.Nome_Reduzido, ' foi inserido mais de uma vez.')
             from tb_arbitros  a with(nolock)
             join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
            where a.ID_Arbitro = @id_arb_3
	   )
       raiserror (@retorno, 11, 127)
       rollback transaction
	end

end