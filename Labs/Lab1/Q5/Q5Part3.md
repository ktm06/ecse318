Since the operations is sequential, we consider both the setup/hold times of the flip flops as well as the propagation delay of the logic gates. Specifically, we consider the longest logical path to find what the worst case delay is.

There are two logical components that contribute to propagation delay in our implementation of the divider

assign R_N = (count == 1) ? R : {R[N-1:0], D[N-1]}; // Mux 
The delay for a 2-to-1 MUX in the datapath is 2 gate delays.

assign sum = control ? (R_N - Mwide) : (R_N + Mwide); // fa
The delay of a 5 bit full adder is the delay of a normal full adder x 5 maximum carries. since each full adder is 2 gates (as shown in Q4), we can say that the propagation delay is 2 * 5 = 10. 

Add onto the setup time of 0.5 units, we have a total time to complete one cycle of 2 + 10 + 0.5 = 12.5. 

Since we need 4 cycles to complete a division, we get a total time to complete one operation of 12.5 * 5 = 62.5.