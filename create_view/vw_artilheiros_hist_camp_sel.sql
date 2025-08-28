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
              , c.ID_Campeonato  ) ,

cte_qtd_jogos_subst_anf (Jogos, ID_Jogador, ID_Campeonato)
as  ( 
       select count(a.ID_Jogo_Selecao) as Jogos
            , b.ID_Jogador_Entrada     as ID_Jogador
            , d.ID_Campeonato
         from tb_jogos_selecoes               a with(nolock)
         join tb_jogos_selecoes_substituicoes b with(nolock) on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
                                                            and a.ID_selecao_anfitriao = b.ID_Selecao
         join tb_campeonatos_edicoes          c with(nolock) on c.ID_Campeonato_Edicao = a.ID_campeonato_edicao
         join tb_campeonatos                  d with(nolock) on d.ID_Campeonato = c.ID_Campeonato
        group by b.ID_jogador_entrada
               , d.ID_Campeonato ) ,

cte_qtd_jogos_subst_vis (Jogos, ID_Jogador, ID_Campeonato)
as  ( 
       select count(a.ID_Jogo_Selecao) as Jogos
            , b.ID_Jogador_Entrada     as ID_Jogador
            , d.ID_Campeonato
         from tb_jogos_selecoes               a with(nolock)
         join tb_jogos_selecoes_substituicoes b with(nolock) on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
                                                            and a.ID_selecao_visitante = b.ID_Selecao
         join tb_campeonatos_edicoes          c with(nolock) on c.ID_Campeonato_Edicao = a.ID_campeonato_edicao
         join tb_campeonatos                  d with(nolock) on d.ID_Campeonato = c.ID_Campeonato
        group by b.ID_jogador_entrada
               , d.ID_Campeonato ) ,

cte_qtd_ast_anf (Assistencias, ID_Jogador, ID_Campeonato)
as  ( 
       select count(a.Assistencia) as Assistencias
            , a.Assistencia        as ID_Jogador
            , d.ID_Campeonato
         from tb_jogos_selecoes_eventos    a with(nolock)
         join tb_jogos_selecoes            b with(nolock)on b.ID_Jogo_Selecao = a.ID_Jogo_Selecao
                                                        and b.ID_Selecao_Anfitriao = a.ID_Selecao
         join tb_campeonatos_edicoes       c with(nolock)on c.ID_Campeonato_Edicao = b.ID_campeonato_edicao
         join tb_campeonatos               d with(nolock)on d.ID_Campeonato = c.ID_Campeonato
	    group by a.assistencia
               , d.ID_Campeonato ) ,

cte_qtd_ast_vis (Assistencias, ID_Jogador, ID_Campeonato)
as  ( 
       select count(a.Assistencia) as Assistencias
            , a.Assistencia        as ID_Jogador
            , d.ID_Campeonato
         from tb_jogos_selecoes_eventos    a with(nolock)
         join tb_jogos_selecoes            b with(nolock)on b.ID_Jogo_Selecao = a.ID_Jogo_Selecao
                                                        and b.ID_Selecao_Visitante = a.ID_Selecao
         join tb_campeonatos_edicoes       c with(nolock)on c.ID_Campeonato_Edicao = b.ID_campeonato_edicao
         join tb_campeonatos               d with(nolock)on d.ID_Campeonato = c.ID_Campeonato
	    group by a.assistencia
               , d.ID_Campeonato ) 

      select a.ID_Jogador                      as ID_Jogador
           , d.Nome_Reduzido                   as Jogador
		   , dbo.fn_jgd_sel_camp(a.ID_Jogador
                               , c.Campeonato) as Selecao
           , c.Campeonato                      as Campeonato
		   , isnull(e.Jogos,0) 
		   + isnull(f.Jogos,0)                 
		   + isnull(g.Jogos,0)                 
		   + isnull(h.Jogos,0)                 as Jogos
           , count(a.ID_jogo_selecao_evento)   as Gols
           , isnull(i.Assistencias,0)
           + isnull(j.Assistencias,0)          as Assistencias
		from tb_jogos_selecoes_eventos a with(nolock)
        join tb_jogos_selecoes         b with(nolock)on b.ID_jogo_selecao = a.ID_jogo_selecao
		join vw_campeonatos            c with(nolock)on c.ID_Campeonato_Edicao = b.ID_campeonato_edicao
        join vw_jogadores              d with(nolock)on d.ID_jogador = a.ID_jogador
   left join cte_qtd_jogos_anf         e with(nolock)on e.ID_Jogador = a.ID_Jogador
                                                    and e.ID_Campeonato = c.ID_Campeonato
   left join cte_qtd_jogos_vis         f with(nolock)on f.ID_Jogador = a.ID_Jogador
                                                    and f.ID_Campeonato = c.ID_Campeonato
   left join cte_qtd_jogos_subst_anf   g with(nolock)on g.ID_Jogador = a.ID_Jogador
                                                    and g.ID_Campeonato = c.ID_Campeonato
   left join cte_qtd_jogos_subst_vis   h with(nolock)on h.ID_Jogador = a.ID_Jogador
                                                    and h.ID_Campeonato = c.ID_Campeonato
   left join cte_qtd_ast_anf           i with(nolock)on i.ID_Jogador = a.ID_Jogador
                                                    and i.ID_Campeonato = c.ID_Campeonato
   left join cte_qtd_ast_vis           j with(nolock)on j.ID_Jogador = a.ID_Jogador
                                                    and j.ID_Campeonato = c.ID_Campeonato
       where a.ID_tipo_evento in (1,5,9) --Gol, Gol de Penalti, Gol de Falta 
       group by a.ID_Jogador 
              , d.Nome_Reduzido
              , c.Campeonato
              , isnull(e.Jogos,0) 
		      + isnull(f.Jogos,0)
		      + isnull(g.Jogos,0)
		      + isnull(h.Jogos,0)
              , isnull(i.Assistencias,0)
		      + isnull(j.Assistencias,0)

