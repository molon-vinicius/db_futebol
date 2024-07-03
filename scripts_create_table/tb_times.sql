CREATE TABLE tb_times
(ID_time NUMERIC(15) IDENTITY(1,1) PRIMARY KEY NOT NULL
,Nome_Time VARCHAR(128) NULL
,ID_Cidade INT NULL)

ALTER TABLE tb_times WITH CHECK ADD FOREIGN KEY(ID_Cidade)
REFERENCES tb_cidades (ID_Cidade)
GO
