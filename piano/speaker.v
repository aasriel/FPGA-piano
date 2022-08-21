module speaker(
 input clk,
 input rst_n,
 input [12:0] key_value,
 input [12:0] key_flag,
 input [2:0] yinjie,
 input stat,
 input [5:0] note,
 output pwm_out
 );
 	wire [24:0] count1;wire [24:0] count2;wire [24:0] count3;
	wire [24:0] count4;wire [24:0] count5;wire [24:0] count6;
	wire [24:0] count7;wire [24:0] count8;wire [24:0] count9;
	wire [24:0] count10;wire [24:0] count11;wire [24:0] count12;
	wire [24:0] count13;  //累加器不同频率地址输出
	reg [24:0] u_count1;reg [24:0] u_count2; //rom地址输入
	reg [1:0] en; //romIP使能标志
	reg [4:0] rom1;reg [4:0] rom2; //rom地址输入选择标志
	reg [4:0] rom2_note;
	reg [12:0] PWM_in;
	wire [11:0] data_out1;
    wire [11:0] data_out2;
    reg [13:0] PWM_DDS_accumulator;
	reg [2:0] yinjie_box;

	initial begin
		yinjie_box = 3'd1;
	end

//romIP
 sin_rom sin1 (
   .Address(u_count1[24:14]),
   .OutClock(clk),
   .OutClockEn(en[0]),
   .Reset(1'b0),
   .Q(data_out1)
  );
 sin_rom sin2 (
   .Address(u_count2[24:14]),
   .OutClock(clk),
   .OutClockEn(en[1]),
   .Reset(1'b0),
   .Q(data_out2)
  );

//相位累加器(输出的频率分辨率=48MHZ/(2^(11)*2^(14))=1.4305HZ)
DDS u_DDS_1(
 .clk (clk),
 .rst_n (rst_n),
 .key_value (key_value[0]&&~stat),
 .yinjie (yinjie),
 .yinjie_box(yinjie_box),
 .stat(stat),
 .fcw (16'd183),//C1-261.63HZ
 .count (count1)
 );

DDS u_DDS_2(
 .clk (clk),
 .rst_n (rst_n),
 .key_value (key_value[1]&&~stat),
 .yinjie (yinjie),
 .yinjie_box(yinjie_box),
 .stat(stat),
 .fcw (16'd194),//C1#/D1B-277.18HZ
 .count (count2)
 );

DDS u_DDS_3(
 .clk (clk),
 .rst_n (rst_n),
 .key_value (key_value[2]&&~stat),
 .yinjie (yinjie),
 .yinjie_box(yinjie_box),
 .stat(stat),
 .fcw (16'd205),//D1-293.66HZ
 .count (count3)
 );

DDS u_DDS_4(
 .clk (clk),
 .rst_n (rst_n),
 .key_value (key_value[3]&&~stat),
 .yinjie (yinjie),
 .yinjie_box(yinjie_box),
 .stat(stat),
 .fcw (16'd217),//D1#/E1B-311.13HZ
 .count (count4)
 );

DDS u_DDS_5(
 .clk (clk),
 .rst_n (rst_n),
 .key_value (key_value[4]&&~stat),
 .yinjie (yinjie),
 .yinjie_box(yinjie_box),
 .stat(stat),
 .fcw (16'd230),//E1-329.63HZ
 .count (count5)
 );

DDS u_DDS_6(
 .clk (clk),
 .rst_n (rst_n),
 .key_value (key_value[5]&&~stat),
 .yinjie (yinjie),
 .yinjie_box(yinjie_box),
 .stat(stat),
 .fcw (16'd244),//F1-349.63HZ
 .count (count6)
 );

DDS u_DDS_7(
 .clk (clk),
 .rst_n (rst_n),
 .key_value (key_value[6]&&~stat),
 .yinjie (yinjie),
 .yinjie_box(yinjie_box),
 .stat(stat),
 .fcw (16'd259),//F1#/G1B-369.99HZ
 .count (count7)
 );

DDS u_DDS_8(
 .clk (clk),
 .rst_n (rst_n),
 .key_value (key_value[7]&&~stat),
 .yinjie (yinjie),
 .yinjie_box(yinjie_box),
 .stat(stat),
 .fcw (16'd274),//G1-392HZ
 .count (count8)
 );

DDS u_DDS_9(
 .clk (clk),
 .rst_n (rst_n),
 .key_value (key_value[8]&&~stat),
 .yinjie (yinjie),
 .yinjie_box(yinjie_box),
 .stat(stat),
 .fcw (16'd290),//G1#/A1B-415.3HZ
 .count (count9)
 );

DDS u_DDS_10(
 .clk (clk),
 .rst_n (rst_n),
 .key_value (key_value[9]&&~stat),
 .yinjie (yinjie),
 .yinjie_box(yinjie_box),
 .stat(stat),
 .fcw (16'd308),//A1-440HZ
 .count (count10)
 );

DDS u_DDS_11(
 .clk (clk),
 .rst_n (rst_n),
 .key_value (key_value[10]&&~stat),
 .yinjie (yinjie),
 .yinjie_box(yinjie_box),
 .stat(stat),
 .fcw (16'd326),//A1#/B1B-466.16HZ
 .count (count11)
 );

DDS u_DDS_12(
 .clk (clk),
 .rst_n (rst_n),
 .key_value (key_value[11]&&~stat),
 .yinjie (yinjie),
 .yinjie_box(yinjie_box),
 .stat(stat),
 .fcw (16'd345),//B1-493.88HZ
 .count (count12)
 );

DDS u_DDS_13(
 .clk (clk),
 .rst_n (rst_n),
 .key_value (key_value[12]&&~stat),
 .yinjie (yinjie),
 .yinjie_box(yinjie_box),
 .stat(stat),
 .fcw (16'd366),//C2-523.25HZ
 .count (count13)
 );


always @(negedge clk)
	begin
		if(stat == 1'b0) begin//电子琴状态
		case(rom1)//某一琴键按下时
			5'd0:en[0] <= 1'b0;
			5'd1: begin
			if(key_flag[0])
				en[0] <= ~key_value[0];//该琴键被松开，失能romIPsin1
            end                        //该琴键仍处于按下状态时romIPsin1被使能
			5'd2: begin
			if(key_flag[1])
				en[0] <= ~key_value[1];
			end
			5'd3: begin
			if(key_flag[2])
				en[0] <= ~key_value[2];
			end
			5'd4: begin
			if(key_flag[3])
				en[0] <= ~key_value[3];
			end
			5'd5: begin
			if(key_flag[4])
				en[0] <= ~key_value[4];
			end
			5'd6: begin
			if(key_flag[5])
				en[0] <= ~key_value[5];
			end
			5'd7: begin
			if(key_flag[6])
				en[0] <= ~key_value[6];
			end
			5'd8: begin
			if(key_flag[7])
				en[0] <= ~key_value[7];
			end
			5'd9: begin
			if(key_flag[8])
				en[0] <= ~key_value[8];
			end
			5'd10: begin
			if(key_flag[9])
				en[0] <= ~key_value[9];
			end
			5'd11: begin
			if(key_flag[10])
				en[0] <= ~key_value[10];
			end
			5'd12: begin
			if(key_flag[11])
				en[0] <= ~key_value[11];
			end
			5'd13: begin
			if(key_flag[12])
				en[0] <= ~key_value[12];
			end
			default:en[0] <= 1'b0;
         endcase
         end
		if(stat == 1'b1)
			en[0] <= 1'b1;
	end

always @(*)
    begin
		if(stat == 1'b0) begin //电子琴状态
	    if(~en[0]) begin  //romIPsin1被失能时，依次扫描按键，当有与rom2寄存按键不同的按键被按下，寄存该按键标号
		    if(key_value[12:0] != 13'h1fff) begin 
			    if((key_value[0]==1'b0)&&key_flag[0]&&(rom2 != 5'd1)) begin 
						rom1 = 5'd1;  
				end
			    else if((key_value[1]==1'b0)&&key_flag[1]&&(rom2 != 5'd2))begin
						rom1 = 5'd2;
				end
			    else if((key_value[2]==1'b0)&&key_flag[2]&&(rom2 != 5'd3))begin
						rom1 = 5'd3;
				end
			    else if((key_value[3]==1'b0)&&key_flag[3]&&(rom2 != 5'd4))begin
						rom1 = 5'd4;
				end
			    else if((key_value[4]==1'b0)&&key_flag[4]&&(rom2 != 5'd5))begin
						rom1 = 5'd5;
				end
			    else if((key_value[5]==1'b0)&&key_flag[5]&&(rom2 != 5'd6))begin
						rom1 = 5'd6;
				end
			    else if((key_value[6]==1'b0)&&key_flag[6]&&(rom2 != 5'd7))begin
						rom1 = 5'd7;
				end
			    else if((key_value[7]==1'b0)&&key_flag[7]&&(rom2 != 5'd8))begin
						rom1 = 5'd8;
				end
			    else if((key_value[8]==1'b0)&&key_flag[8]&&(rom2 != 5'd9))begin
						rom1 = 5'd9;
				end
			    else if((key_value[9]==1'b0)&&key_flag[9]&&(rom2 != 5'd10))begin
						rom1 = 5'd10;
				end
			    else if((key_value[10]==1'b0)&&key_flag[10]&&(rom2 != 5'd11))begin
						rom1 = 5'd11;
				end
			    else if((key_value[11]==1'b0)&&key_flag[11]&&(rom2 != 5'd12))begin
						rom1 = 5'd12;
				end
			    else if((key_value[12]==1'b0)&&key_flag[12]&&(rom2 != 5'd13))begin
						rom1 = 5'd13;
				end
				else
				    rom1 = 5'd0;
			end
			else
			    rom1 = 5'd0;
		end
		end
	end


	

always @(negedge clk)
	begin
		if(stat == 1'b0) begin //电子琴状态
	    case(rom1) //根据rom1寄存按键标号选择地址输入
		    5'd0:u_count1 <= 0;
			5'd1:u_count1 <= count1;
			5'd2:u_count1 <= count2;
			5'd3:u_count1 <= count3;
			5'd4:u_count1 <= count4;
			5'd5:u_count1 <= count5;
			5'd6:u_count1 <= count6;
			5'd7:u_count1 <= count7;
			5'd8:u_count1 <= count8;
			5'd9:u_count1 <= count9;
			5'd10:u_count1 <= count10;
			5'd11:u_count1 <= count11;
			5'd12:u_count1 <= count12;
			5'd13:u_count1 <= count13;
			default:u_count1 <= 0;
		 endcase
		 end
		if(stat == 1'b1) begin //音乐盒状态
	    case(note%12) //根据音符选择地址输入
		    6'd0:begin
			    if(note/12)
				    u_count1 <= count12;
				else
				    u_count1 <= 0;
            end					
			6'd1:u_count1 <= count1;
			6'd2:u_count1 <= count2;
			6'd3:u_count1 <= count3;
			6'd4:u_count1 <= count4;
			6'd5:u_count1 <= count5;
			6'd6:u_count1 <= count6;
			6'd7:u_count1 <= count7;
			6'd8:u_count1 <= count8;
			6'd9:u_count1 <= count9;
			6'd10:u_count1 <= count10;
			6'd11:u_count1 <= count11;
			default:u_count1 <= 0;
		 endcase
		 end
	end

always @(negedge clk)//根据音符改变音程
    begin
	    if(stat == 1'b1) begin
			if(note > 6'd36)
				yinjie_box <= 3'd4;
		    else if(note > 6'd24) 
			    yinjie_box <= 3'd3;
			else if(note > 6'd12)
			    yinjie_box <= 3'd2;
			else
				yinjie_box <= 3'd1;
		end
	end

always @(negedge clk)
	begin
		if(stat == 1'b0) begin
		case(rom2)
			5'd0:en[1] <= 1'b0;
			5'd1: begin
			if(key_flag[0])
				en[1] <= ~key_value[0];//该琴键被松开，失能romIPsin2
            end                        //该琴键仍处于按下状态时romIPsin2被使能
			5'd2: begin
			if(key_flag[1])
				en[1] <= ~key_value[1];
			end
			5'd3: begin
			if(key_flag[2])
				en[1] <= ~key_value[2];
			end
			5'd4: begin
			if(key_flag[3])
				en[1] <= ~key_value[3];
			end
			5'd5: begin
			if(key_flag[4])
				en[1] <= ~key_value[4];
			end
			5'd6: begin
			if(key_flag[5])
				en[1] <= ~key_value[5];
			end
			5'd7: begin
			if(key_flag[6])
				en[1] <= ~key_value[6];
			end
			5'd8: begin
			if(key_flag[7])
				en[1] <= ~key_value[7];
			end
			5'd9: begin
			if(key_flag[8])
				en[1] <= ~key_value[8];
			end
			5'd10: begin
			if(key_flag[9])
				en[1] <= ~key_value[9];
			end
			5'd11: begin
			if(key_flag[10])
				en[1] <= ~key_value[10];
			end
			5'd12: begin
			if(key_flag[11])
				en[1] <= ~key_value[11];
			end
			5'd13: begin
			if(key_flag[12])
				en[1] <= ~key_value[12];
			end
			default:en[1] <= 1'b0;
         endcase
         end
		if(stat == 1'b1)
			en[1] <= 1'b1;
	end

always @(*)
    begin
		if(stat == 1'b0) begin
	    if(~en[1] && en[0]) begin
		    if(key_value[12:0] != 13'h1fff) begin
			    if((key_value[0]==1'b0)&&key_flag[0]&&(rom1 != 5'd1)) begin
						rom2 = 5'd1;
				end
			    else if((key_value[1]==1'b0)&&key_flag[1]&&(rom1 != 5'd2))begin
						rom2 = 5'd2;
				end
			    else if((key_value[2]==1'b0)&&key_flag[2]&&(rom1 != 5'd3))begin
						rom2 = 5'd3;
				end
			    else if((key_value[3]==1'b0)&&key_flag[3]&&(rom1 != 5'd4))begin
						rom2 = 5'd4;
				end
			    else if((key_value[4]==1'b0)&&key_flag[4]&&(rom1 != 5'd5))begin
						rom2 = 5'd5;
				end
			    else if((key_value[5]==1'b0)&&key_flag[5]&&(rom1 != 5'd6))begin
						rom2 = 5'd6;
				end
			    else if((key_value[6]==1'b0)&&key_flag[6]&&(rom1 != 5'd7))begin
						rom2 = 5'd7;
				end
			    else if((key_value[7]==1'b0)&&key_flag[7]&&(rom1 != 5'd8))begin
						rom2 = 5'd8;
				end
			    else if((key_value[8]==1'b0)&&key_flag[8]&&(rom1 != 5'd9))begin
						rom2 = 5'd9;
				end
			    else if((key_value[9]==1'b0)&&key_flag[9]&&(rom1 != 5'd10))begin
						rom2 = 5'd10;
				end
			    else if((key_value[10]==1'b0)&&key_flag[10]&&(rom1 != 5'd11))begin
						rom2 = 5'd11;
				end
			    else if((key_value[11]==1'b0)&&key_flag[11]&&(rom1 != 5'd12))begin
						rom2 = 5'd12;
				end
			    else if((key_value[12]==1'b0)&&key_flag[12]&&(rom1 != 5'd13))begin
						rom2 = 5'd13;
				end
				else
				    rom2 = 5'd0;
			end
			else
			    rom2 = 5'd0;
		end
		end
	end


always@(negedge clk) begin
		if(stat == 1'b1) begin
			rom2_note <= 5'd0;
	    end
end


always @(negedge clk)
	begin
		if(stat == 1'b0) begin
	    case(rom2)
		    5'd0:u_count2 <= 0;
			5'd1:u_count2 <= count1;
			5'd2:u_count2 <= count2;
			5'd3:u_count2 <= count3;
			5'd4:u_count2 <= count4;
			5'd5:u_count2 <= count5;
			5'd6:u_count2 <= count6;
			5'd7:u_count2 <= count7;
			5'd8:u_count2 <= count8;
			5'd9:u_count2 <= count9;
			5'd10:u_count2 <= count10;
			5'd11:u_count2 <= count11;
			5'd12:u_count2 <= count12;
			5'd13:u_count2 <= count13;
			default:u_count2 <= 0;
		 endcase
		 end
		if(stat == 1'b1) begin
	     case(rom2_note%12)
		    5'd0:begin
			    if(rom2_note/12)
				    u_count2 <= count12;
				else
				    u_count2 <= 0;
            end					
			5'd1:u_count2 <= count1;
			5'd2:u_count2 <= count2;
			5'd3:u_count2 <= count3;
			5'd4:u_count2 <= count4;
			5'd5:u_count2 <= count5;
			5'd6:u_count2 <= count6;
			5'd7:u_count2 <= count7;
			5'd8:u_count2 <= count8;
			5'd9:u_count2 <= count9;
			5'd10:u_count2 <= count10;
			5'd11:u_count2 <= count11;
			default:u_count2 <= 0;
		 endcase
		end
	end


	 always @(negedge clk or negedge rst_n)//调用DDS结果通过PWM调制输出
		 begin
			if(!rst_n)
				 PWM_DDS_accumulator <= 0;
			else
				 PWM_DDS_accumulator <= PWM_DDS_accumulator[12:0] + PWM_in;
		 end

     always @(negedge clk or negedge rst_n)
		 begin
			 if(!rst_n)
				 PWM_in <= 13'd0;
			 else if(key_value[12:0] != 13'h1FFF || stat == 1'b1)
				 PWM_in <= data_out1[11:0]+data_out2[11:0];
			 else
				 PWM_in <= 13'd0;
		 end
				 
     assign pwm_out = PWM_DDS_accumulator[13];

endmodule