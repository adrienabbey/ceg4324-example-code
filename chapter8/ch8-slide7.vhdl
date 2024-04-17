FUNCTION to_integer (bin : BIT_VECTOR) RETURN INTEGER IS
    VARIABLE result : INTEGER;
BEGIN
    result := 0;
    FOR i IN bin'RANGE LOOP
        IF bin(i) = '1' THEN
            result := result + 2 ** i;
        END IF;
    END LOOP;
    RETURN result;
END to_integer;