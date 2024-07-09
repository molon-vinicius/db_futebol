CREATE TABLE tb_jogadores_habilidades
(
	[ID_Jogador] INT NULL,
	[Periodo] VARCHAR(9) NULL,
	[Attack] INT NULL,
	[Defence] INT NULL,
	[Body_Balance] INT NULL,
	[Stamina] INT NULL,
	[Top_Speed] INT NULL,
	[Acceleration] INT NULL,
	[Response] INT NULL,
	[Agility] INT NULL,
	[Dribble_Accuracy] INT NULL,
	[Dribble_Speed] INT NULL,
	[Short_Pass_Accuracy] INT NULL,
	[Short_Pass_Speed] INT NULL,
	[Long_Pass_Accuracy] INT NULL,
	[Long_Pass_Speed] INT NULL,
	[Shot_Accuracy] INT NULL,
	[Shot_Power] INT NULL,
	[Shot_Technique] INT NULL,
	[Free_Kick_Accuracy] INT NULL,
	[Curling] INT NULL,
	[Header] INT NULL,
	[Jump] INT NULL,
	[Technique] INT NULL,
	[Aggression] INT NULL,
	[Mentality] INT NULL,
	[Goalkeeper_Skills] INT NULL,
	[Team_Work] INT NULL,
	[Injury_Tolerance] INT NULL,
	[Condition] INT NULL,
	[Weak_Foot_Accuracy] INT NULL,
	[Weak_Foot_Frequency] INT NULL,
	[Consistency] INT NULL)

ALTER TABLE tb_jogadores_habilidades ADD CONSTRAINT UQ_Jogadores_Habil UNIQUE (ID_Jogador)
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD FOREIGN KEY(ID_Jogador)
REFERENCES tb_jogadores (ID_Jogador)
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_acceleration] CHECK (([Acceleration]>=(1) AND [Acceleration]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_acceleration]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_aggression] CHECK (([Aggression]>=(1) AND [Aggression]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_aggression]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_agility] CHECK (([Agility]>=(1) AND [Agility]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_agility]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_attack] CHECK (([Attack]>=(1) AND [Attack]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_attack]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_balance] CHECK (([Body_Balance]>=(1) AND [Body_Balance]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_balance]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_condition] CHECK (([Condition]>=(1) AND [Condition]<=(8)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_condition]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_consistency] CHECK (([Consistency]>=(1) AND [Consistency]<=(8)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_consistency]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_curling] CHECK (([Curling]>=(1) AND [Curling]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_curling]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_defence] CHECK (([Defence]>=(1) AND [Defence]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_defence]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_dribble_acc] CHECK (([Dribble_Accuracy]>=(1) AND [Dribble_Accuracy]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_dribble_acc]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_dribble_sp] CHECK (([Dribble_Speed]>=(1) AND [Dribble_Speed]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_dribble_sp]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_fk_acc] CHECK (([Free_Kick_Accuracy]>=(1) AND [Free_Kick_Accuracy]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_fk_acc]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_gk_skills] CHECK (([Goalkeeper_Skills]>=(1) AND [Goalkeeper_Skills]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_gk_skills]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_header] CHECK (([Header]>=(1) AND [Header]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_header]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_injury] CHECK (([Injury_Tolerance]>=(1) AND [Injury_Tolerance]<=(8)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_injury]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_jump] CHECK (([Jump]>=(1) AND [Jump]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_jump]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_long_pass_acc] CHECK (([Long_Pass_Accuracy]>=(1) AND [Long_Pass_Accuracy]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_long_pass_acc]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_long_pass_sp] CHECK (([Long_Pass_Speed]>=(1) AND [Long_Pass_Speed]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_long_pass_sp]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_mentality] CHECK (([Mentality]>=(1) AND [Mentality]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_mentality]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_response] CHECK (([Response]>=(1) AND [Response]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_response]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_short_pass_acc] CHECK (([Short_Pass_Accuracy]>=(1) AND [Short_Pass_Accuracy]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_short_pass_acc]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_short_pass_sp] CHECK (([Short_Pass_Speed]>=(1) AND [Short_Pass_Speed]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_short_pass_sp]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_shot_acc] CHECK (([Shot_Accuracy]>=(1) AND [Shot_Accuracy]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_shot_acc]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_shot_power] CHECK (([Shot_Power]>=(1) AND [Shot_Power]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_shot_power]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_shot_tech] CHECK (([Shot_Technique]>=(1) AND [Shot_Technique]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_shot_tech]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_stamina] CHECK (([Stamina]>=(1) AND [Stamina]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_stamina]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_tech] CHECK (([Technique]>=(1) AND [Technique]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_tech]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_top_speed] CHECK (([Top_Speed]>=(1) AND [Top_Speed]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_top_speed]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_tw] CHECK (([Team_Work]>=(1) AND [Team_Work]<=(99)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_tw]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_weak_foot_acc] CHECK (([Weak_Foot_Accuracy]>=(1) AND [Weak_Foot_Accuracy]<=(8)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_weak_foot_acc]
GO

ALTER TABLE tb_jogadores_habilidades  WITH CHECK ADD CONSTRAINT [Chk_column_weak_foot_freq] CHECK (([Weak_Foot_Frequency]>=(1) AND [Weak_Foot_Frequency]<=(8)))
GO

ALTER TABLE tb_jogadores_habilidades CHECK CONSTRAINT [Chk_column_weak_foot_freq]
GO
