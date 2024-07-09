create function dbo.fn_estadios_local
(@nome_estadio varchar(128))
returns varchar(128)

begin

declare @cidade_estadio varchar(128) 

     select @cidade_estadio = concat(b.Nome_Cidade, ' - ', c.Nome_Pais)
       from tb_estadios    a with(nolock)
  	   join tb_cidades     b with(nolock)on b.ID_Cidade = a.ID_Cidade
	     join tb_paises      c with(nolock)on c.ID_Pais = b.ID_Pais
      where a.Nome_Reduzido = @nome_estadio
	       or a.Nome_Estadio like '%'+@nome_estadio+'%' 
		
     return @cidade_estadio
       
end
