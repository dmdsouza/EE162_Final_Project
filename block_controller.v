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
	reg [9:0] randomX;
	reg [8:0] randomY;
	//these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg game_over;
	reg [9:0] xpos, ypos;
	reg apple_inX, apple_inY;
	reg [9:0] appXPos, appYPos;
	reg [1:0] direction;
	
	reg [9:0] block_fill_x [20:0];
	reg [9:0] block_fill_y [20:0];
	reg [1:0] prev_direction;
	reg apple, apple_inX, apple_inY;
	parameter DARKRED = 12'b1010_1000_1000;
	parameter DARKGREEN = 12'b0000_1100_0000;
	parameter TEAL = 12'b0000_1000_1000;
	parameter RED = 12'b1111_0000_0000;
	parameter SPEED = 10;
	integer i, j;
	
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	always@ (vga_clk) 
	begin
		//force black if not inside the display area
    	if(~bright )	
			rgb = 12'b0000_0000_0000;
		//trigger a full red display if the game is lost by self-collison or 
		else if(game_over)
			rgb = RED;	
		//apple color		
		else if (apple_fill) 
			rgb = DARKRED;
		//snake body color assignments. snake body length maxes out at 20
		else if (block_fill) 
			rgb = DARKGREEN; 
		else if(block_fill1)
			rgb = TEAL;
		else if(block_fill2)
			rgb = DARKGREEN;
		else if(block_fill3)
			rgb = TEAL;
		else if(block_fill4)
			rgb = DARKGREEN;
		else if(block_fill5)
			rgb = TEAL;
		else if(block_fill6)
			rgb = DARKGREEN;
		else if(block_fill7)
			rgb = TEAL;
		else if(block_fill8)
			rgb = DARKGREEN;
		else if(block_fill9)
			rgb = TEAL;
		else if(block_fill10)
			rgb = DARKGREEN;
		else if(block_fill11)
			rgb = TEAL;
		else if(block_fill12)
			rgb = DARKGREEN;
		else if(block_fill13)
			rgb = TEAL;
		else if(block_fill14)
			rgb = DARKGREEN;
		else if(block_fill15)
			rgb = TEAL;
		else if(block_fill16)
			rgb = DARKGREEN;
		else if(block_fill17)
			rgb = TEAL;
		else if(block_fill18)
			rgb = DARKGREEN;
		else if(block_fill19)
			rgb = TEAL;
		else if(block_fill20)
			rgb = DARKGREEN;
		//if it isnt the apple or body and there is other trigger fill it in as background	
		else	
			rgb = background;
	end
	//the +-2 for the positions give the dimension of the apple block (i.e. it will be 4x4 pixels)
	//apple block
	assign apple_fill = vCount >= (appYPos - 2) && vCount <= (appYPos + 2) && hCount >= (appXPos - 2) && hCount <= (appXPos + 2);
	
	//the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)
	//snake head
	assign block_fill = vCount >= (ypos - 5) && vCount <= (ypos + 5) && hCount >= (xpos - 5) && hCount <= (xpos + 5);
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
			//places the snake in the middle at the beginning of each game
			xpos <= 450;
			ypos <= 250;
			//begins with an automatic direction of right
			direction <= 2'b00;
			//previous direction initilization since you are not allowed to go immediately back to previous direction in a tradional snake game
			prev_direction <= 2'b00;
			//initalizes all possible blocks of the snake body
			for(i = 0; i < 21; i = i+1)
			begin
				block_fill_x[i] <= 10'b0000000000;
				block_fill_y[i] <= 10'b0000000000;
			end
			//head initilization
			block_fill_x[0] <= 450;
			block_fill_y[0] <= 250;
		end
		else if (clk) 
		begin
		/* Note that the top left of the screen does NOT correlate to vCount=0 and hCount=0. The display_controller.v file has the 
			synchronizing pulses for both the horizontal sync and the vertical sync begin at vcount=0 and hcount=0. Recall that after 
			the length of the pulse, there is also a short period called the back porch before the display area begins. So effectively, 
			the top left corner corresponds to (hcount,vcount)~(144,35). Which means with a 640x480 resolution, the bottom right corner 
			corresponds to ~(783,515).  
		*/
			//makes the direction continuous until a button changes it's direction
			//if the prev_direction was not left, can be done without prev_direction variable but included for readibilty
			if(right && prev_direction != 2'b01) 
			begin
				direction <= 2'b00;
				prev_direction <= 2'b00;
			end
			//go left -- only if the prev_direction was not right
			else if(left && prev_direction != 2'b00) 
			begin
				direction <= 2'b01;
				prev_direction <= 2'b01;
			end
			//go up -- if the prev_direction was not down
			else if(up && prev_direction != 2'b11) 
			begin
				direction <= 2'b10;
				prev_direction <= 2'b10;
			end
			//go down -- if the prev_direction was not up
			else if(down && prev_direction != 2'b10) 
			begin
				direction <= 2'b11;
				prev_direction <= 2'b11;
			end
			//if the snake hits the right edge of the screen after going right loop around 
			//ie place the snake at the left most point along the same y coordinate
			if(direction == 2'b00) 
			begin
				xpos <= xpos + SPEED; 				
				block_fill_x[0] <= block_fill_x[0] + SPEED;
				//these are rough values of the screen dimensions in order to loop around
				//if it hits the right end
				if(xpos == 800) 
				begin
					//places the snake back to the beginning
					xpos <= 150;
					block_fill_x[0] <= 150;
				end
					
			end
			//if the snake hits the left edge of the screen after going left loop around 
			//ie place the snake at the right most point along the same y coordinate
			else if(direction == 2'b01) 
			begin
				xpos <= xpos - SPEED; //A[0] <= A[0] + SPEED;
				block_fill_x[0] <= block_fill_x[0] - SPEED;
				//snake hits the left side
				if(xpos == 150)
				begin
					//place at the rightmost side
					xpos <= 800;
					block_fill_x[0] <= 800;
				end
			end
			//if the snake hits the top edge of the screen after going up loop around 
			//ie place the snake at the bottom most point along the same x coordinate
			else if(direction == 2'b10) 
			begin
				ypos <= ypos-SPEED; 
				block_fill_y[0] <= block_fill_y[0] - SPEED;
				//snake hits the top of the screen
				if(ypos == 34)
				begin
					//place at the bottom
					ypos <= 514;
					block_fill_y[0] <= 514;
				end
			end
			//if the snake hits the bottom edge of the screen after going down loop around 
			//ie place the snake at the top most point along the same x coordinate
			else if(direction == 2'b11) 
			begin
				ypos <= ypos + SPEED; //A[0] <= A[0] + SPEED;
				block_fill_y[0] <= block_fill_y[0] + SPEED;
				//snake hits the bottom
				if(ypos == 514) 
				begin
					//place at the top
					ypos <= 34;
					block_fill_y[0] <= 34;
				end
			end
			//updating the values in the fifo
			//realigns the rest of the snake body 
			if(appleCount < 20) begin
				for(i = 0; i < appleCount; i = i+1)
				begin
					block_fill_x[i+1] <= block_fill_x[i];
					block_fill_y[i+1] <= block_fill_y[i];
							
				end		
			end
		end
	end
	
	//the background color reflects the most recent button press
	always@(posedge clk, posedge rst) 
	begin
		if(rst)
			background <= 12'b1111_1110_1010;
		else 
			background <= 12'b1111_1110_1010;
			
	end
	
	//apple position
	// appleRandomizer(vga_clk, randomX, randomY);
	always@(posedge vga_clk, posedge rst)
	begin
		if(rst)
		begin
			//assign  the apples corrdinates the random x corrdinate 
			// appXPos = randomX;
			//assign  the apples corrdinates the random y corrdinate 
			// appYPos = randomY;
			appXPos <= 650;
			appYPos <= 150;
			//this is triggered by reset so the snake has not eaten any apples yet
			appleCount <= 0;
		end
		else 
		begin
			//logic to determine if the xpos and ypos are in the applefill range -- collison with apple detection
			//checks whether or not the entire snake block covers the entire apple block
			//if true then apple was eaten and place a new apple on the random location
			if( ((xpos - 5) < (appXPos + 2)) && ((xpos + 5) > (appXPos - 2)) && ((ypos - 5) < (appYPos + 2)) && ((ypos + 5) > (appYPos - 2))) 
			begin 
				appXPos <= randomX;
				appYPos <= randomY;
				appleCount <= appleCount + 1'b1;
			end
		end
	end
	
	//detect collison with snake body and trigger game_over
	always@(posedge vga_clk, posedge rst)
	begin
		//game over initlization
		if(rst)
		begin
			game_over <= 0;
		end
		else 
		//the apple count value is equal to the expected number of snake body blocks
		begin
			//access each block and check whether or not it is intersecting with another block
			//if it is triggre game over otherwise continue through the for loop and exit if no collision is detected
			if(appleCount < 20) begin
				for(j = 1; j < appleCount; j = j + 1) 
				begin
					if( ((xpos - 5) < (block_fill_x[j] + 2)) && ((xpos + 5) > (block_fill_x[j] - 2)) && ((ypos - 5) < (block_fill_y[j] + 2))
						&& ((ypos + 5) > (block_fill_y[j] - 2))) 
					begin
						game_over <= 1;
					end
				end
			end
		end			
	end

	


//random apple generator 
//creates a random coordinate in the x and y direction
//which is later assigned to the apples x and y coordinate

	
	//random starting values for the pseudo random code
	// output reg [9:0]randomX = 256;
	// output reg [8:0]randomY = 201;
	//option 1
	always @(posedge vga_clk, posedge rst)
	begin	
		if(rst)
		begin
			randomX <= 256;
			randomY <= 201;
		end
		//psudorandom assignment in order to maximiza variance among value
		else begin
			
			randomX <= (randomX + 5) % 400 + 156;
			//if it exceeds the maximum bound in the x direction then assign it manually
			if(randomX >= 800)
			begin
				randomX <= 500;
			end
			//if it viiolates the minimum bound in the x direction then assign it manually
			if(randomX < 150)
			begin
				randomX <= 311;
			end
			//psudorandom assignment in order to maximiza variance among value
			randomY <= (randomY + 3) % 300 + 77;
			//if it exceeds the maximum bound in the y direction then assign it manually
			if(randomY >= 514)
			begin
				randomY <= 300;
			end
			//if it violates the minimum bound in the y direction then assign it manually
			if(randomY < 34)
			begin
				randomY <= 176;
			end
			
		end

	end

	//option 2 with the vga constraints 

	// always @(posedge vga_clk)
  	// begin  
    // 	randomX <= ((randomX + 3) % 78) + 150;
    // 	randomY <= ((randomY + 5) % 58) + 34;
  	// end

	//option 2's base code --  no attempt at constraining
	// always @(posedge vga_clk)
  	// begin  
    // 	randomX <= ((randomX + 3) % 78) + 1;
    // 	randomY <= ((randomY + 5) % 58) + 1;
  	// end


endmodule