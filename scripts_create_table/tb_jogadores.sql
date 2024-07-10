CREATE TABLE tb_jogadores
(ID_Jogador INT IDENTITY(1,1) PRIMARY KEY NOT NULL
,Pe_Preferencial VARCHAR(1) NULL
,ID_Pessoa INT NOT NULL
,Ambidestro VARCHAR(1) NULL
,Lado_Oposto VARCHAR(1) NULL
,Dois_Lados VARCHAR(1) NULL) 
GO

ALTER TABLE tb_jogadores WITH CHECK ADD FOREIGN KEY(ID_Pessoa)
REFERENCES tb_pessoas (ID_Pessoa)
GO

ALTER TABLE tb_jogadores ADD CONSTRAINT UQ_jogadores UNIQUE (ID_Pessoa)
GO

ALTER TABLE tb_jogadores ADD CONSTRAINT df_ambidestro DEFAULT ('N') FOR Ambidestro
GO

ALTER TABLE tb_jogadores ADD CONSTRAINT df_lado_oposto DEFAULT ('N') FOR Lado_Oposto
GO

ALTER TABLE tb_jogadores ADD CONSTRAINT df_dois_lados DEFAULT ('N') FOR Dois_Lados
GO

