create trigger tr_jogos_sel_pen
            on tb_jogos_selecoes_penaltis
for insert, update 
  
as

begin

   set nocount on

    if not exists (
      select 1
        from inserted           i
        join tb_jogos_selecoes  j with(nolock)on i.ID_jogo_selecao = j.ID_jogo_selecao
       where i.ID_Selecao = j.ID_selecao_anfitriao
          or i.ID_Selecao = j.ID_selecao_visitante 
    )
    begin
        raiserror('Seleção informada não participou da partida.', 16, 1);
        rollback transaction;
        return
    end
	
    if not exists (
      select 1
        from inserted                  i
        join tb_jogos_selecoes         j with(nolock)on i.ID_jogo_selecao = j.ID_jogo_selecao
                                                    and i.ID_Selecao = j.ID_selecao_anfitriao
        join tb_selecoes_elencos       a with(nolock)on a.ID_campeonato_edicao = j.ID_campeonato_edicao
                                                    and a.ID_Selecao = i.ID_Selecao
                                                    and a.ID_Jogador = i.ID_Jogador
       union all

      select 1
        from inserted                  i
        join tb_jogos_selecoes         j with(nolock)on i.ID_jogo_selecao = j.ID_jogo_selecao
                                                    and i.ID_Selecao = j.ID_selecao_visitante
        join tb_selecoes_elencos       a with(nolock)on a.ID_campeonato_edicao = j.ID_campeonato_edicao
                                                    and a.ID_Selecao = i.ID_Selecao
                                                    and a.ID_Jogador = i.ID_Jogador

    )
    begin
        raiserror('Jogador não pertence à seleção informada.', 16, 1);
        rollback transaction;
        return
    end

    if exists (
      select 1  
        from inserted                        i
        join tb_jogos_selecoes_anfitrioes    a with(nolock)on i.ID_Jogo_Selecao = a.ID_Jogo_Selecao
                                                          and i.ID_selecao = a.ID_selecao
        join tb_jogos_selecoes_substituicoes s with(nolock)on i.ID_Jogo_Selecao = s.ID_Jogo_Selecao
                                                          and i.ID_selecao = s.ID_selecao                                                          
                                                          and i.ID_Jogador = s.ID_jogador_saida                                                         
       where i.ID_Jogador = a.ID_jogador
       
	   union all

      select 1  
        from inserted                        i
        join tb_jogos_selecoes_visitantes    a with(nolock)on i.ID_Jogo_Selecao = a.ID_Jogo_Selecao
                                                          and i.ID_selecao = a.ID_selecao
        join tb_jogos_selecoes_substituicoes s with(nolock)on i.ID_Jogo_Selecao = s.ID_Jogo_Selecao
                                                          and i.ID_selecao = s.ID_selecao                                                          
                                                          and i.ID_Jogador = s.ID_jogador_saida                                                         
       where i.ID_Jogador = a.ID_jogador
    )
    begin
        raiserror('Jogador não foi utilizado ou foi substituído durante a partida.', 16, 1);
        rollback transaction;
        return
    end

end
