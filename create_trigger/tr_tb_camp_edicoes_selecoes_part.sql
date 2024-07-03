create trigger tr_tb_camp_edicoes_selecoes_part    
            on tb_campeonatos_edicoes_selecoes_part    
for insert, update    
as    
     select 'Não é possível inserir campeonatos de times nessa tabela.'    
      from inserted               A    
      join tb_campeonatos_edicoes B on B.ID_Campeonato_Edicao = A.ID_Campeonato_Edicao    
      join tb_campeonatos         C on C.ID_Campeonato = B.ID_Campeonato    
     where C.ID_Tipo_Campeonato = 1 --Clubes

