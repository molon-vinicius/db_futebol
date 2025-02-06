alter function [dbo].[fn_formatar_texto]
(
	@texto varchar(max)
)
returns varchar(max)
as
begin

	declare @texto_formatado varchar(max)
	
	-- o trecho abaixo possibilita que caracteres como "º" ou "ª"
	-- sejam convertidos para "o" ou "a", respectivamente
	set @texto_formatado = @texto collate sql_latin1_general_cp1250_ci_as

	-- o trecho abaixo remove acentos e outros caracteres especiais,
	-- substituindo os mesmos por letras normais
	set @texto_formatado = @texto_formatado collate sql_latin1_general_cp1251_ci_as

	return @texto_formatado

end
