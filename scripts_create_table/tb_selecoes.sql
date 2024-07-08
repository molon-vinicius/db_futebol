CREATE TABLE tb_selecoes
(ID_Selecao INT IDENTITY(1,1) PRIMARY KEY NOT NULL
,Nome_Selecao VARCHAR(128) NOT NULL
,ID_Confederacao INT NOT NULL
,Ativo VARCHAR(1) NULL
,Data_Fundacao VARCHAR(10)
,Data_Encerramento VARCHAR(10))

ALTER TABLE tb_selecoes WITH CHECK ADD FOREIGN KEY(ID_Confederacao)
REFERENCES tb_confederacoes (ID_Confederacao)
GO

ALTER TABLE tb_selecoes ADD CONSTRAINT df_selecoes_ativas DEFAULT ('S') FOR Ativo
GO
