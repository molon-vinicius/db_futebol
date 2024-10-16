set identity_insert tb_confederacoes on

insert into tb_confederacoes
           (ID_Confederacao
           ,Sigla_Confederacao
           ,Nome_Confederacao
           ,ID_Continente)
	
     values (0, NULL,'Todas',0)
           ,(1, 'CAF','Confederação Africana de Futebol',1)
           ,(2, 'AFC','Confederação Asiática de Futebol',2)
           ,(3, 'CONCACAF','Confederação de Futebol da América do Norte, Central e Caribe',3)
           ,(4, 'CONMEBOL','Confederação Sul-Americana de Futebol',4)
           ,(5, 'UEFA','União das Federações Europeias de Futebol',5)
           ,(6, 'OFC','Confederação de Futebol da Oceania',6) 

set identity_insert tb_confederacoes off
