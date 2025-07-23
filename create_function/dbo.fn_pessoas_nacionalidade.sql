create or alter function dbo.fn_pessoas_nacionalidade
(@ID_Pessoa int)
returns varchar(128)

begin

declare @nacionalidade varchar(128) 

     select @nacionalidade = b.Nome_Pais
       from tb_pessoas    a with(nolock)
       join tb_paises     b with(nolock)on b.ID_Pais = a.Pais_Preferencial  
      where a.ID_Pessoa = @ID_Pessoa

     return @nacionalidade
       
end

