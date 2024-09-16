create function fn_jogadores_posicoes
(@id_jogador int)
returns varchar(100)

begin 

declare @pos varchar(3) = ''
declare @rtn varchar(100) = ''
declare @posicoes table
(ID_Jogador int
,Posicao varchar(3)
,SN varchar(1))

insert into @posicoes (ID_Jogador, Posicao, SN)
     select ID_Jogador, Posicao, SN       
       from (
	        select ID_Jogador, GK, CB, SB, SW, WB, DM, CM, SM, AM, WF, SS, CF
            from tb_jogadores_posicoes
           where ID_Jogador = @id_jogador
		) p
    unpivot (

	SN for Posicao in ( GK, CB, SB, SW, WB, DM, CM, SM, AM, WF, SS, CF ) 
	    ) as unpvt 
     where SN in ('S','P')

if ( select distinct b.Pe_Preferencial
       from @posicoes    a 
       join tb_jogadores b with(nolock)on b.ID_Jogador = a.ID_Jogador
) is not null
begin
     update a
        set Posicao = concat(Pe_Preferencial, Posicao)
       from @posicoes    a
       join tb_jogadores b with(nolock)on b.ID_Jogador = a.ID_Jogador
      where a.Posicao in ('SB', 'WB', 'SM', 'WF')
        and b.Lado_Oposto = 'N'

     update a
        set Posicao = concat(case when Pe_Preferencial = 'R'
                                  then 'L'
                                  else 'R' 
                             end, Posicao)
       from @posicoes    a
       join tb_jogadores b with(nolock)on b.ID_Jogador = a.ID_Jogador
      where a.Posicao in ('SB', 'WB', 'SM', 'WF')
        and b.Lado_Oposto = 'S'	

end

while (select count(Posicao) as qtd from @posicoes) > 0
begin

   if exists (select Posicao from @posicoes where SN = 'P')
   begin
   select @pos = Posicao
     from @posicoes
    where SN = 'P'
   end
   else
   begin
   select @pos = min(Posicao)
     from @posicoes
    where SN = 'S'
   end

      set @rtn = @rtn + @pos + ', '

   delete from @posicoes where Posicao = @pos

end

  select @rtn = substring(@rtn, 0, len(@rtn))

  return @rtn

end
