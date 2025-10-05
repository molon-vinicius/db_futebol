CREATE OR ALTER TRIGGER tr_selecoes_tecnicos
ON dbo.tb_selecoes_tecnicos
FOR INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON

    IF EXISTS (
        SELECT 1
          FROM inserted i
     LEFT JOIN tb_campeonatos_edicoes_selecoes_part   p  ON p.ID_Campeonato_Edicao = i.ID_Campeonato_Edicao
                                                        AND p.ID_Selecao = i.ID_Selecao
         WHERE p.ID_Selecao IS NULL
    )
    BEGIN
        RAISERROR ('Seleção não participou desta edição da competição.', 11, 127)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF EXISTS (
        SELECT i.ID_Tecnico, i.ID_Campeonato_Edicao
          FROM inserted i
          JOIN tb_selecoes_tecnicos t   ON t.ID_Campeonato_Edicao = i.ID_Campeonato_Edicao
                                       AND t.ID_Tecnico = i.ID_Tecnico
                                       AND t.ID_Selecao_Tecnico <> i.ID_Selecao_Tecnico
         GROUP BY i.ID_Tecnico, i.ID_Campeonato_Edicao
    )
    BEGIN
        RAISERROR ('Técnico já cadastrado em outra seleção desta edição.', 11, 127)
        ROLLBACK TRANSACTION
        RETURN
    END
END
GO
