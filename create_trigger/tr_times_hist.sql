CREATE OR ALTER TRIGGER tr_times_hist
ON tb_times_historicos
FOR INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Erro VARCHAR(255);

    ;WITH Validacoes AS (
        SELECT i.ID_Time
             , i.Situacao_Atual
             , i.Data_Inicio
             , i.Data_Fim
             , i.ID_Cidade
          FROM inserted i
    )
    SELECT TOP 1
     @Erro = CASE WHEN v.Situacao_Atual = 'S' AND v.Data_Fim IS NOT NULL
                  THEN 'Se a coluna "Situação Atual" for igual a ''S'' a coluna "Data Fim" não pode estar preenchida.'
                  WHEN v.Situacao_Atual = 'N' AND v.Data_Fim IS NULL
                  THEN 'Se a coluna "Situação Atual" for igual a ''N'' a coluna "Data Fim" não pode ser nula.'
                  WHEN v.Situacao_Atual <> 'S' AND v.Data_Inicio > v.Data_Fim
                  THEN 'Data Inicial não pode ser posterior à data final.'
             END
    FROM Validacoes v
    WHERE (v.Situacao_Atual = 'S' AND v.Data_Fim IS NOT NULL)
       OR (v.Situacao_Atual = 'N' AND v.Data_Fim IS NULL)
       OR (v.Situacao_Atual <> 'S' AND v.Data_Inicio > v.Data_Fim)

    IF @Erro IS NOT NULL
    BEGIN
        RAISERROR(@Erro, 11, 127)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF EXISTS (
        SELECT 1
          FROM inserted i
          JOIN tb_times_historicos th ON th.ID_Time = i.ID_Time
         WHERE th.ID_Status_Historico = 0
         GROUP BY i.ID_Time
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR('Time não pode ter o "Status Histórico" = 0 [Fundação] em mais de um registro.', 11, 127)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF EXISTS (
        SELECT 1
          FROM inserted i
          JOIN tb_times_historicos th ON th.ID_Time = i.ID_Time
         WHERE th.Situacao_Atual = 'S'
         GROUP BY i.ID_Time
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR('Time não pode ter mais de um registro com a "Situação Atual" = ''S''.', 11, 127)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF EXISTS (
        SELECT 1
          FROM inserted i
          JOIN tb_cidades  c1 ON c1.ID_Cidade = i.ID_Cidade
          JOIN tb_paises   p1 ON p1.ID_Pais = c1.ID_Pais
          JOIN tb_times     t ON t.ID_Time = i.ID_Time
          JOIN tb_cidades  c2 ON c2.ID_Cidade = t.ID_Cidade
          JOIN tb_paises   p2 ON p2.ID_Pais = c2.ID_Pais
         WHERE p1.ID_Pais <> p2.ID_Pais
    )
    BEGIN
        RAISERROR('A cidade informada deve ser do mesmo país cadastrado na tabela referência "tb_times".', 11, 127)
        ROLLBACK TRANSACTION
        RETURN
    END
END
GO
