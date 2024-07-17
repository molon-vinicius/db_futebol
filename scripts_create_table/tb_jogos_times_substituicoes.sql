CREATE TABLE tb_jogos_times_substituicoes
(ID_Jogo_Time_Substituicao NUMERIC(15) IDENTITY(1,1) PRIMARY KEY NOT NULL
,ID_Jogo_Time NUMERIC(15) NOT NULL
,ID_Time NUMERIC(15) NOT NULL
,Minuto TINYINT NOT NULL
,ID_Jogador_Saida INT NOT NULL
,ID_Jogador_Entrada INT NOT NULL)

ALTER TABLE tb_jogos_times_substituicoes WITH CHECK ADD FOREIGN KEY(ID_Jogo_Time)
REFERENCES tb_jogos_times (ID_Jogo_Time)
GO

ALTER TABLE tb_jogos_times_substituicoes WITH CHECK ADD FOREIGN KEY(ID_Jogador_Saida)
REFERENCES tb_jogadores (ID_Jogador)
GO

ALTER TABLE tb_jogos_times_substituicoes WITH CHECK ADD FOREIGN KEY(ID_Jogador_Entrada)
REFERENCES tb_jogadores (ID_Jogador)
GO

ALTER TABLE tb_jogos_times_substituicoes WITH CHECK ADD FOREIGN KEY(ID_Time)
REFERENCES tb_times (ID_Time)
GO

ALTER TABLE tb_jogos_times_substituicoes
ADD CONSTRAINT UQ_jg_time_subst_saida UNIQUE (ID_Jogo_Time, ID_Time, ID_Jogador_Saida)
GO

ALTER TABLE tb_jogos_times_substituicoes
ADD CONSTRAINT UQ_jg_time_subst_entr UNIQUE (ID_Jogo_Time, ID_Time, ID_Jogador_Entrada)
GO
