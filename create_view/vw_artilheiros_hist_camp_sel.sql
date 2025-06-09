create or alter view vw_artilheiros_hist_camp_sel

as

with 
cte_qtd_jogos_anf (Jogos, ID_Jogador, ID_Campeonato)
as  ( 
      select count(a.ID_Jogo_Selecao) as Jogos
           , b.ID_Jogador
           , c.ID_Campeonato
        from tb_jogos_selecoes            a with(nolock)
        join tb_jogos_selecoes_anfitrioes b with(nolock)on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
        join tb_campeonatos_edicoes       c with(nolock)on c.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
        join tb_campeonatos               d with(nolock)on d.ID_Campeonato = c.ID_Campeonato
       group by b.ID_Jogador
              , c.ID_Campeonato ) ,
			  
cte_qtd_jogos_vis (Jogos, ID_Jogador, ID_Campeonato)
as  ( 
      select count(a.ID_Jogo_Selecao) as Jogos
           , b.ID_Jogador
           , c.ID_Campeonato
        from tb_jogos_selecoes            a with(nolock)
        join tb_jogos_selecoes_visitantes b with(nolock)on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
        join tb_campeonatos_edicoes       c with(nolock)on c.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
        join tb_campeonatos               d with(nolock)on d.ID_Campeonato = c.ID_Campeonato
       group by b.ID_Jogador
              , c.ID_Campeonato  ) 

      select a.ID_Jogador                      as ID_Jogador
           , d.Nome_Reduzido                   as Jogador
           , dbo.fn_jgd_sel_camp(a.ID_Jogador
                               , c.Campeonato) as Selecao
           , c.Campeonato                      as Campeonato
           , isnull(e.Jogos,0) 
           + isnull(f.Jogos,0)                 as Jogos
           , count(a.ID_jogo_selecao_evento)   as Gols
        from tb_jogos_selecoes_eventos a with(nolock)
        join tb_jogos_selecoes         b with(nolock)on b.ID_jogo_selecao = a.ID_jogo_selecao
        join vw_campeonatos            c with(nolock)on c.ID_Campeonato_Edicao = b.ID_campeonato_edicao
        join vw_jogadores              d with(nolock)on d.ID_jogador = a.ID_jogador
   left join cte_qtd_jogos_anf         e with(nolock)on e.ID_Jogador = a.ID_Jogador
                                                    and e.ID_Campeonato = c.ID_Campeonato
   left join cte_qtd_jogos_vis         f with(nolock)on f.ID_Jogador = a.ID_Jogador
                                                    and f.ID_Campeonato = c.ID_Campeonato
       where a.ID_tipo_evento in (1,5) 
       group by a.ID_Jogador 
              , d.Nome_Reduzido
              , c.Campeonato
              , isnull(e.Jogos,0) 
              + isnull(f.Jogos,0)
