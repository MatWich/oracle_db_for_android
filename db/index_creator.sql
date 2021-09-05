CREATE OR REPLACE PACKAGE PKG_IND_CHECK
IS
	TYPE REC_IND_CHECK IS RECORD(
		table_name VARCHAR2(2000),
		column_name VARCHAR2(2000),
		owner VARCHAR2(50),
    index_str VARCHAR(2000),
    drop_constraints VARCHAR2(2000),
    tab_id_check VARCHAR2(2000)
	);
	TYPE TYP_ARR IS TABLE OF REC_IND_CHECK;

	FUNCTION CREATE_COMMANDS(v_user_name VARCHAR2 DEFAULT 'MAT') RETURN TYP_ARR PIPELINED;
END PKG_IND_CHECK;
/
CREATE OR REPLACE PACKAGE BODY PKG_IND_CHECK
IS
	FUNCTION CREATE_COMMANDS(v_user_name VARCHAR2 DEFAULT 'MAT') RETURN TYP_ARR
	PIPELINED
	IS
		CURSOR my_cursor IS
		SELECT a.table_name
     , a.column_name
     , a.constraint_name
     , c.owner
     , c.r_owner
     , c.constraint_type
     , c_pk.table_name      r_table_name
     , c_pk.constraint_name r_pk
     , cc_pk.column_name    r_column_name
     , c.index_name
  FROM all_cons_columns a
  JOIN all_constraints  c       ON (a.owner                 = c.owner                   AND a.constraint_name   = c.constraint_name     )
  JOIN all_constraints  c_pk    ON (c.r_owner               = c_pk.owner                AND c.r_constraint_name = c_pk.constraint_name  )
  JOIN all_cons_columns cc_pk   on (cc_pk.constraint_name   = c_pk.constraint_name      AND cc_pk.owner         = c_pk.owner            )
  WHERE c.owner LIKE v_user_name
  AND c.constraint_type IN ('R', 'F') AND c.index_name IS NULL
  AND (a.table_name, a.column_name, c.owner) NOT IN ( SELECT table_name, column_name, table_owner AS owner FROM ALL_IND_COLUMNS)
  ORDER BY a.table_name;

  v_val REC_IND_CHECK;
  v_max_id VARCHAR2(1000);
  v_table_space VARCHAR2(100);
  v_constraint VARCHAR2(30);
  v_check_constraint_name VARCHAR2(100);
  v_check_value VARCHAR2(100);
  v_check_purpose VARCHAR(4000); -- 'not null' or sth else
  v_check_long_type LONG;


	BEGIN
		FOR tab_name_rec IN my_cursor LOOP
    v_val.table_name := tab_name_rec.table_name;
    v_val.column_name := tab_name_rec.column_name;
    v_val.owner := tab_name_rec.owner;
    SELECT Max(id)
    INTO v_max_id FROM tablice WHERE full_name=v_val.table_name;

    -- table space
    SELECT tablespace_name
    INTO v_table_space
    FROM all_tables
    WHERE owner = v_val.owner AND table_name = v_val.table_name;

    -- might be just only one eg not null check 
    SELECT search_condition
    INTO v_check_long_type
    FROM ALL_CONSTRAINTS a
    JOIN USER_CONS_COLUMNS c ON (a.OWNER = c.OWNER AND a.CONSTRAINT_NAME = c.CONSTRAINT_NAME)
    WHERE constraint_type = 'C' AND c.table_name = v_val.table_name AND c.column_name = v_val.column_name;

    v_constraint := tab_name_rec.constraint_name;
    
    -- creating index
    v_val.index_str := 'CREATE OR REPLACE INDEX ' ||v_val.owner || '.' || v_max_id ||'' || REPLACE(v_val.column_name, 'FK', '') || '_I' || ' ON ' || v_val.owner || '.' || v_val.table_name || '(' || v_val.column_name || ') LOGGING TABLESPACE ' || v_table_space || ' NOPARALLEL' || Chr(10) || '/';
    -- create a drop constraint
    IF v_constraint LIKE '%FK' THEN 
       v_val.drop_constraints := 'ALTER TABLE ' || v_val.owner || '.' || v_val.table_name || ' DROP CONSTRAINT ' || v_constraint || Chr(10) || '/';
    END IF;
    -- create a check constraint 
    v_check_constraint_name := SubStr(v_constraint, 1, length(v_constraint)-3) || '_CK';

    -- nwm dlaczego jak widzi _CHECK to tez daje nulla ale to dobrze
    --IF v_check_constraint_name NOT LIKE '%CK' OR v_check_constraint_name NOT LIKE '%CHECK' OR v_check_constraint_name NOT LIKE '%CHK' OR v_check_constraint_name NOT LIKE '%CH' THEN
      v_check_purpose := SubStr(v_check_long_type, 1, 3999);
     IF Upper(v_check_purpose) NOT LIKE '%NOT NULL%' OR v_check_purpose IS NULL THEN
        v_val.tab_id_check := 'ALTER TABLE ' || v_val.owner || '.' || v_val.table_name || ' ADD CONSTRAINT ' || v_check_constraint_name || ' CHECK (' || v_val.column_name || ' IN (''' || v_max_id ||'''))' || Chr(10) || '/';
    ELSE                                        
      v_val.tab_id_check := null;
    END IF;
    
    PIPE ROW(v_val);
		END LOOP;
		RETURN;     -- "Returns nothing but controll "
	END CREATE_COMMANDS;
END;
/

desc all_cons_columns;
desc all_constraints;

select * FROM TABLE(PKG_IND_CHECK.CREATE_COMMANDS('MAT'));
    