CREATE TABLE tb_selecoes_elencos
(ID_Selecao_Elenco NUMERIC(15) IDENTITY(1,1) PRIMARY KEY NOT NULL
,ID_Selecao INT NOT NULL
,ID_Campeonato_Edicao INT NOT NULL
,ID_Jogador INT NOT NULL
,Camisa VARCHAR(2) NULL
,Capitao VARCHAR(1) NULL
,Nome_Camisa VARCHAR(20) NULL
,Posicoes VARCHAR(60) NOT NULL)

ALTER TABLE tb_selecoes_elencos WITH CHECK ADD FOREIGN KEY(ID_campeonato_edicao)
REFERENCES tb_campeonatos_edicoes (ID_Campeonato_Edicao)
GO

ALTER TABLE tb_selecoes_elencos WITH CHECK ADD FOREIGN KEY(ID_Jogador)
REFERENCES tb_jogadores (ID_Jogador)
GO

ALTER TABLE tb_selecoes_elencos WITH CHECK ADD FOREIGN KEY(ID_Selecao)
REFERENCES tb_selecoes (ID_Selecao)
GO
