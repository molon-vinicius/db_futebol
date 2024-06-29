/* Adicionando todos os estados brasileiros */
declare @Nome_Pais varchar(100)
set @Nome_Pais = 'Brasil'

declare @ID_Pais int
set @ID_Pais = (select ID_Pais from tb_paises with(nolock) where Nome_Pais = @Nome_Pais)

if @ID_Pais is null
begin
  select 'País informado não encontrado.'
  return
end

else
begin
insert into tb_estados (Nome_Estado, ID_Pais, Sigla_Estado)

values('Acre',@ID_Pais,'AC')
     ,('Alagoas',@ID_Pais,'AL')
     ,('Amapá',@ID_Pais,'AP')
     ,('Amazonas',@ID_Pais,'AM')
     ,('Bahia',@ID_Pais,'BA')
     ,('Ceará',@ID_Pais,'CE')
     ,('Distrito Federal',@ID_Pais,'DF')
     ,('Espírito Santo',@ID_Pais,'ES')
     ,('Goiás',@ID_Pais,'GO')
     ,('Maranhão',@ID_Pais,'MA')
     ,('Mato Grosso',@ID_Pais,'MT')
     ,('Mato Grosso do Sul',@ID_Pais,'MS')
     ,('Minas Gerais',@ID_Pais,'MG')
     ,('Pará',@ID_Pais,'PA')
     ,('Paraíba',@ID_Pais,'PB')
     ,('Paraná',@ID_Pais,'PR')
     ,('Pernambuco',@ID_Pais,'PE')
     ,('Piauí',@ID_Pais,'PI')
     ,('Rio de Janeiro',@ID_Pais,'RJ')
     ,('Rio Grande do Norte',@ID_Pais,'RN')
     ,('Rio Grande do Sul',@ID_Pais,'RS')
     ,('Rondônia',@ID_Pais,'RO')
     ,('Roraima',@ID_Pais,'RR')
     ,('Santa Catarina',@ID_Pais,'SC')
     ,('São Paulo',@ID_Pais,'SP')
     ,('Sergipe',@ID_Pais,'SE')
     ,('Tocantins',@ID_Pais,'TO')
end
