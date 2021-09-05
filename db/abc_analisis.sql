CREATE OR REPLACE FUNCTION abc_analisis ( v_prod_id IN NUMBER, v_row_no IN NUMBER, v_a_grade IN NUMBER DEFAULT 0.8, v_b_grade IN NUMBER DEFAULT 0.95) RETURN CHAR
IS 
    v_margin NUMBER;
    v_result CHAR(1);
    v_to_compare NUMBER := 0;
    v_total_margin NUMBER;
BEGIN
    -- get total margin
    SELECT SUM(ac.price - pr.worth)
    INTO v_total_margin
    FROM auctions ac
    INNER JOIN products pr ON ac.product_id = pr.id;
    
    -- get margin
    SELECT SUM(ac.price - pr.worth)
    INTO v_margin
    FROM auctions ac
    INNER JOIN products pr ON ac.product_id = pr.id
    WHERE ac.product_id = v_prod_id;
    
    -- every margin before v_row_no
    SELECT SUM(margin)
    INTO v_to_compare 
    FROM (
        SELECT ac.product_id, SUM(ac.price - pr.worth) margin
        FROM auctions ac
        INNER JOIN products pr ON ac.product_id = pr.id
        GROUP BY ac.product_id
        ORDER BY margin DESC
    ) WHERE ROWNUM <= v_row_no;

    v_to_compare := v_to_compare / v_total_margin;
    v_to_compare := ROUND(v_to_compare, 2);
    
    IF(v_to_compare < v_a_grade) THEN
        v_result := 'A';
    ELSIF (v_to_compare < v_b_grade) THEN
        v_result := 'B';
    ELSE
        v_result := 'C';
    END IF;
    
    RETURN v_result;

END abc_analisis;
/

select * FROM auctions;
select * from products;
INSERT INTO auctions (id, price, amount, seller_id, product_id, tab_id) VALUES (auctions_seq.nextval, 1, 5, 13, 6, 'AUC');

SELECT product_id, margin, abc_analisis(product_id, CAST(ROWNUM AS NUMBER), 0.2, 0.4) ABC, CAST(ROWNUM AS NUMBER(10)) AS ROW_NUM, SYSDATE
FROM (
    SELECT ac.product_id product_id, SUM(ac.price - pr.worth) as margin 
    FROM auctions ac
    INNER JOIN products pr ON ac.product_id = pr.id
    GROUP BY ac.product_id
    ORDER BY margin desc
);