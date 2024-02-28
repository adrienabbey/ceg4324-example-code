half_add : PROCESS IS
BEGIN
    sum <= a XOR b AFTER T_pd;
    carry <= a AND b AFTER T_pd;
    WAIT ON a, b;
END PROCESS;

half_add : PROCESS (a, b) IS
BEGIN
    sum <= a XOR b AFTER T_pd;
    carry <= a AND b AFTER T_pd;
    -- wait on a,b is NOT needed
END PROCESS;