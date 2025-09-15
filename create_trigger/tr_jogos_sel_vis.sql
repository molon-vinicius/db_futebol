create or alter trigger tr_jogos_sel_vis on tb_jogos_selecoes_visitantes
for insert, update
as
begin
    set nocount on;

    -- 1) valida se a seleção visitante realmente participou do jogo
    if exists (
        select 1
        from inserted i
        where not exists (
            select 1
            from tb_jogos_selecoes js
            where js.id_jogo_selecao = i.id_jogo_selecao
              and js.id_selecao_visitante = i.id_selecao
        )
    )
    begin
        raiserror('Seleção visitante informada não participou da partida ou está cadastrada como seleção anfitriã.', 16, 1);
        rollback transaction;
        return;
    end;

    -- 2) valida se o jogador pertence ao elenco da seleção visitante
    if exists (
        select 1
        from inserted i
        where not exists (
            select 1
            from tb_jogos_selecoes js
            join tb_selecoes_elencos se
              on se.id_campeonato_edicao = js.id_campeonato_edicao
             and se.id_selecao = js.id_selecao_visitante
             and se.id_jogador = i.id_jogador
            where js.id_jogo_selecao = i.id_jogo_selecao
              and js.id_selecao_visitante = i.id_selecao
        )
    )
    begin
        raiserror('Jogador não pertence à seleção visitante.', 16, 1);
        rollback transaction;
        return;
    end;

    -- 3) valida quantidade máxima de titulares
    if exists (
        select 1
        from inserted i
        cross apply (
            select count(*) as qtde
            from tb_jogos_selecoes_visitantes a
            where a.id_jogo_selecao = i.id_jogo_selecao
        ) c
        where c.qtde > 11
    )
    begin
        raiserror('Quantidade de jogadores titulares já atingida.', 16, 1);
        rollback transaction;
        return;
    end;

    -- 4) valida se não há mais de um goleiro
    if exists (
        select 1
        from inserted i
        cross apply (
            select count(*) as qtgk
            from tb_jogos_selecoes_visitantes a
            join tb_jogadores_posicoes p on p.id_jogador = a.id_jogador
            where a.id_jogo_selecao = i.id_jogo_selecao
              and p.gk = 's'
        ) g
        where g.qtgk > 1
    )
    begin
        raiserror('Goleiro já cadastrado para o time titular.', 16, 1);
        rollback transaction;
        return;
    end;

    -- 5) se já há 11 titulares, valida que exista pelo menos 1 goleiro
    if exists (
        select 1
        from inserted i
        cross apply (
            select count(*) as qtde,
                   sum(case when p.gk = 's' then 1 else 0 end) as qtgk
            from tb_jogos_selecoes_visitantes a
            join tb_jogadores_posicoes p on p.id_jogador = a.id_jogador
            where a.id_jogo_selecao = i.id_jogo_selecao
        ) t
        where t.qtde = 11 and t.qtgk = 0
    )
    begin
        raiserror('Necessário cadastrar um goleiro para o time titular.', 16, 1);
        rollback transaction;
        return;
    end;

end;
go
