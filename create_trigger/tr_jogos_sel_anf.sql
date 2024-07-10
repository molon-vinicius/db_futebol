create trigger tr_jogos_sel_anf 
            on tb_jogos_selecoes_anfitrioes
for insert, update 
 
as

begin

declare @id int = (select ID_jogo_selecao from inserted)
declare @qtd_jogadores int 

	   select @qtd_jogadores = count(a.ID_jogador)
	     from tb_jogos_selecoes_anfitrioes a with(nolock)
		  where a.ID_jogo_selecao = @id
  
  if @qtd_jogadores > 11
  begin
     raiserror ('Quantidade de jogadores titulares já atingida.', 11, 127)
	   rollback transaction
  end

end
