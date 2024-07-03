CREATE TABLE tb_pessoas
(ID_Pessoa INT IDENTITY(1,1) PRIMARY KEY NOT NULL
,Nome_Completo NVARCHAR(128) NOT NULL
,Nome_Reduzido VARCHAR(60) NOT NULL
,Altura NUMERIC(15, 2) NULL
,ID_Cidade_Nascimento INT NULL
,Dupla_Cidadania INT NULL
,Pais_Preferencial INT NOT NULL
,Data_Nascimento VARCHAR(10) NULL
,Data_Obito VARCHAR(10) NULL) 
GO

ALTER TABLE tb_pessoas WITH CHECK ADD FOREIGN KEY(Dupla_Cidadania)
REFERENCES tb_paises (ID_Pais)
GO

ALTER TABLE tb_pessoas WITH CHECK ADD FOREIGN KEY(ID_Cidade_Nascimento)
REFERENCES tb_cidades (ID_Cidade)
GO

ALTER TABLE tb_pessoas WITH CHECK ADD FOREIGN KEY(Pais_Preferencial)
REFERENCES tb_paises (ID_Pais)
GO
