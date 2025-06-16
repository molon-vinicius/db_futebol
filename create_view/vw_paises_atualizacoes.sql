create or alter view vw_paises_atualizacoes

as

    select a.ID_Pais_Antigo       as ID_Pais_Antigo
         , b.Nome_Pais            as Nome_Pais_Antigo
         , format(a.Inicio_vigencia,'dd/MM/yyyy') as Inicio_Vigencia
         , format(a.Fim_Vigencia   ,'dd/MM/yyyy') as Fim_Vigencia
         , a.ID_Pais_Atual        as ID_Pais_Atual
         , c.Nome_Pais            as Nome_Pais_Atual
      from tb_paises_atualizacoes   a with(nolock)
      join tb_paises                b with(nolock)on b.ID_Pais = a.ID_Pais_Antigo
      join tb_paises                c with(nolock)on c.ID_Pais = a.ID_Pais_Atual

