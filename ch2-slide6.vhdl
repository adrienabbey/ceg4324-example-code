-- Chapter 2, Slide 6

ARCHITECTURE structure OF fulladder IS
    COMPONENT halfadder
        PORT (
            A, B : IN BIT;
            S, C : OUT BIT);
    END COMPONENT;
    COMPONENT or2
        PORT (
            A, B : IN BIT;
            C : OUT BIT);
    END COMPONENT;
    SIGNAL s1, s2, s3 : BIT;
BEGIN
    ha1 : halfadder PORT MAP(A, B, s1, s2);
    o1 : or2 PORT MAP(s2, s3, COUT);
    ha2 : halfadder PORT MAP(CIN, s1, SUM, s3);
END structure;