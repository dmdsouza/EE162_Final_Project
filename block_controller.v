`timescale 1ns / 1ps

module block_controller(
	input vga_clk,
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input rst,
	input up, input down, input left, input right,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg [11:0] background,
	output reg [5:0] appleCount
   );
	wire block_fill,block_fill1,block_fill2,block_fill3,block_fill4;
	wire apple_fill;
	
	//these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg game_over;
	reg [9:0] xpos, ypos;
	reg [9:0] appXPos, appYPos;
	reg [1:0] direction;
	
	reg [9:0] block_fill_x [20:0];
	reg [9:0] block_fill_y [20:0];
	reg [1:0] prev_direction;
	reg apple, apple_inX, apple_inY;
	parameter RED   = 12'b1111_0000_0000;
	parameter YELLOW = 12'b1111_1111_0000;
	parameter BLUE =  12'b0000_0000_1111;
	parameter GREEN = 12'b0000_1111_0000;
	parameter SPEED = 10;
	integer i, j ;
	
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	always@ (vga_clk) begin
    	if(~bright )	//force black if not inside the display area
			rgb = 12'b0000_0000_0000;
		else if(game_over)
			rgb = GREEN;			
		else if (apple_fill) 
			rgb = YELLOW; 
		else if (block_fill) 
			rgb = RED; 
		else if(block_fill1)
			rgb = BLUE;
		else if(block_fill2)
			rgb = RED;
		else if(block_fill3)
			rgb = BLUE;
		else if(block_fill4)
			rgb = RED;
		else if(block_fill5)
			rgb = BLUE;
		else if(block_fill6)
			rgb = RED;
		else if(block_fill7)
			rgb = BLUE;
		else if(block_fill8)
			rgb = RED;
		else if(block_fill9)
			rgb = BLUE;
		else if(block_fill10)
			rgb = RED;
		else if(block_fill11)
			rgb = BLUE;
		else if(block_fill12)
			rgb = RED;
		else if(block_fill13)
			rgb = BLUE;
		else if(block_fill14)
			rgb = RED;
		else if(block_fill15)
			rgb = BLUE;
		else if(block_fill16)
			rgb = RED;
		else if(block_fill17)
			rgb = BLUE;
		else if(block_fill18)
			rgb = RED;
		else if(block_fill19)
			rgb = BLUE;
		else if(block_fill20)
			rgb = RED;
			
		else	
			rgb=background;
	end
	
	//apple 
	assign apple_fill = vCount>=(appYPos-2) && vCount<=(appYPos+2) && hCount>=(appXPos-2) && hCount<=(appXPos+2);
	
		//the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)
	//snake head
	assign block_fill= vCount>=(ypos-5) && vCount<=(ypos+5) && hCount>=(xpos-5) && hCount<=(xpos+5);
	//snake body
	assign block_fill1 = vCount>=(block_fill_y[1]-5) && vCount<=(block_fill_y[1]+5) && hCount>=(block_fill_x[1]-5) && hCount<=(block_fill_x[1]+5);
	assign block_fill2 = vCount>=(block_fill_y[2]-5) && vCount<=(block_fill_y[2]+5) && hCount>=(block_fill_x[2]-5) && hCount<=(block_fill_x[2]+5);
	assign block_fill3 = vCount>=(block_fill_y[3]-5) && vCount<=(block_fill_y[3]+5) && hCount>=(block_fill_x[3]-5) && hCount<=(block_fill_x[3]+5);
	assign block_fill4 = vCount>=(block_fill_y[4]-5) && vCount<=(block_fill_y[4]+5) && hCount>=(block_fill_x[4]-5) && hCount<=(block_fill_x[4]+5);
	assign block_fill5 = vCount>=(block_fill_y[5]-5) && vCount<=(block_fill_y[5]+5) && hCount>=(block_fill_x[5]-5) && hCount<=(block_fill_x[5]+5);
	assign block_fill6 = vCount>=(block_fill_y[6]-5) && vCount<=(block_fill_y[6]+5) && hCount>=(block_fill_x[6]-5) && hCount<=(block_fill_x[6]+5);
	assign block_fill7 = vCount>=(block_fill_y[7]-5) && vCount<=(block_fill_y[7]+5) && hCount>=(block_fill_x[7]-5) && hCount<=(block_fill_x[7]+5);
	assign block_fill8 = vCount>=(block_fill_y[8]-5) && vCount<=(block_fill_y[8]+5) && hCount>=(block_fill_x[8]-5) && hCount<=(block_fill_x[8]+5);
	assign block_fill9 = vCount>=(block_fill_y[9]-5) && vCount<=(block_fill_y[9]+5) && hCount>=(block_fill_x[9]-5) && hCount<=(block_fill_x[9]+5);
	assign block_fill10 = vCount>=(block_fill_y[10]-5) && vCount<=(block_fill_y[10]+5) && hCount>=(block_fill_x[10]-5) && hCount<=(block_fill_x[10]+5);
	assign block_fill11 = vCount>=(block_fill_y[11]-5) && vCount<=(block_fill_y[11]+5) && hCount>=(block_fill_x[11]-5) && hCount<=(block_fill_x[11]+5);
	assign block_fill12 = vCount>=(block_fill_y[12]-5) && vCount<=(block_fill_y[12]+5) && hCount>=(block_fill_x[12]-5) && hCount<=(block_fill_x[12]+5);
	assign block_fill13 = vCount>=(block_fill_y[13]-5) && vCount<=(block_fill_y[13]+5) && hCount>=(block_fill_x[13]-5) && hCount<=(block_fill_x[13]+5);
	assign block_fill14 = vCount>=(block_fill_y[14]-5) && vCount<=(block_fill_y[14]+5) && hCount>=(block_fill_x[14]-5) && hCount<=(block_fill_x[14]+5);
	assign block_fill15 = vCount>=(block_fill_y[15]-5) && vCount<=(block_fill_y[15]+5) && hCount>=(block_fill_x[15]-5) && hCount<=(block_fill_x[15]+5);
	assign block_fill16 = vCount>=(block_fill_y[16]-5) && vCount<=(block_fill_y[16]+5) && hCount>=(block_fill_x[16]-5) && hCount<=(block_fill_x[16]+5);
	assign block_fill17 = vCount>=(block_fill_y[17]-5) && vCount<=(block_fill_y[17]+5) && hCount>=(block_fill_x[17]-5) && hCount<=(block_fill_x[17]+5);
	assign block_fill18 = vCount>=(block_fill_y[18]-5) && vCount<=(block_fill_y[18]+5) && hCount>=(block_fill_x[18]-5) && hCount<=(block_fill_x[18]+5);
	assign block_fill19 = vCount>=(block_fill_y[19]-5) && vCount<=(block_fill_y[19]+5) && hCount>=(block_fill_x[19]-5) && hCount<=(block_fill_x[19]+5);
	assign block_fill20 = vCount>=(block_fill_y[20]-5) && vCount<=(block_fill_y[20]+5) && hCount>=(block_fill_x[20]-5) && hCount<=(block_fill_x[20]+5);
	
	
	always@(posedge clk, posedge rst) 
	begin
		if(rst)
		begin 
			//rough values for center of screen
			xpos<=450;
			ypos<=250;
			
			direction<=2'b00;
			
			prev_direction <= 2'b00;
			
			for(i = 0; i < 21; i = i+1)
			begin
				block_fill_x[i] <= 10'b0000000000;
				block_fill_y[i] <= 10'b0000000000;
			end
			block_fill_x[0] <= 450;
			block_fill_y[0] <= 250;
		end
		else if (clk) begin
		
		/* Note that the top left of the screen does NOT correlate to vCount=0 and hCount=0. The display_controller.v file has the 
			synchronizing pulses for both the horizontal sync and the vertical sync begin at vcount=0 and hcount=0. Recall that after 
			the length of the pulse, there is also a short period called the back porch before the display area begins. So effectively, 
			the top left corner corresponds to (hcount,vcount)~(144,35). Which means with a 640x480 resolution, the bottom right corner 
			corresponds to ~(783,515).  
		*/
			//makes the direction continuous until a button changes it's direction
			if(right && prev_direction != 2'b01) //if the prev_direction was not left, can be done without prev_direction variable but for readibilty included
			begin
				direction <= 2'b00;
				prev_direction <= 2'b00;
			end
			else if(left && prev_direction != 2'b00) //if the prev_direction was not right
			begin
				direction <= 2'b01;
				prev_direction <= 2'b01;
			end
			else if(up && prev_direction != 2'b11) //if the prev_direction was not down
			begin
				direction <= 2'b10;
				prev_direction <= 2'b10;
			end
			else if(down && prev_direction != 2'b10) //if the prev_direction was not up
			begin
				direction <= 2'b11;
				prev_direction <= 2'b11;
			end
			if(direction == 2'b00) begin
				xpos<=xpos+SPEED; 				
				block_fill_x[0] <= block_fill_x[0] + SPEED;
				if(xpos==800) //these are rough values to attempt looping around
				begin
					xpos<=150;
					block_fill_x[0] <= 150;
				end
					
			end
			else if(direction == 2'b01) begin
				xpos<=xpos-SPEED; //A[0] <= A[0] + SPEED;
				block_fill_x[0] <= block_fill_x[0] - SPEED;
				if(xpos==150)begin
					xpos<=800;
					block_fill_x[0] <= 800;
				end
			end
			else if(direction == 2'b10) begin
				ypos<=ypos-SPEED; //A[0] <= A[0] + SPEED;
				block_fill_y[0] <= block_fill_y[0] - SPEED;
				if(ypos==34)begin
					ypos<=514;
					block_fill_y[0] <= 514;
				end
			end
			else if(direction == 2'b11) begin
				ypos<=ypos+SPEED; //A[0] <= A[0] + SPEED;
				block_fill_y[0] <= block_fill_y[0] + SPEED;
				if(ypos==514) begin
					ypos<=34;
					block_fill_y[0] <= 34;
				end
			end
			//updating the values in the fifo
			
			for(i = 0; i < appleCount; i = i+1)begin
				block_fill_x[i+1] <= block_fill_x[i];
				block_fill_y[i+1] <= block_fill_y[i];
						
			end			
		end
	end
	
	//the background color reflects the most recent button press
	always@(posedge clk, posedge rst) begin
		if(rst)
			background <= 12'b0000_1111_1111;
		else 
			background <= 12'b0000_1111_1111;
			
	end
	
	//apple position TODO: Add random logic
	always@(posedge vga_clk, posedge rst)
	begin
		if(rst)
		begin
			appXPos <= 650;
			appYPos <= 150;
			appleCount <= 0;
		end
		else begin
			//logic to determine if the xpos and ypos are in the applefill range
			// collison with apple detection
			if( ((xpos -5) < (appXPos+2)) && ((xpos +5) > (appXPos-2)) && ((ypos-5) < (appYPos+2)) && ((ypos+5) > (appYPos-2))) begin
				if(appleCount[0] == 1)begin //odd
					appXPos <= 650;
					appYPos <= 150;
					appleCount <= appleCount + 1'b1;
				end
				else begin //even
					appXPos <= 350;
					appYPos <= 250;
					appleCount <= appleCount + 1'b1;
				end
			end					
		end
	end
	
	
	//detect collison with snake body and trigger game_over
	always@(posedge clk, posedge rst)
	begin
		if(rst)
		begin
			game_over <= 0;
		end
		else begin
			for(j = 1; j < appleCount; j = j + 1) begin
				if( ((xpos -5) < (block_fill_x[j]+2)) && ((xpos +5) > (block_fill_x[j]-2)) && ((ypos-5) < (block_fill_y[j]+2)) && ((ypos+5) > (block_fill_y[j]-2))) begin
					game_over <= 1;
				end
			end
		end			
	end
	
	//random apple generator
	
			
			

	
	
endmodule
