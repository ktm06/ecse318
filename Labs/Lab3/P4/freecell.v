module freecellPlayer(clock,source,dest,win);  
input clock;
input [3:0] source, dest;
output win;

reg [5:0] tableau[0:7][6:0];
reg [2:0] column_count[0:7];
reg [5:0] freecells[0:3];
reg [3:0] freecell_card;
reg [5:0] homecells[0:3][12:0];
reg [3:0] home_count[0:3];

initial begin
	tableau[0] = {6'100100, 6'011011, 6'011010, 6'010110, 6'100011, 6'010001, 6'000001};
	tableau[1] = {6'100101, 6'101010, 6'001000, 6'110100, 6'000110, 6'001101, 6'000010};
	tableau[2] = {6'101011, 6'110111, 6'111001, 6'110110, 6'110010, 6'101101, 6'110001};
	tableau[3] = {6'000100, 6'100001, 6'111100, 6'110101, 6'100111, 6'001001, 6'101000};
	tableau[4] = {6'011100, 6'001011, 6'101100, 6'100110, 6'010010, 6'101001, 6'000000};
	tableau[5] = {6'010101, 6'011101, 6'110011, 6'011001, 6'000011, 6'100010, 6'000000};
	tableau[6] = {6'000101, 6'010011, 6'001100, 6'010111, 6'111101, 6'111010, 6'000000};
	tableau[7] = {6'111011, 6'010100, 6'001010, 6'111000, 6'000111, 6'011000, 6'000000};
	column_count[0] = 3'd7;
	column_count[1] = 3'd7;
	column_count[2] = 3'd7;
	column_count[3] = 3'd7;
	column_count[4] = 3'd6;
	column_count[5] = 3'd6;
	column_count[6] = 3'd6;
	column_count[7] = 3'd6;

	freecells = '{6'd0, 6'd0, 5'd0, 5'd0};
	freecell_card = 4'd0;
	homecells = '{'{6'd0}, '{6'd0}, '{6'd0}, '{6'd0}};
	home_count = '{0, 0, 0, 0};

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

    if (homecell_dest) begin
		if (home_count[src_card[5:4]] == 0) begin
			dest_valid = (src_card[3:0] == 4'b0001);
		end else begin
			reg [5:0] top_card = homecells[src_card[5:4]][home_count[src_card[5:4]] - 1];
            reg [3:0] top_val = top_card[3:0];
            dest_valid = (src_card[3:0] == top_val + 1); 
		end
    end else if (freecell_dest) begin
        dest_valid = !freecell_card[dest_freecell];
    end else if (tableau_dest) begin
        if (column_count[dest_column] == 0) begin
            dest_valid = 1;
        end else begin
            reg [5:0] dest_top_card = tableau[dest_column][column_count[dest_column] - 1];
            dest_valid = valid_tableau(src_card, dest_top_card);
        end
    end
end

function valid_tableau;
    input [5:0] src_card;
    input [5:0] dest_top_card;
    begin
        
        reg [1:0] src_suit = src_card[5:4];
        reg [1:0] dest_suit = dest_top_card[5:4];
        reg [3:0] src_val = src_card[3:0];
        reg [3:0] dest_val = dest_top_card[3:0];

        reg src = (src_suit == 2'b00) || (src_suit == 2'b01);
        reg dest = (dest_suit == 2'b00) || (dest_suit == 2'b01);
        reg color_ok = (src != dest);

        reg sequence_ok = (src_val == dest_val - 1);

        valid_tableau = color_ok && sequence_ok;
    end
endfunction

// Lines 109 - 111 can be put in the function below
/*function valid_homecell;
    input [5:0] top_homecell_card;
    begin {} end
endfunction*/

always @(posedge clock) begin
	// Remove card from source
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
            reg [1:0] homecell_suit = src_card[5:4];
            homecells[homecell_suit][home_count[homecell_suit]] = src_card;
            home_count[homecell_suit] = home_count[homecell_suit] + 1;
        end
    end

    // Check win condition
    win = (home_count[0] + home_count[1] + home_count[2] + home_count[3] == 52);
end

endmodule