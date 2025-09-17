alter trigger tr_times_hist
           on tb_times_historicos
for insert, update
as
begin
    set nocount on

    if exists (
       select 1
         from inserted i
        where i.Situacao_Atual = 'S'
          and i.Data_Fim is not null
    )
    begin
        raiserror('Se a coluna "Situação Atual" for igual a ''S'' a coluna "Data Fim" não pode estar preenchida.', 11, 127)
        rollback transaction
        return
    end

    if exists (
      select 1
        from inserted i
       where i.Situacao_Atual = 'N'
         and i.Data_Fim is null
    )
    begin
        raiserror('Se a coluna "Situação Atual" for igual a ''N'' a coluna "Data Fim" não pode ser nula.', 11, 127)
        rollback transaction
        return
    end

    if exists (
       select 1
         from inserted i
        where i.Situacao_Atual <> 'S'
          and i.Data_Inicio > i.Data_Fim
    )
    begin
        raiserror('Data Inicial não pode ser posterior a data final.', 11, 127)
        rollback transaction
        return
    end

    if exists (
       select i.ID_Time
         from inserted i
         join tb_times_historicos th on th.ID_Time = i.ID_Time
        where th.ID_Status_Historico = 0
        group by i.ID_Time
       having count(*) > 1
    )
    begin
        raiserror('Time não pode ter o "Status Histórico" = 0 [Fundação] em mais de um registro.', 11, 127)
        rollback transaction
        return
    end

    if exists (
        select i.ID_Time
        from inserted i
        join tb_times_historicos th on th.ID_Time = i.ID_Time
        where th.Situacao_Atual = 'S'
        group by i.ID_Time
        having count(*) > 1
    )
    begin
        raiserror('Time não pode ter mais de um registro com a "Situação Atual" = ''S''.', 11, 127)
        rollback transaction
        return
    end

    if exists (
      select 1
        from inserted i
        join tb_cidades   c on c.ID_Cidade = i.ID_Cidade
        join tb_paises   p1 on p1.ID_Pais = c.ID_Pais
        join tb_times     t on t.ID_Time = i.ID_Time
        join tb_cidades  c2 on c2.ID_Cidade = t.ID_Cidade
        join tb_paises   p2 on p2.ID_Pais = c2.ID_Pais
       where p1.ID_Pais <> p2.ID_Pais
    )
    begin
        raiserror('A cidade informada deve ser do mesmo país cadastrado na tabela referência "tb_times".', 11, 127)
        rollback transaction
        return
    end
end

