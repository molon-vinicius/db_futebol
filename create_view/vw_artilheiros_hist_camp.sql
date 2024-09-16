create view vw_artilheiros_hist_camp

as

      select a.ID_Jogador                      as ID_Jogador
           , d.Nome_Reduzido                   as Jogador
           , dbo.fn_jgd_sel_camp(a.ID_Jogador) as Selecao
           , isnull(f.Jogos, 0) 
           + isnull(g.Jogos, 0)                as Jogos
           , count(a.ID_jogo_selecao_evento)   as Gols
        from tb_jogos_selecoes_eventos a with(nolock)
        join tb_jogos_selecoes         b with(nolock)on b.ID_jogo_selecao = a.ID_jogo_selecao
        join vw_campeonatos            c with(nolock)on c.ID_Campeonato_Edicao = b.ID_campeonato_edicao
        join vw_jogadores              d with(nolock)on d.ID_jogador = a.ID_jogador
   left join (
		       select count(a.ID_Jogo_Selecao) as Jogos
                , b.ID_Jogador
                , c.ID_Campeonato
             from tb_jogos_selecoes            a with(nolock)
             join tb_jogos_selecoes_anfitrioes b with(nolock)on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
             join tb_campeonatos_edicoes       c with(nolock)on c.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
             join tb_campeonatos               d with(nolock)on d.ID_Campeonato = c.ID_Campeonato
            group by b.ID_Jogador
                   , c.ID_Campeonato
        )                              f             on f.ID_Jogador = a.ID_Jogador
                                                    and f.ID_Campeonato = c.ID_Campeonato
   left join (
		       select count(a.ID_Jogo_Selecao) as Jogos
                , b.ID_Jogador
                , c.ID_Campeonato
             from tb_jogos_selecoes            a with(nolock)
             join tb_jogos_selecoes_visitantes b with(nolock)on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
             join tb_campeonatos_edicoes       c with(nolock)on c.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
             join tb_campeonatos               d with(nolock)on d.ID_Campeonato = c.ID_Campeonato
            group by b.ID_Jogador
                   , c.ID_Campeonato
            )                          g             on g.ID_jogador = a.ID_Jogador
                                                    and g.ID_Campeonato = c.ID_Campeonato                                 
       where a.ID_tipo_evento in (1,5) 
       group by a.ID_Jogador 
              , d.Nome_Reduzido
              , isnull(f.Jogos, 0) 
              + isnull(g.Jogos, 0)

