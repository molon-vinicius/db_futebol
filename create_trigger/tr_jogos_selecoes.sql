create trigger tr_jogos_selecoes
            on tb_jogos_selecoes
for insert, update 
  
as

begin
	
declare @ID_campeonato  int
declare @id_camp_ed     int
declare @id_arb         int
declare @id_arb_1       int
declare @id_arb_2       int
declare @id_arb_3       int
declare @id_arb_4       int
declare @id_anf         int
declare @id_vis         int
declare @old_dt         date
declare @dt             date
declare @old_id_estadio int
declare @id_estadio     int
declare @pais_estadio   varchar(80)
declare @retorno        varchar(150)

        select @id_camp_ed   = a.ID_Campeonato_Edicao
             , @dt           = a.Data_Jogo
             , @id_arb       = a.ID_Arbitro
             , @id_arb_1     = a.ID_Arbitro_Aux_1
             , @id_arb_2     = a.ID_Arbitro_Aux_2
             , @id_arb_3     = a.ID_Arbitro_Aux_3
             , @id_arb_4     = a.ID_Arbitro_Aux_4
             , @id_anf       = a.ID_Selecao_Anfitriao
             , @id_vis       = a.ID_Selecao_Visitante
             , @id_estadio   = a.ID_estadio
             , @pais_estadio = d.Nome_Pais
          from inserted    a with(nolock)
          join tb_estadios b with(nolock)on b.ID_estadio = a.ID_estadio
          join tb_cidades  c with(nolock)on c.ID_Cidade = b.ID_Cidade
          join tb_paises   d with(nolock)on d.ID_Pais = c.ID_Pais

        select @ID_campeonato  = ID_Campeonato
          from tb_campeonatos_edicoes with(nolock)
         where ID_Campeonato_Edicao = @id_camp_ed

  if (select ID_Jogo_Selecao from deleted) is not null
  begin
          
      select @old_id_estadio = id_estadio
           , @old_dt = data_jogo
        from deleted 

  if @ID_campeonato > 0
  begin

    if @old_dt <> @dt
    and (
       select @dt as Dt
         from inserted                a with(nolock)
         join tb_campeonatos_edicoes  b with(nolock)on b.ID_Campeonato_Edicao = a.ID_campeonato_edicao
        where b.Ano <> year(@dt) 
    ) is not null
    begin
       raiserror ('Data do jogo com ano divergente do campeonato.', 11, 127)
       rollback transaction
    end

    if @old_id_estadio <> @id_estadio 
    and ( 
       select c.Nome_Pais
         from inserted               a with(nolock)
         join tb_campeonatos_edicoes b with(nolock)on b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
         join tb_paises              c with(nolock)on c.ID_Pais = b.Pais_Sede           
        where c.Nome_Pais = @pais_estadio
	) is null
    begin
       raiserror ('País do estádio informado é diferente do(s) país(es) sede(s).', 11, 127)
       rollback transaction
    end 

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

  if (select ID_jogo_selecao from deleted) is null
  begin

  if @ID_campeonato > 0
  begin
   
    if (
       select b.Ano
         from inserted                a with(nolock)
         join tb_campeonatos_edicoes  b with(nolock)on b.ID_Campeonato_Edicao = a.ID_campeonato_edicao
        where b.Ano <> year(@dt)  
    ) is not null
    begin
       raiserror ('Data do jogo com ano divergente do campeonato.', 11, 127)
       rollback transaction
    end

    if (
       select c.Nome_Pais
         from inserted               a with(nolock)
         join tb_campeonatos_edicoes b with(nolock)on b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
         join tb_paises              c with(nolock)on c.ID_Pais = b.Pais_Sede           
        where c.Nome_Pais = @pais_estadio
    ) is null
    begin
       raiserror ('País do estádio informado é diferente do(s) país(es) sede(s).', 11, 127)
       rollback transaction
    end 

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

end

