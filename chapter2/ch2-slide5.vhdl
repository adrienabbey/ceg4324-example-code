-- Chapter 2, Slide 5

ARCHITECTURE structure OF fulladder IS
    COMPONENT xor2 PORT (A, B : IN BIT;
        C : OUT BIT);
    END COMPONENT;
    COMPONENT or2 PORT (A, B : IN BIT;
        C : OUT BIT);
    END COMPONENT;
    COMPONENT and2 PORT (A, B : IN BIT;
        C : OUT BIT);
    END COMPONENT;
    SIGNAL s1, s2, s3, s4, s5 : BIT;
BEGIN
    x1 : xor2 PORT MAP(A, B, s1);
    x2 : xor2 PORT MAP(s1, CIN, SUM);
    a1 : and2 PORT MAP(A, B, s2);
    a2 : and2 PORT MAP(B, CIN, s3);
    a3 : and2 PORT MAP(A, CIN, s4);
    o1 : or2 PORT MAP(s2, s3, s5);
    o2 : or2 PORT MAP(s4, s5, COUT);
END structure;