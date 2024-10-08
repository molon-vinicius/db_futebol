CREATE TABLE tb_cidades
(ID_Cidade INT IDENTITY(1,1) PRIMARY KEY NOT NULL
,Nome_Cidade VARCHAR(120) NOT NULL
,ID_Pais INT NOT NULL
,ID_Estado NUMERIC(15, 0) NULL
)

ALTER TABLE tb_cidades WITH CHECK ADD FOREIGN KEY(ID_Estado)
REFERENCES tb_estados (ID_Estado)
GO

ALTER TABLE tb_cidades WITH CHECK ADD FOREIGN KEY(ID_Pais)
REFERENCES tb_paises (ID_Pais)
GO

ALTER TABLE tb_cidades ADD CONSTRAINT uq_cidades UNIQUE (Nome_Cidade, ID_estado, ID_Pais)
GO
