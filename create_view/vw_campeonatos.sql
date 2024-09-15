create view vw_campeonatos 

as

     select b.ID_Campeonato_Edicao  as ID_Campeonato_Edicao
          , concat(b.Ano, ' ', a.Descricao, ' - ', c.Nome_Pais) as Nome
          , b.Ano                   as Ano
          , a.Descricao             as Campeonato
          , c.Nome_Pais             as Pais_Sede     
          , a.ID_Campeonato         as ID_Campeonato
          , a.Descricao             as Campeonato
       from tb_campeonatos           a with(nolock)
       join tb_campeonatos_edicoes   b with(nolock)on b.ID_Campeonato = a.ID_Campeonato
       join tb_paises                c with(nolock)on c.ID_Pais = b.Pais_Sede
