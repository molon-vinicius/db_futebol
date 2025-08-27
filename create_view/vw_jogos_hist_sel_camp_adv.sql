create or alter view vw_jogos_hist_sel_camp_adv

as

with 
cte_qtd_jogos (ID_Campeonato
             , ID_Selecao
             , ID_Adversario
             , Jogos
             , Descricao
             , Vitorias
             , Empates
             , Derrotas
             , Gols_Pro
             , Gols_Contra )
as  ( 

     select x.ID_Campeonato    as ID_Campeonato
          , x.ID_Selecao       as ID_Selecao
          , x.ID_Adversario    as ID_Adversario
          , sum(x.Jogos)       as Jogos
          , x.Descricao        as Descricao
          , sum(x.Vitorias)    as Vitorias
          , sum(x.Empates)     as Empates
          , sum(x.Derrotas)    as Derrotas
          , sum(x.Gols_Pro)    as Gols_Pro
          , sum(x.Gols_Contra) as Gols_Contra
       from (
           select count(a.ID_Jogo_Selecao)    as Jogos
                , a.ID_Anfitriao              as ID_Selecao
                , a.ID_Visitante              as ID_Adversario
                , b.ID_Campeonato
                , c.Descricao
                , sum(iif(a.GA > a.GV, 1, 0)) as Vitorias
                , sum(iif(a.GA = a.GV, 1, 0)) as Empates
                , sum(iif(a.GA < a.GV, 1, 0)) as Derrotas
                , sum(a.GA)                   as Gols_Pro                      
                , sum(a.GV)                   as Gols_Contra
             from vw_jogos_selecoes               a with(nolock)
             join tb_campeonatos_edicoes          b with(nolock)on b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
             join tb_campeonatos                  c with(nolock)on c.ID_Campeonato = b.ID_Campeonato
		    group by a.ID_Anfitriao
                   , a.ID_Visitante
                   , c.Descricao
                   , b.ID_Campeonato 
              
            union all

           select count(a.ID_Jogo_Selecao)    as Jogos
                , a.ID_Visitante              as ID_Selecao
                , a.ID_Anfitriao              as ID_Adversario
                , b.ID_Campeonato
                , c.Descricao
                , sum(iif(a.GV > a.GA, 1, 0)) as Vitorias
                , sum(iif(a.GV = a.GA, 1, 0)) as Empates
                , sum(iif(a.GV < a.GA, 1, 0)) as Derrotas
                , sum(a.GV)                   as Gols_Pro                      
                , sum(a.GA)                   as Gols_Contra
             from vw_jogos_selecoes               a with(nolock)
             join tb_campeonatos_edicoes          b with(nolock)on b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
             join tb_campeonatos                  c with(nolock)on c.ID_Campeonato = b.ID_Campeonato
		    group by a.ID_Visitante
                   , a.ID_Anfitriao
                   , c.Descricao
                   , b.ID_Campeonato   )            x
      group by x.ID_Selecao
             , x.ID_Adversario 
             , x.ID_Campeonato
             , x.Descricao
	) 
      
      select c.Descricao             as Campeonato
           , a.ID_Selecao            as ID_Selecao
           , b.Nome_Selecao          as Selecao
           , a.ID_Adversario         as ID_Adversario
           , d.Nome_Selecao          as Adversario
           , a.Jogos                 as Jogos
           , a.Vitorias              as Vitorias
           , a.Empates               as Empates
           , a.Derrotas              as Derrotas
           , a.Gols_Pro              as Gols_Pro
           , a.Gols_Contra           as Gols_Contra
           , a.Gols_Pro 
           - a.Gols_Contra           as Saldo         
		from cte_qtd_jogos             a with(nolock)
        join tb_selecoes               b with(nolock)on b.ID_Selecao = a.ID_Selecao
        join tb_campeonatos            c with(nolock)on c.ID_Campeonato = a.ID_Campeonato 
        join tb_selecoes               d with(nolock)on d.ID_Selecao = a.ID_Adversario

