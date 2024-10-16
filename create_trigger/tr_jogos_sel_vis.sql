create trigger tr_jogos_sel_vis
            on tb_jogos_selecoes_visitantes
for insert, update 
 
as

begin

declare @id_jogo_sel   int 
declare @qtd_jogadores int 
declare @id_sel        int 
declare @id_jogador    int 

       select @id_jogo_sel = ID_jogo_selecao
            , @id_sel      = ID_selecao
            , @id_jogador  = ID_Jogador
         from inserted

       select @qtd_jogadores = count(a.ID_jogador)
         from tb_jogos_selecoes_visitantes a with(nolock)
        where a.ID_jogo_selecao = @id_jogo_sel
	
if (select ID_Jogo_Selecao from deleted) is not null
begin
  if not exists (
     select ID_Jogo_Selecao
       from tb_jogos_selecoes   a with(nolock) 
      where a.ID_jogo_selecao      = @id_jogo_sel
        and a.ID_selecao_visitante = @id_sel
  )
  begin
     raiserror ('Seleção visitante informada não participou da partida ou está cadastrada como seleção anfitriã.', 11, 127)
     rollback transaction
  end

  if not exists(
     select ID_jogador
       from tb_jogos_selecoes    a with(nolock)
       join tb_selecoes_elencos  b with(nolock)on b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
                                              and b.ID_Selecao = a.ID_Selecao_Visitante
      where a.ID_Jogo_Selecao = @id_jogo_sel
        and a.ID_selecao_visitante = @id_sel
        and b.ID_Jogador = @id_jogador		
	 )

  begin
     raiserror ('Jogador não pertencente a seleção visitante.', 11, 127)
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
       from tb_jogos_selecoes_visitantes a with(nolock)
       join tb_jogadores_posicoes        b with(nolock)on b.ID_Jogador = a.ID_jogador
      where a.ID_Jogo_Selecao = @id_jogo_sel 
        and b.GK = 'S'
     ) > 1
  begin
     raiserror ('Goleiro já cadastrado para o time titular.', 11, 127)
     rollback transaction
  end 

  if @qtd_jogadores = 11
  and (
     select GK
       from tb_jogos_selecoes_visitantes a with(nolock)
       join tb_jogadores_posicoes        b with(nolock)on b.ID_Jogador = a.ID_jogador
      where a.ID_Jogo_Selecao = @id_jogo_sel 
        and b.GK = 'S'
     ) is null
  begin
     raiserror ('Necessário cadastrar um goleiro para o time titular.', 11, 127)
     rollback transaction
  end 
end

if (select ID_Jogo_Selecao from deleted) is null
begin
  if not exists (
     select ID_Jogo_Selecao
       from tb_jogos_selecoes   a with(nolock) 
      where a.ID_jogo_selecao      = @id_jogo_sel
        and a.ID_selecao_visitante = @id_sel
  )
  begin
     raiserror ('Seleção visitante informada não participou da partida ou está cadastrada como seleção anfitriã.', 11, 127)
     rollback transaction
  end

  if not exists(
     select ID_Jogador
       from tb_jogos_selecoes    a with(nolock)
       join tb_selecoes_elencos  b with(nolock)on b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
                                              and b.ID_Selecao = a.ID_Selecao_Visitante
      where a.ID_Jogo_Selecao = @id_jogo_sel
        and a.ID_selecao_visitante = @id_sel
        and b.ID_Jogador = @id_jogador		
	 )

  begin
     raiserror ('Jogador não pertencente a seleção visitante.', 11, 127)
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
       from tb_jogos_selecoes_visitantes a with(nolock)
       join tb_jogadores_posicoes        b with(nolock)on b.ID_Jogador = a.ID_jogador
      where a.ID_Jogo_Selecao = @id_jogo_sel 
        and b.GK = 'S'
     ) > 1
  begin
     raiserror ('Goleiro já cadastrado para o time titular.', 11, 127)
     rollback transaction
  end 

  if @qtd_jogadores = 11
  and (
     select GK
       from tb_jogos_selecoes_visitantes a with(nolock)
       join tb_jogadores_posicoes        b with(nolock)on b.ID_Jogador = a.ID_jogador
      where a.ID_Jogo_Selecao = @id_jogo_sel 
        and b.GK = 'S'
     ) is null 
  begin  
     raiserror ('Necessário cadastrar um goleiro para o time titular.', 11, 127)
     rollback transaction
  end 
end

end
