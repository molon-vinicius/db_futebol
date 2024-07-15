CREATE TABLE tb_jogos_selecoes_substituicoes
(ID_Jogo_Selecao_Substituicao NUMERIC(15) IDENTITY(1,1) PRIMARY KEY NOT NULL
,ID_Jogo_Selecao NUMERIC(15) NOT NULL
,ID_Selecao INT NOT NULL
,Minuto TINYINT NULL
,Acrescimos TINYINT NULL
,ID_Jogador_Saida INT NOT NULL
,ID_Jogador_Entrada INT NOT NULL)

ALTER TABLE tb_jogos_selecoes_substituicoes WITH CHECK ADD FOREIGN KEY(ID_Jogo_Selecao)
REFERENCES tb_jogos_selecoes (ID_Jogo_Selecao)
GO

ALTER TABLE tb_jogos_selecoes_substituicoes WITH CHECK ADD FOREIGN KEY(ID_Jogador_Saida)
REFERENCES tb_jogadores (ID_Jogador)
GO

ALTER TABLE tb_jogos_selecoes_substituicoes WITH CHECK ADD FOREIGN KEY(ID_Jogador_Entrada)
REFERENCES tb_jogadores (ID_Jogador)
GO

ALTER TABLE tb_jogos_selecoes_substituicoes WITH CHECK ADD FOREIGN KEY(ID_selecao)
REFERENCES tb_selecoes (ID_Selecao)
GO

ALTER TABLE tb_jogos_selecoes_substituicoes 
ADD CONSTRAINT UQ_Jogos_Sel_Subst_Entrada UNIQUE (ID_Jogo_Selecao, ID_Selecao, ID_Jogador_Entrada)
GO

ALTER TABLE tb_jogos_selecoes_substituicoes 
ADD CONSTRAINT UQ_Jogos_Sel_Subst_Saida UNIQUE (ID_Jogo_Selecao, ID_Selecao, ID_Jogador_Saida)
GO
