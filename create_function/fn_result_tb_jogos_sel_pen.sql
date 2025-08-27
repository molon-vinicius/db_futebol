create or alter function fn_result_tb_jogos_sel_pen
(@ID_Jogo_Selecao int)
returns varchar(150)

as 

begin

declare @rtn varchar(150)
declare @aux table (Linha int identity (1,1), ID_Selecao int, Nome_Selecao varchar(60), Gols int)

  insert into @aux (ID_Selecao, Nome_Selecao, Gols)
  select a.ID_Selecao
       , b.Nome_Selecao
       , sum(convert(int, a.Gol)) as Gols
    from tb_jogos_selecoes_penaltis a with(nolock)
    join tb_selecoes                b with(nolock)on b.ID_Selecao = a.ID_Selecao
    join tb_jogos_selecoes          c with(nolock)on c.ID_jogo_selecao = a.ID_jogo_selecao
                                                 and c.ID_Selecao_Anfitriao = a.ID_Selecao
   where a.ID_jogo_selecao = @id_jogo_selecao
   group by a.ID_selecao, b.Nome_Selecao
   
   union all

  select a.ID_Selecao
       , b.Nome_Selecao
       , sum(convert(int, a.Gol)) as Gols
    from tb_jogos_selecoes_penaltis a with(nolock)
    join tb_selecoes                b with(nolock)on b.ID_Selecao = a.ID_Selecao  
    join tb_jogos_selecoes          c with(nolock)on c.ID_jogo_selecao = a.ID_jogo_selecao
                                                 and c.ID_Selecao_Visitante = a.ID_Selecao
   where a.ID_jogo_selecao = @id_jogo_selecao
   group by a.ID_selecao, b.Nome_Selecao
   
   select @rtn = max(case when linha = 1 
                          then Nome_Selecao + ' ' + cast(Gols as varchar) 
                     end) + '-' +
                 max(case when linha = 2 
                          then cast(Gols as varchar) + ' ' + Nome_Selecao 
                     end)
     from @aux

   return @rtn
   
end

