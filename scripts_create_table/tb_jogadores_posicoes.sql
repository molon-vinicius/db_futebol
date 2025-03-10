CREATE TABLE tb_jogadores_posicoes
(ID_Jogador INT NOT NULL
,GK VARCHAR(1) NULL
,CB VARCHAR(1) NULL
,SB VARCHAR(1) NULL
,SW VARCHAR(1) NULL
,WB VARCHAR(1) NULL
,DM VARCHAR(1) NULL
,CM VARCHAR(1) NULL
,SM VARCHAR(1) NULL
,AM VARCHAR(1) NULL
,WF VARCHAR(1) NULL
,SS VARCHAR(1) NULL
,CF VARCHAR(1) NULL) 
GO

ALTER TABLE tb_jogadores_posicoes ADD  DEFAULT ('N') FOR GK
GO

ALTER TABLE tb_jogadores_posicoes ADD  DEFAULT ('N') FOR CB
GO

ALTER TABLE tb_jogadores_posicoes ADD  DEFAULT ('N') FOR SB
GO

ALTER TABLE tb_jogadores_posicoes ADD  DEFAULT ('N') FOR SW
GO

ALTER TABLE tb_jogadores_posicoes ADD  DEFAULT ('N') FOR WB
GO

ALTER TABLE tb_jogadores_posicoes ADD  DEFAULT ('N') FOR DM
GO

ALTER TABLE tb_jogadores_posicoes ADD  DEFAULT ('N') FOR CM
GO

ALTER TABLE tb_jogadores_posicoes ADD  DEFAULT ('N') FOR SM
GO

ALTER TABLE tb_jogadores_posicoes ADD  DEFAULT ('N') FOR AM
GO

ALTER TABLE tb_jogadores_posicoes ADD  DEFAULT ('N') FOR WF
GO

ALTER TABLE tb_jogadores_posicoes ADD  DEFAULT ('N') FOR SS
GO

ALTER TABLE tb_jogadores_posicoes ADD  DEFAULT ('N') FOR CF
GO

ALTER TABLE tb_jogadores_posicoes WITH CHECK ADD FOREIGN KEY(ID_Jogador)
REFERENCES tb_jogadores (ID_Jogador)
GO

alter table tb_jogadores_posicoes add constraint uq_jogadores_posicoes unique (ID_Jogador)

ALTER TABLE tb_jogadores_posicoes
ADD CONSTRAINT chk_posicoes 
    CHECK (GK in ('S','N','P')
       and CB in ('S','N','P')
       and SB in ('S','N','P')
       and SW in ('S','N','P')
       and WB in ('S','N','P')
       and DM in ('S','N','P')
       and CM in ('S','N','P')
       and SM in ('S','N','P')
       and AM in ('S','N','P')
       and WF in ('S','N','P')
       and SS in ('S','N','P')
       and CF in ('S','N','P'))
