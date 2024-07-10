/* 
A tabela tb_jogadores_posicoes terá 3 opções de preenchimento: 'N' / 'S' / 'P' (Não / Sim / Preferencial)
A trigger evita as seguintes situações:
- que um jogador não tenha nenhuma posição selecionada;
- que um jogador tenha duas posições preferenciais;
- que um jogador que tenha duas ou mais posições selecionadas tenha uma posição como P;
- caso haja só uma posição que o jogador atue, salvar com o 'S' ao invés do 'P'.
*/

create trigger tr_jogadores_posicoes 
            on tb_jogadores_posicoes
for insert, update 
 
as
declare @id_jogador int 
declare @aux tinyint = (select count(Sigla_Posicao) as qtd from tb_posicoes with(nolock))
declare @sigla_posicao varchar(2)
declare @cont tinyint = 1
declare @comando nvarchar(max) = ''

 select @id_jogador = ID_jogador
   from inserted

if object_id('tempdb..#contadores') is not null drop table #contadores
create table #contadores 
             (cont_S tinyint
			       ,cont_P tinyint)
insert into  #contadores (cont_S, cont_P) values (0,0)

while @cont <= @aux
begin
   
    select @Sigla_Posicao = Sigla_Posicao 
	    from tb_posicoes with(nolock)
     where ID_Posicao = @cont

       set @comando =
    '
     if exists ( select ID_Jogador from tb_jogadores_posicoes where ID_Jogador = '+convert(varchar(6),@id_jogador)+' and '+@Sigla_Posicao+' = ''S'')
	 begin
        update #contadores 
           set cont_S = cont_S + 1
	 end

	      if exists ( select ID_Jogador from tb_jogadores_posicoes where ID_Jogador = '+convert(varchar(6),@id_jogador)+' and '+@Sigla_Posicao+' = ''P'')
	 begin
        update #contadores 
           set cont_P = cont_P + 1
	 end
	'
	execute sp_executesql @comando 

	set @cont = @cont + 1
end
      
if  (select cont_S from #contadores) = 0
and (select cont_P from #contadores) = 0
  begin
    raiserror ('É necessário pelo menos uma posição cadastrada para salvar o registro na tabela.', 11, 127)
    rollback transaction
  end

if  (select cont_S from #contadores) > 1 
and (select cont_P from #contadores) = 0
  begin
    raiserror ('É necessário definir uma posição como ''P'' [Preferencial] quando há mais de uma posição cadastrada.', 11, 127)
    rollback transaction
  end

if  (select cont_S from #contadores) = 0 
and (select cont_P from #contadores) = 1
  begin
    raiserror ('Caso haja só uma posição cadastrada para o jogador, salvar com a instrução ''S''.', 11, 127)
    rollback transaction
  end

if  (select cont_S from #contadores) = 0
and (select cont_P from #contadores) > 1
  begin
    raiserror ('Não é possível salvar múltiplas posições como ''P'' [Preferencial].', 11, 127)
    rollback transaction
  end

if  (select cont_S from #contadores) > 1
and (select cont_P from #contadores) > 1
  begin
    raiserror ('Não é possível salvar múltiplas posições como ''P'' [Preferencial].', 11, 127)
    rollback transaction
  end
