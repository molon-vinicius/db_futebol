create table tb_tipos_campeonatos
(ID_Tipo_Campeonato int identity(1,1) primary key not null
,Descricao varchar(25) not null) 

alter table tb_tipos_campeonatos add constraint uq_tipo_camp unique (Descricao) 
