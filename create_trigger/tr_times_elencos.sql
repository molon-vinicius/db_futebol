create trigger tr_times_elencos on tb_times_elencos
for insert, update 

/* Validação para impossibilitar a inserção ou atualização de informações no formato errado.*/
/* - Camisa só aceitará caracteres numéricos e diferentes de zero.*/
/* - Nome na camisa só aceitará letras, sem a possibilidade de inserção de números ou caracteres especiais.*/
/* - Padrão da coluna 'Temporada' da tabela, exemplos: 1904 (modelo sulamericano) ou 1904/1905 (modelo europeu), 
   caso a informação esteja diferente, será exibida uma mensagem para correção da informação.*/
/* - Validação do ano das datas de entrada e saída conforme coluna 'Temporada'.*/
  
as

begin

declare @temporada varchar(9)
declare @camisa varchar(2)
declare @data_entrada date
declare @data_saida date
declare @nome_camisa varchar(20)
declare @retorno varchar(100)

select @temporada    = temporada
     , @camisa       = camisa
		 , @data_entrada = data_entrada
		 , @data_saida   = data_saida 
		 , @nome_camisa  = nome_camisa
      from inserted    with(nolock)

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

   if year(@data_entrada) not in (substring(@temporada,0,5),substring(@temporada,6,4))
   begin
	  raiserror ('Data de Entrada inválida, ano divergente com a temporada.', 11, 127)
	  rollback transaction
   end

   if year(@data_saida) not in (substring(@temporada,0,5),substring(@temporada,6,4))
   begin
	  raiserror ('Data de Saída inválida, ano divergente com a temporada.', 11, 127)
	  rollback transaction
   end
   
end 
