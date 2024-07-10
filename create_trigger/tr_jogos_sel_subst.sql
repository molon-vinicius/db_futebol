create trigger tr_jogos_sel_subst 
            on tb_jogos_selecoes_substituicoes
for insert, update 
 
as

begin

declare @id_jogo_sel int 
declare @id_jgd_ent  int
declare @id_jgd_sai  int
declare @minuto      tinyint

      select @id_jogo_sel = ID_Jogo_Selecao
           , @id_jgd_ent  = ID_Jogador_Entrada
		       , @id_jgd_sai  = ID_Jogador_Saida
		       , @minuto      = Minuto
        from inserted 


  if @id_jgd_ent = @id_jgd_sai
  begin
     raiserror ('Jogador de entrada informado é igual ao jogador de saída.', 11, 127)
	   rollback transaction
  end

  if exists (
     select 1
       from tb_jogos_selecoes_substituicoes
      where ID_Jogo_Selecao = @id_jogo_sel
        and ID_Jogador_Saida = @id_jgd_ent
  )
  begin
     raiserror ('Jogador que saiu anteriormente no mesmo jogo não pode voltar para a partida.', 11, 127)
	   rollback transaction
  end

  if @minuto > 120
  or @minuto = 0
  begin
     raiserror ('Minuto informado inválido, os valores devem ser entre 1 e 120 minutos. Para ''Acréscimos'' preencher a coluna equivalente.', 11, 127)
	   rollback transaction
  end

end
