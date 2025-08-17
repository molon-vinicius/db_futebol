create or alter function fn_jogadores_habilidades_estilos
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
	          select ID_Jogador
                 , P01_Classic_N10
                 , P02_Anchor_Man
                 , P03_Trickster
                 , P04_Darting_Run
                 , P05_Mazing_Run
                 , P06_Pinpoint_Pass
                 , P07_Early_Cross
                 , P08_Box_to_Box
                 , P09_Cut_Back_Pass
                 , P10_Incisive_Run
                 , P11_Long_Ranger
                 , P12_Enforcer
                 , P13_Goal_Poacher
                 , P14_Dummy_Run
                 , P15_Free_Roaming
                 , P16_Extra_Attacker
                 , P17_Chasing_Back
                 , P18_Talisman
                 , P19_Fox_in_the_Box
			        from tb_jogadores_habilidades_estilos
             where ID_Jogador = @id_jogador
		) p
    unpivot (

	  SN for Habilidade in ( P01_Classic_N10
                         , P02_Anchor_Man
                         , P03_Trickster
                         , P04_Darting_Run
                         , P05_Mazing_Run
                         , P06_Pinpoint_Pass
                         , P07_Early_Cross
                         , P08_Box_to_Box
                         , P09_Cut_Back_Pass
                         , P10_Incisive_Run
                         , P11_Long_Ranger
                         , P12_Enforcer
                         , P13_Goal_Poacher
                         , P14_Dummy_Run
                         , P15_Free_Roaming
                         , P16_Extra_Attacker
                         , P17_Chasing_Back
                         , P18_Talisman
                         , P19_Fox_in_the_Box ) ) as unpvt 
                     where SN in ('S')
	
while (select count(Habilidade) as qtd from @habilidades) > 0
begin
  
   select @hab = min(Habilidade)
     from @habilidades
    where SN = 'S'

      set @rtn = @rtn + substring(@hab,0,4) + ' -' + substring(@hab,4,len(@hab)-1) + ', '

   delete from @habilidades where Habilidade = @hab

end

  select @rtn = substring(@rtn, 0, len(@rtn))
  select @rtn = replace(@rtn,'_',' ')

  return @rtn
  
 end

