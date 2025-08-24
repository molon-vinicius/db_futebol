create function fn_selecoes_visitantes  
(@id_jogo_selecao int)
returns @elenco table 
(camisa int
,capitao varchar(1)
,id_jogador int
,nome_reduzido varchar(60)
,id_pos_pref tinyint  
,posicoes varchar(60))

as 

/* teste */
--declare @id_jogo_selecao int = 55

--declare @elenco table 
--(camisa int
--,capitao varchar(1)
--,id_jogador int
--,nome_reduzido varchar(60)
--,id_posicao varchar(2)
--,posicoes varchar(60))

begin
 insert into @elenco (camisa, capitao, id_jogador, nome_reduzido, posicoes)
      select a.camisa
           , a.capitao
           , a.id_jogador
           , case when a.capitao = 'P' or y.ID_Jogador is not null
                  then concat(c.Nome_Reduzido, ' (C)')
                  else c.Nome_Reduzido
             end                 as Nome_Reduzido
           , dbo.fn_id_posicao_preferencial(a.id_jogador)  as ID_Pos_Pref 
           , dbo.fn_jogadores_posicoes(a.id_jogador) as Posicoes
        from tb_jogos_selecoes            x with(nolock)
        join tb_selecoes_elencos          a with(nolock)on a.ID_selecao = x.ID_selecao_visitante
                                                       and a.ID_Campeonato_Edicao = x.ID_Campeonato_Edicao
        join tb_jogos_selecoes_visitantes b with(nolock)on b.ID_selecao = a.ID_selecao
                                                       and b.ID_jogador = a.ID_jogador
                                                       and b.ID_jogo_selecao = x.ID_jogo_selecao
        join vw_jogadores                 c with(nolock)on c.ID_jogador = a.ID_jogador
   left join tb_selecoes_elencos_capitaes y with(nolock)on y.ID_Selecao = b.ID_selecao
                                                       and y.ID_jogador = b.ID_jogador
                                                       and y.ID_Jogo_selecao = b.ID_jogo_selecao
       where b.ID_jogo_selecao = @id_jogo_selecao

if not exists ( 
   select nome_reduzido
     from @elenco
    where capitao = 'P' )
begin
   update @elenco
      set nome_reduzido = concat(nome_reduzido, ' (C)')
    where capitao = 'S'
end
   return
end

