create view vw_campeonatos

as 

    select a.ID_Campeonato         
         , b.ID_Campeonato_Edicao
         , a.Descricao        as Campeonato
         , b.Ano
         , c.Nome_Pais        as Pais_Sede
         , case when a.Nacional = 'S'
                then 'Nacional'
                when a.ID_Confederacao = 0 and a.ID_Tipo_Campeonato is not null
                then 'Mundial'
                when a.Nacional = 'N' and a.ID_Confederacao > 0
                then 'Continental'
                when a.ID_Tipo_Campeonato is null
                then 'Amistoso'
           end                as Nivel 
      from tb_campeonatos           a with(nolock)
      join tb_campeonatos_edicoes   b with(nolock)on b.ID_Campeonato = a.ID_Campeonato
 left join tb_paises                c with(nolock)on c.ID_Pais = b.Pais_Sede
 
