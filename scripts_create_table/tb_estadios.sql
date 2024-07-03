CREATE TABLE tb_estadios
(ID_Estadio NUMERIC(15) IDENTITY(1,1) PRIMARY KEY NOT NULL
,Nome_Estadio VARCHAR(128) NULL
,Nome_Reduzido VARCHAR(60) NULL
,ID_Cidade INT NOT NULL
,Ativo VARCHAR(1) NULL
,Capacidade NUMERIC(15) NULL
,Fundacao VARCHAR(10) NOT NULL
,Encerramento VARCHAR(10) NULL) 

ALTER TABLE tb_estadios WITH CHECK ADD FOREIGN KEY(ID_Cidade)
REFERENCES tb_cidades (ID_Cidade)
GO
