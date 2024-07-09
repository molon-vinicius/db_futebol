create function dbo.fn_valida_string
(@nome varchar(20))
returns varchar(100) 

begin
declare @tam int = (select len(@nome) as tam)
declare @retorno int = 0
declare @msg varchar(100)

while @tam > 0
  begin
    if exists (
	     select 1 as msg 
        where substring(@nome,@tam,1) NOT IN 
		('-','''',' ','a','b','c','d','e','f','g','h'
		,'i','j','k','l','m','n','o','p','q','r','s'
		,'t','u','v','w','x','y','z','ã','õ','ä','ë'
		,'ï','ö','ü','â','ê','ô','á','é','í','ó','ú'
		,'æ','ß','ø','å')
     )
        begin
          set @retorno = 1
        end
    set @tam = @tam - 1
  
  end 

  if @retorno = 1
  begin 
     select @msg = concat('Nome: ''', @nome ,''' inválido. Não é possível inserir caracteres numéricos ou especiais.')
  end
 
end
