create trigger tr_pessoas
            on tb_pessoas
for insert, update 
  
as

begin
declare @id_cid_nasc  int
declare @id_pais_nasc int
declare @id_dupla_cid int
declare @retorno      varchar(150)

        select @id_cid_nasc  = ID_Cidade_Nascimento 
             , @id_dupla_cid = Dupla_Cidadania
          from inserted

        select @id_pais_nasc = b.ID_Pais
          from inserted     a with(nolock)
          join tb_cidades   b with(nolock)on b.ID_Cidade = a.ID_Cidade_Nascimento
         where a.ID_Cidade_Nascimento = @id_cid_nasc

    if @id_pais_nasc = @id_dupla_cid
    begin
       raiserror ('País de nascimento e de dupla cidadania informados são iguais.', 11, 127)
       rollback transaction
    end
	
end

