create trigger tr_estadios_encerramento
            on tb_estadios
for insert, update 
 
as

declare @ativo varchar(1)
declare @encerramento varchar(10)

    select @ativo        = Ativo
         , @encerramento = Encerramento
      from inserted 

  if (select ID_Estadio from deleted) is not null
  begin
		
       if @ativo = 'N' and @encerramento is null
       begin
         raiserror ('É necessário informar uma data de encerramento para estádios inativos.', 11, 127)
	 rollback transaction
       end

       if @ativo = 'S' and @encerramento is not null
       begin
         raiserror ('Não é possível inserir um estádio ativo com data de encerramento.', 11, 127)
	 rollback transaction
       end
  end
	
  if (select ID_Estadio from deleted) is null
  begin
     if @ativo = 'N' and @encerramento is null
     begin
       raiserror ('É necessário informar uma data de encerramento para estádios inativos.', 11, 127)
       rollback transaction
     end

     if @ativo = 'S' and @encerramento is not null
     begin
       raiserror ('Não é possível inserir um estádio ativo com data de encerramento.', 11, 127)
       rollback transaction
     end
  end
