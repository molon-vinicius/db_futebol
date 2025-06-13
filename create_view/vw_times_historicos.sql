create or alter view vw_times_historicos

as 

     select a.ID_Time
          , x.Nome_Reduzido   as Nome_Atual
          , a.Nome_Time       as Nome_Anterior_Completo
          , a.Nome_Reduzido   as Nome_Anterior_Reduzido
          , a.ID_Cidade 
          , b.Nome_Cidade
          , b.Nome_Pais
          , a.Data_Inicio     as Inicio_Periodo 
          , a.Data_Fim        as Fim_Periodo 
          , a.ID_Status_Historico
          , c.Descricao       as Status_Historico
          , a.Observacao
       from tb_times_historicos      a with(nolock)
       join vw_cidades               b with(nolock)on b.ID_Cidade = a.ID_Cidade
       join tb_status_historicos     c with(nolock)on c.ID_Status_Historico = a.ID_Status_Historico
       join tb_times                 x with(nolock)on x.ID_Time = a.ID_Time

