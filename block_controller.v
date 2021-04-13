`timescale 1ns / 1ps

module block_controller(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input rst,
	input up, input down, input left, input right,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg [11:0] background
   );
	wire block_fill;
	wire apple_fill;
	
	//these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg [9:0] xpos, ypos;
	reg [9:0] appXPos, appYPos;
	reg [1:0] direction;
	reg [5:0] appleCount;
	reg apple, apple_inX, apple_inY;
	parameter RED   = 12'b1111_0000_0000;
	parameter YELLOW = 12'b1111_1111_0000;
	parameter SPEED = 1'd1;
	
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	always@ (*) begin
    	if(~bright )	//force black if not inside the display area
			rgb = 12'b0000_0000_0000;
		else if (apple_fill) 
			rgb = YELLOW; 
		else if (block_fill) 
			rgb = RED; 
		else	
			rgb=background;
	end

	
	assign apple_fill = vCount>=(appYPos-2) && vCount<=(appYPos+2) && hCount>=(appXPos-2) && hCount<=(appXPos+2);
	
		//the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)
	assign block_fill= vCount>=(ypos-5) && vCount<=(ypos+5) && hCount>=(xpos-5) && hCount<=(xpos+5);
	
	always@(posedge clk, posedge rst) 
	begin
		if(rst)
		begin 
			//rough values for center of screen
			xpos<=450;
			ypos<=250;
			
			direction<=2'b00;
		end
		else if (clk) begin
		
		/* Note that the top left of the screen does NOT correlate to vCount=0 and hCount=0. The display_controller.v file has the 
			synchronizing pulses for both the horizontal sync and the vertical sync begin at vcount=0 and hcount=0. Recall that after 
			the length of the pulse, there is also a short period called the back porch before the display area begins. So effectively, 
			the top left corner corresponds to (hcount,vcount)~(144,35). Which means with a 640x480 resolution, the bottom right corner 
			corresponds to ~(783,515).  
		*/
			//makes the direction continuous until a button changes it's direction
			if(right)
			begin
				direction <= 2'b00;
			end
			else if(left)
			begin
				direction <= 2'b01;
			end
			else if(up)
			begin
				direction <= 2'b10;
			end
			else if(down)
			begin
				direction <= 2'b11;
			end
			
			if(direction == 2'b00) begin
				xpos<=xpos+SPEED; //change the amount you increment to make the speed faster 
				if(xpos==800) //these are rough values to attempt looping around, you can fine-tune them to make it more accurate- refer to the block comment above
					xpos<=150;
			end
			else if(direction == 2'b01) begin
				xpos<=xpos-SPEED;
				if(xpos==150)
					xpos<=800;
			end
			else if(direction == 2'b10) begin
				ypos<=ypos-SPEED;
				if(ypos==34)
					ypos<=514;
			end
			else if(direction == 2'b11) begin
				ypos<=ypos+SPEED;
				if(ypos==514)
					ypos<=34;
			end
			
			
			
		end
	end
	
	//the background color reflects the most recent button press
	always@(posedge clk, posedge rst) begin
		if(rst)
			background <= 12'b1111_1111_1111;
		else 
			background <= 12'b0000_1111_1111;
			//if(right)
				// background <= 12'b1111_1111_0000;
			// else if(left)
				// background <= 12'b0000_1111_1111;
			// else if(down)
				// background <= 12'b0000_1111_0000;
			// else if(up)
				// background <= 12'b0000_0000_1111;
	end
	
	
	always@(posedge clk, posedge rst)
	begin
		if(rst)
		begin
			appXPos<=650;
			appYPos <= 150;
			appleCount <= 0;
		end
	end
		// else if(clk)
		// begin
		// //changing the position of apple by detecting if the square has touched the apple
			// if(
			// vCount>=(ypos-5) && vCount<=(ypos+5) && hCount>=(xpos-5) && hCount<=(xpos+5);
			
	
	
	// always@(posedge clk)
	// begin	
		// appleCount = appleCount + 1;
		// apple_inX <= (xpos > appXPos && xpos < (appXPos + 10));
		// apple_inY <= (ypos > appYPos && ypos < (appYPos + 10));
		// apple = apple_inX && apple_inY;
		// if(appleCount == 1)
		// begin
			// appXPos <= 320;
			// appYPos <= 100;
		// end
		// else
		// begin
			// if(apple)
			// begin
				// if(appleCount%2 == 0)
				// begin
					// appXPos <= 320;
					// appYPos <= 100;
				// end
				// else
				// begin 
					// appXPos <= 320;
					// appYPos <= 100;
				// end
			// end
		// end
	// end
			
			

	
	
endmodule
