create trigger tr_times_hist
            on tb_times_historicos
for insert, update 

as

begin
declare @id_time        int
declare @id_cidade      int
declare @id_status_hist int
declare @sit_atual      char
declare @dt_ini         date
declare @dt_fim         date

        select @id_time        = ID_Time
             , @id_cidade      = ID_Cidade
             , @id_status_hist = ID_Status_Historico
             , @sit_atual      = Situacao_Atual
             , @dt_ini         = Data_Inicio
             , @dt_fim         = Data_Fim
          from inserted

  if (select ID_Time_Historico from deleted) is not null
  begin
    if @sit_atual = 'S'
    and @dt_fim is not null
    begin
       raiserror ('Se a coluna "Situação Atual" for igual a ''S'' a coluna "Data Fim" não pode estar preenchida.', 11, 127)
       rollback transaction
    end

    if @sit_atual = 'N'
    and @dt_fim is null
    begin
       raiserror ('Se a coluna "Situação Atual" for igual a ''N'' a coluna "Data Fim" não pode ser nula.', 11, 127)
       rollback transaction
    end

    if @sit_atual <> 'S'
    and @dt_ini > @dt_fim
    begin
       raiserror ('Data Inicial não pode ser posterior a data final.', 11, 127)
       rollback transaction
    end

    if (select count(ID_Time_Historico) as qtd 
          from tb_times_historicos with(nolock)
         where ID_Time = @id_time
           and ID_Status_Historico = 0) > 1
    begin
       raiserror ('Time não pode ter o "Status Histórico" = 0 [Fundação] em mais de um registro.', 11, 127)
       rollback transaction
    end

    if (select count(ID_Time_Historico) as qtd 
          from tb_times_historicos with(nolock)
         where ID_Time = @id_time
           and Situacao_Atual = 'S') > 1
    begin
       raiserror ('Time não pode ter mais de um registro com a "Situação Atual" = ''S''.', 11, 127)
       rollback transaction
    end

    if (select b.ID_Pais
          from tb_cidades a with(nolock)
          join tb_paises  b with(nolock)on b.ID_Pais = a.ID_Pais
         where a.ID_Cidade = @id_cidade
	  ) <>
	     (select b.ID_Pais
          from tb_times   a with(nolock)
          join tb_cidades b with(nolock)on b.ID_Cidade = a.ID_Cidade
          join tb_paises  c with(nolock)on c.ID_Pais = b.ID_Pais
         where a.ID_Time = @id_time
	  )  
    begin
       raiserror ('A cidade informada deve ser do mesmo país cadastrado na tabela referência "tb_times".', 11, 127)
       rollback transaction
    end

  end
  
  if (select ID_Time_Historico from deleted) is null
  begin
    if @sit_atual = 'S'
    and @dt_fim is not null
    begin
       raiserror ('Se a coluna "Situação Atual" for igual a ''S'' a coluna "Data Fim" não pode estar preenchida.', 11, 127)
       rollback transaction
    end

    if @sit_atual = 'N'
    and @dt_fim is null
    begin
       raiserror ('Se a coluna "Situação Atual" for igual a ''N'' a coluna "Data Fim" não pode ser nula.', 11, 127)
       rollback transaction
    end

    if @sit_atual <> 'S'
    and @dt_ini > @dt_fim
    begin
       raiserror ('Data Inicial não pode ser posterior a data final.', 11, 127)
       rollback transaction
    end

    if (select count(ID_Time_Historico) as qtd 
          from tb_times_historicos with(nolock)
         where ID_Time = @id_time
           and ID_Status_Historico = 0) > 1
    begin
       raiserror ('Time não pode ter o "Status Histórico" = 0 [Fundação] em mais de um registro.', 11, 127)
       rollback transaction
    end

    if (select count(ID_Time_Historico) as qtd 
          from tb_times_historicos with(nolock)
         where ID_Time = @id_time
           and Situacao_Atual = 'S') > 1
    begin
       raiserror ('Time não pode ter mais de um registro com a "Situação Atual" = ''S''.', 11, 127)
       rollback transaction
    end

    if (select b.ID_Pais
          from tb_cidades a with(nolock)
          join tb_paises  b with(nolock)on b.ID_Pais = a.ID_Pais
         where a.ID_Cidade = @id_cidade
    ) <>
       (select b.ID_Pais
          from tb_times   a with(nolock)
          join tb_cidades b with(nolock)on b.ID_Cidade = a.ID_Cidade
          join tb_paises  c with(nolock)on c.ID_Pais = b.ID_Pais
         where a.ID_Time = @id_time
    )  
    begin
       raiserror ('A cidade informada deve ser do mesmo país cadastrado na tabela referência "tb_times".', 11, 127)
       rollback transaction
    end
  end
  
end


