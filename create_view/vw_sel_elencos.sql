create view vw_sel_elencos

as

     select a.ID_Campeonato_Edicao     as ID_Campeonato_Edicao
          , concat (d.Ano, ' '
                   ,d.Campeonato, ' - '         
                   ,d.Pais_Sede)       as Campeonato  
          , a.ID_Selecao               as ID_Selecao
          , c.Nome_Selecao             as Nome_Selecao
          , a.ID_Jogador               as ID_Jogador  
          , a.Camisa                   as Camisa  
          , b.Nome_Reduzido            as Jogador  
          , a.Capitao                  as Capitao   
       from tb_selecoes_elencos         a with(nolock)
       join vw_jogadores                b with(nolock)on b.ID_Jogador = a.ID_jogador
       join tb_selecoes                 c with(nolock)on c.ID_Selecao = a.ID_Selecao
       join vw_campeonatos              d with(nolock)on d.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
      where d.Tipo_Campeonato = 'Seleção' 
	  
