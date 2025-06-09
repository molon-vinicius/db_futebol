create or alter trigger tr_jogos_time_subst 
                     on tb_jogos_times_substituicoes
for insert, update 
as

begin

declare @temporada    varchar(9)
declare @id_jogo_time int
declare @id_time      int
declare @id_jgd_ent   int
declare @id_jgd_sai   int
declare @id_anf       int
declare @id_vis       int 
declare @minuto       tinyint
declare @retorno      varchar(150)
declare @jgd_sai_sub char(1)

      select @id_jogo_time = ID_Jogo_Time
           , @id_time      = ID_Time
           , @id_jgd_ent   = ID_Jogador_Entrada
           , @id_jgd_sai   = ID_Jogador_Saida
           , @minuto       = Minuto
        from inserted

      select @id_anf = a.ID_Time_Anfitriao
           , @id_vis = a.ID_Time_Visitante  
        from tb_jogos_times  a with(nolock)
       where a.ID_Jogo_Time = @id_jogo_time

      select @jgd_sai_sub = 'S'
        from tb_jogos_times_substituicoes with(nolock)
       where ID_Jogo_Time = @id_jogo_time
         and ID_Time = @id_time
         and ID_Jogador_Entrada = @id_jgd_sai   

if (select ID_Jogo_Time from deleted) is not null
begin
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

  if  @id_time <> @id_anf
  and @id_time <> @id_vis
  begin
     raiserror ('Time informado não participou desta partida.', 11, 127)
     rollback transaction
  end

  if (  
     select b.ID_Jogador  as qtd 
       from tb_jogos_times            a with(nolock)
       join tb_times_elencos          b with(nolock)on b.ID_Time = a.ID_Time_Anfitriao
                                                   and b.Temporada = @temporada
  left join tb_jogos_times_anfitrioes c with(nolock)on c.ID_Time = b.ID_Time
                                                   and c.ID_Jogador = b.ID_Jogador
                                                   and c.ID_Jogo_Time = a.ID_Jogo_Time
      where c.ID_Jogador is null
        and a.ID_Time_Anfitriao = @id_time
        and a.ID_Jogo_Time = @id_jogo_time 
        and b.ID_Jogador = @id_jgd_ent
	
      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_times            a with(nolock)
       join tb_times_elencos          b with(nolock)on b.ID_Time = a.ID_Time_Visitante
                                                   and b.Temporada = @temporada
  left join tb_jogos_times_visitantes c with(nolock)on c.ID_Time = b.ID_Time
                                                   and c.ID_Jogador = b.ID_Jogador
                                                   and c.ID_Jogo_Time = a.ID_Jogo_Time
      where c.ID_Jogador is null
        and a.ID_Time_Visitante = @id_time
        and a.ID_Jogo_Time = @id_jogo_time 
        and b.ID_Jogador = @id_jgd_ent
	  ) is null
  begin
  set @retorno = (
      select concat('O jogador de entrada ''', b.Nome_Reduzido ,''' é inválido, pois já está em campo ou não faz parte do elenco para esta partida.')
        from tb_jogadores a with(nolock)
        join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
       where a.ID_Jogador = @id_jgd_ent
	  )
  if @retorno is null begin set @retorno = 'Jogador informado não existe.' end 
     raiserror (@retorno, 11, 127)
     rollback transaction
  end

  if not exists (  
     select b.ID_Jogador  as qtd 
       from tb_jogos_times            a with(nolock)
       join tb_jogos_times_anfitrioes b with(nolock)on b.ID_Time = a.ID_Time_Anfitriao
                                                   and b.ID_Jogo_Time = a.ID_Jogo_Time
      where a.ID_Jogo_Time = @id_jogo_time
        and b.ID_Jogador = @id_jgd_sai
        and b.ID_Time = @id_time
		
      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_times            a with(nolock)
       join tb_jogos_times_visitantes b with(nolock)on b.ID_Time = a.ID_Time_Visitante
                                                   and b.ID_Jogo_Time = a.ID_Jogo_Time
      where a.ID_Jogo_Time = @id_jogo_time
        and b.ID_Jogador = @id_jgd_sai
        and b.ID_Time = @id_time
   ) 
   and isnull(@jgd_sai_sub,'N') = 'N'
  begin
  set @retorno = (
      select concat('O jogador de saída ''', b.Nome_Reduzido ,''' é inválido, pois não faz parte do elenco que iniciou a partida.')
        from tb_jogadores a with(nolock)
        join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
       where a.ID_Jogador = @id_jgd_sai
	  )
  if @retorno is null begin set @retorno = 'Jogador informado não existe.' end 
     raiserror (@retorno, 11, 127)
     rollback transaction
  end

  if exists (
     select 1
       from tb_jogos_times_substituicoes
      where ID_Jogo_Time = @id_jogo_time
        and ID_Jogador_Saida = @id_jgd_ent
  )
  begin
     raiserror ('Jogador que saiu anteriormente no mesmo jogo não pode voltar para a partida.', 11, 127)
     rollback transaction
  end
end

if (select ID_Jogo_Time from deleted) is null
begin
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

  if  @id_time <> @id_anf
  and @id_time <> @id_vis
  begin
     raiserror ('Time informado não participou desta partida.', 11, 127)
     rollback transaction
  end

  if (  
     select b.ID_Jogador  as qtd 
       from tb_jogos_times            a with(nolock)
       join tb_times_elencos          b with(nolock)on b.ID_Time = a.ID_Time_Anfitriao
                                                   and b.Temporada = @temporada
  left join tb_jogos_times_anfitrioes c with(nolock)on c.ID_Time = b.ID_Time
                                                   and c.ID_Jogador = b.ID_Jogador
                                                   and c.ID_Jogo_Time = a.ID_Jogo_Time
      where c.ID_Jogador is null
        and a.ID_Time_Anfitriao = @id_time
        and a.ID_Jogo_Time = @id_jogo_time 
        and b.ID_Jogador = @id_jgd_ent
	
      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_times            a with(nolock)
       join tb_times_elencos          b with(nolock)on b.ID_Time = a.ID_Time_Visitante
                                                   and b.Temporada = @temporada
  left join tb_jogos_times_visitantes c with(nolock)on c.ID_Time = b.ID_Time
                                                   and c.ID_Jogador = b.ID_Jogador
                                                   and c.ID_Jogo_Time = a.ID_Jogo_Time
      where c.ID_Jogador is null
        and a.ID_Time_Visitante = @id_time
        and a.ID_Jogo_Time = @id_jogo_time 
        and b.ID_Jogador = @id_jgd_ent
	  ) is null
  begin
  set @retorno = (
      select concat('O jogador de entrada ''', b.Nome_Reduzido ,''' é inválido, pois já está em campo ou não faz parte do elenco para esta partida.')
        from tb_jogadores a with(nolock)
        join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
       where a.ID_Jogador = @id_jgd_ent
	  )
  if @retorno is null begin set @retorno = 'Jogador informado não existe.' end 
     raiserror (@retorno, 11, 127)
     rollback transaction
  end

  if not exists (  
     select b.ID_Jogador  as qtd 
       from tb_jogos_times            a with(nolock)
       join tb_jogos_times_anfitrioes b with(nolock)on b.ID_Time = a.ID_Time_Anfitriao
                                                   and b.ID_Jogo_Time = a.ID_Jogo_Time
      where a.ID_Jogo_Time = @id_jogo_time
        and b.ID_Jogador = @id_jgd_sai
        and b.ID_Time = @id_time
		
      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_times            a with(nolock)
       join tb_jogos_times_visitantes b with(nolock)on b.ID_Time = a.ID_Time_Visitante
                                                   and b.ID_Jogo_Time = a.ID_Jogo_Time
      where a.ID_Jogo_Time = @id_jogo_time
        and b.ID_Jogador = @id_jgd_sai
        and b.ID_Time = @id_time
	  ) and isnull(@jgd_sai_sub,'N') = 'N'
  begin
  set @retorno = (
      select concat('O jogador de saída ''', b.Nome_Reduzido ,''' é inválido, pois não faz parte do elenco que iniciou a partida.')
        from tb_jogadores a with(nolock)
        join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
       where a.ID_Jogador = @id_jgd_sai
	  )
  if @retorno is null begin set @retorno = 'Jogador informado não existe.' end 
     raiserror (@retorno, 11, 127)
     rollback transaction
  end

  if exists (
     select 1
       from tb_jogos_times_substituicoes
      where ID_Jogo_Time = @id_jogo_time
        and ID_Jogador_Saida = @id_jgd_ent
  )
  begin
     raiserror ('Jogador que saiu anteriormente no mesmo jogo não pode voltar para a partida.', 11, 127)
     rollback transaction
  end
end

end

