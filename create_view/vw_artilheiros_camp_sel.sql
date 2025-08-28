create or alter view vw_artilheiros_camp_sel

as

      select b.ID_campeonato_edicao
           , a.ID_Jogador                    as ID_Jogador
           , d.Nome_Reduzido                 as Jogador
		   , e.Nome_Selecao                  as Selecao
           , dbo.fn_jogadores_posicoes(a.ID_Jogador) as Posicoes
		   , isnull(f.Jogos, 0) 
		   + isnull(g.Jogos, 0)
           + isnull(h1.Jogos, 0)
           + isnull(h2.Jogos, 0)             as Jogos
           , count(a.ID_jogo_selecao_evento) as Gols
           , isnull(i1.Assistencias,0)
           + isnull(i2.Assistencias,0)       as Assistencias
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
                 from tb_jogos_selecoes                a with(nolock)
                 join tb_jogos_selecoes_anfitrioes     b with(nolock)on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao                                      
                group by b.ID_Jogador
                       , a.ID_campeonato_edicao
                       , a.ID_selecao_anfitriao
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
   left join (
               select count(a.ID_Jogo_Selecao) as Jogos
                    , b.ID_Jogador_Entrada
                    , a.ID_campeonato_edicao
                from tb_jogos_selecoes               a with(nolock)
                join tb_jogos_selecoes_substituicoes b with(nolock)on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
                                                                  and a.ID_selecao_anfitriao = b.ID_Selecao
               group by b.ID_jogador_entrada
                      , a.ID_campeonato_edicao
            )                         h1             on h1.ID_jogador_entrada = a.ID_jogador
                                                    and h1.ID_campeonato_edicao = b.ID_campeonato_edicao  

   left join (
               select count(a.ID_Jogo_Selecao) as Jogos
                    , b.ID_Jogador_Entrada
                    , a.ID_campeonato_edicao
                from tb_jogos_selecoes               a with(nolock)
                join tb_jogos_selecoes_substituicoes b with(nolock)on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
                                                                  and a.ID_selecao_visitante = b.ID_Selecao
               group by b.ID_jogador_entrada
                      , a.ID_campeonato_edicao
            )                         h2             on h2.ID_jogador_entrada = a.ID_jogador
                                                    and h2.ID_campeonato_edicao = b.ID_campeonato_edicao  

   left join ( select count(a.Assistencia) as Assistencias
                    , a.Assistencia        as ID_Jogador
                    , c.ID_Campeonato_Edicao 
                 from tb_jogos_selecoes_eventos    a with(nolock)
                 join tb_jogos_selecoes            b with(nolock)on b.ID_Jogo_Selecao = a.ID_Jogo_Selecao
                                                                and b.ID_Selecao_Anfitriao = a.ID_Selecao
                 join tb_campeonatos_edicoes       c with(nolock)on c.ID_Campeonato_Edicao = b.ID_campeonato_edicao
                group by a.assistencia
                       , c.ID_Campeonato_Edicao
            )                         i1             on i1.ID_jogador = a.ID_jogador
                                                    and i1.ID_campeonato_edicao = b.ID_campeonato_edicao  
   left join ( select count(a.Assistencia) as Assistencias
                    , a.Assistencia        as ID_Jogador
                    , c.ID_Campeonato_Edicao 
                 from tb_jogos_selecoes_eventos    a with(nolock)
                 join tb_jogos_selecoes            b with(nolock)on b.ID_Jogo_Selecao = a.ID_Jogo_Selecao
                                                                and b.ID_Selecao_Visitante = a.ID_Selecao
                 join tb_campeonatos_edicoes       c with(nolock)on c.ID_Campeonato_Edicao = b.ID_campeonato_edicao
                group by a.assistencia
                       , c.ID_Campeonato_Edicao
            )                         i2             on i2.ID_jogador = a.ID_jogador
                                                    and i2.ID_campeonato_edicao = b.ID_campeonato_edicao  
       where a.ID_tipo_evento in (1,5,9) --Gol, Gol Pênalti, Gol de Falta
       group by a.ID_Jogador 
              , d.Nome_Reduzido
              , e.Nome_Selecao
              , isnull(f.Jogos, 0) 
              , isnull(g.Jogos, 0)
              , isnull(h1.Jogos, 0)
              , isnull(h2.Jogos, 0)
              , isnull(i1.Assistencias,0)
              + isnull(i2.Assistencias,0)
              , b.ID_campeonato_edicao
			  , c.Ano
			  , c.Campeonato 
			  , c.Pais_Sede  

