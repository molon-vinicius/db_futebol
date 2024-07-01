/* No caso abaixo será necessário a criação de duas Constraints por conta da relação com a tabela 'tb_estados' */
/* A priori a tabela 'tb_estados' só terá relação com cidades do Brasil, porém, existem algumas cidades de mesmo nome em estados diferentes */
/* Há também cidades com mesmo nome em países diferentes também, por isso a criação das duas restrições abaixo */

ALTER TABLE tb_cidades
ADD UNIQUE (Nome_Cidade, ID_Estado)

ALTER TABLE tb_cidades
ADD UNIQUE (Nome_Cidade, ID_Pais)
