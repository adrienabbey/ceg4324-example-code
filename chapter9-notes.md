# Fixed-Point Numbers (Addition/Multiplication)

## Integers
- Integers are typically 8-, 16-, 32-, or 64-bits long.
- $20=16+4=(0001\,0100)_2$ : 8-bits
- $20=16+4=(0000\,0000\,0001\,0100)_2$ : 16-bits
- Use 2's Complement format for negative numbers
	- $20=(0001\,0100)_2$
	- $-20=(1110\,1100)_2$ : 8-bits
	- $-20=(1111\,1111\,1110\,1100)_2$ : 16-bits

### Integers in Registers
- Registers may be smaller than required.  For example, storing a 16-bit integer in 8-bit registers requires splitting the integer between registers.
- $20=(0001\,0100)_2$
	- As an 8-bit integer in register $(\text{r1})$:
		- $\text{r1}=20=(0001\,0100)_2$
	- As a 16-bit integer in two registers $(\text{r1}\,\text{r2})$
		- $\text{r1}=0=(0000\,0000)_2$
		- $\text{r2}=20=(0001\,0100)_2$
		- $(\text{r1 r2})=(0000\,0000\,0001\,0100)_2$

## Fixed-Point Numbers
- Fixed-Point Numbers are generally stored in $\text In.\text Qm$ format.  This is sometimes referred to as $\text Qn.m$ format.
	- $n=$ the number of integer bits
	- $m=$ the number of fractional bits
- Example: $\text I8.\text Q16$:
$$00101110.1101000000000000$$
$$=32+8+4+2+\frac 1 2+\frac 1 4+\frac 1 {16}$$
$$=46.8125$$

### Signed Fixed-Point Numbers
- Positive fixed-point numbers are the same as unsigned fixed-point numbers.
- Negative fixed-point numbers are obtained by simply calculating the 2's complement as if they were integers.

$$\begin{align}
\text I8.\text Q8: 01000110.11000000&=70.75 \\
\text{2's Complement}: 10111001.01000000&=-70.75
\end{align}$$

### Fixed-Point Addition
- Fixed-point addition is the same as integer addition.
- Align two fixed-point numbers and apply integer addition.

### Unsigned Fixed-Point Multiplication
- Unsigned fixed-point multiplication is similar to integer multiplication.

### Signed Fixed-Point Multiplication
- Use 2's complement format for fixed-point numbers.
- $(\text Ia.\text Qb)\cdot(\text Ic.\text Qd)=\text I(a+c-1).\text Q(b+d+1)$
- Take the 2's complement of the last partial product if the multiplier is negative.

```text
   1.10 = I1.Q2 = -0.5
x  0.10 = I1.Q2 =  0.5
--------
  00000
  1110
+ 000
-------- = I1.Q5
  111000 = 1.11000 = -0.25
```

- NOTE: There is sign-extention padding on the first two product sums!  This is necessary due to the values being signed!
- NOTE: The final sum is also padded once on the right!  Multiplying signed fixed-point numbers changes the fixed-point numbers, which must be preserved!

```text
   11.01 = I2.Q2 = -0.75
x  1.101 = I1.Q3 = -0.375
-----------
   1111101
   000000
   11101
+  0011
-----------
   00010010 = I2.Q6 = 00.010010 = 0.28125
```