CREATE TABLE tb_jogos_selecoes_visitantes
(ID_Jogo_Selecao_Visitante NUMERIC(15) IDENTITY(1,1) PRIMARY KEY NOT NULL
,ID_Jogo_Selecao NUMERIC(15) NOT NULL
,ID_Selecao INT NOT NULL
,ID_Jogador INT NOT NULL)

ALTER TABLE tb_jogos_selecoes_visitantes WITH CHECK ADD FOREIGN KEY(ID_Jogo_Selecao)
REFERENCES tb_jogos_selecoes (ID_Jogo_Selecao)
GO

ALTER TABLE tb_jogos_selecoes_visitantes WITH CHECK ADD FOREIGN KEY(ID_Jogador)
REFERENCES tb_jogadores (ID_Jogador)
GO

ALTER TABLE tb_jogos_selecoes_visitantes WITH CHECK ADD FOREIGN KEY(ID_Selecao)
REFERENCES tb_selecoes (ID_Selecao)
GO

ALTER TABLE tb_jogos_selecoes_visitantes ADD CONSTRAINT UQ_jogos_sel_vis UNIQUE (ID_Jogo_Selecao, ID_Selecao, ID_Jogador)
GO
