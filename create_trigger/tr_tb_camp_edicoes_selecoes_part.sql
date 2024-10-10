create trigger tr_tb_camp_edicoes_selecoes_part    
            on tb_campeonatos_edicoes_selecoes_part    
for insert, update    
as    

begin

  if (select ID_Selecao from deleted) is not null
  begin
    if (
       select a.ID_campeonato_edicao   
         from inserted               A    
         join tb_campeonatos_edicoes B on B.ID_campeonato_edicao = A.ID_campeonato_edicao    
         join tb_campeonatos         C on C.ID_campeonato = B.ID_campeonato    
        where C.ID_Tipo_Campeonato = 1
    ) is not null
    begin
      raiserror('Não é possível inserir campeonatos de times nessa tabela.', 11, 127)    
      rollback transaction
    end

  end 

  if (select ID_Selecao from deleted) is null
  begin
    if (
       select a.ID_campeonato_edicao   
         from inserted               A    
         join tb_campeonatos_edicoes B on B.ID_campeonato_edicao = A.ID_campeonato_edicao    
         join tb_campeonatos         C on C.ID_campeonato = B.ID_campeonato    
        where C.ID_Tipo_Campeonato = 1
    ) is not null
    begin
      raiserror('Não é possível inserir campeonatos de times nessa tabela.', 11, 127)    
      rollback transaction
    end
  end

end	 
