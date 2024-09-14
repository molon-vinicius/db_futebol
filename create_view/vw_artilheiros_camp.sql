create view vw_artilheiros_camp

as

      select b.ID_campeonato_edicao
           , a.ID_Jogador                    as ID_Jogador
           , d.Nome_Reduzido                 as Jogador
           , e.Nome_Selecao                  as Selecao
           , isnull(f.Jogos, 0) 
           + isnull(g.Jogos, 0)              as Jogos
           , count(a.ID_jogo_selecao_evento) as Gols
           , c.Ano                           as Ano
           , c.Campeonato                    as Campeonato
           , c.Pais_Sede                     as Pais_Sede
        from tb_jogos_selecoes_eventos a with(nolock)
        join tb_jogos_selecoes         b with(nolock)on b.ID_jogo_selecao = a.ID_jogo_selecao
        join vw_campeonatos            c with(nolock)on c.ID_Campeonato_Edicao = b.ID_campeonato_edicao
        join vw_jogadores              d with(nolock)on d.ID_jogador = a.ID_jogador
        join tb_selecoes               e with(nolock)on e.ID_Selecao = a.ID_selecao
   left join (
		       select count(a.ID_Jogo_Selecao) as Jogos
                    , b.ID_Jogador
                    , a.ID_campeonato_edicao
                 from tb_jogos_selecoes            a with(nolock)
                 join tb_jogos_selecoes_anfitrioes b with(nolock)on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
                group by b.ID_Jogador
                       , a.ID_campeonato_edicao
        )                              f             on f.ID_Jogador = a.ID_Jogador
                                                    and f.ID_campeonato_edicao = b.ID_campeonato_edicao
   left join (
		       select count(a.ID_Jogo_Selecao) as Jogos
                    , b.ID_Jogador
                    , a.ID_campeonato_edicao
                 from tb_jogos_selecoes            a with(nolock)
                 join tb_jogos_selecoes_visitantes b with(nolock)on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
                group by b.ID_Jogador
                       , a.ID_campeonato_edicao			
            )                          g             on g.ID_jogador = a.ID_Jogador
                                                    and g.ID_campeonato_edicao = b.ID_campeonato_edicao                                 
       where a.ID_tipo_evento in (1,5)   
       group by a.ID_Jogador 
              , d.Nome_Reduzido
              , e.Nome_Selecao
              , isnull(f.Jogos, 0) + isnull(g.Jogos, 0)
              , b.ID_campeonato_edicao
              , c.Ano
              , c.Campeonato 
              , c.Pais_Sede  
