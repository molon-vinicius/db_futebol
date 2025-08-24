create or alter function fn_posicao_preferencial 
(@id_jogador int)
returns @pos table ( id_pos tinyint, pos varchar(3) )

begin

declare @aux varchar (3)   
    select @aux = case when substring(dbo.fn_jogadores_posicoes(@id_jogador),0,2) in ('R','L')
                       then substring(dbo.fn_jogadores_posicoes(@id_jogador),2,2)
                       else replace(substring(dbo.fn_jogadores_posicoes(@id_jogador),0,4),',','') 
                  end

    insert into @pos ( id_pos , pos ) 
    select ID_Posicao as id_pos
         , @aux       as pos
      from tb_posicoes with(nolock)
     where Sigla_Posicao = @aux

    return 

end

