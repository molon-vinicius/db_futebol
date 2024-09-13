create view vw_jogos_selecoes_eventos

as

     select a.ID_jogo_selecao 
          , a.minuto
          , b.Descricao       as evento
		      , c.Nome_Selecao
		      , d.Nome_Reduzido   as jogador
		      , a.observacao
       from tb_jogos_selecoes_eventos a with(nolock)
	     join tb_tipos_eventos          b with(nolock)on b.ID_tipo_evento = a.ID_tipo_evento
       join tb_selecoes               c with(nolock)on c.ID_Selecao = a.ID_selecao
	     join vw_jogadores              d with(nolock)on d.ID_jogador = a.ID_jogador
