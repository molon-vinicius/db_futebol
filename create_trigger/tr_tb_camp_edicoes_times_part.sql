create trigger tr_tb_camp_edicoes_times_part  
            on tb_campeonatos_edicoes_times_part  
for insert, update  
as  
     select 'Não é possível inserir campeonatos de seleções nessa tabela.'  
       from inserted               a  
       join tb_campeonatos_edicoes b on b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao  
       join tb_campeonatos         c on c.ID_Campeonato = b.ID_Campeonato  
      where c.ID_Tipo_Campeonato = 2  --Seleções
