CREATE TABLE tb_confederacoes
(ID_Confederacao INT IDENTITY(1,1) PRIMARY KEY NOT NULL
,Sigla_Confederacao VARCHAR(10) NULL
,Nome_Confederacao VARCHAR(128) NULL
,ID_Continente INT NULL)

ALTER TABLE tb_confederacoes  WITH CHECK ADD FOREIGN KEY(ID_Continente)
REFERENCES tb_continentes (ID_Continente)
GO
