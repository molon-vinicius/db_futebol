/* Criando constraints do tipo Unique para evitar o cadastramento de informações duplicadas nas tabelas */

ALTER TABLE tb_cidades
ADD UNIQUE (Nome_Cidade, ID_Estado, ID_Pais)

/* Por conta de só haver estados brasileiros até então, será necessário criar uma trigger para validação da referência
com a tabela 'tb_estados', porém, independente disso, a validação acima evita a duplicidade de cidades do mesmo país, 
visto que, a informação da coluna 'ID_Estado' pode ser nula */
