create function dbo.fn_pessoas_nacionalidade
(@nome_pessoa varchar(128))
returns varchar(128)

begin

declare @nacionalidade varchar(128) 

     select @nacionalidade = b.Nome_Pais
       from tb_pessoas    a with(nolock)
       join tb_paises     b with(nolock)on b.ID_Pais = a.Pais_Preferencial  
      where a.Nome_Reduzido = @nome_pessoa
	       or a.Nome_Completo like '%'+@nome_pessoa+'%' 

     return @nacionalidade
       
end
