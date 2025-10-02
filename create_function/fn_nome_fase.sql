create or alter function fn_nome_fase (@ID_Jogo_Selecao int)
returns varchar(100)
as
begin

--declare @ID_Jogo_Selecao int = 303 --teste
declare @retorno varchar(100)

    ;with cte as (
      select b.Grupos
           , b.Fases
           , x.ID_Campeonato_Fase
           , x.Descricao
        from tb_campeonatos_fases                 x with(nolock)
        join tb_jogos_selecoes                    a with(nolock) on a.ID_Campeonato_Fase = x.ID_Campeonato_Fase
        join tb_campeonatos_edicoes_selecoes_part b with(nolock) on b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
                                                                 and b.ID_Selecao = a.ID_Selecao_Anfitriao
        where a.ID_Jogo_Selecao = @ID_Jogo_Selecao
    ),

    grupos as (
        select 
            value as Grupo,
            row_number() over(order by (select null)) as rn
        from cte
        cross apply string_split(Grupos, ',')
    ),
    fases as (
        select 
            value as Fase,
            row_number() over(order by (select null)) as rn
        from cte
        cross apply string_split(Fases, ',')
    )

    select top 1
        @retorno =  c.Descricao + ' - Grupo ' + ltrim(rtrim(b.Grupo))                    
    from fases        a
    join grupos       b on a.rn = b.rn
	join cte          c on c.ID_Campeonato_Fase = a.Fase
	
    return @retorno

end
go
