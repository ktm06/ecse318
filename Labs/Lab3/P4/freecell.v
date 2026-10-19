module freecellPlayer(clock,source,dest,win);  
input clock;
input [3:0] source, dest;
output reg win;

reg [5:0] tableau[0:7][0:19];
reg [4:0] column_count[0:7];
reg [5:0] freecells[0:3];
reg [3:0] freecell_card;
reg [5:0] homecells[0:3][12:0];
reg [3:0] home_count[0:3];
integer i, j;

task load_column(input [2:0] c, input [41:0] cards);
    integer k;
    for (k = 0; k < 7; k = k + 1)
        tableau[c][k] = cards[41 - 6*k -: 6];
endtask

initial begin
	for (i = 0; i < 8; i = i + 1)
		for (j = 0; j < 20; j = j + 1)
			tableau[i][j] = 6'd0;
	load_column(0, {6'b100100, 6'b011011, 6'b011010, 6'b010110, 6'b100011, 6'b010001, 6'b000001});
	load_column(1, {6'b100101, 6'b101010, 6'b001000, 6'b110100, 6'b000110, 6'b001101, 6'b000010});
	load_column(2, {6'b101011, 6'b110111, 6'b111001, 6'b110110, 6'b110010, 6'b101101, 6'b110001});
	load_column(3, {6'b000100, 6'b100001, 6'b111100, 6'b110101, 6'b100111, 6'b001001, 6'b101000});
	load_column(4, {6'b011100, 6'b001011, 6'b101100, 6'b100110, 6'b010010, 6'b101001, 6'b000000});
	load_column(5, {6'b010101, 6'b011101, 6'b110011, 6'b011001, 6'b000011, 6'b100010, 6'b000000});
	load_column(6, {6'b000101, 6'b010011, 6'b001100, 6'b010111, 6'b111101, 6'b111010, 6'b000000});
	load_column(7, {6'b111011, 6'b010100, 6'b001010, 6'b111000, 6'b000111, 6'b011000, 6'b000000});
	column_count[0] = 3'd7;
	column_count[1] = 3'd7;
	column_count[2] = 3'd7;
	column_count[3] = 3'd7;
	column_count[4] = 3'd6;
	column_count[5] = 3'd6;
	column_count[6] = 3'd6;
	column_count[7] = 3'd6;

	for (i = 0; i < 4; i = i + 1) begin
		freecells[i] = 6'd0;
		home_count[i] = 4'd0;
		for (j = 0; j < 13; j = j + 1)
			homecells[i][j] = 6'd0;
	end
	freecell_card = 4'd0;

	win = 0;
end

reg [2:0] src_column, dest_column;
reg [1:0] src_freecell, dest_freecell;
reg tableau_src, freecell_src, illegal_src, tableau_dest, freecell_dest, homecell_dest;    

// Decode source
always @(*) begin
    tableau_src = (source[3] == 0);
    freecell_src = (source[3:2] == 2'b10);
    illegal_src = (source[3:2] == 2'b11);

    if (tableau_src) begin
        src_column = source[2:0];
        src_freecell = 2'd0;
    end else if (freecell_src) begin
        src_column = 3'd0;
        src_freecell = source[1:0];
    end else begin
        src_column = 3'd0;
        src_freecell = 2'd0;
    end
end

// Decode destination
always @(*) begin
    tableau_dest = (dest[3] == 0);
    freecell_dest = (dest[3:2] == 2'b10);
    homecell_dest = (dest[3:2] == 2'b11);

    if (tableau_dest) begin
        dest_column = dest[2:0];
        dest_freecell = 2'd0;
    end else if (freecell_dest) begin
        dest_column = 3'd0;
        dest_freecell = dest[1:0];
	end	else begin
        dest_column = 3'd0;
        dest_freecell = 2'd0;
    end
end

reg src_valid, dest_valid;
reg [5:0] src_card;
reg [5:0] top_card, dest_top_card;
reg [3:0] top_val;
reg [1:0] homecell_suit;

always @(*) begin
    src_valid = 0;
    src_card = 6'd0;

    if (illegal_src) begin
        src_valid = 0;
    end else if (tableau_src) begin
        if (column_count[src_column] > 0) begin
            src_valid = 1;
            src_card = tableau[src_column][column_count[src_column] - 1];
        end
    end else if (freecell_src) begin
        if (freecell_card[src_freecell]) begin
            src_valid = 1;
            src_card = freecells[src_freecell];
        end
    end
end

// Check destination validity
always @(*) begin
    dest_valid = 0;
    top_card = 6'd0;
    top_val = 4'd0;
    dest_top_card = 6'd0;

    if (homecell_dest) begin
		if (home_count[src_card[5:4]] == 0) begin
			dest_valid = (src_card[3:0] == 4'b0001);
		end else begin
			top_card = homecells[src_card[5:4]][home_count[src_card[5:4]] - 1];
            top_val = top_card[3:0];
            dest_valid = (src_card[3:0] == top_val + 1); 
		end
    end else if (freecell_dest) begin
        dest_valid = !freecell_card[dest_freecell];
    end else if (tableau_dest) begin
        if (column_count[dest_column] == 0) begin
            dest_valid = 1;
        end else begin
            dest_top_card = tableau[dest_column][column_count[dest_column] - 1];
            dest_valid = valid_tableau(src_card, dest_top_card);
        end
    end
end

function valid_tableau;
    input [5:0] src_card;
    input [5:0] dest_top_card;
    reg [1:0] src_suit, dest_suit;
    reg [3:0] src_val, dest_val;
    reg src_red, dest_red, color_ok, sequence_ok;
    begin
        src_suit = src_card[5:4];
        dest_suit = dest_top_card[5:4];
        src_val = src_card[3:0];
        dest_val = dest_top_card[3:0];

        src_red = (src_suit == 2'b00) || (src_suit == 2'b01);
        dest_red = (dest_suit == 2'b00) || (dest_suit == 2'b01);
        color_ok = (src_red != dest_red);

        sequence_ok = (src_val == dest_val - 1);

        valid_tableau = color_ok && sequence_ok;
    end
endfunction

always @(posedge clock) begin

    if (src_valid && dest_valid) begin
        if (tableau_src) begin
            column_count[src_column] = column_count[src_column] - 1;
        end else if (freecell_src) begin
            freecell_card[src_freecell] = 0;
        end

        // Place card in destination
        if (tableau_dest) begin
            tableau[dest_column][column_count[dest_column]] = src_card;
            column_count[dest_column] = column_count[dest_column] + 1;
        end else if (freecell_dest) begin
            freecells[dest_freecell] = src_card;
            freecell_card[dest_freecell] = 1;
        end else if (homecell_dest) begin
            homecell_suit = src_card[5:4];
            homecells[homecell_suit][home_count[homecell_suit]] = src_card;
            home_count[homecell_suit] = home_count[homecell_suit] + 1;
        end
    end

    win = (home_count[0] + home_count[1] + home_count[2] + home_count[3] == 52);
end

endmodule