CREATE trigger tr_pessoas
            on tb_pessoas
for insert, update 
  
as

begin
declare @id_cid_nasc  int
declare @id_pais_nasc int
declare @id_dupla_cid int
declare @dt_nasc      varchar(10)
declare @dt_obt       varchar(10)
declare @retorno      varchar(150)

        select @id_cid_nasc  = ID_Cidade_Nascimento 
             , @id_dupla_cid = Dupla_Cidadania
             , @dt_nasc      = Data_Nascimento
             , @dt_obt       = Data_Obito
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
	
    if len(@dt_nasc) > 10	
    or try_convert(date, @dt_nasc) is null
    begin
       raiserror ('Formato da data de nascimento é inválido.', 11, 127)
       rollback transaction
    end

    if len(@dt_obt) > 10
    or try_convert(date, @dt_obt) is null
    begin
       raiserror ('Formato da data de óbito é inválido.', 11, 127)
       rollback transaction
    end

    if @dt_nasc <> '01/01/1000' and @dt_obt <> '01/01/1000'
    begin
      if convert(date, @dt_nasc) > convert(date, @dt_obt)
      or convert(date, @dt_nasc) = convert(date, @dt_obt)
      begin
         raiserror ('A ordem cronológica das datas de nascimento e de óbito estão incorretas.', 11, 127)
         rollback transaction
      end
    end

end

