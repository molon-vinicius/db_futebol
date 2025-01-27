create view vw_jogadores_sem_stats

as
   select a.ID_Jogador
        , a.Nome_Reduzido
        , a.Pais_Nascimento
        , a.Nacionalidade
        , a.Posicoes
        , a.Pe_Preferencial
     from vw_jogadores               a with(nolock)
left join tb_jogadores_habilidades   b with(nolock)on b.ID_Jogador = a.ID_Jogador 
    where b.ID_Jogador is null
