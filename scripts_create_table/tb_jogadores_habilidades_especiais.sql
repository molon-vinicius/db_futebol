CREATE TABLE tb_jogadores_habilidades_especiais
(ID_Jogador INT NOT NULL
,Dribbling VARCHAR(1)
,Tactical_Dribble VARCHAR(1)
,Positioning VARCHAR(1)
,Playmaking VARCHAR(1)
,Scoring VARCHAR(1)
,Post_Player VARCHAR(1)
,Lines VARCHAR(1)
,Middle_Shooting VARCHAR(1)
,Side VARCHAR(1)
,Center VARCHAR(1)
,Curling_Shot VARCHAR(1))

ALTER TABLE tb_jogadores_habilidades_especiais WITH CHECK ADD FOREIGN KEY(ID_Jogador)
REFERENCES tb_jogadores (ID_Jogador)
GO

ALTER TABLE tb_jogadores_habilidades_especiais ADD  DEFAULT ('N') FOR Dribbling
GO

ALTER TABLE tb_jogadores_habilidades_especiais ADD  DEFAULT ('N') FOR Tactical_Dribble
GO

ALTER TABLE tb_jogadores_habilidades_especiais ADD  DEFAULT ('N') FOR Positioning
GO

ALTER TABLE tb_jogadores_habilidades_especiais ADD  DEFAULT ('N') FOR Playmaking
GO

ALTER TABLE tb_jogadores_habilidades_especiais ADD  DEFAULT ('N') FOR Scoring
GO

ALTER TABLE tb_jogadores_habilidades_especiais ADD  DEFAULT ('N') FOR Post_Player
GO

ALTER TABLE tb_jogadores_habilidades_especiais ADD  DEFAULT ('N') FOR Lines
GO

ALTER TABLE tb_jogadores_habilidades_especiais ADD  DEFAULT ('N') FOR Middle_Shooting
GO

ALTER TABLE tb_jogadores_habilidades_especiais ADD  DEFAULT ('N') FOR Side
GO

ALTER TABLE tb_jogadores_habilidades_especiais ADD  DEFAULT ('N') FOR Center
GO

ALTER TABLE tb_jogadores_habilidades_especiais ADD  DEFAULT ('N') FOR Curling_Shot
GO
