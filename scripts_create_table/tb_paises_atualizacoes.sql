create table tb_paises_atualizacoes
            (ID_Pais_Antigo int
            ,ID_Pais_Atual int
            ,Inicio_Vigencia date 
            ,Fim_Vigencia date)

alter table tb_paises_atualizacoes add foreign key (ID_Pais_Antigo) references tb_paises(ID_Pais)
alter table tb_paises_atualizacoes add foreign key (ID_Pais_Atual)  references tb_paises(ID_Pais)
alter table tb_paises_atualizacoes add constraint uq_pais_atualiza  unique (ID_Pais_Antigo, ID_Pais_Atual)
