CREATE TABLE tb_jogos_selecoes
(ID_Jogo_Selecao NUMERIC(15) IDENTITY(1,1) PRIMARY KEY NOT NULL
,Data_Jogo DATE NULL
,ID_Campeonato_Edicao INT NULL
,ID_Estadio NUMERIC(15) NULL
,ID_Arbitro INT NULL
,ID_Arbitro_Aux_1 INT NULL
,ID_Arbitro_Aux_2 INT NULL
,ID_Arbitro_Aux_3 INT NULL
,ID_Arbitro_Aux_4 INT NULL
,Espectadores INT NULL
,ID_Selecao_Anfitriao INT NOT NULL
,ID_Selecao_Visitante INT NOT NULL
,Observacao NVARCHAR(MAX) NULL
,ID_Campeonato_Fase INT NOT NULL)

ALTER TABLE tb_jogos_selecoes WITH CHECK ADD FOREIGN KEY(ID_arbitro)
REFERENCES tb_arbitros (ID_Arbitro)
GO

ALTER TABLE tb_jogos_selecoes WITH CHECK ADD FOREIGN KEY(ID_Arbitro_Aux_1)
REFERENCES tb_arbitros (ID_Arbitro)
GO

ALTER TABLE tb_jogos_selecoes WITH CHECK ADD FOREIGN KEY(ID_Arbitro_Aux_2)
REFERENCES tb_arbitros (ID_Arbitro)
GO

ALTER TABLE tb_jogos_selecoes WITH CHECK ADD FOREIGN KEY(ID_Arbitro_Aux_3)
REFERENCES tb_arbitros (ID_Arbitro)
GO

ALTER TABLE tb_jogos_selecoes WITH CHECK ADD FOREIGN KEY(ID_Arbitro_Aux_4)
REFERENCES tb_arbitros (ID_Arbitro)
GO

ALTER TABLE tb_jogos_selecoes WITH CHECK ADD FOREIGN KEY(ID_Campeonato_Fase)
REFERENCES tb_campeonatos_fases (ID_Campeonato_Fase)
GO

ALTER TABLE tb_jogos_selecoes WITH CHECK ADD FOREIGN KEY(ID_Campeonato_Edicao)
REFERENCES tb_campeonatos_edicoes (ID_Campeonato_Edicao)
GO

ALTER TABLE tb_jogos_selecoes WITH CHECK ADD FOREIGN KEY(ID_Estadio)
REFERENCES tb_estadios (ID_Estadio)
GO

ALTER TABLE tb_jogos_selecoes WITH CHECK ADD FOREIGN KEY(ID_Selecao_Visitante)
REFERENCES tb_selecoes (ID_Selecao)
GO

ALTER TABLE tb_jogos_selecoes WITH CHECK ADD FOREIGN KEY(ID_Selecao_Anfitriao)
REFERENCES tb_selecoes (ID_Selecao)
GO

ALTER TABLE tb_jogos_selecoes
ADD UNIQUE (Data_Jogo, ID_Campeonato_Edicao, ID_Estadio, ID_Selecao_Anfitriao, ID_Selecao_Visitante)
GO
