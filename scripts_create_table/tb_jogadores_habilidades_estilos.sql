CREATE TABLE tb_jogadores_habilidades_estilos
(ID_Jogador INT NOT NULL
,P01_Classic_N10 VARCHAR(1)
,P02_Anchor_Man VARCHAR(1)
,P03_Trickster VARCHAR(1)
,P04_Darting_Run VARCHAR(1)
,P05_Mazing_Run VARCHAR(1)
,P06_Pinpoint_Pass VARCHAR(1)
,P07_Early_Cross VARCHAR(1)
,P08_Box_to_Box VARCHAR(1)
,P09_Cut_Back_Pass VARCHAR(1)
,P10_Incisive_Run VARCHAR(1)
,P11_Long_Ranger VARCHAR(1)
,P12_Enforcer VARCHAR(1)
,P13_Goal_Porcher VARCHAR(1)
,P14_Dummy_Run VARCHAR(1)
,P15_Free_Roaming VARCHAR(1)
,P16_Extra_Attacker VARCHAR(1)
,P17_Chasing_Back VARCHAR(1)
,P18_Talisman VARCHAR(1)
,P19_Fox_in_the_Box VARCHAR(1))

ALTER TABLE tb_jogadores_habilidades_estilos WITH CHECK ADD FOREIGN KEY(ID_Jogador)
REFERENCES tb_jogadores (ID_Jogador)
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P01_Classic_N10
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P02_Anchor_Man
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P03_Trickster
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P04_Darting_Run
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P05_Mazing_Run
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P06_Pinpoint_Pass
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P07_Early_Cross
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P08_Box_to_Box
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P09_Cut_Back_Pass
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P10_Incisive_Run
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P11_Long_Ranger
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P12_Enforcer
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P13_Goal_Porcher
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P14_Dummy_Run
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P15_Free_Roaming
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P16_Extra_Attacker
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P17_Chasing_Back
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P18_Talisman
GO

ALTER TABLE tb_jogadores_habilidades_estilos ADD  DEFAULT ('N') FOR P19_Fox_in_the_Box
GO

ALTER TABLE tb_jogadores_habilidades_especiais ADD CONSTRAINT UQ_jog_hab_esp UNIQUE (ID_Jogador)
