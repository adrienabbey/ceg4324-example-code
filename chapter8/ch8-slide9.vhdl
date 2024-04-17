PROCEDURE add_unsigned (
    in1, in2 : IN bit_vector(7 DOWNTO 0);
    sum : OUT bit_vector(7 DOWNTO 0);
    Cout : OUT BOOLEAN) IS

    VARIABLE sum_tmp : bit_vector(7 DOWNTO 0);
    VARIABLE carry : BIT := '0';

BEGIN
    FOR i IN sum_tmp'reverse_range LOOP -- This reverses the range (0 to 7)
        sum_tmp(i) := in1(i) XOR in2(i) XOR carry;
        carry := (in1(i) AND in2(i))
            OR (carry AND (in1(i))
            OR (carry AND (in2(i))));
    END LOOP;

    sum := sum_tmp;
    Cout := carry = '1'; -- This is a TRUE/FALSE statement.
END PROCEDURE add_unsigned;