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
	reg [9:0] block_fill_x [9:0];
	reg [9:0] block_fill_y [9:0];
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
		else if(block_fill1)
			rgb = RED;
		else if(block_fill2)
			rgb = RED;
		else if(block_fill3)
			rgb = RED;
		else if(block_fill4)
			rgb = RED;
			
		else	
			rgb=background;
	end
	
	//head collides with any elements in the fifo
	assign apple_fill = vCount>=(appYPos-2) && vCount<=(appYPos+2) && hCount>=(appXPos-2) && hCount<=(appXPos+2);
	
		//the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)
		//{}{}{}{}{}
	assign block_fill= vCount>=(ypos-5) && vCount<=(ypos+5) && hCount>=(xpos-5) && hCount<=(xpos+5);
	assign block_fill1 = vCount>=(block_fill_y[1]-5) && vCount<=(block_fill_y[1]+5) && hCount>=(block_fill_x[1]-5) && hCount<=(block_fill_x[1]+5);
	assign block_fill2 = vCount>=(block_fill_y[2]-5) && vCount<=(block_fill_y[2]+5) && hCount>=(block_fill_x[2]-5) && hCount<=(block_fill_x[2]+5);
	assign block_fill3 = vCount>=(block_fill_y[3]-5) && vCount<=(block_fill_y[3]+5) && hCount>=(block_fill_x[3]-5) && hCount<=(block_fill_x[3]+5);
	assign block_fill4 = vCount>=(block_fill_y[4]-5) && vCount<=(block_fill_y[4]+5) && hCount>=(block_fill_x[4]-5) && hCount<=(block_fill_x[4]+5);
	//for(loop of assign)
	//A[i] ->FIFO 
	//A[i] = 000000000 or {xpos,ypos}
	//assign blockfill1 = A[i] && vCount>=(ypos-5) && vCount<=(ypos+5) && hCount>=(xpos-5) && hCount<=(xpos+5);
	//....assign blockfill20
	integer i ;
	always@(posedge clk, posedge rst) 
	begin
		if(rst)
		begin 
			//rough values for center of screen
			xpos<=450;
			ypos<=250;
			
			direction<=2'b00;
			for(i = 0; i < 10; i = i+1)
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
				//Ax[i]				= {324,234} {0000,0000,000} 
				//Ay[i] = {000,000,000}
				xpos<=xpos+SPEED; //A[0] <= A[0]={0000,0000}.xpos + SPEED;
				
				block_fill_x[0] <= block_fill_x[0] + SPEED;
				block_fill_y[0] <= block_fill_y[0] + SPEED;
				//FIFO for(int i = 0; i < length_of_array; i ++)
				//  A[i] <= A[i+1]
				//A[0] 
				//change the amount you increment to make the speed faster 
				if(xpos==800) //these are rough values to attempt looping around, you can fine-tune them to make it more accurate- refer to the block comment above
				begin
					xpos<=150;
					block_fill_x[0] <= 150;
				end
					
			end
			else if(direction == 2'b01) begin
				xpos<=xpos-SPEED; //A[0] <= A[0] + SPEED;
				block_fill_x[0] <= block_fill_y[0] - SPEED;
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
			block_fill_x[0] <= xpos;
			block_fill_y[0] <= ypos;
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
