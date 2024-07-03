CREATE TABLE tb_campeonatos_edicoes_selecoes_part
(ID_Campeonato_Edicao INT NOT NULL
,ID_Selecao INT NOT NULL
,Obs VARCHAR(40) NULL) 

ALTER TABLE tb_campeonatos_edicoes_selecoes_part WITH CHECK ADD FOREIGN KEY(ID_Selecao)
REFERENCES tb_selecoes (ID_Selecao)
GO


