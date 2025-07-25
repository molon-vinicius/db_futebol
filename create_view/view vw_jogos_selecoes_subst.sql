create or alter view vw_jogos_selecoes_subst

as

     select x.ID_Jogo_Selecao_Substituicao    as ID_Jogo_Sel_Subst
          , x.ID_Jogo_Selecao                 as ID_Jogo_Selecao
          , a.Descricao_Completa              as Desc_Completa
          , x.ID_Selecao                      as ID_Selecao
          , d.Nome_Selecao                    as Nome_Selecao  
          , x.ID_Jogador_Entrada              as ID_Jgd_Entrada
          , b.Nome_Reduzido                   as Nome_Jgd_Entrada
          , b.Posicoes                        as Pos_Jgd_Entrada
          , x.ID_Jogador_Saida                as ID_Jgd_Saida
          , c.Nome_Reduzido                   as Nome_Jgd_Saida
          , c.Posicoes                        as Pos_Jgd_Saida
          , x.Minuto                          as Minuto
          , x.Acrescimos                      as Acresc
       from tb_jogos_selecoes_substituicoes   x	with(nolock)
       join vw_jogos_selecoes                 a with(nolock)on a.ID_Jogo_Selecao = x.ID_Jogo_Selecao
       join vw_jogadores                      b with(nolock)on b.ID_Jogador = x.ID_Jogador_Entrada
       join vw_jogadores                      c with(nolock)on c.ID_Jogador = x.ID_Jogador_Saida
       join tb_selecoes                       d with(nolock)on d.ID_Selecao = x.ID_Selecao


