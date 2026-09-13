Since the circuit is combinational, the time it takes to complete one operation is determined by the longest path through the circuit,
which we can trace through the number of gates it needs to go through.

Per the problem, we assume each gate has a one unit of delay

We can look at this cell by cell by looking at how many gates there are in one CAS:

In fa.v, we have the following:

assign cout = (a &b ) | (a & cin) | (b & cin);
assign sum = a ^ b ^ cin;

Both cout and sum go through two gates. Therefore, we have two units of delay per fa. We have one fa in each cas cell and nothing else. So each cas cell goes through 4 units of delay.

We have four of these 4 cells per row, so that ends of being 2 * 4 units of delay from the cas cells in one row. Additionally, in each cell, we have a xor gate (assign b_control = m ^ b;) which runs in parallel per row. Therefore, we add a +1 unit delay per row, to give us 8 + 1 = 9 units of delay per row. Since we have 5 of these rows, we have 9 * 5 = 45 units of delay. 