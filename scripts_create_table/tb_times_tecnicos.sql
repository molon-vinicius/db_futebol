CREATE TABLE tb_times_tecnicos
(ID_Time_Tecnico NUMERIC(15) IDENTITY(1,1) PRIMARY KEY NOT NULL
,ID_Time NUMERIC(15) NOT NULL
,ID_Campeonato_Edicao INT NOT NULL
,ID_Tecnico INT NOT NULL
,Data_Entrada DATE NOT NULL
,Data_Saida DATE NOT NULL)

ALTER TABLE tb_times_tecnicos WITH CHECK ADD FOREIGN KEY(ID_Campeonato_Edicao)
REFERENCES tb_campeonatos_edicoes (ID_Campeonato_Edicao)
GO

ALTER TABLE tb_times_tecnicos WITH CHECK ADD FOREIGN KEY(ID_Tecnico)
REFERENCES tb_tecnicos (ID_Tecnico)
GO

ALTER TABLE tb_times_tecnicos WITH CHECK ADD FOREIGN KEY(ID_Time)
REFERENCES tb_times (ID_Time)
GO
