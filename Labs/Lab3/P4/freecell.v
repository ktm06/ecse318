module freecellPlayer(clock,source,dest,win);  
input clock;
input [3:0] source, dest;
output win;

reg [5:0] tableau[0:7][6:0];
reg [2:0] column_count[0:7];
reg [5:0] freecells[0:3];
reg [0:3] freecell_card;
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

reg [2:0] src_column;
reg [1:0] src_freecell;
reg src_tableau;      
reg src_freecell;
reg src_illegal;

reg [2:0] dest_column;      
reg [1:0] dest_freecell;       
reg dest_tableau;     
reg dest_freecell;    
reg dest_homecell;    

// Decode source
always @(*) begin
    src_tableau = (source[3] == 0);
    src_freecell = (source[3:2] == 2'b10);
    src_illegal = (source[3:2] == 2'b11);

    if (src_tableau) begin
        src_column = source[2:0];
        src_freecell = 0;
    end else if (src_freecell) begin
        src_column = 0;
        src_freecell = source[1:0];
    end else begin
        src_column = 0;
        src_freecell = 0;
    end
end

// Decode destination
always @(*) begin
    dest_tableau = (dest[3] == 0);
    dest_freecell = (dest[3:2] == 2'b10);
    dest_homecell = (dest[3:2] == 2'b11);

    if (dest_tableau) begin
        dest_column = dest[2:0];
        dest_freecell = 0;
    end else if (dest_freecell) begin
        dest_column = 0;
        dest_freecell = dest[1:0];
    end else begin
        dest_column = 0;
        dest_freecell = 0;
    end
end


always @(posedge clock) begin
	
end

endmodule