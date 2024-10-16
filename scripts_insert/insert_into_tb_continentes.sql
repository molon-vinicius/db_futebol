
set identity_insert tb_continentes on

insert into tb_continentes (ID_Continente, Nome_Continente)
     values (0,'Todos')
          , (1,'África')
          , (2,'Ásia')
          , (3,'América Central e do Norte')
          , (4,'América do Sul')
          , (5,'Europa')
          , (6,'Oceania')

set identity_insert tb_continentes off
