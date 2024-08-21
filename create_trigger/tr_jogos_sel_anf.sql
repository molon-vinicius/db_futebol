create trigger tr_jogos_sel_anf
            on tb_jogos_selecoes_anfitrioes
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
         from tb_jogos_selecoes_anfitrioes a with(nolock)
        where a.ID_jogo_selecao = @id_jogo_sel

  if not exists (
     select 1
       from tb_jogos_selecoes   a with(nolock) 
      where a.ID_jogo_selecao      = @id_jogo_sel
        and a.ID_selecao_anfitriao = @id_sel
  )
  begin
     raiserror ('Seleção anfitriã informada não participou da partida ou está cadastrada como seleção visitante.', 11, 127)
     rollback transaction
  end

  if not exists(
     select 1
       from tb_jogos_selecoes    a with(nolock)
       join tb_selecoes_elencos  b with(nolock)on b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
                                              and b.ID_Selecao = a.ID_Selecao_Anfitriao
      where a.ID_Jogo_Selecao = @id_jogo_sel
        and a.ID_Selecao_Anfitriao = @id_sel
        and b.ID_Jogador = @id_jogador		
     )
  begin
     raiserror ('Jogador não pertencente a seleção Anfitriã.', 11, 127)
     rollback transaction
  end

  if @qtd_jogadores > 11
  begin
     raiserror ('Quantidade de jogadores titulares já atingida.', 11, 127)
     rollback transaction
  end

end
