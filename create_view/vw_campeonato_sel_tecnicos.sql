create view vw_campeonato_sel_tecnicos

as
     select e.ID_Campeonato_Edicao
          , concat(e.Ano, ' ', f.Descricao, ' - ',g.Nome_Pais ) as Campeonato
          , b.Nome_Selecao
          , d.Nome_Reduzido
          , e.Ano
          , f.Descricao                  
          , g.Nome_Pais                     as Pais_Sede
       from tb_selecoes_tecnicos   a with(nolock)
       join tb_selecoes            b with(nolock)on b.ID_Selecao = a.ID_selecao
       join tb_tecnicos            c with(nolock)on c.ID_Tecnico = a.ID_tecnico
       join tb_pessoas             d with(nolock)on d.ID_Pessoa  = c.ID_Pessoa
       join tb_campeonatos_edicoes e with(nolock)on e.ID_Campeonato_Edicao = a.ID_campeonato_edicao
       join tb_campeonatos         f with(nolock)on f.ID_Campeonato = e.ID_Campeonato
       join tb_paises              g with(nolock)on g.ID_Pais = e.Pais_Sede
