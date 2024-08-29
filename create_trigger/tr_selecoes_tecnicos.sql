create trigger tr_selecoes_tecnicos
            on tb_selecoes_tecnicos
for insert, update 

as

begin
declare @id_sel     int
declare @id_camp_ed int
declare @id_tec     int

        select @id_camp_ed  = ID_Campeonato_Edicao 
             , @id_sel      = ID_Selecao
             , @id_tec      = ID_Tecnico
          from inserted

    if not exists (
           select ID_Selecao 
             from tb_campeonatos_edicoes_selecoes_part with(nolock)
            where ID_Campeonato_Edicao = @id_camp_ed
              and ID_Selecao = @id_sel
    )              
    begin
       raiserror ('Seleção não participou desta edição da competição.', 11, 127)
       rollback transaction
    end

    if (select count(ID_Selecao_Tecnico) as qtd 
          from tb_selecoes_tecnicos with(nolock)
         where ID_Campeonato_Edicao = @id_camp_ed
           and ID_Tecnico = @id_tec) > 1
    begin
       raiserror ('Técnico já cadastrado em outra seleção.', 11, 127)
       rollback transaction
    end
	
end

