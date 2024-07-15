create function fn_selecoes_anfitrioes  
(@id_jogo_selecao int)
returns @elenco table 
(camisa int
,capitao varchar(1)
,id_jogador int
,nome_reduzido varchar(60)
,id_posicao int
,posicoes varchar(60))

as 

/* teste */
--declare @id_jogo_selecao int = 15
--declare @elenco table 
--(camisa int
--,capitao varchar(1)
--,nome_reduzido varchar(60)
--,id_posicao varchar(2)
--,posicoes varchar(60))

begin
insert into @elenco (camisa, capitao, id_jogador, nome_reduzido, id_posicao, posicoes)
      select a.camisa
           , a.capitao
           , a.id_jogador
           , case when a.capitao = 'P'
                  then concat(c.Nome_Reduzido, ' (C)')
                  else c.Nome_Reduzido
             end                 as Nome_Reduzido
           , d.id_posicao
           , a.posicoes 
        from tb_jogos_selecoes            x with(nolock)
        join tb_selecoes_elencos          a with(nolock)on a.ID_selecao = x.ID_selecao_anfitriao
	join tb_jogos_selecoes_anfitrioes b with(nolock)on b.ID_selecao = a.ID_selecao
                                                       and b.ID_jogador = a.ID_jogador			                        										   and b.ID_jogo_selecao = x.ID_jogo_selecao
        join vw_jogadores                 c with(nolock)on c.ID_jogador = a.ID_jogador
        join tb_posicoes                  d with(nolock)on d.Sigla_Posicao = case when substring(a.posicoes,0,2) in ('R','L')
                                                                                  then substring(a.posicoes,2,2)
                                                                                  else substring(a.posicoes,0,3)
                                                                             end 
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
