CREATE OR ALTER TRIGGER tr_sel_elencos_cap
                     ON tb_selecoes_elencos_capitaes
FOR INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON

    IF EXISTS (
        SELECT 1
          FROM inserted i
          JOIN deleted  d ON i.ID_Jogo_Selecao <> d.ID_Jogo_Selecao
    )
    BEGIN
        RAISERROR ('Não é possível alterar o ID do jogo, necessário excluir e inserir novamente as informações.', 11, 127)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF EXISTS (
        SELECT 1
          FROM inserted i
     LEFT JOIN deleted  d ON 1=1
         WHERE NOT EXISTS (
                 SELECT 1
                   FROM tb_jogos_selecoes js WITH (NOLOCK)
                  WHERE js.ID_Jogo_Selecao = i.ID_Jogo_Selecao
                    AND i.ID_Selecao IN (js.ID_Selecao_Anfitriao, js.ID_Selecao_Visitante)
        )
    )
    BEGIN
        RAISERROR ('Não é possível inserir o capitão, pois a seleção informada não faz parte dessa partida.', 11, 127)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF EXISTS (
        SELECT 1
          FROM inserted i
         WHERE NOT EXISTS (
               SELECT 1
                 FROM tb_jogos_selecoes js WITH (NOLOCK)
            LEFT JOIN tb_jogos_selecoes_anfitrioes ja WITH (NOLOCK) ON ja.ID_Jogo_Selecao = js.ID_Jogo_Selecao
            LEFT JOIN tb_jogos_selecoes_visitantes jv WITH (NOLOCK) ON jv.ID_Jogo_Selecao = js.ID_Jogo_Selecao
                WHERE js.ID_Jogo_Selecao = i.ID_Jogo_Selecao
                  AND i.ID_Jogador IN (ja.ID_Jogador, jv.ID_Jogador)
        )
    )
    BEGIN
        RAISERROR ('Jogador informado não faz parte de nenhuma das seleções da partida.', 11, 127)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF EXISTS (
        SELECT 1
          FROM inserted i
          JOIN tb_jogos_selecoes  js WITH (NOLOCK)ON js.ID_Jogo_Selecao = i.ID_Jogo_Selecao
          JOIN tb_selecoes_elencos c WITH (NOLOCK)ON c.ID_Selecao = i.ID_Selecao
                                                 AND c.ID_Campeonato_Edicao = js.ID_Campeonato_Edicao
         WHERE c.Capitao IN ('P', 'S')
           AND EXISTS (
                   SELECT 1
                     FROM tb_selecoes_elencos_capitaes x
                    WHERE x.ID_Jogo_Selecao = i.ID_Jogo_Selecao
                      AND x.ID_Selecao = i.ID_Selecao
                      AND x.ID_Jogador <> i.ID_Jogador
          )
    )
    BEGIN
        RAISERROR ('Seleção já tem um capitão definido para essa partida.', 11, 127)
        ROLLBACK TRANSACTION
        RETURN
    END
END
GO
