create pr alter view vw_jogos_selecoes_penaltis

as

    select a.ID_jogo_selecao_penalti
         , a.ID_jogo_selecao
         , a.ID_Selecao
         , b.Nome_Selecao
         , a.ID_jogador 
         , c.Nome_Reduzido
         , case when a.Gol = 0
                then 'X'
                else 'O'
           end       as Gol
      from tb_jogos_selecoes_penaltis  a with(nolock) 
      join tb_selecoes                 b with(nolock)on b.ID_Selecao = a.ID_Selecao  
      join vw_jogadores                c with(nolock)on c.ID_Jogador = a.ID_Jogador

