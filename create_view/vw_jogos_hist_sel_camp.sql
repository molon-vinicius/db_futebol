create or alter view vw_jogos_hist_sel_camp

as

with 
cte_qtd_jogos (Jogos
             , ID_Selecao
             , ID_Campeonato
             , Descricao
             , Vitorias
             , Empates
             , Derrotas
             , Gols_Pro
             , Gols_Contra )
as  ( 

     select sum(x.Jogos)       as Jogos
          , x.ID_Selecao       as ID_Selecao
          , x.ID_Campeonato    as ID_Campeonato
          , x.Descricao        as Descricao
          , sum(x.Vitorias)    as Vitorias
          , sum(x.Empates)     as Empates
          , sum(x.Derrotas)    as Derrotas
          , sum(x.Gols_Pro)    as Gols_Pro
          , sum(x.Gols_Contra) as Gols_Contra
       from (
           select count(a.ID_Jogo_Selecao) as Jogos
                , a.ID_Anfitriao           as ID_Selecao
                , b.ID_Campeonato
                , c.Descricao
                , sum(iif(a.Gols_Anfitriao > a.Gols_Visitante, 1, 0)) as Vitorias
                , sum(iif(a.Gols_Anfitriao = a.Gols_Visitante, 1, 0)) as Empates
                , sum(iif(a.Gols_Anfitriao < a.Gols_Visitante, 1, 0)) as Derrotas
                , sum(a.Gols_Anfitriao)    as Gols_Pro                      
                , sum(a.Gols_Visitante)    as Gols_Contra
             from vw_jogos_selecoes               a with(nolock)
             join tb_campeonatos_edicoes          b with(nolock)on b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
             join tb_campeonatos                  c with(nolock)on c.ID_Campeonato = b.ID_Campeonato
            group by a.ID_Anfitriao
                   , c.Descricao
                   , b.ID_Campeonato 
              
            union all

           select count(a.ID_Jogo_Selecao) as Jogos
                , a.ID_Visitante           as ID_Selecao
                , b.ID_Campeonato
                , c.Descricao
                , sum(iif(a.Gols_Visitante > a.Gols_Anfitriao, 1, 0)) as Vitorias
                , sum(iif(a.Gols_Visitante = a.Gols_Anfitriao, 1, 0)) as Empates
                , sum(iif(a.Gols_Visitante < a.Gols_Anfitriao, 1, 0)) as Derrotas
                , sum(a.Gols_Visitante)    as Gols_Pro                      
                , sum(a.Gols_Anfitriao)    as Gols_Contra
             from vw_jogos_selecoes               a with(nolock)
             join tb_campeonatos_edicoes          b with(nolock)on b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
             join tb_campeonatos                  c with(nolock)on c.ID_Campeonato = b.ID_Campeonato
            group by a.ID_Visitante
                   , c.Descricao
                   , b.ID_Campeonato   )            x
      group by x.ID_Selecao
             , x.ID_Campeonato
             , x.Descricao
	) ,

cte_qtd_part ( ID_Selecao, ID_Campeonato , Qtd_Part ) 
as (  select a.ID_Selecao
           , b.ID_Campeonato
           , count(b.ID_Campeonato_Edicao) as Qtd_Part
        from tb_campeonatos_edicoes_selecoes_part  a with(nolock)
        join tb_campeonatos_edicoes                b with(nolock)on b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
       group by a.ID_Selecao
              , b.ID_Campeonato ) 

      select a.ID_Selecao            as ID_Selecao
           , c.Nome_Selecao          as Selecao
           , b.Descricao             as Campeonato
           , a.Qtd_Part              as Qtd_Part
           , b.Jogos                 as Jogos
           , b.Vitorias              as Vitorias
           , b.Empates               as Empates
           , b.Derrotas              as Derrotas
           , b.Gols_Pro              as Gols_Pro
           , b.Gols_Contra           as Gols_Contra
           , b.Gols_Pro 
           - b.Gols_Contra           as Saldo         
        from cte_qtd_part              a with(nolock)
        join cte_qtd_jogos             b with(nolock)on b.ID_Selecao = a.ID_Selecao
                                                    and b.ID_Campeonato = a.ID_Campeonato
        join tb_selecoes               c with(nolock)on c.ID_Selecao = a.ID_Selecao
  
