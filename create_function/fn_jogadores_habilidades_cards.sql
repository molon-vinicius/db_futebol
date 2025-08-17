create function fn_jogadores_habilidades_cards
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
                 , S01_Marauding
                 , S02_Passer
                 , S03_1_on_1_Finish
                 , S04_PK_Taker
                 , S05_1_Touch_Play
                 , S06_Outside_Curve
                 , S07_Marking
                 , S08_Slide_Tackle
                 , S09_Covering
                 , S10_DF_Leader
                 , S11_Penalty_Saver
                 , S12_1_on_1_Keeper
                 , S13_Long_Throw
                 , S14_Speed_Merchant
                 , S15_Shoulder_Feint_Skills
                 , S16_Roulette_Skills
                 , S17_Flip_Flap_Skills
                 , S18_Turning_Skills
                 , S19_Scissors_Skills
                 , S20_Flicking_Skills
                 , S21_Step_On_Skills
                 , S22_Side_Stepping_Skills
                 , S23_Super_Sub
			        from tb_jogadores_habilidades_cards
             where ID_Jogador = @id_jogador
		) p
    unpivot (

   	SN for Habilidade in ( S01_Marauding
                         , S02_Passer
                         , S03_1_on_1_Finish
                         , S04_PK_Taker
                         , S05_1_Touch_Play
                         , S06_Outside_Curve
                         , S07_Marking
                         , S08_Slide_Tackle
                         , S09_Covering
                         , S10_DF_Leader
                         , S11_Penalty_Saver
                         , S12_1_on_1_Keeper
                         , S13_Long_Throw
                         , S14_Speed_Merchant
                         , S15_Shoulder_Feint_Skills
                         , S16_Roulette_Skills
                         , S17_Flip_Flap_Skills
                         , S18_Turning_Skills
                         , S19_Scissors_Skills
                         , S20_Flicking_Skills
                         , S21_Step_On_Skills
                         , S22_Side_Stepping_Skills
                         , S23_Super_Sub ) ) as unpvt 
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

