create or alter function dbo.fn_jgd_sel_camp  
(@ID_Jogador int
,@Camp varchar(100))
returns varchar(200)  

begin  

declare @retorno varchar(200) = ''
declare @sel varchar(80) = ''
declare @ano int
declare @selecoes table
       (ID_Jogador int
       ,Nome_Selecao varchar(120)
       ,Ano int
       ,Campeonato varchar(100))

               insert into @selecoes (ID_Jogador, Nome_Selecao, Ano, Campeonato)
               select distinct
                      b.ID_Jogador
                    , d.Nome_Selecao
                    , c.Ano
                    , c.Campeonato
                 from tb_jogos_selecoes            a with(nolock)
                 join tb_jogos_selecoes_anfitrioes b with(nolock)on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
                 join vw_campeonatos               c with(nolock)on c.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
                 join tb_selecoes                  d with(nolock)on d.ID_Selecao = b.ID_Selecao  
                where ID_Jogador = @id_jogador

                union 

               select distinct
                      b.ID_Jogador
                    , d.Nome_Selecao
                    , c.Ano
                    , c.Campeonato
                 from tb_jogos_selecoes            a with(nolock)
                 join tb_jogos_selecoes_visitantes b with(nolock)on a.ID_Jogo_Selecao = b.ID_Jogo_Selecao
                 join vw_campeonatos               c with(nolock)on c.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
                 join tb_selecoes                  d with(nolock)on d.ID_Selecao = b.ID_Selecao  
                where ID_Jogador = @id_jogador

declare @aux char(1)

if exists (select Campeonato from @selecoes where Campeonato = @camp)
begin
  set @aux = 'S'
end
else
begin
  set @aux = 'N'
end

if (select count(distinct Nome_Selecao) from @selecoes) > 1
begin

   while (select count(Nome_Selecao) as qtd from @selecoes) > 0
   begin

          select @ano = min(Ano) from @selecoes where Campeonato = @camp
	
             set @retorno = @retorno + (select concat(Ano, ' ', Nome_Selecao, ' ' ) from @selecoes where Ano = @ano and Campeonato = @camp)

	  delete from @selecoes where Ano = @ano
   end
   
     set @retorno = rtrim(@retorno)
     
end
	
else
begin

   set @sel = (select distinct Nome_Selecao from @selecoes) 

   while (select count(Ano) as qtd from @selecoes where Campeonato = @camp) > 0
   begin
      
	  select @ano = min(Ano) from @selecoes where Campeonato = @camp

	     set @retorno = @retorno + (select concat(Ano, '/') from @selecoes where Ano = @ano and Campeonato = @camp)
		 
	  delete from @selecoes where Ano = @ano and Campeonato = @camp

   end
   
   if @aux = 'N' 
   begin
     set @retorno = null
   end
   else
   begin
      set @retorno = substring(@retorno,0,len(@retorno)) + ' ' + @sel
   end
   
end
   return @retorno           
end  
