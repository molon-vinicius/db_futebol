set identity_insert tb_tipos_campeonatos on
           
insert into tb_tipos_campeonatos 
           ( ID_Tipo_Campeonato
           , Descricao)
     values(0, 'Campeonato Não Oficial')
          ,(1, 'Clubes')
          ,(2, 'Seleções')

set identity_insert tb_tipos_campeonatos off
