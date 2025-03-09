 create table tb_times_historicos
             (ID_Time_Historico numeric(15) identity primary key
             ,ID_Time numeric(15)
             ,Nome_Time varchar(128)
             ,Nome_Reduzido varchar(60)
             ,ID_Cidade int
             ,Data_Inicio varchar(10)
             ,Data_Fim varchar(10)
             ,Observacao nvarchar(500)
             ,Situacao_Atual varchar(1))

alter table tb_times_historicos 
add constraint fk_times_hist_id_time
foreign key (ID_Time) references tb_times(ID_Time)

alter table tb_times_historicos 
add constraint fk_times_hist_id_cidade
foreign key (ID_Cidade) references tb_cidades(ID_Cidade)

alter table tb_times_historicos
add ID_Status_Historico int

alter table tb_times_historicos 
add constraint fk_times_hist_id_status
foreign key (ID_Status_Historico) references tb_status_historicos(ID_Status_Historico)

