create or alter view vw_jogos_sel_sub

as

   select concat(b.Descricao_Completa,' | ',b.Fase,' | ',b.Anfitriao,' x ',b.Visitante) as Desc_Jogo
        , a.minuto
        , c.Nome_Selecao
        , d.Nome_Reduzido   as Jogador_Entrada
        , e.Nome_Reduzido   as Jogador_Saida
     from tb_jogos_selecoes_substituicoes a with(nolock)
     join vw_jogos_selecoes               b with(nolock)on b.ID_jogo_selecao = a.ID_jogo_selecao
     join tb_selecoes                     c with(nolock)on c.ID_Selecao = a.ID_Selecao
     join vw_jogadores                    d with(nolock)on d.ID_Jogador = a.ID_jogador_saida
     join vw_jogadores                    e with(nolock)on e.ID_Jogador = a.ID_jogador_entrada
