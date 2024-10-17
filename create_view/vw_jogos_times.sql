create view vw_jogos_times

as 
  
   select distinct
          src.ID_jogo_time                     as ID_jogo_time 
        , format(src.Data_Jogo, 'dd/MM/yyyy')  as Data_Jogo
        , concat(ce.Ano, ' ', c.Descricao)     as Descricao_Completa
        , est.Nome_Reduzido                    as Estadio
        , dbo.fn_estadios_local(est.Nome_Reduzido) as Local_Estadio
        , src.Espectadores                     as Espectadores
        , cf.ID_Campeonato_Fase                as ID_Fase
        , cf.Descricao                         as Fase
        , anf.ID_time                          as ID_Anfitriao
        , anf.Nome_time                        as Anfitriao
        , isnull(a.gols,0)                     as Gols_Anfitriao
        , vis.ID_time                          as ID_Visitante
        , vis.Nome_time                        as Visitante
        , isnull(v.gols,0)                     as Gols_Visitante
        , arb.Nome_Reduzido                    as Arbitro_Principal
        , arb1.Nome_Reduzido                   as Auxiliar_1
        , arb2.Nome_Reduzido                   as Auxiliar_2
        , arb3.Nome_Reduzido                   as Auxiliar_3
        , arb4.Nome_Reduzido                   as Auxiliar_4
        , src.Observacao                       as Observacao
        , src.ID_campeonato_edicao             as ID_Campeonato_Edicao
        , ce.Ano                               as Ano
        , c.Descricao                          as Campeonato
     from tb_jogos_times             src with(nolock)
     join tb_campeonatos_edicoes      ce with(nolock)on ce.ID_Campeonato_Edicao = src.ID_campeonato_edicao
     join tb_campeonatos               c with(nolock)on c.ID_Campeonato = ce.ID_Campeonato
     join tb_campeonatos_fases        cf with(nolock)on cf.ID_Campeonato_Fase = src.ID_Campeonato_Fase
left join tb_paises                    p with(nolock)on p.ID_Pais = ce.Pais_Sede
     join tb_estadios                est with(nolock)on est.ID_estadio = src.ID_estadio
     join tb_cidades                cest with(nolock)on cest.ID_Cidade = est.ID_Cidade
     join tb_times                   anf with(nolock)on anf.ID_time = src.ID_time_anfitriao
left join (
         select ID_jogo_time 
              , count(ID_tipo_evento) as gols
              , ID_time
           from tb_jogos_times_eventos  with(nolock)
          where ID_tipo_evento in (1, 5, 8) -- Gol, Gol (P), Gol Contra
          group by ID_jogo_time, ID_time
                                     ) a             on a.ID_jogo_time = src.ID_jogo_time
                                                    and a.ID_time = src.ID_time_anfitriao
     join tb_times                   vis with(nolock)on vis.ID_time = src.ID_time_visitante
left join (
         select ID_jogo_time 
              , count(ID_tipo_evento) as gols
              , ID_time
           from tb_jogos_times_eventos  with(nolock)
          where ID_tipo_evento in (1, 5, 8) -- Gol, Gol (P), Gol Contra
          group by ID_jogo_time, ID_time
                                     ) v             on v.ID_jogo_time = src.ID_jogo_time
                                                    and v.ID_time = src.ID_time_visitante		 
     join vw_arbitros                arb with(nolock)on arb.ID_Arbitro = src.ID_arbitro
left join vw_arbitros               arb1 with(nolock)on arb1.ID_Arbitro = src.ID_arbitro_aux_1
left join vw_arbitros               arb2 with(nolock)on arb2.ID_Arbitro = src.ID_arbitro_aux_2
left join vw_arbitros               arb3 with(nolock)on arb3.ID_Arbitro = src.ID_arbitro_aux_3
left join vw_arbitros               arb4 with(nolock)on arb4.ID_Arbitro = src.ID_arbitro_aux_4 
    group by src.ID_jogo_time 
           , format(src.Data_Jogo, 'dd/MM/yyyy')
           , concat(ce.Ano, ' ', c.Descricao)
           , est.Nome_Reduzido
           , cest.Nome_Cidade  
           , cf.ID_Campeonato_Fase
           , cf.Descricao
           , anf.ID_time
           , anf.Nome_time
           , a.gols
           , vis.ID_time
           , vis.Nome_time
           , v.gols
           , arb.Nome_Reduzido
           , arb1.Nome_Reduzido
           , arb2.Nome_Reduzido
           , arb3.Nome_Reduzido
           , arb4.Nome_Reduzido
           , src.Observacao
           , src.ID_campeonato_edicao     
           , ce.Ano
           , c.Descricao
           , p.Nome_Pais
           , src.Espectadores

