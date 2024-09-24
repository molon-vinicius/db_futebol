create view vw_cidades

as 

  select a.ID_Cidade 
       , a.Nome_Cidade
       , b.ID_Pais
       , b.Nome_Pais
    from tb_cidades  a with(nolock)
    join tb_paises   b with(nolock)on b.ID_Pais = a.ID_Pais
