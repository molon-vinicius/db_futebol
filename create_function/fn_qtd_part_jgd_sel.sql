create or alter function fn_qtd_part_jgd_sel
(@id_camp int
,@id_jgd int)

returns int

as

begin

declare @rtn int

        select @rtn = count(distinct a.ID_Campeonato_Edicao) 
          from tb_selecoes_elencos     a with(nolock)
          join tb_campeonatos_edicoes  b with(nolock)on b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao  
          join tb_campeonatos          c with(nolock)on c.ID_Campeonato = b.ID_Campeonato				 
         where a.ID_Jogador = @id_jgd
           and c.ID_Campeonato = @id_camp

return @rtn

end
