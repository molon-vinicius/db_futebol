create or alter procedure dbo.usp_campeonatos_classif
(@id_camp_edicao int
,@grupo varchar(20) = null)

as

begin

set nocount on
	
/* teste */
--declare @id_camp_edicao int = 194
--declare @grupo varchar(20)

declare @tipo_camp int
declare @pts_vitoria int
declare @ano_str varchar(10)

     select @tipo_camp = b.ID_Tipo_Campeonato
          , @ano_str   = a.Ano
       from tb_campeonatos_edicoes a with(nolock)
       join tb_campeonatos         b with(nolock)on b.ID_Campeonato = a.ID_Campeonato
      where a.ID_Campeonato_Edicao = @id_camp_edicao

declare @ano int 
    set @ano = try_convert(int, left(@ano_str, 4));
    set @pts_vitoria = case when @ano >= 1995 then 3 else 2 end;

  -- gerar #aux (alinha Grupo <-> Fase pela posição usando OPENJSON)
  if object_id('tempdb..#aux') is not null drop table #aux;

  ;with part as (
      select ID_Selecao as ID_Equipe
           , Grupos
           , Fases
        from tb_campeonatos_edicoes_selecoes_part with(nolock)
       where id_campeonato_edicao = @id_camp_edicao and @tipo_camp = 2

       union all

      select ID_Time    as ID_Equipe
           , Grupos
           , Fases
       from tb_campeonatos_edicoes_times_part with(nolock)
      where id_campeonato_edicao = @id_camp_edicao and @tipo_camp = 1
  ),
        grp as (
     select p.ID_Equipe
          , upper(ltrim(rtrim(g.[value]))) as Grupo
          , g.[key] AS pos
      from part p
     cross apply openjson(
          '["' + replace(replace(isnull(replace(p.Grupos,' ',''),''), ',', '","'), '""', '"') + '"]'
          ) g
  ),
  fase as (
     select p.ID_Equipe
          , try_convert(tinyint, f.[value]) as Fase
          , f.[key] AS pos
      from part p
      cross apply openjson(
          '["' + replace(replace(isnull(replace(p.Fases,' ',''),''), ',', '","'), '""', '"') + '"]'
          ) f
  )
  
   select g.ID_Equipe,
          g.Grupo,
          f.Fase
     into #aux
     from grp  g
     join fase f  on f.ID_Equipe = g.ID_Equipe
                 and f.pos = g.pos
    where f.Fase in (2,6,8,9,10,16,17,18)
      and g.Grupo is not null and g.Grupo <> ''

  if not exists (select 1 from #aux)
  begin
      select 'Competição não teve nenhuma fase de grupos para exibir a classificação.' as msg
      return
  end

  if object_id('tempdb..#partidas') is not null drop table #partidas;
  create table #partidas 
             ( Grupo varchar(20)
             , ID_Fase tinyint
             , ID_Equipe int
             , Nome_Equipe varchar(100)
             , Gols_Pro int
             , Gols_Contra int
             , Pts tinyint
             , V tinyint
             , E tinyint
             , D tinyint )

  if (@tipo_camp = 2)
  begin
      insert into #partidas
	            ( Grupo
				, ID_Fase
				, ID_Equipe
				, Nome_Equipe
				, Gols_Pro
				, Gols_Contra
				, Pts
				, V
				, E
				, D )
          select ax.Grupo
               , j.ID_Fase
               , j.ID_Anfitriao
               , j.Anfitriao
               , j.Gols_Anfitriao
               , j.Gols_Visitante
               , case when j.Gols_Anfitriao > j.Gols_Visitante then @pts_vitoria
                      when j.Gols_Anfitriao = j.Gols_Visitante then 1 else 0 end
               , case when j.Gols_Anfitriao > j.Gols_Visitante then 1 else 0 end
               , case when j.Gols_Anfitriao = j.Gols_Visitante then 1 else 0 end
               , case when j.Gols_Anfitriao < j.Gols_Visitante then 1 else 0 end
            from vw_jogos_selecoes j with(nolock)
            join #aux             ax             on ax.ID_Equipe = j.ID_Anfitriao 
	                                            and ax.Fase = j.ID_Fase
           where j.ID_Campeonato_Edicao = @id_camp_edicao
             and j.ID_Fase in (2,6,8,9,10,16,17,18)

      insert into #partidas 
                ( Grupo
				, ID_Fase
				, ID_Equipe
				, Nome_Equipe
				, Gols_Pro
				, Gols_Contra
				, Pts
				, V 
				, E 
				, D )
      
	       select ax.Grupo
                , j.ID_Fase
                , j.ID_Visitante
                , j.Visitante
                , j.Gols_Visitante
                , j.Gols_Anfitriao
                , case when j.Gols_Visitante > j.Gols_Anfitriao then @pts_vitoria
                       when j.Gols_Visitante = j.Gols_Anfitriao then 1 else 0 end
                , case when j.Gols_Visitante > j.Gols_Anfitriao then 1 else 0 end
                , case when j.Gols_Visitante = j.Gols_Anfitriao then 1 else 0 end
                , case when j.Gols_Visitante < j.Gols_Anfitriao then 1 else 0 end
             from vw_jogos_selecoes  j with(nolock)
             join #aux              ax             on ax.ID_Equipe = j.ID_Visitante 
                                                  and ax.Fase = j.ID_Fase
            where j.ID_Campeonato_Edicao = @id_camp_edicao
              and j.ID_Fase in (2,6,8,9,10,16,17,18);
  end
  else
  begin
      insert into #partidas 
                ( Grupo
				, ID_Fase
				, ID_Equipe
				, Nome_Equipe
				, Gols_Pro
				, Gols_Contra
				, Pts
				, V
				, E
				, D )
           select ax.Grupo
                , j.ID_Fase
                , j.ID_Anfitriao
                , j.Anfitriao
                , j.Gols_Anfitriao
                , j.Gols_Visitante
                , case when j.Gols_Anfitriao > j.Gols_Visitante then @pts_vitoria
                       when j.Gols_Anfitriao = j.Gols_Visitante then 1 else 0 end
                , case when j.Gols_Anfitriao > j.Gols_Visitante then 1 else 0 end
                , case when j.Gols_Anfitriao = j.Gols_Visitante then 1 else 0 end
                , case when j.Gols_Anfitriao < j.Gols_Visitante then 1 else 0 end
             from vw_jogos_times  j with(nolock)
             join #aux           ax             on ax.ID_Equipe = j.ID_Anfitriao 
                                               and ax.Fase = j.ID_Fase
            where j.ID_Campeonato_Edicao = @id_camp_edicao
              and j.ID_Fase in (2,6,8,9,10,16,17,18);

      insert into #partidas 
	            ( Grupo
				, ID_Fase
				, ID_Equipe
				, Nome_Equipe
				, Gols_Pro
				, Gols_Contra
				, Pts
				, V
				, E
				, D )
           select ax.Grupo
                , j.ID_Fase
                , j.ID_Visitante
                , j.Visitante
                , j.Gols_Visitante
                , j.Gols_Anfitriao
                , case when j.Gols_Visitante > j.Gols_Anfitriao then @pts_vitoria
                       when j.Gols_Visitante = j.Gols_Anfitriao then 1 else 0 end
                , case when j.Gols_Visitante > j.Gols_Anfitriao then 1 else 0 end
                , case when j.Gols_Visitante = j.Gols_Anfitriao then 1 else 0 end
                , case when j.Gols_Visitante < j.Gols_Anfitriao then 1 else 0 end
             from vw_jogos_times j with(nolock)
             join #aux          ax             on ax.ID_Equipe = j.ID_Visitante 
                                              and ax.Fase = j.ID_Fase
            where j.ID_Campeonato_Edicao = @id_camp_edicao
              and j.ID_Fase in (2,6,8,9,10,16,17,18);
  end

  if not exists (select 1 from #partidas)
  begin
      select 'Competição não teve nenhuma fase de grupos para exibir a classificação.' as msg
      return
  end

           select p.Grupo                         as Grupo
                , p.ID_Fase                       as ID_Fase
                , f.Descricao                     as Fase
                , p.ID_Equipe					  as ID_Equipe
                , p.Nome_Equipe					  as Nome_Equipe
                , count(*)                        as Qtd_Jogos
                , sum(p.Pts)                      as Pontos
                , sum(p.V)                        as Vitorias
                , sum(p.E)                        as Empates
                , sum(p.D)                        as Derrotas
                , sum(p.Gols_Pro)                 as Gols_Pro
                , sum(p.Gols_Contra)              as Gols_Contra
                , sum(p.Gols_Pro - p.Gols_Contra) as Saldo
             from #partidas              p
             join tb_campeonatos_fases   f with(nolock)on f.ID_Campeonato_Fase = p.ID_Fase
            where (@grupo is null or p.Grupo = @grupo)
            group by p.Grupo
			       , p.ID_Fase
				   , f.Descricao
				   , p.ID_Equipe
				   , p.Nome_Equipe
            order by p.ID_Fase
                   , p.Grupo
                   , sum(p.Pts)                      desc
                   , sum(p.Gols_Pro - p.Gols_Contra) desc
                   , sum(p.Gols_Pro)                 desc
                   , sum(p.V)                        desc
end

