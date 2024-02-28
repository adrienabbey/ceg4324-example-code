IF k = 0 THEN
    var1 := a + 1;
ELSIF k = 1 THEN
    var2 := b + a;
ELSE
    var1 := '0';
    var2 := '0';
END IF;

IF ((clk'event) AND (clk = '1')) THEN
    q1 <= d1;
    q2 <= d2;
END IF;