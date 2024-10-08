/* tabela para tratamento de elencos com vários capitães */
create table tb_selecoes_elencos_capitaes
            (ID_Jogo_Selecao numeric(15)
            ,ID_Selecao numeric(15)
            ,ID_Jogador numeric(15))
  
alter table tb_selecoes_elencos_capitaes add constraint uq_sel_elenco_cap unique (ID_Jogo_Selecao, ID_Selecao, ID_Jogador)
