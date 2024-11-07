alter view vw_jogadores 
  
as  
   select a.ID_Jogador
        , b.Nome_Reduzido  
        , dbo.fn_pessoas_nacionalidade(b.Nome_Completo) as Nacionalidade
        , isnull(c.Nome_Pais,d.Nome_Pais)               as Pais_Nascimento
        , dbo.fn_jogadores_posicoes(a.ID_Jogador)       as Posicoes
        , case when Ambidestro = 'S'
               then 'Ambidestro'
               when Pe_Preferencial = 'R'
               then 'Destro'
               when Pe_Preferencial = 'L'
               then 'Canhoto'
               when Ambidestro = 'S'
               then 'Ambidestro'
               else ' - '
          end                                           as Pe_Preferencial       
        , a.Dois_Lados
        , a.Lado_Oposto       	   
     from tb_jogadores    a with(nolock)  
     join tb_pessoas      b with(nolock)on b.ID_Pessoa = a.ID_Pessoa 
left join vw_cidades      c with(nolock)on c.ID_Cidade = b.ID_Cidade_Nascimento
     join tb_paises       d with(nolock)on d.ID_Pais   = b.Pais_Preferencial



