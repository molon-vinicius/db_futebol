DECLARE @NOME_ARQUIVO VARCHAR(100) 
DECLARE @DIRETORIO    VARCHAR(500)
SET @NOME_ARQUIVO = 'db_futebol_bkp_' 
                  + CASE WHEN CONVERT(VARCHAR(2), DAY(GETDATE())) < 10
                         THEN '0' + CONVERT(VARCHAR(2), DAY(GETDATE()))
                         ELSE CONVERT(VARCHAR(2), DAY(GETDATE())) 
                    END  + '_' 
                  + CASE WHEN CONVERT(VARCHAR(2), MONTH(GETDATE())) < 10
                         THEN '0' + CONVERT(VARCHAR(2), MONTH(GETDATE()))
                         ELSE CONVERT(VARCHAR(2), MONTH(GETDATE())) 
                    END  + '_' 
                  + CONVERT(VARCHAR(4), YEAR(GETDATE())) 
  
SET @DIRETORIO = CONCAT('C:\backup\', @NOME_ARQUIVO, '.bak')

BACKUP DATABASE [db_futebol] TO DISK = @DIRETORIO  
WITH NOFORMAT, NOINIT, NAME = @NOME_ARQUIVO, SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
