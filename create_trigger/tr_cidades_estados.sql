alter trigger tr_cidades_estados
on tb_cidades
for insert, update
as
begin
    set nocount on

    /*
       1. Se país 'Brasil', então ID_Estado é obrigatório.
       2. Se ID_Estado informado, ele deve pertencer ao país informado.
    */

    if exists (
       select 1
         from inserted     i
         join tb_paises    p on p.ID_Pais = i.ID_Pais
        where p.Nome_Pais = 'Brasil'
          and i.ID_Estado IS NULL
    )
    begin
        raiserror('Para cadastrar cidades do Brasil é necessário informar o Estado pertencente.', 11, 127)
        rollback transaction
        return
    end

    if exists (
        select 1
        from inserted    i
        join tb_paises   p on p.ID_Pais = i.ID_Pais
   left join tb_estados  e on e.ID_Estado = i.ID_Estado
       where i.ID_Estado is not null
         and (e.ID_Estado is null or e.ID_Pais <> i.ID_Pais)
    )
    begin
        raiserror('Estado não pertencente ao país informado.', 11, 127)
        rollback transaction
        return
    end
end

