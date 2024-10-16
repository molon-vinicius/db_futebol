create trigger tr_jogos_time_vis 
            on tb_jogos_times_visitantes
for insert, update 
 
as

begin

declare @id int = (select ID_Jogo_Time from inserted)
declare @qtd_jogadores int 

	   select @qtd_jogadores = count(a.ID_Jogador)
	     from tb_jogos_times_visitantes a with(nolock)
            where a.ID_Jogo_Time = @id

if (select ID_Jogo_Time from deleted) is not null
begin 
  if @qtd_jogadores > 11
  begin
     raiserror ('Quantidade de jogadores titulares já atingida.', 11, 127)
     rollback transaction
  end
end

if (select ID_Jogo_Time from deleted) is null
begin
  if @qtd_jogadores > 11
  begin
     raiserror ('Quantidade de jogadores titulares já atingida.', 11, 127)
     rollback transaction
  end
end

end
