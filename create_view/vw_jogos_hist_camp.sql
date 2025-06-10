create or alter view vw_jogos_hist_camp

as

with 
cte_qtd_jogos_anf (Jogos, ID_Jogador, ID_Campeonato, Descricao)
as  ( 
      select count(a.ID_Jogo_Selecao) as Jogos
           , b.ID_Jogador
           , c.ID_Campeonato
           , d.Descricao
        from tb_jogos_selecoes            a with(nolock)
        join tb_jogos_selecoes_anfitrioes b with(nolock)on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
        join tb_campeonatos_edicoes       c with(nolock)on c.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
        join tb_campeonatos               d with(nolock)on d.ID_Campeonato = c.ID_Campeonato
       group by b.ID_Jogador
              , d.Descricao
              , c.ID_Campeonato ) ,
			  
cte_qtd_jogos_vis (Jogos, ID_Jogador, ID_Campeonato, Descricao)
as  ( 
      select count(a.ID_Jogo_Selecao) as Jogos
           , b.ID_Jogador
           , c.ID_Campeonato
           , d.Descricao
        from tb_jogos_selecoes            a with(nolock)
        join tb_jogos_selecoes_visitantes b with(nolock)on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
        join tb_campeonatos_edicoes       c with(nolock)on c.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
        join tb_campeonatos               d with(nolock)on d.ID_Campeonato = c.ID_Campeonato
       group by b.ID_Jogador
              , d.Descricao
              , c.ID_Campeonato ) 

      select a.ID_Jogador                                as ID_Jogador
           , a.Nome_Reduzido                             as Jogador
           , dbo.fn_jgd_sel_camp(a.ID_Jogador           
                                ,isnull(e.Descricao,f.Descricao)) as Selecao
           , isnull(e.Jogos, 0) 
           + isnull(f.Jogos, 0)                          as Jogos
           , isnull(e.ID_Campeonato,f.ID_Campeonato)     as ID_Campeonato
        from vw_jogadores              a with(nolock)
   left join cte_qtd_jogos_anf         e with(nolock)on e.ID_Jogador = a.ID_Jogador
   left join cte_qtd_jogos_vis         f with(nolock)on f.ID_Jogador = a.ID_Jogador
       where isnull(e.Jogos, 0) + isnull(f.Jogos, 0) > 0

