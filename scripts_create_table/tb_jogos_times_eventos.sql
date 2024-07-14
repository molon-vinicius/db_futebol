CREATE TABLE tb_jogos_times_eventos
(ID_Jogo_Time_Evento NUMERIC(15) IDENTITY(1,1) PRIMARY KEY NOT NULL
,ID_Jogo_Time NUMERIC(15) NOT NULL
,ID_Tipo_Evento INT NOT NULL
,Minuto TINYINT NOT NULL
,ID_Time NUMERIC(15) NOT NULL
,ID_Jogador INT NOT NULL
,Acrescimos_45 TINYINT NULL
,Acrescimos_90 TINYINT NULL
,Acrescimos_105 TINYINT NULL
,Acrescimos_120 TINYINT NULL)

ALTER TABLE tb_jogos_times_eventos WITH CHECK ADD FOREIGN KEY(ID_Jogo_Time)
REFERENCES tb_jogos_times (ID_Jogo_Time)
GO

ALTER TABLE tb_jogos_times_eventos WITH CHECK ADD FOREIGN KEY(ID_Jogador)
REFERENCES tb_jogadores (ID_Jogador)
GO

ALTER TABLE tb_jogos_times_eventos WITH CHECK ADD FOREIGN KEY(ID_Tipo_Evento)
REFERENCES tb_tipos_eventos (ID_Tipo_Evento)
GO

ALTER TABLE tb_jogos_times_eventos WITH CHECK ADD FOREIGN KEY(ID_Time)
REFERENCES tb_times (ID_Time)
GO


