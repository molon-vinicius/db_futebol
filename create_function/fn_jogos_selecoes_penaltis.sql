CREATE OR ALTER FUNCTION dbo.fn_jogos_selecoes_penaltis
(
    @ID_Jogo_Selecao INT = NULL
)
RETURNS TABLE
AS
RETURN
(
WITH PenaltiNumerado AS (
    SELECT a.ID_Jogo_Selecao_Penalti
         , a.ID_Jogo_Selecao
         , a.ID_Selecao
         , b.Nome_Selecao
         , a.ID_Jogador
         , c.Nome_Reduzido
         , CASE WHEN a.Gol = 0 
                THEN 'X' 
                ELSE 'O' 
           END      AS Gol
         , ROW_NUMBER() OVER ( PARTITION BY a.ID_Jogo_Selecao, a.ID_Selecao 
                               ORDER BY a.ID_Jogo_Selecao_Penalti ) AS OrdemPorSelecao
      FROM dbo.tb_jogos_selecoes_penaltis a WITH (NOLOCK)
      JOIN dbo.tb_selecoes                b WITH (NOLOCK) ON b.ID_Selecao = a.ID_Selecao
      JOIN dbo.vw_jogadores               c WITH (NOLOCK) ON c.ID_Jogador = a.ID_Jogador
     WHERE @ID_Jogo_Selecao IS NULL 
        OR a.ID_Jogo_Selecao = @ID_Jogo_Selecao
),
SelecaoQueComeca AS (
    -- pega, por jogo, a linha com o menor ID_Jogo_Selecao_Penalti e retorna a seleção dessa linha
    SELECT ID_Jogo_Selecao
         , ID_Selecao AS ID_Selecao_Inicial
      FROM (
          SELECT ID_Jogo_Selecao, ID_Selecao,
                 ROW_NUMBER() OVER (PARTITION BY ID_Jogo_Selecao ORDER BY ID_Jogo_Selecao_Penalti) AS rn
            FROM dbo.tb_jogos_selecoes_penaltis
           WHERE @ID_Jogo_Selecao IS NULL OR ID_Jogo_Selecao = @ID_Jogo_Selecao
       ) x
     WHERE rn = 1
)

    SELECT p.ID_Jogo_Selecao_Penalti
         , p.ID_Jogo_Selecao
         , p.ID_Selecao
         , p.Nome_Selecao
         , p.ID_Jogador
         , p.Nome_Reduzido
         , p.Gol
         , p.OrdemPorSelecao
         , CASE WHEN p.ID_Selecao = s.ID_Selecao_Inicial 
                THEN p.OrdemPorSelecao * 2 - 1 
                ELSE p.OrdemPorSelecao*2 
           END      AS OrdemExibicao
         , CASE WHEN p.ID_Selecao = s.ID_Selecao_Inicial 
                THEN 1 
                ELSE 0 
           END      AS PrimeiraSelecao
      FROM PenaltiNumerado   p
      JOIN SelecaoQueComeca  s ON s.ID_Jogo_Selecao = p.ID_Jogo_Selecao
)

