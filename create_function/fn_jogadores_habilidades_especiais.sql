create function fn_jogadores_habilidades_especiais
(@id_jogador int)
returns varchar(100)

begin 

--declare @id_jogador int = 4 /* teste */
declare @hab varchar(20) = ''
declare @rtn varchar(150) = ''
declare @habilidades table
(ID_Jogador int
,Habilidade varchar(20)
,SN varchar(1))

insert into @habilidades (ID_Jogador, Habilidade, SN)
     select ID_Jogador, Habilidade, SN       
       from (
	        select ID_Jogador, Dribbling, Tactical_Dribble, Positioning, Playmaking, Scoring, Post_Player, Lines, Middle_Shooting, Side, Center, Curling_Shot
            from tb_jogadores_habilidades_especiais
           where ID_Jogador = @id_jogador
		) p
    unpivot (

	SN for Habilidade in ( Dribbling, Tactical_Dribble, Positioning, Playmaking, Scoring, Post_Player, Lines, Middle_Shooting, Side, Center, Curling_Shot ) 
	    ) as unpvt 
   where SN in ('S')
	
while (select count(Habilidade) as qtd from @habilidades) > 0
begin
  
   select @hab = min(Habilidade)
     from @habilidades
    where SN = 'S'

      set @rtn = @rtn + @hab + ', '

   delete from @habilidades where Habilidade = @hab

end

  select @rtn = substring(@rtn, 0, len(@rtn))

  return @rtn

 end

