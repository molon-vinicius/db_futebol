CREATE view vw_jogadores 
  
as  
  select a.ID_Jogador
       , b.Nome_Reduzido  
       , dbo.fn_pessoas_nacionalidade(b.Nome_Completo) as Nacionalidade  
    from tb_jogadores    a with(nolock)  
    join tb_pessoas      b with(nolock)on b.ID_Pessoa = a.ID_Pessoa  

