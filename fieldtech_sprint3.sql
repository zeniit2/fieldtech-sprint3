-- =====================================================================
--  FIELDTECH ENGINEERING CHALLENGE - SPRINT 3
--  SQL aplicado ao Challenge MOTIVA / CCR
--  Robô cortador de grama autônomo para a faixa de domínio das rodovias
-- ---------------------------------------------------------------------
--  Banco: PostgreSQL
--  Execução (cria as tabelas, carrega os dados e roda as 5 consultas):
--      psql -U postgres -d fieldtech -f fieldtech_sprint3.sql
-- =====================================================================


-- =====================================================================
--  1. ESTRUTURA DO BANCO (duas tabelas relacionadas 1:N)
-- =====================================================================

DROP TABLE IF EXISTS operacao_corte;
DROP TABLE IF EXISTS trecho;

-- Trechos de rodovia sob concessão em que o robô faz a roçada da faixa.
CREATE TABLE trecho (
    id_trecho               INTEGER       PRIMARY KEY,
    rodovia                 VARCHAR(40)   NOT NULL,   -- ex.: SP-330 Anhanguera
    km_inicial              NUMERIC(6,1)  NOT NULL,
    km_final                NUMERIC(6,1)  NOT NULL,
    sentido                 VARCHAR(10)   NOT NULL,
    tipo_terreno            VARCHAR(10)   NOT NULL,   -- plano / ondulado / inclinado
    inclinacao_media_graus  NUMERIC(4,1)  NOT NULL,
    area_m2                 INTEGER       NOT NULL    -- área da faixa a roçar (3 m de largura)
);

-- Cada operação de corte executada pelo robô em um trecho.
-- Um trecho tem várias operações (chave estrangeira id_trecho).
CREATE TABLE operacao_corte (
    id_operacao           INTEGER       PRIMARY KEY,
    id_trecho             INTEGER       NOT NULL REFERENCES trecho (id_trecho),
    data_operacao         DATE          NOT NULL,
    duracao_min           INTEGER       NOT NULL,
    area_cortada_m2       INTEGER       NOT NULL,
    bateria_inicial_pct   INTEGER       NOT NULL,
    bateria_final_pct     INTEGER       NOT NULL,
    temp_max_motor_c      NUMERIC(4,1)  NOT NULL,   -- temperatura máxima do motor de corte
    umidade_grama_pct     INTEGER       NOT NULL,
    velocidade_media_kmh  NUMERIC(4,2)  NOT NULL,
    status_operacao       VARCHAR(10)   NOT NULL    -- normal / atencao / critico
);


-- =====================================================================
--  2. CARGA DOS DADOS
--  (os mesmos registros estão em dados/trechos.csv e dados/operacoes.csv)
-- =====================================================================

INSERT INTO trecho (id_trecho, rodovia, km_inicial, km_final, sentido, tipo_terreno, inclinacao_media_graus, area_m2) VALUES
  (1, 'SP-330 Anhanguera', 32, 33.5, 'Norte', 'plano', 3, 4500),
  (2, 'SP-330 Anhanguera', 58, 59, 'Sul', 'ondulado', 8.5, 3000),
  (3, 'SP-348 Bandeirantes', 45, 46.2, 'Norte', 'plano', 2.5, 3600),
  (4, 'SP-348 Bandeirantes', 71, 72, 'Sul', 'inclinado', 14, 3000),
  (5, 'SP-280 Castello Branco', 24, 25.5, 'Oeste', 'ondulado', 9, 4500),
  (6, 'SP-280 Castello Branco', 88, 88.8, 'Leste', 'inclinado', 17, 2400),
  (7, 'BR-116 Via Dutra', 210, 211.4, 'Norte', 'plano', 4, 4200),
  (8, 'BR-116 Via Dutra', 163, 164, 'Sul', 'inclinado', 15.5, 3000);

INSERT INTO operacao_corte (id_operacao, id_trecho, data_operacao, duracao_min, area_cortada_m2, bateria_inicial_pct, bateria_final_pct, temp_max_motor_c, umidade_grama_pct, velocidade_media_kmh, status_operacao) VALUES
  (1, 1, '2026-08-03', 63, 846, 88, 68, 50.1, 62, 0.89, 'normal'),
  (2, 2, '2026-08-04', 73, 754, 100, 70, 65.6, 58, 0.68, 'atencao'),
  (3, 3, '2026-08-05', 110, 1474, 95, 60, 52.9, 66, 0.88, 'normal'),
  (4, 4, '2026-08-06', 83, 705, 96, 52, 73.8, 60, 0.56, 'critico'),
  (5, 5, '2026-08-07', 115, 1116, 89, 46, 69.5, 79, 0.64, 'atencao'),
  (6, 6, '2026-08-08', 107, 740, 93, 35, 82.5, 88, 0.46, 'critico'),
  (7, 7, '2026-08-10', 116, 1377, 96, 59, 58, 90, 0.78, 'atencao'),
  (8, 1, '2026-08-11', 104, 1396, 89, 58, 57.3, 55, 0.89, 'atencao'),
  (9, 3, '2026-08-12', 107, 1456, 90, 54, 54.4, 65, 0.9, 'normal'),
  (10, 8, '2026-08-13', 98, 758, 90, 44, 82.6, 63, 0.51, 'critico'),
  (11, 2, '2026-08-14', 79, 818, 89, 56, 61.4, 88, 0.68, 'atencao'),
  (12, 5, '2026-08-17', 119, 1286, 92, 48, 69.7, 67, 0.71, 'atencao'),
  (13, 4, '2026-08-18', 81, 674, 96, 54, 77.7, 56, 0.55, 'critico'),
  (14, 1, '2026-08-19', 79, 1094, 93, 67, 53.2, 60, 0.91, 'normal'),
  (15, 3, '2026-08-20', 103, 1363, 90, 57, 55.3, 69, 0.87, 'normal'),
  (16, 6, '2026-08-20', 93, 602, 94, 50, 83.3, 88, 0.43, 'critico'),
  (17, 7, '2026-08-21', 104, 1308, 100, 66, 55.7, 81, 0.83, 'normal'),
  (18, 2, '2026-08-25', 115, 1150, 95, 52, 68.4, 89, 0.66, 'atencao'),
  (19, 8, '2026-08-26', 64, 460, 100, 69, 75.3, 68, 0.47, 'critico'),
  (20, 1, '2026-08-27', 82, 1125, 92, 68, 51, 57, 0.91, 'normal'),
  (21, 3, '2026-08-28', 71, 895, 96, 75, 49.6, 81, 0.83, 'normal'),
  (22, 5, '2026-08-29', 84, 793, 95, 63, 63.8, 90, 0.62, 'atencao'),
  (23, 4, '2026-09-01', 112, 831, 90, 38, 78.5, 62, 0.49, 'critico'),
  (24, 7, '2026-09-02', 90, 1196, 91, 62, 53.7, 80, 0.88, 'normal'),
  (25, 1, '2026-09-04', 103, 1368, 100, 69, 54.2, 74, 0.88, 'normal'),
  (26, 2, '2026-09-05', 60, 640, 93, 68, 62.6, 69, 0.7, 'atencao'),
  (27, 3, '2026-09-06', 114, 1481, 88, 53, 56.5, 73, 0.86, 'atencao'),
  (28, 5, '2026-09-08', 61, 613, 94, 68, 62.1, 83, 0.66, 'atencao'),
  (29, 4, '2026-09-10', 107, 774, 89, 33, 80.8, 66, 0.48, 'critico'),
  (30, 7, '2026-09-11', 95, 1193, 88, 60, 54.9, 75, 0.83, 'normal'),
  (31, 1, '2026-09-12', 112, 1491, 89, 51, 52.7, 61, 0.88, 'normal'),
  (32, 2, '2026-09-15', 110, 1093, 94, 48, 66.4, 72, 0.66, 'atencao'),
  (33, 3, '2026-09-16', 111, 1458, 98, 62, 55.6, 80, 0.87, 'normal'),
  (34, 7, '2026-09-17', 79, 1079, 95, 71, 55.6, 55, 0.9, 'normal'),
  (35, 5, '2026-09-18', 105, 1132, 93, 52, 65, 63, 0.71, 'atencao');


-- =====================================================================
--  3. CONSULTAS
-- =====================================================================

-- ---------------------------------------------------------------------
-- CONSULTA 1
-- Pergunta: Em quais trechos o robô rende menos (menor produtividade
--           média, em m² cortados por minuto)?
-- Conceitos: JOIN, AVG, COUNT, GROUP BY, ORDER BY, LIMIT
-- ---------------------------------------------------------------------
SELECT t.rodovia,
       t.km_inicial,
       t.km_final,
       t.tipo_terreno,
       COUNT(o.id_operacao)                                        AS operacoes,
       ROUND(AVG(o.area_cortada_m2::numeric / o.duracao_min), 1)   AS produtividade_m2_min
FROM operacao_corte o
JOIN trecho t ON t.id_trecho = o.id_trecho
GROUP BY t.id_trecho, t.rodovia, t.km_inicial, t.km_final, t.tipo_terreno
ORDER BY produtividade_m2_min
LIMIT 3;

-- ---------------------------------------------------------------------
-- CONSULTA 2
-- Pergunta: Em quais trechos o robô teve operações críticas
--           (superaquecimento ou bateria no limite), quantas foram e
--           qual a temperatura máxima registrada?
-- Conceitos: JOIN, WHERE, COUNT, MAX, MIN, GROUP BY, ORDER BY
-- ---------------------------------------------------------------------
SELECT t.rodovia,
       t.km_inicial,
       t.km_final,
       t.inclinacao_media_graus,
       COUNT(o.id_operacao)      AS operacoes_criticas,
       MAX(o.temp_max_motor_c)   AS temp_maxima_c,
       MIN(o.bateria_final_pct)  AS menor_bateria_final_pct
FROM operacao_corte o
JOIN trecho t ON t.id_trecho = o.id_trecho
WHERE o.status_operacao = 'critico'
GROUP BY t.id_trecho, t.rodovia, t.km_inicial, t.km_final, t.inclinacao_media_graus
ORDER BY operacoes_criticas DESC, temp_maxima_c DESC;

-- ---------------------------------------------------------------------
-- CONSULTA 3
-- Pergunta: Quanta área o robô cortou em cada rodovia em setembro de
--           2026 e quantas horas de operação isso exigiu?
-- Conceitos: JOIN, WHERE (intervalo de datas), SUM, COUNT, GROUP BY, ORDER BY
-- ---------------------------------------------------------------------
SELECT t.rodovia,
       COUNT(o.id_operacao)                  AS operacoes,
       SUM(o.area_cortada_m2)                AS area_cortada_m2,
       SUM(o.duracao_min)                    AS tempo_total_min,
       ROUND(SUM(o.duracao_min) / 60.0, 1)   AS tempo_total_h
FROM operacao_corte o
JOIN trecho t ON t.id_trecho = o.id_trecho
WHERE o.data_operacao BETWEEN DATE '2026-09-01' AND DATE '2026-09-30'
GROUP BY t.rodovia
ORDER BY area_cortada_m2 DESC;

-- ---------------------------------------------------------------------
-- CONSULTA 4
-- Pergunta: Quais trechos estão há mais tempo sem corte e devem entrar
--           primeiro na próxima programação do robô?
--           (data de referência: 21/09/2026)
-- Conceitos: JOIN, MAX, GROUP BY, ORDER BY, LIMIT
-- ---------------------------------------------------------------------
SELECT t.rodovia,
       t.km_inicial,
       t.km_final,
       t.tipo_terreno,
       MAX(o.data_operacao)                       AS ultimo_corte,
       DATE '2026-09-21' - MAX(o.data_operacao)   AS dias_sem_corte
FROM trecho t
JOIN operacao_corte o ON o.id_trecho = t.id_trecho
GROUP BY t.id_trecho, t.rodovia, t.km_inicial, t.km_final, t.tipo_terreno
ORDER BY dias_sem_corte DESC
LIMIT 5;

-- ---------------------------------------------------------------------
-- CONSULTA 5
-- Pergunta: Quanto de bateria o robô gasta em cada tipo de terreno?
--           Uma carga é suficiente para uma operação completa?
-- Conceitos: JOIN, AVG, MIN, COUNT, GROUP BY, ORDER BY
-- ---------------------------------------------------------------------
SELECT t.tipo_terreno,
       COUNT(o.id_operacao)                                                          AS operacoes,
       ROUND(AVG(o.duracao_min), 0)                                                  AS duracao_media_min,
       ROUND(AVG(o.bateria_inicial_pct - o.bateria_final_pct), 1)                    AS consumo_medio_pct,
       ROUND(AVG((o.bateria_inicial_pct - o.bateria_final_pct) * 60.0 / o.duracao_min), 1) AS consumo_pct_por_hora,
       MIN(o.bateria_final_pct)                                                      AS menor_bateria_final_pct
FROM operacao_corte o
JOIN trecho t ON t.id_trecho = o.id_trecho
GROUP BY t.tipo_terreno
ORDER BY consumo_pct_por_hora DESC;
