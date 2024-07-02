CREATE TABLE tb_campeonatos_edicoes
(ID_Campeonato_Edicao INT IDENTITY(1,1) PRIMARY KEY NOT NULL
,ID_Campeonato INT NOT NULL
,Ano VARCHAR(4) NOT NULL
,Pais_Sede INT NOT NULL)

ALTER TABLE tb_campeonatos_edicoes WITH CHECK ADD FOREIGN KEY(ID_Campeonato)
REFERENCES tb_campeonatos (ID_Campeonato)
GO
