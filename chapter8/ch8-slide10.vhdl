PROCEDURE add_unsigned (
    in1, in2 : IN BIT_VECTOR(7 DOWNTO 0);
    sum : OUT BIT_VECTOR(7 DOWNTO 0);
    Cout : OUT BIT) IS -- This is a BIT now

    VARIABLE sum_tmp : BIT_VECTOR(7 DOWNTO 0);
    VARIABLE carry : BIT := '0';

BEGIN
    FOR i IN sum_tmp'reverse_range LOOP
        sum_tmp(i) := in1(i) XOR in2(i) XOR carry;
        carry := (in1(i) AND in2(i))
            OR (carry AND (in1(i)))
            OR (carry AND (in2(i)));
    END LOOP;

    sum := sum_tmp;
    Cout := carry; -- Now just a BIT
END PROCEDURE add_unsigned;