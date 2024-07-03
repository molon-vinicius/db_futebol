CREATE TABLE tb_campeonatos
(ID_Campeonato INT IDENTITY(1,1) PRIMARY KEY NOT NULL
,ID_Tipo_Campeonato INT NOT NULL
,Descricao VARCHAR(60) NOT NULL
,Ativo VARCHAR(1) NOT NULL
,ID_Confederacao INT NOT NULL
,Nacional VARCHAR(1) NULL) 

ALTER TABLE tb_campeonatos ADD CONSTRAINT df_nacional DEFAULT ('N') FOR Nacional
GO

ALTER TABLE tb_campeonatos ADD CONSTRAINT df_ativo DEFAULT ('S') FOR Ativo
GO

ALTER TABLE tb_campeonatos WITH CHECK ADD FOREIGN KEY(ID_Confederacao)
REFERENCES tb_confederacoes (ID_Confederacao)
GO

ALTER TABLE tb_campeonatos WITH CHECK ADD FOREIGN KEY(ID_Tipo_Campeonato)
REFERENCES tb_tipos_campeonatos (ID_Tipo_Campeonato)
GO
