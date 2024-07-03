CREATE TABLE tb_arbitros
(ID_Arbitro INT IDENTITY(1,1) PRIMARY KEY NOT NULL
,ID_Pessoa INT NOT NULL)

ALTER TABLE tb_arbitros WITH CHECK ADD FOREIGN KEY(ID_Pessoa)
REFERENCES tb_pessoas (ID_Pessoa)
GO
