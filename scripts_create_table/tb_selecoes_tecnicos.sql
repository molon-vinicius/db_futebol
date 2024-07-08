CREATE TABLE tb_selecoes_tecnicos
(ID_Selecao_Tecnico NUMERIC(15) IDENTITY(1,1) PRIMARY KEY NOT NULL
,ID_Selecao INT NOT NULL
,ID_Campeonato_Edicao INT NOT NULL
,ID_Tecnico INT NOT NULL)

ALTER TABLE tb_selecoes_tecnicos WITH CHECK ADD FOREIGN KEY(ID_Campeonato_Edicao)
REFERENCES tb_campeonatos_edicoes (ID_Campeonato_Edicao)
GO

ALTER TABLE tb_selecoes_tecnicos WITH CHECK ADD FOREIGN KEY(ID_Selecao)
REFERENCES tb_selecoes (ID_Selecao)
GO

ALTER TABLE tb_selecoes_tecnicos WITH CHECK ADD FOREIGN KEY(ID_Tecnico)
REFERENCES tb_tecnicos (ID_Tecnico)
GO
