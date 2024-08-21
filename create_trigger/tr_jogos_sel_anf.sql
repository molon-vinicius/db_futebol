create trigger tr_jogos_sel_anf 
            on tb_jogos_selecoes_anfitrioes
for insert, update 
 
as

begin

declare @id_jogo_sel   int 
declare @qtd_jogadores int 
declare @id_sel        int 

       select @id_jogo_sel = ID_jogo_selecao
            , @id_sel      = ID_selecao
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
  
  if @qtd_jogadores > 11
  begin
     raiserror ('Quantidade de jogadores titulares já atingida.', 11, 127)
     rollback transaction
  end

end
