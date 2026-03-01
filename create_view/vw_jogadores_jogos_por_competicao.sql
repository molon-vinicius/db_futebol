create view vw_jogadores_jogos_por_competicao

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

cte_qtd_part (ID_Jogador, Jogador, ID_Campeonato, Campeonato, Jogos)
as
	(
      select coalesce(e.ID_Jogador        
	                   ,f.ID_Jogador
				        	   ,g.ID_Jogador
					           ,h.ID_Jogador)            as ID_Jogador
           , d.Nome_Reduzido                   as Jogador
		       , coalesce(e.ID_Campeonato
		                 ,f.ID_Campeonato
					           ,g.ID_Campeonato
					           ,h.ID_Campeonato )        as ID_Campeonato
           , c.Campeonato                      as Campeonato
		       , isnull(e.Jogos,0) 
		       + isnull(f.Jogos,0)                 
		       + isnull(g.Jogos,0)                 
		       + isnull(h.Jogos,0)                 as Jogos
	    	from tb_jogos_selecoes         b with(nolock)
	    	join vw_campeonatos            c with(nolock)on c.ID_Campeonato_Edicao = b.ID_campeonato_edicao
		    join vw_sel_elencos            a with(nolock)on a.ID_Campeonato_Edicao = c.ID_Campeonato_Edicao
   left join cte_qtd_jogos_anf         e with(nolock)on e.ID_Jogador = a.ID_Jogador
                                                    and e.ID_Campeonato = c.ID_Campeonato
   left join cte_qtd_jogos_vis         f with(nolock)on f.ID_Jogador = a.ID_Jogador
                                                    and f.ID_Campeonato = c.ID_Campeonato
   left join cte_qtd_jogos_subst_anf   g with(nolock)on g.ID_Jogador = a.ID_Jogador
                                                    and g.ID_Campeonato = c.ID_Campeonato
   left join cte_qtd_jogos_subst_vis   h with(nolock)on h.ID_Jogador = a.ID_Jogador
                                                    and h.ID_Campeonato = c.ID_Campeonato    
	      join vw_jogadores              d with(nolock)on d.ID_jogador = e.ID_jogador

       group by coalesce( e.ID_Jogador        
	                      , f.ID_Jogador
					              , g.ID_Jogador
					              , h.ID_Jogador)    
              , d.Nome_Reduzido
			        , coalesce( e.ID_Campeonato
		                    , f.ID_Campeonato
					              , g.ID_Campeonato
					              , h.ID_Campeonato )
              , c.Campeonato
              , isnull(e.Jogos,0) 
		          + isnull(f.Jogos,0)
		          + isnull(g.Jogos,0)
		          + isnull(h.Jogos,0)
     )

	  select ID_Jogador
	       , Jogador
		     , Campeonato		
		     , dbo.fn_qtd_part_jgd_sel( ID_Campeonato, ID_Jogador ) as Qtd_Participacoes
		     , dbo.fn_jgd_sel_camp(ID_Jogador, Campeonato)          as Descricao
		     , Jogos
	    from cte_qtd_part              qtd_part with(nolock)
