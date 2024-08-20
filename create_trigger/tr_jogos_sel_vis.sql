create trigger tr_jogos_sel_vis 
            on tb_jogos_selecoes_visitantes
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
         from tb_jogos_selecoes_visitantes a with(nolock)
        where a.ID_jogo_selecao = @id_jogo_sel

  if not exists (
     select 1
       from tb_jogos_selecoes            a with(nolock) 
       join tb_jogos_selecoes_visitantes b with(nolock)on b.ID_jogo_selecao = a.ID_jogo_selecao
                                                      and a.ID_selecao_visitante = b.ID_selecao
      where a.ID_jogo_selecao = @id_jogo_sel
  )
  begin
     raiserror ('Seleção visitante informada não participou da partida ou está cadastrada como seleção anfitriã.', 11, 127)
     rollback transaction
  end
  
  if @qtd_jogadores > 11
  begin
     raiserror ('Quantidade de jogadores titulares já atingida.', 11, 127)
     rollback transaction
  end

end

