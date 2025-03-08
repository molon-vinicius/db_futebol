create view vw_times

as 
   
    select a.ID_Time         as ID_Time
         , a.Nome_Reduzido   as Nome
         , a.Data_Fundacao   as Fundacao
         , concat(b.Nome_Cidade
                 ,iif(c.ID_Estado is not null, '/'+c.Sigla_Estado,'')
                 )           as Cidade
         , d.Nome_Pais       as Pais
      from tb_times      a with(nolock)
      join tb_cidades    b with(nolock)on b.ID_Cidade = a.ID_Cidade
 left join tb_estados    c with(nolock)on c.ID_Estado = b.ID_Estado
      join tb_paises     d with(nolock)on d.ID_Pais   = b.ID_Pais
