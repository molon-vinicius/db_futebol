create view vw_tecnicos  
  
as  
  select a.ID_Tecnico  
       , b.Nome_Reduzido  
       , dbo.fn_pessoas_nacionalidade(b.Nome_Reduzido) as Nacionalidade  
    from tb_tecnicos     a with(nolock)  
    join tb_pessoas      b with(nolock)on b.ID_Pessoa = a.ID_Pessoa  
