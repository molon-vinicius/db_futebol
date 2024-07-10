CREATE TABLE tb_jogos_selecoes_eventos
(ID_Jogo_Selecao_Evento NUMERIC(15) IDENTITY(1,1) PRIMARY KEY NOT NULL
,ID_Jogo_Selecao NUMERIC(15) NOT NULL
,ID_Tipo_Evento INT NOT NULL
,Minuto TINYINT NULL
,Acrescimos TINYINT NULL
,ID_Selecao INT NOT NULL
,ID_Jogador INT NOT NULL
,Observacao VARCHAR(100) NULL)


ALTER TABLE tb_jogos_selecoes_eventos WITH CHECK ADD FOREIGN KEY(ID_Jogo_Selecao)
REFERENCES tb_jogos_selecoes (ID_Jogo_Selecao)
GO

ALTER TABLE tb_jogos_selecoes_eventos WITH CHECK ADD FOREIGN KEY(ID_Jogador)
REFERENCES tb_jogadores (ID_Jogador)
GO

ALTER TABLE tb_jogos_selecoes_eventos WITH CHECK ADD FOREIGN KEY(ID_Selecao)
REFERENCES tb_selecoes (ID_Selecao)
GO

ALTER TABLE tb_jogos_selecoes_eventos WITH CHECK ADD FOREIGN KEY(ID_Tipo_Evento)
REFERENCES tb_tipos_eventos (ID_Tipo_Evento)
GO
