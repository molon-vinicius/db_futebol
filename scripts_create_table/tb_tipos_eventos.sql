CREATE TABLE tb_tipos_eventos
(ID_Tipo_Evento INT IDENTITY(1,1) PRIMARY KEY NOT NULL
,Descricao VARCHAR(30) NOT NULL)

GO

INSERT INTO tb_tipos_eventos
           (Descricao)
    VALUES (Gol)
          ,(Cartão Amarelo)
          ,(Cartão Vermelho)
          ,(Gol Olímpico)
          ,(Gol (P))
          ,(Pênalti (X))
          ,(Gol Anulado)
          ,(Gol Contra)
          ,(Gol de Falta)

