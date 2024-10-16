create trigger tr_jogos_time_anf
            on tb_jogos_times_anfitrioes
for insert, update 
 
as

begin

declare @id_jogo_time  int 
declare @qtd_jogadores int 
declare @id_time       int 
declare @id_jogador    int 

       select @id_jogo_time = ID_jogo_time
            , @id_time      = ID_time
            , @id_jogador   = ID_Jogador
         from inserted

       select @qtd_jogadores = count(a.ID_jogador)
         from tb_jogos_times_anfitrioes a with(nolock)
        where a.ID_Jogo_Time = @id_jogo_time
	
if (select ID_Jogo_Time from deleted) is not null
begin
  if not exists (
     select ID_Jogo_Time
       from tb_jogos_times   a with(nolock) 
      where a.ID_Jogo_Time      = @id_jogo_time
        and a.ID_time_anfitriao = @id_time
  )
  begin
     raiserror ('Time anfitrião informado não participou da partida ou está cadastrada como time visitante.', 11, 127)
     rollback transaction
  end

  if not exists(
     select ID_jogador
       from tb_jogos_times         a with(nolock)
       join tb_campeonatos_edicoes b with(nolock)on b.ID_Campeonato_Edicao = a.ID_campeonato_edicao
       join tb_times_elencos       c with(nolock)on c.Temporada = b.Ano
                                                and c.ID_time = a.ID_time_anfitriao
      where a.ID_Jogo_Time = @id_jogo_time
        and a.ID_time_anfitriao = @id_time
        and c.ID_Jogador = @id_jogador		
	 )

  begin
     raiserror ('Jogador não pertencente ao time anfitrião.', 11, 127)
     rollback transaction
  end

  if @qtd_jogadores > 11
  begin
     raiserror ('Quantidade de jogadores titulares já atingida.', 11, 127)
     rollback transaction
  end

  if @qtd_jogadores = 11
  and (
     select count(GK) as qtd
       from tb_jogos_times_anfitrioes a with(nolock)
       join tb_jogadores_posicoes        b with(nolock)on b.ID_Jogador = a.ID_jogador
      where a.ID_Jogo_Time = @id_jogo_time 
        and b.GK = 'S'
     ) > 1
  begin
     raiserror ('Goleiro já cadastrado para o time titular.', 11, 127)
     rollback transaction
  end 

  if @qtd_jogadores = 11
  and (
     select GK
       from tb_jogos_times_anfitrioes a with(nolock)
       join tb_jogadores_posicoes        b with(nolock)on b.ID_Jogador = a.ID_jogador
      where a.ID_Jogo_Time = @id_jogo_time 
        and b.GK = 'S'
     ) is null
  begin
     raiserror ('Necessário cadastrar um goleiro para o time titular.', 11, 127)
     rollback transaction
  end 
end

if (select ID_Jogo_Time from deleted) is null
begin
  if not exists (
     select ID_Jogo_Time
       from tb_jogos_times   a with(nolock) 
      where a.ID_Jogo_Time      = @id_jogo_time
        and a.ID_time_anfitriao = @id_time
  )
  begin
     raiserror ('Time anfitrião informado não participou da partida ou está cadastrada como time visitante.', 11, 127)
     rollback transaction
  end

  if not exists(
     select ID_jogador
       from tb_jogos_times         a with(nolock)
       join tb_campeonatos_edicoes b with(nolock)on b.ID_Campeonato_Edicao = a.ID_campeonato_edicao
       join tb_times_elencos       c with(nolock)on c.Temporada = b.Ano
                                                and c.ID_time = a.ID_time_anfitriao
      where a.ID_Jogo_Time = @id_jogo_time
        and a.ID_time_anfitriao = @id_time
        and c.ID_Jogador = @id_jogador		
	 )
  begin
     raiserror ('Jogador não pertencente ao time anfitrião.', 11, 127)
     rollback transaction
  end

  if @qtd_jogadores > 11
  begin
     raiserror ('Quantidade de jogadores titulares já atingida.', 11, 127)
     rollback transaction
  end

  if @qtd_jogadores = 11
  and (
     select count(GK) as qtd
       from tb_jogos_times_anfitrioes a with(nolock)
       join tb_jogadores_posicoes        b with(nolock)on b.ID_Jogador = a.ID_jogador
      where a.ID_Jogo_Time = @id_jogo_time 
        and b.GK = 'S'
     ) > 1
  begin
     raiserror ('Goleiro já cadastrado para o time titular.', 11, 127)
     rollback transaction
  end 

  if @qtd_jogadores = 11
  and (
     select GK
       from tb_jogos_times_anfitrioes a with(nolock)
       join tb_jogadores_posicoes        b with(nolock)on b.ID_Jogador = a.ID_jogador
      where a.ID_Jogo_Time = @id_jogo_time 
        and b.GK = 'S'
     ) is null 
  begin  
     raiserror ('Necessário cadastrar um goleiro para o time titular.', 11, 127)
     rollback transaction
  end 
end

end
