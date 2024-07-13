CREATE TABLE tb_jogos_times_visitantes
(ID_Jogo_Time_Visitante NUMERIC(15) IDENTITY(1,1) PRIMARY KEY NOT NULL
,ID_Jogo_Time NUMERIC(15) NOT NULL
,ID_Time NUMERIC(15) NOT NULL
,ID_Jogador INT NOT NULL)

ALTER TABLE tb_jogos_times_visitantes WITH CHECK ADD FOREIGN KEY(ID_Jogo_Time)
REFERENCES tb_jogos_times (ID_Jogo_Time)
GO

ALTER TABLE tb_jogos_times_visitantes WITH CHECK ADD FOREIGN KEY(ID_Jogador)
REFERENCES tb_jogadores (ID_Jogador)
GO

ALTER TABLE tb_jogos_times_visitantes WITH CHECK ADD FOREIGN KEY(ID_Time)
REFERENCES tb_times (ID_Time)
GO

ALTER TABLE tb_jogos_times_visitantes ADD CONSTRAINT UQ_jogos_time_vis UNIQUE (ID_Jogo_Selecao, ID_Selecao, ID_Jogador)
GO
