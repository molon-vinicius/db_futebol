CREATE TABLE tb_campeonatos_edicoes_times_part
(ID_Campeonato_Edicao INT IDENTITY(1,1) NOT NULL
,ID_Time NUMERIC(15) NULL
,Obs VARCHAR(40) NULL)

ALTER TABLE tb_campeonatos_edicoes_times_part WITH CHECK ADD FOREIGN KEY(ID_Time)
REFERENCES tb_times (ID_Time)
GO
