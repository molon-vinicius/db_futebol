CREATE TABLE tb_jogadores_habilidades_cards
(ID_Jogador INT NOT NULL
,S01_Marauding VARCHAR(1)
,S02_Passer VARCHAR(1)
,S03_1_on_1_Finish VARCHAR(1)
,S04_PK_Taker VARCHAR(1)
,S05_1_Touch_Play VARCHAR(1)
,S06_Outside_Curve VARCHAR(1)
,S07_Marking VARCHAR(1)
,S08_Slide_Tackle VARCHAR(1)
,S09_Covering VARCHAR(1)
,S10_DF_Leader VARCHAR(1)
,S11_Penalty_Saver VARCHAR(1)
,S12_1_on_1_Keeper VARCHAR(1)
,S13_Long_Throw VARCHAR(1)
,S14_Speed_Merchant VARCHAR(1)
,S15_Shoulder_Feint_Skills VARCHAR(1)
,S16_Roulette_Skills VARCHAR(1)
,S17_Flip_Flap_Skills VARCHAR(1)
,S18_Turning_Skills VARCHAR(1)
,S19_Scissors_Skills VARCHAR(1)
,S20_Flicking_Skills VARCHAR(1)
,S21_Step_On_Skills VARCHAR(1)
,S22_Side_Stepping_Skills VARCHAR(1)
,S23_Super_Sub VARCHAR(1))

ALTER TABLE tb_jogadores_habilidades_estilos WITH CHECK ADD FOREIGN KEY(ID_Jogador)
REFERENCES tb_jogadores (ID_Jogador)
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S01_Marauding
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S02_Passer
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S03_1_on_1_Finish
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S04_PK_Taker
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S05_1_Touch_Play
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S06_Outside_Curve
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S07_Marking
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S08_Slide_Tackle
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S09_Covering
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S10_DF_Leader
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S11_Penalty_Saver
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S12_1_on_1_Keeper
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S13_Long_Throw
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S14_Speed_Merchant
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S15_Shoulder_Feint_Skills
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S16_Roulette_Skills
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S17_Flip_Flap_Skills
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S18_Turning_Skills
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S19_Scissors_Skills
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S20_Flicking_Skills
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S21_Step_On_Skills
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S22_Side_Stepping_Skills
GO

ALTER TABLE tb_jogadores_habilidades_cards ADD  DEFAULT ('N') FOR S23_Super_Sub
GO
