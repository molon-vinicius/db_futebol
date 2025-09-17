alter trigger tr_camp_edicoes
on tb_campeonatos_edicoes
for insert, update
as
begin
    set nocount on

    if exists (select 1 from deleted)
    begin
        raiserror('Não é possível alterar os dados nessa tabela. Necessário excluir e inserir novamente as informações.', 11, 27);
        rollback transaction
        return
    end

    if exists (
        select 1
        from inserted i
        where not (
              (len(i.Ano) = 4  and i.Ano not like '%[^0-9]%') 
           or (len(i.Ano) = 9 
               and i.Ano like '[0-9][0-9][0-9][0-9]/[0-9][0-9][0-9][0-9]'
               and cast(left(i.Ano,4) as int) + 1 = cast(right(i.Ano,4) as int))
        )
    )
    begin
        raiserror('A coluna "Temporada" deve estar no formato "XXXX" ou "XXXX/XXXX" (anos numéricos e consecutivos).', 11, 127)
        rollback transaction
        return
    end
end

