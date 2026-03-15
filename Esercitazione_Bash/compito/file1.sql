SELECT 
    s.settore_descrizione AS Settore,
    r.anno,
    -- Calcolo Medie per Genere (Pivoting)
    AVG(CASE WHEN r.genere = 'M' THEN r.valore_retribuzione END) AS Wage_M,
    AVG(CASE WHEN r.genere = 'F' THEN r.valore_retribuzione END) AS Wage_F,
    -- Calcolo Difensivo del Gender Pay Gap %
    (AVG(CASE WHEN r.genere = 'M' THEN r.valore_retribuzione END) - 
     AVG(CASE WHEN r.genere = 'F' THEN r.valore_retribuzione END)) / 
     NULLIF(AVG(CASE WHEN r.genere = 'M' THEN r.valore_retribuzione END), 0) * 100 AS Pay_Gap_Pct,
    -- Career Leak (Gap tra base e leadership)
    (d.donne_totale_pct - d.donne_cda_pct) AS Career_Leak_Index
FROM fact_retribuzioni r
JOIN dim_settori s ON r.cod_ateco = s.cod_ateco
JOIN fact_dnf_aziende d ON s.settore_id = d.settore_id AND r.anno = d.anno_rif
GROUP BY 1, 2
HAVING Pay_Gap_Pct IS NOT NULL
ORDER BY 5 DESC;