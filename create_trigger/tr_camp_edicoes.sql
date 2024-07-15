create trigger tr_camp_edicoes
            on tb_campeonatos_edicoes
for insert, update

as

begin

declare @temporada varchar(9)
declare @retorno varchar(150)
declare @temporada_aux int

  if len(@temporada) = 4
  begin
	  set @temporada_aux = convert(int, @temporada)
  end

  if len(@temporada) = 9
  begin
	  set @temporada_aux = convert(int, substring(@temporada,6,4))
  end

  if (len(@temporada) <> 4 and len(@temporada) <> 9)
  begin
    raiserror ('A coluna ''Temporada'' deve estar no formato ''XXXX/XXXX'' ou ''XXXX''', 11, 127)
    rollback transaction
  end

  if (len(@temporada) = 4 or len(@temporada) = 9)
  begin
     if len(@temporada) = 4
     and (select dbo.fn_valida_numericos(@temporada)) is not null
     begin
         set @retorno = (select dbo.fn_valida_numericos(@temporada))
         raiserror (@retorno, 11, 127)
	       rollback transaction       
     end

     if len(@temporada) = 9
	   begin
        if isnumeric(substring(@temporada,0,5)) = 0
	      or isnumeric(substring(@temporada,6,4)) = 0	 
	      begin
           raiserror ('A coluna ''Temporada'' deve estar no formato ''XXXX/XXXX''', 11, 127)
	         rollback transaction
	      end

        if isnumeric(substring(@temporada,0,5)) = 1
	      and isnumeric(substring(@temporada,6,4)) = 1
	      begin
	        if substring(@temporada,5,1) <> '/'
          begin
	           raiserror ('A coluna ''Temporada'' deve estar no formato ''XXXX/XXXX''', 11, 127)
	           rollback transaction
          end

	        if substring(@temporada,6,4) <> substring(@temporada,0,5)+1
		      begin
             set @retorno = concat('A temporada ',substring(@temporada,0,5),'/',substring(@temporada,6,4),' é inválida pois não é sequencial.')
	           raiserror (@retorno, 11, 127)
	           rollback transaction
		      end
        end
     end 
  end
end
