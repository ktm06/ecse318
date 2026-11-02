Since the circuit is combinational, the time it takes to complete one operation is determined by the longest path through the circuit,
which we can trace through the number of gates it needs to go through.

Per the problem, we assume each gate has one unit of delay.

We can look at this cell by cell by looking at how many gates there are in one CAS:

In fa.vhd, we have the following:

cout <= (a and b) or (a and cin) or (b and cin);
sum  <= a xor b xor cin;

Both cout and sum go through two gates. Therefore, we have two units of delay per fa. We have one fa in each cas cell. So each cas cell goes through 2 units of delay.

We have four of these cells per row, so that ends up being 2 * 4 units of delay from the cas cells in one row. Additionally, in each cell, we have a xor gate (b_control <= m xor b;) which runs in parallel per row. Therefore, we add a +1 unit delay per row, to give us 8 + 1 = 9 units of delay per row. Since we have 5 of these rows, we have 9 * 5 = 45 units of delay.