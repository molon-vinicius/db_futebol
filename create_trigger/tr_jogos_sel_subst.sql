alter trigger tr_jogos_sel_subst 
           on tb_jogos_selecoes_substituicoes
for insert, update 
 
as

begin

declare @id_jogo_sel int
declare @id_selecao  int
declare @id_jgd_ent  int
declare @id_jgd_sai  int
declare @id_anf      int
declare @id_vis      int 
declare @minuto      tinyint
declare @retorno     varchar(150)

      select @id_jogo_sel = ID_Jogo_Selecao
           , @id_selecao  = ID_Selecao
           , @id_jgd_ent  = ID_Jogador_Entrada
           , @id_jgd_sai  = ID_Jogador_Saida
           , @minuto      = Minuto
        from inserted

      select @id_anf = a.ID_Selecao_Anfitriao
           , @id_vis = a.ID_Selecao_Visitante  
        from tb_jogos_selecoes  a with(nolock)
       where a.ID_Jogo_Selecao = @id_jogo_sel

  if @minuto > 120
  or @minuto = 0
  begin
     raiserror ('Minuto informado inválido, os valores devem ser entre 1 e 120 minutos. Para ''Acréscimos'' preencher a coluna equivalente.', 11, 127)
     rollback transaction
  end

  if @id_jgd_ent = @id_jgd_sai
  begin
     raiserror ('Jogador de entrada informado é igual ao jogador de saída.', 11, 127)
     rollback transaction
  end

  if  @id_selecao <> @id_anf
  and @id_selecao <> @id_vis
  begin
     raiserror ('Seleção informada não participou desta partida.', 11, 127)
     rollback transaction
  end

  if (  
     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes            a with(nolock)
       join tb_selecoes_elencos          b with(nolock)on b.ID_Selecao = a.ID_Selecao_Anfitriao
                                                      and b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
  left join tb_jogos_selecoes_anfitrioes c with(nolock)on c.ID_Selecao = b.ID_Selecao
                                                      and c.ID_Jogador = b.ID_Jogador
      where c.ID_Jogador is null
        and a.ID_Selecao_Anfitriao = @id_selecao
        and a.ID_Jogo_Selecao = @id_jogo_sel 
        and b.ID_Jogador = @id_jgd_ent
	
      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes            a with(nolock)
       join tb_selecoes_elencos          b with(nolock)on b.ID_Selecao = a.ID_Selecao_Visitante
                                                      and b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
  left join tb_jogos_selecoes_visitantes c with(nolock)on c.ID_Selecao = b.ID_Selecao
                                                      and c.ID_Jogador = b.ID_Jogador
      where c.ID_Jogador is null
        and a.ID_Selecao_Visitante = @id_selecao
        and a.ID_Jogo_Selecao = @id_jogo_sel 
        and b.ID_Jogador = @id_jgd_ent
	  ) is null
  begin
  set @retorno = (
      select concat('O jogador de entrada ''', b.Nome_Reduzido ,''' é inválido, pois não faz parte do elenco ou já está entre os titulares da partida.')
        from tb_jogadores a with(nolock)
        join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
       where a.ID_Jogador = @id_jgd_ent
	  )
     raiserror (@retorno, 11, 127)
     rollback transaction
  end

  if not exists (  
     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes            a with(nolock)
       join tb_jogos_selecoes_anfitrioes b with(nolock)on b.ID_Selecao = a.ID_Selecao_Anfitriao
      where a.ID_Jogo_Selecao = @id_jogo_sel
        and b.ID_Jogador = @id_jgd_sai
		
      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes            a with(nolock)
       join tb_jogos_selecoes_visitantes b with(nolock)on b.ID_Selecao = a.ID_Selecao_Visitante
      where a.ID_Jogo_Selecao = @id_jogo_sel
        and b.ID_Jogador = @id_jgd_sai
	  )
  begin
  set @retorno = (
      select concat('O jogador de saída ''', b.Nome_Reduzido ,''' é inválido, pois não faz parte do elenco que iniciou a partida.')
        from tb_jogadores a with(nolock)
        join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
       where a.ID_Jogador = @id_jgd_sai
	  )
     raiserror (@retorno, 11, 127)
     rollback transaction
  end

  if exists (
     select 1
       from tb_jogos_selecoes_substituicoes
      where ID_Jogo_Selecao = @id_jogo_sel
        and ID_Jogador_Saida = @id_jgd_ent
  )
  begin
     raiserror ('Jogador que saiu anteriormente no mesmo jogo não pode voltar para a partida.', 11, 127)
     rollback transaction
  end

end
