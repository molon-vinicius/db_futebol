create trigger tr_sel_elencos_cap
            on tb_selecoes_elencos_capitaes
for insert, update 
  
as

begin

declare @id_jogo_sel int
declare @id_sel      int
declare @id_jgd      int
declare @old_id_jogo_sel int
declare @old_id_sel      int
declare @old_id_jgd      int
declare @erro varchar(1000)

        select @id_jogo_sel = ID_Jogo_Selecao
             , @id_sel      = ID_Selecao
             , @id_jgd      = ID_Jogador
          from inserted
  
  if (select ID_Jogo_Selecao from deleted) is not null 
  begin
      select @old_id_jogo_sel = ID_Jogo_Selecao
           , @old_id_sel      = ID_Selecao
           , @old_id_jgd      = ID_Jogador
        from deleted   

    if @old_id_jogo_sel <> @id_jogo_sel
    begin
      raiserror ('Não é possível alterar o ID do jogo, necessário excluir e inserir novamente as informações.', 11, 127)
      rollback transaction
    end

    if @old_id_sel <> @id_sel
    begin
       if not exists (
          select ID_selecao_anfitriao
            from tb_jogos_selecoes with(nolock)
           where ID_jogo_selecao = @id_jogo_sel
             and ID_selecao_anfitriao = @id_sel

           union all

          select ID_selecao_visitante
            from tb_jogos_selecoes with(nolock)
           where ID_jogo_selecao = @id_jogo_sel
             and ID_selecao_visitante = @id_sel
	   )
	   begin
             raiserror ('Não é possível inserir o capitão, pois a seleção informada não faz parte dessa partida.', 11, 127)
             rollback transaction
           end
    end

    if @old_id_jgd <> @id_jgd
    begin
       if not exists (
          select ID_Jogador
            from tb_jogos_selecoes            a with(nolock)
            join tb_jogos_selecoes_anfitrioes b with(nolock)on b.ID_jogo_selecao = a.ID_jogo_selecao
           where b.ID_jogo_selecao = @id_jogo_sel
             and b.ID_Jogador = @id_jgd

           union all

          select ID_Jogador
            from tb_jogos_selecoes            a with(nolock)
            join tb_jogos_selecoes_visitantes b with(nolock)on b.ID_jogo_selecao = a.ID_jogo_selecao
           where b.ID_jogo_selecao = @id_jogo_sel
             and b.ID_Jogador = @id_jgd
   	   )
       begin
          raiserror ('Jogador informado não faz parte de nenhuma das seleções da partida.', 11, 127)
          rollback transaction
       end

    end

  end

  if (select ID_Jogo_Selecao from deleted) is null
  begin
    if not exists (
       select ID_selecao_anfitriao
         from tb_jogos_selecoes with(nolock)
        where ID_jogo_selecao = @id_jogo_sel
          and ID_selecao_anfitriao = @id_sel

        union all

       select ID_selecao_visitante
         from tb_jogos_selecoes with(nolock)
        where ID_jogo_selecao = @id_jogo_sel
          and ID_selecao_visitante = @id_sel
	)
    begin
       raiserror ('Não é possível inserir o capitão, pois a seleção informada não faz parte dessa partida.', 11, 127)
       rollback transaction
    end

    if not exists (
       select ID_Jogador
         from tb_jogos_selecoes            a with(nolock)
         join tb_jogos_selecoes_anfitrioes b with(nolock)on b.ID_jogo_selecao = a.ID_jogo_selecao
        where b.ID_jogo_selecao = @id_jogo_sel
          and b.ID_Jogador = @id_jgd

        union all

       select ID_Jogador
         from tb_jogos_selecoes            a with(nolock)
         join tb_jogos_selecoes_visitantes b with(nolock)on b.ID_jogo_selecao = a.ID_jogo_selecao
        where b.ID_jogo_selecao = @id_jogo_sel
          and b.ID_Jogador = @id_jgd
	)
    begin
       raiserror ('Jogador informado não faz parte de nenhuma das seleções da partida.', 11, 127)
       rollback transaction
    end

    if exists (
       select 1
         from tb_jogos_selecoes        a with(nolock)
         join tb_selecoes_elencos      b with(nolock)on b.ID_campeonato_edicao = a.ID_campeonato_edicao
                                                    and b.ID_selecao = a.ID_selecao_anfitriao
        where a.ID_Jogo_Selecao = @id_jogo_sel
          and b.ID_selecao = @id_sel
          and b.Capitao in ('P', 'S')

        union all

       select 1
         from tb_jogos_selecoes        a with(nolock)
         join tb_selecoes_elencos      b with(nolock)on b.ID_campeonato_edicao = a.ID_campeonato_edicao
                                                    and b.ID_selecao = a.ID_selecao_visitante
        where a.ID_Jogo_Selecao = @id_jogo_sel
          and b.ID_selecao = @id_sel
          and b.Capitao in ('P', 'S')
    ) 
    begin
       raiserror ('Seleção já tem um capitão definido para essa partida.', 11, 127)
       rollback transaction
    end

  end

end
 
