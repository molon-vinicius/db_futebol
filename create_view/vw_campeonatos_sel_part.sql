create view vw_campeonatos_sel_part

as

     select a.ID_Campeonato
          , a.ID_Campeonato_Edicao
          , concat(a.Ano, ' ', a.Campeonato, ' - ', a.Pais_Sede) as Campeonato
          , b.ID_selecao
          , c.Nome_Selecao
          , b.Grupos     
       from vw_campeonatos                       a with(nolock)
       join tb_campeonatos_edicoes_selecoes_part b with(nolock)on b.ID_campeonato_edicao = a.ID_Campeonato_Edicao
       join tb_selecoes                          c with(nolock)on c.ID_Selecao = b.ID_selecao     
