create or alter procedure usp_campeonatos_classif
(@id_camp_edicao int
,@grupo varchar(1) null)

as

declare @equipe_aux int
declare @id_jogo_equipe int
declare @id_anfitriao int
declare @id_visitante int
declare @gols_anfitriao int
declare @gols_visitante int
declare @pts_vitoria int
declare @tipo_camp int
declare @ponteiro_grupo tinyint
declare @ponteiro_fase tinyint
declare @grupo_aux varchar(1)
declare @fase_aux varchar(2)

    select @tipo_camp = b.ID_Tipo_Campeonato /* 1 Time | 2 Seleção */
      from tb_campeonatos_edicoes   a with(nolock)
      join tb_campeonatos           b with(nolock)on b.ID_Campeonato = a.ID_Campeonato
     where a.ID_Campeonato_Edicao = @id_camp_edicao

if (
select case when len(a.Ano) > 4
            then substring(a.Ano, 0, 5)
            else a.Ano
       end
  from tb_campeonatos_edicoes a with(nolock)
  join tb_campeonatos         b with(nolock)on b.ID_Campeonato = a.ID_Campeonato
 where a.ID_Campeonato_Edicao = @id_camp_edicao  ) >= 1995
begin
  set @pts_vitoria = 3
end
else 
begin
  set @pts_vitoria = 2
end 

if object_id('tempdb..#fases')   is not null drop table #fases 
if object_id('tempdb..#grupos')  is not null drop table #grupos
if object_id('tempdb..#equipes') is not null drop table #equipes
if object_id('tempdb..#aux')     is not null drop table #aux
if object_id('tempdb..#jogos')   is not null drop table #jogos
if object_id('tempdb..#classif') is not null drop table #classif

create table #aux 
             (ID_Equipe int
             ,Grupo varchar(2)
             ,Fase tinyint)

create table #jogos
            (id_jogo_equipe int
            ,id_anfitriao int
            ,anfitriao varchar(60)
            ,gols_anfitriao int
            ,id_visitante int
            ,visitante varchar(60)
            ,gols_visitante int
            ,id_fase tinyint
            ,grupo varchar(20))

create table #classif
            (grupo varchar(15)
            ,id_fase tinyint
            ,fase varchar(30)
            ,id_equipe int
            ,nome_equipe varchar(60)
            ,qtd_jogos int
            ,pontos int
            ,vitorias int
            ,empates int
            ,derrotas int
            ,gols_pro int
            ,gols_contra int
            ,saldo int)
  
   select distinct 
          Grupos      as grupos
        , ID_Selecao  as ID_Equipe
     into #grupos
     from tb_campeonatos_edicoes_selecoes_part with(nolock)
    where id_campeonato_edicao = @id_camp_edicao
      and @tipo_camp = 2
      and Grupos is not null
    
	union all

   select distinct 
          Grupos     as grupos
        , ID_Time    as ID_Equipe
     from tb_campeonatos_edicoes_times_part with(nolock)
    where id_campeonato_edicao = @id_camp_edicao
      and @tipo_camp = 1
      and Grupos is not null
    order by Grupos

   select distinct 
          Fases       as fases
        , ID_Selecao  as ID_Equipe
     into #fases
     from tb_campeonatos_edicoes_selecoes_part with(nolock)
    where id_campeonato_edicao = @id_camp_edicao
      and @tipo_camp = 2
      and Fases is not null
    
	union all

   select distinct 
          Fases      as fases
        , ID_Time    as ID_Equipe
     from tb_campeonatos_edicoes_times_part with(nolock)
    where id_campeonato_edicao = @id_camp_edicao
      and @tipo_camp = 1
      and Fases is not null
    order by Fases

while (select count(*) as qtd from #grupos where len(grupos) > 1) > 0
begin 

     select @ponteiro_grupo = charindex(',', grupos)
       from #grupos
      where len(Grupos) > 1  

     select @grupo_aux = ltrim(substring(grupos, @ponteiro_grupo+1, @ponteiro_grupo+2))
       from #grupos
      where len(Grupos) > 1
     
insert into #grupos (grupos, ID_Equipe)
     select @grupo_aux as grupos
          , ID_Equipe 
       from #grupos 
      where len(Grupos) > 1
        and grupos like '%'+@grupo_aux+'%'

     update a
        set grupos = replace(grupos, ', ' + @grupo_aux,'')
       from #grupos a 
      where len(Grupos) > 1
end

while (select count(*) as qtd from #fases where len(fases) > 2) > 0
begin 
     
     select @ponteiro_fase  = charindex(',', fases)
       from #fases
      where len(fases) > 1

     select @fase_aux = ltrim(substring(fases, 0, @ponteiro_fase))
       from #fases
      where len(fases) > 1

if @fase_aux in (2,6,8,9,10,16,17,18)
/* 2-Fase de Grupos | 6-Segunda Fase | 8-Terceira Fase | 9-Triangular Final | 10-Quadrangular Final 
  16-Pontos Corridos Turno Único | 17-Pontos Corridos 1º turno | 18-Pontos Corridos 2º turno */
begin

   insert into #fases (fases, ID_Equipe)
        select @fase_aux as fases
             , ID_Equipe 
          from #fases 
         where len(fases) > 1
           and fases like '%'+@fase_aux+'%'
end		   

        update a
           set fases = substring(fases,@fase_aux+2,len(fases)+1)
          from #fases a 
         where len(Fases) > 1

end

delete from #fases where fases not in (2,6,8,9,10,16,17,18) or fases is null

   select distinct a.ID_Equipe
     into #equipes
     from #grupos  a 
     join #fases   b on b.ID_Equipe = a.ID_Equipe

while ( select count(ID_Equipe) as qtd from #equipes ) > 0
begin
  select @equipe_aux = min(ID_Equipe)
    from #equipes

  while ( select count(grupos) as qtd from #grupos where ID_Equipe = @equipe_aux ) > 0
  begin 
     
     select @grupo_aux = min(grupos) from #grupos where	ID_Equipe = @equipe_aux
     select @fase_aux  = min(convert(tinyint, fases))  from #fases  where ID_Equipe = @equipe_aux

insert into #aux (ID_Equipe, Grupo, Fase)
     select @equipe_aux, @grupo_aux, @fase_aux

     delete from #grupos where ID_Equipe = @equipe_aux and grupos = @grupo_aux
     delete from #fases  where ID_Equipe = @equipe_aux and fases  = @fase_aux
  
  end
  
  delete from #equipes where ID_Equipe = @equipe_aux

end

if (select count(ID_Equipe) as qtd from #aux) > 0
begin

insert into #jogos 
           (id_jogo_equipe
           ,id_anfitriao
           ,anfitriao
           ,gols_anfitriao
           ,id_visitante
           ,visitante
           ,gols_visitante
           ,id_fase
           ,grupo)

    select distinct 
           a.ID_jogo_selecao    as ID_Jogo_Equipe
         , a.ID_Anfitriao
         , a.Anfitriao
         , a.Gols_Anfitriao
         , a.ID_Visitante
         , a.Visitante
         , a.Gols_Visitante
         , a.ID_Fase
         , b.grupo              as grupo  
      from vw_jogos_selecoes a with(nolock)
      join #aux              b with(nolock)on b.ID_Equipe = a.ID_Anfitriao
                                          and b.Fase = a.ID_Fase
     where a.ID_Campeonato_Edicao = @id_camp_edicao 
       and a.ID_Fase in (2,6,8,9,10,16,17,18) 
	 /* 2-Fase de Grupos | 6-Segunda Fase | 8-Terceira Fase | 9-Triangular Final | 10-Quadrangular Final */
       and @tipo_camp = 2  /* Selecão */

     union all

    select distinct 
           a.ID_jogo_time       as ID_Jogo_Equipe
         , a.ID_Anfitriao
         , a.Anfitriao
         , a.Gols_Anfitriao
         , a.ID_Visitante
         , a.Visitante
         , a.Gols_Visitante
         , a.ID_Fase
         , b.grupo              as grupo  
      from vw_jogos_times    a with(nolock)
      join #aux              b with(nolock)on b.ID_Equipe = a.ID_Visitante
                                          and b.Fase = a.ID_Fase
     where a.ID_Campeonato_Edicao = @id_camp_edicao 
       and a.ID_Fase in (2,6,8,9,10,16,17,18)
	 /* 2-Fase de Grupos | 6-Segunda Fase | 8-Terceira Fase | 9-Triangular Final | 10-Quadrangular Final */
       and @tipo_camp = 1  /* Time */
     order by ID_Jogo_Equipe
	 
insert into #classif
           (grupo
           ,id_fase
           ,fase
           ,id_equipe
           ,nome_equipe
           ,qtd_jogos
           ,pontos
           ,vitorias
           ,empates
           ,derrotas
           ,gols_pro
           ,gols_contra
           ,saldo)

     select distinct
            a.grupo         as grupo
           ,a.fase          as id_fase
           ,c.descricao     as fase
           ,b.id_selecao    as id_equipe
           ,b.nome_selecao  as nome_equipe
           ,0               as qtd_jogos
           ,0               as pontos
           ,0               as vitorias
           ,0               as empates
           ,0               as derrotas
           ,0               as gols_pro
           ,0               as gols_contra
           ,0               as saldo
      from #aux                    a
      join tb_selecoes             b with(nolock)on b.ID_selecao = a.ID_equipe
      join tb_campeonatos_fases    c with(nolock)on a.fase = c.ID_Campeonato_Fase
     where a.fase in (2,6,8,9,10,16,17,18)
       and @tipo_camp = 2   /* Seleção */   

     union all

    select distinct
           a.grupo         as grupo
          ,a.fase          as id_fase
          ,c.descricao     as fase
          ,b.id_time       as id_equipe
          ,b.nome_reduzido as nome_equipe
          ,0               as qtd_jogos
	  ,0               as pontos
	  ,0               as vitorias
	  ,0               as empates
	  ,0               as derrotas
	  ,0               as gols_pro
	  ,0               as gols_contra
	  ,0               as saldo
      from #aux                    a
      join tb_times                b with(nolock)on b.ID_Time = a.ID_equipe
      join tb_campeonatos_fases    c with(nolock)on a.fase = c.ID_Campeonato_Fase
     where a.fase in (2,6,8,9,10,16,17,18)
       and @tipo_camp = 1   /* Time */ 
	  
while (select count (distinct grupo) as qtd from #aux) > 0
begin
  set @grupo_aux = (select min(grupo) as grupo from #aux)
  
    while (select count(grupo) as qtd from #jogos where grupo = @grupo_aux) > 0 
      begin
      set @id_jogo_equipe = (select min(ID_jogo_equipe) as ID_jogo from #jogos where grupo = @grupo_aux)
	  select @id_anfitriao   = id_anfitriao
               , @gols_anfitriao = gols_anfitriao
	       , @id_visitante   = id_visitante
	       , @gols_visitante = gols_visitante
	    from #jogos 
	   where id_jogo_equipe = @id_jogo_equipe

      update #classif 
         set qtd_jogos = qtd_jogos + 1
	   , pontos    = case when @gols_anfitriao > @gols_visitante
                              then pontos + @pts_vitoria
	                      when @gols_anfitriao = @gols_visitante
			      then pontos + 1
			      else pontos 
                         end
           , vitorias    = iif(@gols_anfitriao > @gols_visitante, vitorias + 1, vitorias)
	   , empates     = iif(@gols_anfitriao = @gols_visitante, empates  + 1, empates )
	   , derrotas    = iif(@gols_anfitriao < @gols_visitante, derrotas + 1, derrotas)
	   , gols_pro    = gols_pro    + @gols_anfitriao
	   , gols_contra = gols_contra + @gols_visitante
       where ID_equipe = @id_anfitriao 
         and grupo = @grupo_aux

      update #classif 
         set qtd_jogos = qtd_jogos + 1
	   , pontos    = case when @gols_visitante > @gols_anfitriao
                              then pontos + @pts_vitoria
	                      when @gols_visitante = @gols_anfitriao
                              then pontos + 1
			      else pontos 
                         end
           , vitorias    = iif(@gols_visitante > @gols_anfitriao, vitorias + 1, vitorias)
	   , empates     = iif(@gols_visitante = @gols_anfitriao, empates  + 1, empates )
	   , derrotas    = iif(@gols_visitante < @gols_anfitriao, derrotas + 1, derrotas)
	   , gols_pro    = gols_pro    + @gols_visitante
	   , gols_contra = gols_contra + @gols_anfitriao
       where ID_equipe = @id_visitante
         and grupo = @grupo_aux
	  
	  delete 
	    from #jogos 
	   where id_jogo_equipe = @id_jogo_equipe

    end

  delete from #aux where grupo = @grupo_aux

end  

  update #classif 
     set saldo = gols_pro - gols_contra

  select grupo
        ,fase
        ,nome_equipe
        ,qtd_jogos
	,pontos
	,vitorias
	,empates
	,derrotas
	,gols_pro
	,gols_contra
	,saldo
    from #classif
   where grupo = @grupo 
      or @grupo is null
   order by grupo, pontos desc, vitorias desc, gols_pro desc, saldo desc

end
	
else 
begin
  select 'Competição não teve nenhuma fase de grupos para exibir a classificação.'
end
