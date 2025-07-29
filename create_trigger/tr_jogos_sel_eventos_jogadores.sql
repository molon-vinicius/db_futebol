create or alter trigger tr_jogos_sel_eventos_jogadores  
                     on tb_jogos_selecoes_eventos
for insert, update 
 
as

begin

declare @id_camp_ed  int
declare @id_jogo_sel int
declare @id_evento   int
declare @id_selecao  int
declare @id_jogador  int
declare @assist      int
declare @id_anf      int
declare @id_vis      int 
declare @minuto      tinyint
declare @acresc      tinyint
declare @minuto_ent  int
declare @minuto_sai  int
declare @min_ent_ast int
declare @min_sai_ast int
declare @retorno     varchar(150)

      select @id_jogo_sel = ID_Jogo_Selecao
           , @id_evento   = ID_Tipo_Evento
           , @id_selecao  = ID_Selecao
           , @id_jogador  = ID_Jogador
           , @assist      = Assistencia
           , @minuto      = Minuto
           , @acresc      = Acrescimos
        from inserted

      select @id_camp_ed = a.ID_Campeonato_Edicao
           , @id_anf     = a.ID_Selecao_Anfitriao
           , @id_vis     = a.ID_Selecao_Visitante  
        from tb_jogos_selecoes  a with(nolock)
       where a.ID_Jogo_Selecao = @id_jogo_sel

      select @minuto_ent = a.Minuto
        from tb_jogos_selecoes_substituicoes a with(nolock)
       where a.ID_Jogo_Selecao = @id_jogo_sel
         and a.ID_Selecao = @id_selecao
         and a.ID_Jogador_Entrada = @id_jogador

      select @minuto_sai = a.Minuto
        from tb_jogos_selecoes_substituicoes a with(nolock)
       where a.ID_Jogo_Selecao = @id_jogo_sel
         and a.ID_Selecao = @id_selecao
         and a.ID_Jogador_Saida = @id_jogador

      select @min_ent_ast = a.Minuto
        from tb_jogos_selecoes_substituicoes a with(nolock)
       where a.ID_Jogo_Selecao = @id_jogo_sel
         and a.ID_Selecao = @id_selecao
         and a.ID_Jogador_Entrada = @assist

      select @min_sai_ast = a.Minuto
        from tb_jogos_selecoes_substituicoes a with(nolock)
       where a.ID_Jogo_Selecao = @id_jogo_sel
         and a.ID_Selecao = @id_selecao
         and a.ID_Jogador_Saida = @assist

if (select ID_Jogo_Selecao from deleted) is not null
begin
  if @minuto > 120
  or @minuto = 0
  begin
     raiserror ('Minuto informado inválido, os valores devem ser entre 1 e 120 minutos. Para ''Acréscimos'' preencher a coluna equivalente.', 11, 127)
     rollback transaction
  end

  if @minuto not in (45, 90, 105, 120)
  and @acresc is not null
  begin
     raiserror ('Só pode ter tempo de acréscimo se o minuto for 45/90/105/120.', 11, 127)
     rollback transaction
  end
		
  if  @id_selecao <> @id_anf
  and @id_selecao <> @id_vis
  begin
     raiserror ('Seleção informada não participou desta partida.', 11, 127)
     rollback transaction
  end

if @id_evento in (2, 3) /* 2-Cartão Amarelo | 3-Cartão Vermelho */
begin
   if (  select ID_Jogador 
           from tb_selecoes_elencos with(nolock)
          where ID_Campeonato_Edicao = @id_camp_ed
            and ID_Selecao = @id_selecao
            and ID_Jogador = @id_jogador
   ) is null
   begin
     raiserror ('Jogador informado não integra o elenco desta seleção.', 11, 127)
     rollback transaction
   end

end

if @assist = @id_jogador
begin
     raiserror ('Jogador que fez o gol não pode ser o mesmo que deu a assistência.', 11, 127)
     rollback transaction
end

if @id_evento <> 2
and @assist is not null
begin
     raiserror ('Assistência só pode ser vinculada com o evento [2] Gol.', 11, 127)
     rollback transaction
end
	
if @id_evento = 2  /* 2-Cartão Amarelo */
and ( 
   select count(ID_Tipo_Evento) as Evento
     from tb_jogos_selecoes_eventos with(nolock)
    where ID_jogo_selecao = @id_jogo_sel
      and ID_jogador = @id_jogador
      and ID_Tipo_Evento = @id_evento
) > 2
begin
   begin
     raiserror ('Jogador não pode receber mais de 2 cartões amarelos.', 11, 127)
     rollback transaction
   end
end

if @id_evento in (1,5,6,7,8) /* 1-Gol | 5-Gol (P) | 6-Pênalti (X) | 7-Gol Anulado | 8-Gol Contra */
begin
  if not exists (

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes            a with(nolock)
       join tb_jogos_selecoes_anfitrioes b with(nolock)on b.ID_Selecao = a.ID_Selecao_Anfitriao
                                                      and b.ID_Jogo_Selecao = a.ID_Jogo_Selecao
      where a.ID_Jogo_Selecao = @id_jogo_sel
        and a.ID_Selecao_Anfitriao = @id_selecao
        and b.ID_Jogador = @id_jogador
		
      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes            a with(nolock)
       join tb_jogos_selecoes_visitantes b with(nolock)on b.ID_Selecao = a.ID_Selecao_Visitante
                                                      and b.ID_Jogo_Selecao = a.ID_Jogo_Selecao
      where a.ID_Jogo_Selecao = @id_jogo_sel
        and a.ID_Selecao_Visitante = @id_selecao
        and b.ID_Jogador = @id_jogador
	  
      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes               a with(nolock)
       join tb_selecoes_elencos             b with(nolock)on b.ID_Selecao = a.ID_Selecao_Anfitriao
                                                         and b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
       join tb_jogos_selecoes_substituicoes c with(nolock)on c.ID_Selecao = b.ID_Selecao
                                                         and c.ID_Jogo_Selecao = a.ID_jogo_selecao
                                                         and c.ID_jogador_entrada = b.ID_Jogador
      where a.ID_Selecao_Anfitriao = @id_selecao
        and a.ID_Jogo_Selecao = @id_jogo_sel 
        and b.ID_Jogador = @id_jogador

      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes               a with(nolock)
       join tb_selecoes_elencos             b with(nolock)on b.ID_Selecao = a.ID_Selecao_Visitante
                                                         and b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
       join tb_jogos_selecoes_substituicoes c with(nolock)on c.ID_Selecao = b.ID_Selecao
                                                         and c.ID_Jogo_Selecao = a.ID_jogo_selecao
                                                         and c.ID_Jogador_Entrada = b.ID_Jogador
      where a.ID_Selecao_Visitante = @id_selecao
        and a.ID_Jogo_Selecao = @id_jogo_sel 
        and b.ID_Jogador = @id_jogador
	  )
  begin     
     if @id_evento <> 8
     begin
         set @retorno = ( 
         select concat('O jogador ''', b.Nome_Reduzido ,''' não faz parte do elenco ou não entrou durante a partida.')
           from tb_jogadores a with(nolock)
           join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
          where a.ID_Jogador = @id_jogador
	     )
          if @retorno is null 
          begin 
            set @retorno = 'Jogador informado não existe.' 
          end 
        raiserror (@retorno, 11, 127)
        rollback transaction
     end
  end

if @id_evento = 1 /* 1-Gol */
and @assist is not null
begin
  if not exists (

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes            a with(nolock)
       join tb_jogos_selecoes_anfitrioes b with(nolock)on b.ID_Selecao = a.ID_Selecao_Anfitriao
                                                      and b.ID_Jogo_Selecao = a.ID_Jogo_Selecao
      where a.ID_Jogo_Selecao = @id_jogo_sel
        and a.ID_Selecao_Anfitriao = @id_selecao
        and b.ID_Jogador = @assist
		
      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes            a with(nolock)
       join tb_jogos_selecoes_visitantes b with(nolock)on b.ID_Selecao = a.ID_Selecao_Visitante
                                                      and b.ID_Jogo_Selecao = a.ID_Jogo_Selecao
      where a.ID_Jogo_Selecao = @id_jogo_sel
        and a.ID_Selecao_Visitante = @id_selecao
        and b.ID_Jogador = @assist
	  
      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes               a with(nolock)
       join tb_selecoes_elencos             b with(nolock)on b.ID_Selecao = a.ID_Selecao_Anfitriao
                                                         and b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
       join tb_jogos_selecoes_substituicoes c with(nolock)on c.ID_Selecao = b.ID_Selecao
                                                         and c.ID_Jogo_Selecao = a.ID_jogo_selecao
                                                         and c.ID_jogador_entrada = b.ID_Jogador
      where a.ID_Selecao_Anfitriao = @id_selecao
        and a.ID_Jogo_Selecao = @id_jogo_sel 
        and c.ID_Jogador_Entrada = @assist

      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes               a with(nolock)
       join tb_selecoes_elencos             b with(nolock)on b.ID_Selecao = a.ID_Selecao_Visitante
                                                         and b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
       join tb_jogos_selecoes_substituicoes c with(nolock)on c.ID_Selecao = b.ID_Selecao
                                                         and c.ID_Jogo_Selecao = a.ID_jogo_selecao
                                                         and c.ID_Jogador_Entrada = b.ID_Jogador
      where a.ID_Selecao_Visitante = @id_selecao
        and a.ID_Jogo_Selecao = @id_jogo_sel 
        and b.ID_Jogador = @assist
	  )
  begin   
       set @retorno = ( 
    select concat('O jogador (assistência) ''', b.Nome_Reduzido ,''' não faz parte do elenco ou não entrou durante a partida.')
      from tb_jogadores a with(nolock)
      join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
     where a.ID_Jogador = @assist
	)
       if @retorno is null 
       begin 
         set @retorno = 'Jogador (assistência) informado não existe.' 
       end 
     raiserror (@retorno, 11, 127)
     rollback transaction
  end

  end

  if @min_ent_ast is not null
  and @minuto < @min_ent_ast
  begin
     set @retorno = (
         select concat('O jogador (assistência) ''', b.Nome_Reduzido , ''' entrou aos ', @min_ent_ast ,''', não é possível salvar esse tipo de evento antes do minuto informado.')
           from tb_jogadores a with(nolock)
           join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
          where a.ID_Jogador = @assist
	     )
     raiserror (@retorno, 11, 127)
     rollback transaction
  end

  if @min_sai_ast is not null
  and @minuto > @min_sai_ast
  begin
     set @retorno = (
         select concat('O jogador (assistência) ''', b.Nome_Reduzido , ''' saiu aos ', @min_sai_ast ,''', não é possível salvar esse tipo de evento após o minuto informado.')
           from tb_jogadores a with(nolock)
           join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
          where a.ID_Jogador = @assist
	     )
     raiserror (@retorno, 11, 127)
     rollback transaction  
  end

  if @minuto_ent is not null
  and @minuto < @minuto_ent
  begin
     set @retorno = (
         select concat('O jogador ''', b.Nome_Reduzido , ''' entrou aos ', @minuto_ent ,''', não é possível salvar esse tipo de evento antes do minuto informado.')
           from tb_jogadores a with(nolock)
           join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
          where a.ID_Jogador = @id_jogador
	     )
     raiserror (@retorno, 11, 127)
     rollback transaction
  end

  if @minuto_sai is not null
  and @minuto > @minuto_sai
  begin
     set @retorno = (
         select concat('O jogador ''', b.Nome_Reduzido , ''' saiu aos ', @minuto_sai ,''', não é possível salvar esse tipo de evento após o minuto informado.')
           from tb_jogadores a with(nolock)
           join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
          where a.ID_Jogador = @id_jogador
	     )
     raiserror (@retorno, 11, 127)
     rollback transaction  
  end

  if @id_evento = 8
  begin
    if @id_selecao = @id_anf
    and not exists ( 
        select a.ID_Jogador
          from tb_jogos_selecoes_visitantes  a with(nolock)
         where a.ID_Jogo_Selecao = @id_jogo_sel
           and a.ID_Jogador = @id_jogador
	)
    begin
       raiserror ('Não é possível contabilizar o gol contra, pois o jogador informado não faz parte do time adversário, .', 11, 127)
       rollback transaction
    end
    if @id_selecao = @id_vis
	and not exists ( 
        select a.ID_Jogador
          from tb_jogos_selecoes_anfitrioes  a with(nolock)
         where a.ID_Jogo_Selecao = @id_jogo_sel
           and a.ID_Jogador = @id_jogador
	)
    begin
       raiserror ('Não é possível contabilizar o gol contra, pois o jogador informado não faz parte do time adversário, .', 11, 127)
       rollback transaction
    end

  end

end

end

if (select ID_Jogo_Selecao from deleted) is null
begin
  if @minuto > 120
  or @minuto = 0
  begin
     raiserror ('Minuto informado inválido, os valores devem ser entre 1 e 120 minutos. Para ''Acréscimos'' preencher a coluna equivalente.', 11, 127)
     rollback transaction
  end

  if @minuto not in (45, 90, 105, 120)
  and @acresc is not null
  begin
     raiserror ('Só pode ter tempo de acréscimo se o minuto for 45/90/105/120.', 11, 127)
     rollback transaction
  end
	
  if  @id_selecao <> @id_anf
  and @id_selecao <> @id_vis
  begin
     raiserror ('Seleção informada não participou desta partida.', 11, 127)
     rollback transaction
  end

if @id_evento in (2, 3) /* 2-Cartão Amarelo | 3-Cartão Vermelho */
begin
   if (  select ID_Jogador 
           from tb_selecoes_elencos with(nolock)
          where ID_Campeonato_Edicao = @id_camp_ed
            and ID_Selecao = @id_selecao
            and ID_Jogador = @id_jogador
   ) is null
   begin
     raiserror ('Jogador informado não integra o elenco desta seleção.', 11, 127)
     rollback transaction
   end

end

if @assist = @id_jogador
begin
     raiserror ('Jogador que fez o gol não pode ser o mesmo que deu a assistência.', 11, 127)
     rollback transaction
end

if @id_evento <> 2
and @assist is not null
begin
     raiserror ('Assistência só pode ser vinculada com o evento [2] Gol.', 11, 127)
     rollback transaction
end
		
if @id_evento = 2  /* 2-Cartão Amarelo */
and ( 
   select count(ID_Tipo_Evento) as Evento
     from tb_jogos_selecoes_eventos with(nolock)
    where ID_jogo_selecao = @id_jogo_sel
      and ID_jogador = @id_jogador
      and ID_Tipo_Evento = @id_evento
) > 2
begin
   begin
     raiserror ('Jogador não pode receber mais de 2 cartões amarelos.', 11, 127)
     rollback transaction
   end
end

if @id_evento in (1,5,6,7,8) /* 1-Gol | 5-Gol (P) | 6-Pênalti (X) | 7-Gol Anulado | 8-Gol Contra */
begin
  if not exists (

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes            a with(nolock)
       join tb_jogos_selecoes_anfitrioes b with(nolock)on b.ID_Selecao = a.ID_Selecao_Anfitriao
                                                      and b.ID_Jogo_Selecao = a.ID_Jogo_Selecao
      where a.ID_Jogo_Selecao = @id_jogo_sel
        and a.ID_Selecao_Anfitriao = @id_selecao
        and b.ID_Jogador = @id_jogador
		
      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes            a with(nolock)
       join tb_jogos_selecoes_visitantes b with(nolock)on b.ID_Selecao = a.ID_Selecao_Visitante
                                                      and b.ID_Jogo_Selecao = a.ID_Jogo_Selecao
      where a.ID_Jogo_Selecao = @id_jogo_sel
        and a.ID_Selecao_Visitante = @id_selecao
        and b.ID_Jogador = @id_jogador
	  
      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes               a with(nolock)
       join tb_selecoes_elencos             b with(nolock)on b.ID_Selecao = a.ID_Selecao_Anfitriao
                                                         and b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
       join tb_jogos_selecoes_substituicoes c with(nolock)on c.ID_Selecao = b.ID_Selecao
                                                         and c.ID_Jogo_Selecao = a.ID_jogo_selecao
                                                         and c.ID_jogador_entrada = b.ID_Jogador
      where a.ID_Selecao_Anfitriao = @id_selecao
        and a.ID_Jogo_Selecao = @id_jogo_sel 
        and b.ID_Jogador = @id_jogador

      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes               a with(nolock)
       join tb_selecoes_elencos             b with(nolock)on b.ID_Selecao = a.ID_Selecao_Visitante
                                                         and b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
       join tb_jogos_selecoes_substituicoes c with(nolock)on c.ID_Selecao = b.ID_Selecao
                                                         and c.ID_Jogo_Selecao = a.ID_jogo_selecao
                                                         and c.ID_Jogador_Entrada = b.ID_Jogador
      where a.ID_Selecao_Visitante = @id_selecao
	and a.ID_Jogo_Selecao = @id_jogo_sel 
        and b.ID_Jogador = @id_jogador
	  )
  begin     
     if @id_evento <> 8
     begin
         set @retorno = ( 
         select concat('O jogador ''', b.Nome_Reduzido ,''' não faz parte do elenco ou não entrou durante a partida.')
           from tb_jogadores a with(nolock)
           join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
          where a.ID_Jogador = @id_jogador
	     )
          if @retorno is null 
          begin 
            set @retorno = 'Jogador informado não existe.' 
          end 
        raiserror (@retorno, 11, 127)
        rollback transaction
     end
  end

if @id_evento = 1 /* 1-Gol */
and @assist is not null
begin
  if not exists (

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes            a with(nolock)
       join tb_jogos_selecoes_anfitrioes b with(nolock)on b.ID_Selecao = a.ID_Selecao_Anfitriao
                                                      and b.ID_Jogo_Selecao = a.ID_Jogo_Selecao
      where a.ID_Jogo_Selecao = @id_jogo_sel
        and a.ID_Selecao_Anfitriao = @id_selecao
        and b.ID_Jogador = @assist
		
      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes            a with(nolock)
       join tb_jogos_selecoes_visitantes b with(nolock)on b.ID_Selecao = a.ID_Selecao_Visitante
                                                      and b.ID_Jogo_Selecao = a.ID_Jogo_Selecao
      where a.ID_Jogo_Selecao = @id_jogo_sel
        and a.ID_Selecao_Visitante = @id_selecao
        and b.ID_Jogador = @assist
	  
      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes               a with(nolock)
       join tb_selecoes_elencos             b with(nolock)on b.ID_Selecao = a.ID_Selecao_Anfitriao
                                                         and b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
       join tb_jogos_selecoes_substituicoes c with(nolock)on c.ID_Selecao = b.ID_Selecao
                                                         and c.ID_Jogo_Selecao = a.ID_jogo_selecao
                                                         and c.ID_jogador_entrada = b.ID_Jogador
      where a.ID_Selecao_Anfitriao = @id_selecao
        and a.ID_Jogo_Selecao = @id_jogo_sel 
        and c.ID_Jogador_Entrada = @assist

      union all

     select b.ID_Jogador  as qtd 
       from tb_jogos_selecoes               a with(nolock)
       join tb_selecoes_elencos             b with(nolock)on b.ID_Selecao = a.ID_Selecao_Visitante
                                                         and b.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
       join tb_jogos_selecoes_substituicoes c with(nolock)on c.ID_Selecao = b.ID_Selecao
                                                         and c.ID_Jogo_Selecao = a.ID_jogo_selecao
                                                         and c.ID_Jogador_Entrada = b.ID_Jogador
      where a.ID_Selecao_Visitante = @id_selecao
        and a.ID_Jogo_Selecao = @id_jogo_sel 
        and b.ID_Jogador = @assist
	  )
  begin   
       set @retorno = ( 
    select concat('O jogador (assistência) ''', b.Nome_Reduzido ,''' não faz parte do elenco ou não entrou durante a partida.')
      from tb_jogadores a with(nolock)
      join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
     where a.ID_Jogador = @assist
	)
       if @retorno is null 
       begin 
         set @retorno = 'Jogador (assistência) informado não existe.' 
       end 
     raiserror (@retorno, 11, 127)
     rollback transaction
  end

  if @min_ent_ast is not null
  and @minuto < @min_ent_ast
  begin
     set @retorno = (
         select concat('O jogador (assistência) ''', b.Nome_Reduzido , ''' entrou aos ', @min_ent_ast ,''', não é possível salvar esse tipo de evento antes do minuto informado.')
           from tb_jogadores a with(nolock)
           join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
          where a.ID_Jogador = @assist
	     )
     raiserror (@retorno, 11, 127)
     rollback transaction
  end

  if @min_sai_ast is not null
  and @minuto > @min_sai_ast
  begin
     set @retorno = (
         select concat('O jogador (assistência) ''', b.Nome_Reduzido , ''' saiu aos ', @min_sai_ast ,''', não é possível salvar esse tipo de evento após o minuto informado.')
           from tb_jogadores a with(nolock)
           join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
          where a.ID_Jogador = @assist
	     )
     raiserror (@retorno, 11, 127)
     rollback transaction  
  end

  end

  if @minuto_ent is not null
  and @minuto < @minuto_ent
  begin
     set @retorno = (
         select concat('O jogador ''', b.Nome_Reduzido , ''' entrou aos ', @minuto_ent ,''', não é possível salvar esse tipo de evento antes do minuto informado.')
           from tb_jogadores a with(nolock)
           join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
          where a.ID_Jogador = @id_jogador
	     )
     raiserror (@retorno, 11, 127)
     rollback transaction
  end

  if @minuto_sai is not null
  and @minuto > @minuto_sai
  begin
     set @retorno = (
         select concat('O jogador ''', b.Nome_Reduzido , ''' saiu aos ', @minuto_sai ,''', não é possível salvar esse tipo de evento após o minuto informado.')
           from tb_jogadores a with(nolock)
           join tb_pessoas   b with(nolock)on b.ID_Pessoa = a.ID_Pessoa
          where a.ID_Jogador = @id_jogador
	     )
     raiserror (@retorno, 11, 127)
     rollback transaction  
  end

  if @id_evento = 8
  begin
    if @id_selecao = @id_anf
    and not exists ( 
        select a.ID_Jogador
          from tb_jogos_selecoes_visitantes  a with(nolock)
         where a.ID_Jogo_Selecao = @id_jogo_sel
           and a.ID_Jogador = @id_jogador
	)
    begin
       raiserror ('Não é possível contabilizar o gol contra, pois o jogador informado não faz parte do time adversário, .', 11, 127)
       rollback transaction
    end
    if @id_selecao = @id_vis
    and not exists ( 
        select a.ID_Jogador
          from tb_jogos_selecoes_anfitrioes  a with(nolock)
         where a.ID_Jogo_Selecao = @id_jogo_sel
           and a.ID_Jogador = @id_jogador
	)
    begin
       raiserror ('Não é possível contabilizar o gol contra, pois o jogador informado não faz parte do time adversário, .', 11, 127)
       rollback transaction
    end

  end

end

end

end

