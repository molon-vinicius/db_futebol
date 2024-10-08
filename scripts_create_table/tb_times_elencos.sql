CREATE TABLE tb_times_elencos 
(ID_Time_Elenco NUMERIC(15) IDENTITY(1,1) PRIMARY KEY NOT NULL
,ID_Time NUMERIC(15) NOT NULL
,Temporada VARCHAR(9) NOT NULL
,ID_Jogador INT NOT NULL
,Camisa VARCHAR(2) NULL
,Data_Entrada DATE NOT NULL
,Data_Saida DATE NOT NULL
,Capitao VARCHAR(1) NULL
,Nome_Camisa VARCHAR(20) NULL
,Posicoes VARCHAR(20) NOT NULL)

ALTER TABLE tb_times_elencos WITH CHECK ADD FOREIGN KEY(ID_Jogador)
REFERENCES tb_jogadores (ID_Jogador)
GO

ALTER TABLE tb_times_elencos WITH CHECK ADD FOREIGN KEY(ID_Time)
REFERENCES tb_times (ID_Time)
GO
