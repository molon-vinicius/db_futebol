create trigger tr_times_elencos 
            on tb_times_elencos
for insert, update 
 
as

begin

declare @temporada varchar(9)
declare @camisa varchar(2)
declare @data_entrada date
declare @data_saida date
declare @nome_camisa varchar(20)
declare @retorno varchar(100)
declare @temporada_aux int

    select @temporada    = Temporada
         , @camisa       = Camisa
	 , @data_entrada = Data_Entrada
	 , @data_saida   = Data_Saida 
	 , @nome_camisa  = Nome_Camisa
      from inserted    with(nolock)

if (select ID_Jogador from deleted) is not null
begin
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
     
   if isnumeric(@camisa) = 0
   begin  
      raiserror ('A coluna ''Camisa'' só aceita caracteres numéricos.', 11, 127)
      rollback transaction
   end

   if @camisa = 0
   begin  
      raiserror ('A coluna ''Camisa'' não pode ser preenchida com o número zero.', 11, 127)
      rollback transaction
   end

   if (select dbo.fn_valida_string(@nome_camisa)) is not null
   begin
      set @retorno = (select dbo.fn_valida_string(@nome_camisa))
      raiserror (@retorno, 11, 127)
      rollback transaction
   end

   if year(@data_entrada) > @temporada_aux
   begin
     raiserror ('Data de entrada inválida, ano maior que a temporada informada.', 11, 127)
     rollback transaction
   end

   if year(@data_saida) > @temporada_aux
   begin
     raiserror ('Data de saída inválida, ano maior que a temporada informada.', 11, 127)
     rollback transaction
   end

   if @data_saida < @data_entrada
   begin
     raiserror ('Data de saída anterior a data de entrada informada.', 11, 127)
     rollback transaction
   end
end 

if (select ID_Jogador from deleted) is null
begin
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
     
   if isnumeric(@camisa) = 0
   begin  
      raiserror ('A coluna ''Camisa'' só aceita caracteres numéricos.', 11, 127)
      rollback transaction
   end

   if @camisa = 0
   begin  
      raiserror ('A coluna ''Camisa'' não pode ser preenchida com o número zero.', 11, 127)
      rollback transaction
   end

   if (select dbo.fn_valida_string(@nome_camisa)) is not null
   begin
      set @retorno = (select dbo.fn_valida_string(@nome_camisa))
      raiserror (@retorno, 11, 127)
      rollback transaction
   end

   if year(@data_entrada) > @temporada_aux
   begin
     raiserror ('Data de entrada inválida, ano maior que a temporada informada.', 11, 127)
     rollback transaction
   end

   if year(@data_saida) > @temporada_aux
   begin
     raiserror ('Data de saída inválida, ano maior que a temporada informada.', 11, 127)
     rollback transaction
   end

   if @data_saida < @data_entrada
   begin
     raiserror ('Data de saída anterior a data de entrada informada.', 11, 127)
     rollback transaction
   end
end 

end 
