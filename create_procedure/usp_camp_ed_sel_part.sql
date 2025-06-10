create or alter procedure usp_camp_ed_sel_part 
(@ID_Campeonato_Edicao int)

as     

declare @desc_camp varchar(100)
declare @grupo varchar(10)
declare @sel varchar(40)
declare @rtn char(1) = 'N'

if object_id('tempdb..#aux')      is not null drop table #aux
if object_id('tempdb..#grupos')   is not null drop table #grupos
if object_id('tempdb..#retorno')  is not null drop table #retorno
if object_id('tempdb..#sel_part') is not null drop table #sel_part

create table #aux (descricao varchar(20))
create table #grupos (linha tinyint identity, descricao varchar(150))
create table #retorno (grupo varchar(150), selecoes varchar(150))
create table #sel_part (sel varchar(40), grupos varchar(20))

if exists (select grupos 
             from tb_campeonatos_edicoes_selecoes_part with(nolock)
            where ID_Campeonato_Edicao = @ID_Campeonato_Edicao
              and grupos is not null)
begin  
        set @rtn = 'S'
     select distinct @desc_camp = concat(b.Ano, ' ', c.Descricao, ' - ', d.Nome_Pais)          
       from tb_campeonatos_edicoes_selecoes_part   a with(nolock)
       join tb_campeonatos_edicoes                 b with(nolock)on b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
       join tb_campeonatos                         c with(nolock)on c.ID_Campeonato = b.ID_Campeonato
       join tb_paises                              d with(nolock)on d.ID_Pais = b.Pais_Sede
      where a.Grupos is not null
        and	a.ID_campeonato_edicao = @ID_Campeonato_Edicao 
end
else
begin
  set @desc_camp = ''
end

if @rtn = 'S'
begin
insert into #aux 
           (descricao)

     select distinct grupos
       from tb_campeonatos_edicoes_selecoes_part
      where ID_campeonato_edicao = @ID_Campeonato_Edicao

while (select count(*) as qtd from #aux) > 0 
begin

    select @grupo = min(descricao)
      from #aux

    insert into #grupos (descricao)
    select @grupo

    update a
       set descricao = replace(descricao, @grupo + ', ','')
      from #aux  a 
     where descricao like '%'+@grupo+'%'

	delete from #aux where descricao = @grupo

end

insert into #sel_part (sel, grupos)
     select b.Nome_Selecao, a.Grupos
       from tb_campeonatos_edicoes_selecoes_part a with(nolock)
       join tb_selecoes                          b with(nolock)on b.ID_Selecao = a.ID_selecao
      where a.ID_campeonato_edicao = @ID_Campeonato_Edicao
	  
insert into #retorno (grupo)
     select distinct descricao from #grupos order by descricao


while (select count(*) as qtd from #grupos) > 0 --(select count(sel) as qtd from #sel_part) > 0
begin

   select @grupo = min(descricao)
     from #grupos

    while (select count(sel) as qtd 
             from #sel_part a
            where grupos like '%'+@grupo+'%' 
    ) > 0
	begin 
	
      select @sel = min(sel)
        from #sel_part
       where grupos like '%'+@grupo+'%'

      update #retorno
         set selecoes = isnull(selecoes,'') + @sel + ', '     	  
       where grupo = @grupo

      update #sel_part
         set grupos = replace(grupos, @grupo, '')
       where sel = @sel
         and grupos like '%'+@grupo+'%'

      delete from #sel_part where sel = @sel and grupos = ''

    end

    delete from #grupos where descricao = @grupo

end 

     update a 
        set selecoes = substring(selecoes,0,len(selecoes))
       from #retorno a 
	 
	 select @desc_camp

      union all

     select concat(grupo,': ', selecoes) as Grupos
       from #retorno
end
else
begin
     select @desc_camp
end

