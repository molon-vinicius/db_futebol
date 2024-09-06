create view vw_jogadores 
  
as  
  select a.ID_Jogador
       , b.Nome_Reduzido  
       , dbo.fn_pessoas_nacionalidade(b.Nome_Completo) as Nacionalidade
       , case when Pe_Preferencial = 'R'
              then 'Destro'
              when Pe_Preferencial = 'L'
              then 'Canhoto'
              when Ambidestro = 'S'
              then 'Ambidestro'
              else 'Sem informação'
         end                                           as Pe_Preferencial       
       , a.Dois_Lados
       , a.Lado_Oposto       	   
    from tb_jogadores    a with(nolock)  
    join tb_pessoas      b with(nolock)on b.ID_Pessoa = a.ID_Pessoa  


