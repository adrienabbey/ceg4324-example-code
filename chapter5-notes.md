# Booth Multiplier
- Before the Booth Multiplier method, binary multiplication was just like elementary multiplication: multiply each individual bit of the multiplier against the multiplicand, bit-shifting left for each, then adding the partial products together.  This becomes exponentially slower with larger values.
- The Booth Multiplier method allows for halving the time required to multiply two values.

## Booth Multiplier Table
| $y_iy_{i-1}y_{i-2}$ | increment |
|:---:|:---:|
|$000$|$0$|
|$001$|$x$|
|$010$|$x$|
|$011$|$2x$|
|$100$|$-2x$|
|$101$|$-x$|
|$110$|$-x$|
|$111$|$0$|

## Booth Multiplier Method
- The Booth Multiplier, as its name implies, is a way to multiply two signed binary numbers, $x$ and $y$.
- Start by creating 3-bit values from $y$:
	- The first 3-bit value is of the two least-significant bits of $y$ with an additional padded zero on the right.
	- The next 3-bit value bit-shifts left twice.  Thus, every 3-bit value overlaps one bit of the previous with one bit of the next.
	- This continues until all $y$ bits are used.  If necessary, add signed padded values for the last 3-bit value.
- Each of these 3-bit values is used to determine which multiplier increment to use, as per the above table.
	- Note: $x$ here is the value of $x$.
	- Multiplying in binary is simply bit-shifting the values.  Multiplying by two is as easy as bit-shifting left by one.
	- To find negative values, use 2's Complement.
- For each 3-bit value:
	- Sum the previous product (starting with zero for the first) with the product determined by the 3-bit value.
	- Repeat this for each 3-bit value.
