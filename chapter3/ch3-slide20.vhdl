-- Example 1:
sum := 0;

L1 : FOR i IN 1 TO N LOOP
    sum := sum + 1;
END LOOP;

-- Example 2:
j := 0;
sum := 10;

WHILE j < 20 LOOP
    sum := sum * 2;
    j := j + 1;
END LOOP;

-- Example 3:
j := 0;
sum := 1;

L2 : LOOP
    sum := sum * 10;
    j := j + 1;
    EXIT L2 WHEN sum > 100;
END LOOP;