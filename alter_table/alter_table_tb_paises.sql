/* Criando constraints do tipo Unique para evitar o cadastramento de informações duplicadas nas tabelas */

ALTER TABLE tb_paises
ADD UNIQUE (Nome_Pais)
