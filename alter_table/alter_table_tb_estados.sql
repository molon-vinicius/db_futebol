/* Criando constraints do tipo Unique para evitar o cadastramento de informações duplicadas nas tabelas */

ALTER TABLE tb_estados
ADD UNIQUE (Nome_Estado, ID_Pais)
