/* Criando constraints do tipo Unique para evitar o cadastramento de informações duplicadas nas tabelas */

ALTER TABLE tb_continentes
ADD UNIQUE (Nome_Continente)
