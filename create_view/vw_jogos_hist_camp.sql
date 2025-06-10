create or alter view vw_jogos_hist_camp

as

with 
cte_qtd_jogos_anf (Jogos, ID_Jogador, ID_Campeonato, Descricao)
as  ( 
      select count(a.ID_Jogo_Selecao) as Jogos
           , b.ID_Jogador
           , c.ID_Campeonato
           , d.Descricao
        from tb_jogos_selecoes               a with(nolock)
        join tb_jogos_selecoes_anfitrioes    b with(nolock)on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
        join tb_campeonatos_edicoes          c with(nolock)on c.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
        join tb_campeonatos                  d with(nolock)on d.ID_Campeonato = c.ID_Campeonato
       group by b.ID_Jogador
              , d.Descricao
              , c.ID_Campeonato ) ,
			  
cte_qtd_jogos_vis (Jogos, ID_Jogador, ID_Campeonato, Descricao)
as  ( 
      select count(a.ID_Jogo_Selecao) as Jogos
           , b.ID_Jogador
           , c.ID_Campeonato
           , d.Descricao
        from tb_jogos_selecoes               a with(nolock)
        join tb_jogos_selecoes_visitantes    b with(nolock)on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
        join tb_campeonatos_edicoes          c with(nolock)on c.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
        join tb_campeonatos                  d with(nolock)on d.ID_Campeonato = c.ID_Campeonato    
       group by b.ID_Jogador
              , d.Descricao
              , c.ID_Campeonato ) ,

cte_qtd_jogos_sub (Jogos, ID_Jogador, ID_Campeonato, Descricao)
as (  
      select count(a.ID_Jogo_Selecao) as Jogos
           , b.ID_Jogador_Entrada     as ID_Jogador
           , c.ID_Campeonato
           , d.Descricao
        from tb_jogos_selecoes               a with(nolock)
        join tb_jogos_selecoes_substituicoes b with(nolock)on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
        join tb_campeonatos_edicoes          c with(nolock)on c.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
        join tb_campeonatos                  d with(nolock)on d.ID_Campeonato = c.ID_Campeonato    
       group by b.ID_Jogador_Entrada
              , d.Descricao
              , c.ID_Campeonato ) ,

cte_qtd_part ( ID_Jogador, ID_Campeonato , Qtd_Part ) 
as (  
      select b.ID_Jogador
           , c.ID_Campeonato
           , count(c.ID_Campeonato_Edicao) as Qtd_Part
        from tb_campeonatos_edicoes_selecoes_part  a with(nolock)
        join tb_selecoes_elencos                   b with(nolock)on b.ID_Selecao = a.ID_Selecao
                                                                and b.ID_campeonato_edicao = a.ID_campeonato_edicao
        join tb_campeonatos_edicoes                c with(nolock)on c.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
       group by b.ID_Jogador
              , c.ID_Campeonato ) ,

cte_qtd_jogos (Jogos, ID_Jogador, ID_Campeonato, Descricao)  
as (
          select Jogos, ID_Jogador, ID_Campeonato, Descricao
	    from cte_qtd_jogos_anf  
	  
	   union all 

	  select Jogos, ID_Jogador, ID_Campeonato, Descricao
	    from cte_qtd_jogos_vis  

	   union all 

	  select Jogos, ID_Jogador, ID_Campeonato, Descricao
	    from cte_qtd_jogos_sub 	)

      select distinct 
             a.ID_Jogador            as ID_Jogador
           , a.Nome_Reduzido         as Jogador
           , a.Posicoes              as Posicoes
           , dbo.fn_jgd_sel_camp
            (a.ID_Jogador           
            ,c.Descricao)            as Selecao
           , b.Qtd_Part              as Qtd_Part
           , sum(c.Jogos)            as Jogos
           , c.Descricao             as Campeonato
        from vw_jogadores              a with(nolock)
        join cte_qtd_part              b with(nolock)on b.ID_Jogador = a.ID_Jogador
        join cte_qtd_jogos             c with(nolock)on c.ID_Jogador = b.ID_Jogador
                                                    and c.ID_Campeonato = b.ID_Campeonato
       group by a.ID_Jogador
              , a.Nome_Reduzido
              , a.Posicoes    
              , b.Qtd_Part  
              , c.Descricao 

  
