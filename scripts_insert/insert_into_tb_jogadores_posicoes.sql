declare @Nome_Reduzido varchar(60) = 'Oliver Kahn'
declare @GK varchar(1) = 'S'
declare @CB varchar(1) = 'N'
declare @SB varchar(1) = 'N'
declare @SW varchar(1) = 'N'
declare @WB varchar(1) = 'N'
declare @DM varchar(1) = 'N'
declare @CM varchar(1) = 'N'
declare @SM varchar(1) = 'N'
declare @AM varchar(1) = 'N'
declare @WF varchar(1) = 'N'
declare @SS varchar(1) = 'N'
declare @CF varchar(1) = 'N'

declare @id_jogador int = (
        select ID_Jogador
          from tb_jogadores a with(nolock)
          join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
         where b.Nome_Reduzido = @Nome_Reduzido
)   

if @id_jogador is null
begin
  select 'Jogador não cadastrado.'
  return
end 

insert into tb_jogadores_posicoes 
       (ID_Jogador
		   ,GK
		   ,CB
		   ,SB
		   ,SW
		   ,WB
		   ,DM
		   ,CM
		   ,SM
		   ,AM
		   ,WF
		   ,SS
		   ,CF)

select @id_jogador AS ID_Jogador
      , @GK         AS GK
		  , @CB         AS CB
		  , @SB         AS SB
		  , @SW         AS SW
		  , @WB         AS WB
		  , @DM         AS DM
		  , @CM         AS CM
		  , @SM         AS SM
		  , @AM         AS AM
		  , @WF         AS WF
		  , @SS         AS SS
		  , @CF         AS CF
