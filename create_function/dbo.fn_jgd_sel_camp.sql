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
                    select b.ID_Jogador
                         , d.Nome_Selecao
                         , c.Ano
                         , c.Campeonato
                      from tb_campeonatos_edicoes_selecoes_part  a with(nolock)
                      join tb_selecoes_elencos                   b with(nolock)on b.ID_Selecao = a.ID_Selecao
                                                                              and b.ID_campeonato_edicao = a.ID_campeonato_edicao
                      join vw_campeonatos                        c with(nolock)on c.ID_Campeonato_Edicao = a.ID_Campeonato_Edicao
                      join tb_selecoes                           d with(nolock)on d.ID_Selecao = a.ID_selecao
                     where b.ID_Jogador = @id_jogador
                  group by b.ID_Jogador
                         , d.Nome_Selecao
                         , c.Ano
                         , c.Campeonato  

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

