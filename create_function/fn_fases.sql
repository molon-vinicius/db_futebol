create or alter function fn_fases
(@fases_ID varchar(60))

returns varchar(100)

as

begin
/* teste */
--declare @fases_ID varchar(50) = '2, 12, 13, 15'
/*********/
  
declare @desc varchar(100) = ''
declare @aux varchar(10) = ''
declare @index tinyint

  set @index = (select charindex(',',@fases_ID))

while len(@fases_ID) > 0
begin 
  
  set @index = (select charindex(',',@fases_ID))
  set @aux   = (select substring(@fases_ID, 0, @index))

  if @index = 0
  begin
    set @aux = @fases_ID
    set @index = len(@fases_ID)
  end

  select @desc = concat(@desc, Descricao, ', ')
    from tb_campeonatos_fases with(nolock)
   where ID_Campeonato_Fase = @aux

  set @fases_ID = substring(@fases_ID,@index+2,len(@fases_ID))

end

  set @desc = substring(@desc,0,len(@desc))

  return @desc

end

