create view vw_estadios 

as 

    select a.ID_Estadio 
         , a.Nome_Estadio
         , a.Nome_Reduzido
         , a.Capacidade 
         , a.Ativo 
         , a.ID_Cidade
         , b.Nome_Cidade
         , c.ID_Pais
         , c.Nome_Pais
      from tb_estadios    a with(nolock)
      join tb_cidades     b with(nolock)on b.ID_Cidade = a.ID_Cidade
      join tb_paises      c with(nolock)on c.ID_Pais = b.ID_Pais
