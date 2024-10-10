create trigger tr_tb_camp_edicoes_times_part    
            on tb_campeonatos_edicoes_times_part    
for insert, update    
as    

begin

  if (select ID_Time from deleted) is not null
  begin
    if (
       select a.ID_campeonato_edicao   
         from inserted               A    
         join tb_campeonatos_edicoes B on B.ID_campeonato_edicao = A.ID_campeonato_edicao    
         join tb_campeonatos         C on C.ID_campeonato = B.ID_campeonato    
        where C.ID_Tipo_Campeonato = 2
    ) is not null
    begin
      raiserror('Não é possível inserir campeonatos de seleções nessa tabela.', 11, 127)    
      rollback transaction
    end

  end 

  if (select ID_Time from deleted) is null
  begin
    if (
       select a.ID_campeonato_edicao   
         from inserted               A    
         join tb_campeonatos_edicoes B on B.ID_campeonato_edicao = A.ID_campeonato_edicao    
         join tb_campeonatos         C on C.ID_campeonato = B.ID_campeonato    
        where C.ID_Tipo_Campeonato = 2
    ) is not null
    begin
      raiserror('Não é possível inserir campeonatos de seleções nessa tabela.', 11, 127)    
      rollback transaction
    end
  end

end	  
