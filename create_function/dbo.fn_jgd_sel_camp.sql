CREATE OR ALTER FUNCTION dbo.fn_jgd_sel_camp
(@id_jogador INT
,@camp VARCHAR(100))

RETURNS VARCHAR(100)

AS
BEGIN
    DECLARE @retorno VARCHAR(MAX);

    ;WITH Selecoes AS (
        SELECT 
            b.ID_Jogador,
            d.Nome_Selecao,
            c.Ano,
            c.Campeonato
        FROM tb_campeonatos_edicoes_selecoes_part a WITH (NOLOCK)
        JOIN tb_selecoes_elencos b WITH (NOLOCK)
            ON b.ID_Selecao = a.ID_Selecao
           AND b.ID_campeonato_edicao = a.ID_campeonato_edicao
        JOIN vw_campeonatos c WITH (NOLOCK)
            ON c.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
        JOIN tb_selecoes d WITH (NOLOCK)
            ON d.ID_Selecao = a.ID_Selecao
        WHERE b.ID_Jogador = @id_jogador
          AND c.Campeonato = @camp
    ),
    Agrupado AS (
        SELECT 
            Nome_Selecao,
            STRING_AGG(CONVERT(VARCHAR(4), Ano), '/') 
                WITHIN GROUP (ORDER BY Ano) AS Anos --Ordena pelo ano da competição
        FROM Selecoes
        GROUP BY Nome_Selecao
    ),
    MinAno AS (
        SELECT 
            a.Nome_Selecao,
            a.Anos,
            MIN(s.Ano) AS MinAno
        FROM Agrupado a
        JOIN Selecoes s ON s.Nome_Selecao = a.Nome_Selecao
        GROUP BY a.Nome_Selecao, a.Anos
    )
    SELECT @retorno = STRING_AGG(Anos + ' ' + Nome_Selecao, ' ')
                      WITHIN GROUP (ORDER BY MinAno)
    FROM MinAno;

    RETURN @retorno;
END;
GO
