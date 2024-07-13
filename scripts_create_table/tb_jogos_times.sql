CREATE TABLE tb_jogos_times
(ID_Jogo_Time NUMERIC(15) IDENTITY(1,1) PRIMARY KEY NOT NULL
,Data_Jogo DATE NOT NULL
,ID_Campeonato_Edicao INT NOT NULL
,ID_Estadio NUMERIC(15) NOT NULL
,ID_Arbitro INT NOT NULL
,ID_Arbitro_Aux_1 INT NULL
,ID_Arbitro_Aux_2 INT NULL
,ID_Arbitro_Aux_3 INT NULL
,ID_Arbitro_Aux_4 INT NULL
,ID_Time_Anfitriao NUMERIC(15) NOT NULL
,ID_Time_Visitante NUMERIC(15) NOT NULL
,Observacao NVARCHAR(MAX) NULL
,Espectadores INT NULL)

ALTER TABLE tb_jogos_times WITH CHECK ADD FOREIGN KEY(ID_Arbitro_Aux_1)
REFERENCES tb_arbitros (ID_Arbitro)
GO

ALTER TABLE tb_jogos_times WITH CHECK ADD FOREIGN KEY(ID_Arbitro_Aux_2)
REFERENCES tb_arbitros (ID_Arbitro)
GO

ALTER TABLE tb_jogos_times WITH CHECK ADD FOREIGN KEY(ID_Arbitro_Aux_3)
REFERENCES tb_arbitros (ID_Arbitro)
GO

ALTER TABLE tb_jogos_times WITH CHECK ADD FOREIGN KEY(ID_Arbitro_Aux_4)
REFERENCES tb_arbitros (ID_Arbitro)
GO

ALTER TABLE tb_jogos_times WITH CHECK ADD FOREIGN KEY(ID_arbitro)
REFERENCES tb_arbitros (ID_Arbitro)
GO

ALTER TABLE tb_jogos_times WITH CHECK ADD FOREIGN KEY(ID_Campeonato_Edicao)
REFERENCES tb_campeonatos_edicoes (ID_Campeonato_Edicao)
GO

ALTER TABLE tb_jogos_times WITH CHECK ADD FOREIGN KEY(ID_Estadio)
REFERENCES tb_estadios (ID_Estadio)
GO

ALTER TABLE tb_jogos_times WITH CHECK ADD FOREIGN KEY(ID_Time_Visitante)
REFERENCES tb_times (ID_Time)
GO

ALTER TABLE tb_jogos_times WITH CHECK ADD FOREIGN KEY(ID_Time_Anfitriao)
REFERENCES tb_times (ID_Time)
GO

