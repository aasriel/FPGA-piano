module piano
 (
     input sys_clk, //系统输入时钟(12MHZ)
	 input rst_n, //复位信号
	 input [14:0] key, //按键信号
	 input key_pa,  //Speaker/Buzzer转换按键信号
	 input key_state, //状态转换按键信号
	 output pwm_out1, //buzzer端pwm输出
	 output pwm_out2 //speaker端pwm输出
);
    wire [14:0] key_value;
    wire [14:0] key_flag;	
	wire clk;  //倍频时钟(48MHZ)
	wire key_state_value;
    wire key_state_flag;
    reg stat; //说明当前状态，0为电子琴状态，1为音乐盒状态
	reg [2:0] yinjie; //用于音程扩展
	reg  [31:0]   cnt;//用于时间计数
	reg clk_beat;//节拍时钟信号
	reg [4:0] beat;//音符
	reg [5:0] note;//节拍
	reg [4:0] count_beat;//音符计数
	reg [7:0] count_note;//节拍计数
	
	initial begin
		yinjie = 3'd1;
		count_beat = 5'd1;
		stat = 1'd0;
	end
//倍频ip	
clk_pll u_clk_pll (
   .CLKI(sys_clk),
   .CLKOP(clk)
   );
//speaker模块
speaker u_speaker(
 .clk(clk),
 .rst_n(rst_n&key_pa),
 .key_value(key_value[12:0]),
 .key_flag(key_flag[12:0]),
 .yinjie(yinjie),
 .stat(stat),
 .note(note),
 .pwm_out(pwm_out2)
 );

//按键消抖
key u_key_1(
   .sys_clk (clk),
   .sys_rst_n (rst_n),
   .key (key[0]),
   .key_flag (key_flag[0]),
   .key_value (key_value[0])
  );
  
  
key u_key_2(
   .sys_clk (clk),
   .sys_rst_n (rst_n),
   .key (key[1]),
   .key_flag (key_flag[1]),
   .key_value (key_value[1])
  );
  
  
key u_key_3(
   .sys_clk (clk),
   .sys_rst_n (rst_n),
   .key (key[2]),
   .key_flag (key_flag[2]),
   .key_value (key_value[2])
  );
  
key u_key_4(
   .sys_clk (clk),
   .sys_rst_n (rst_n),
   .key (key[3]),
   .key_flag (key_flag[3]),
   .key_value (key_value[3])
  );
  
key u_key_5(
   .sys_clk (clk),
   .sys_rst_n (rst_n),
   .key (key[4]),
   .key_flag (key_flag[4]),
   .key_value (key_value[4])
  );
  
key u_key_6(
   .sys_clk (clk),
   .sys_rst_n (rst_n),
   .key (key[5]),
   .key_flag (key_flag[5]),
   .key_value (key_value[5])
  );
  
key u_key_7(
   .sys_clk (clk),
   .sys_rst_n (rst_n),
   .key (key[6]),
   .key_flag (key_flag[6]),
   .key_value (key_value[6])
  );
  
  
key u_key_8(
   .sys_clk (clk),
   .sys_rst_n (rst_n),
   .key (key[7]),
   .key_flag (key_flag[7]),
   .key_value (key_value[7])
  );
  
  
key u_key_9(
   .sys_clk (clk),
   .sys_rst_n (rst_n),
   .key (key[8]),
   .key_flag (key_flag[8]),
   .key_value (key_value[8])
  );
  
key u_key_10(
   .sys_clk (clk),
   .sys_rst_n (rst_n),
   .key (key[9]),
   .key_flag (key_flag[9]),
   .key_value (key_value[9])
  );
  
key u_key_11(
   .sys_clk (clk),
   .sys_rst_n (rst_n),
   .key (key[10]),
   .key_flag (key_flag[10]),
   .key_value (key_value[10])
  );
  
key u_key_12(
   .sys_clk (clk),
   .sys_rst_n (rst_n),
   .key (key[11]),
   .key_flag (key_flag[11]),
   .key_value (key_value[11])
  );
  
key u_key_13(
   .sys_clk (clk),
   .sys_rst_n (rst_n),
   .key (key[12]),
   .key_flag (key_flag[12]),
   .key_value (key_value[12])
  );

key u_key_14(
   .sys_clk (clk),
   .sys_rst_n (rst_n),
   .key (key[13]),
   .key_flag (key_flag[13]),
   .key_value (key_value[13])
  );

key u_key_15(
   .sys_clk (clk),
   .sys_rst_n (rst_n),
   .key (key[14]),
   .key_flag (key_flag[14]),
   .key_value (key_value[14])
  );

key u_key_state(
   .sys_clk (clk),
   .sys_rst_n (rst_n),
   .key (key_state),
   .key_flag (key_state_flag),
   .key_value (key_state_value)
  );


//buzzer模块
buzzer u_buzzer(
 .clk(clk),
 .rst_n(rst_n&(~key_pa)),
 .key_value(key_value[12:0]),
 .key_flag(key_flag[12:0]),
 .yinjie(yinjie),
 .stat(stat),
 .note(note),
 .PWM_out(pwm_out1)
 );
 
always@(negedge clk or negedge rst_n) begin //状态转换
	if(!rst_n)
		stat <= 1'b0;
	else begin
		if(stat == 1'b0) begin
			if(key_state_flag && ~key_state_value)
				stat <= 1'b1;
		end
		if(stat ==  1'b1) begin
			if(key_state_flag && ~key_state_value)
				stat <= 1'b0;
		end
	end
end

			

always@(negedge clk or negedge rst_n) begin //音程扩展
	if(!rst_n)
		yinjie <= 3'd1;
	else if(stat == 1'b0) begin
		if(key_flag[13] && ~key_value[13] && (yinjie > 3'd1))
			yinjie <= yinjie-3'd1;
		if(key_flag[14] && ~key_value[14] && (yinjie < 3'd3))
			yinjie <= yinjie+3'd1;
	end
end
	
// 时钟计数
always @(negedge clk or negedge rst_n) begin
	if(!rst_n)
		cnt <= 0;
	else if(cnt == 4500001)
		cnt <= 0;
	else
	   cnt <= cnt+1;
end

//生成四分之一拍的节拍脉冲信号
always@(negedge clk) begin
	if(cnt==4500000) //可通过更改条件值改变脉冲周期
		clk_beat<=1'b1;
	else
	   clk_beat<=1'b0;
end

always@(negedge clk) begin
		if(stat == 1'b1) begin
			if(clk_beat == 1'b1) begin
				if(count_beat < beat)
				    count_beat <= count_beat+5'd1;
				else begin
				    count_beat <= 5'd1;
				    if(count_note < 8'd214)
					    count_note <= count_note+8'd1;
				    else
					    count_note <= 8'd0;
				end
			end
	    end
end
	
always@(negedge clk) begin//音符表
    case(count_note)
	//奇迹再现
	8'd0:note = {6'd 0};
	8'd1:note = {6'd10};
	8'd2:note = {6'd10};
	//第一小节
	8'd3:note = {6'd10};
	8'd4:note = {6'd13};
	8'd5:note = {6'd22};
	8'd6:note = {6'd20};
	8'd7:note = {6'd20};
	8'd8:note = {6'd18};
	8'd9:note = {6'd 0};
	//第二小节
	8'd10:note = {6'd17};
	8'd11:note  = {6'd18};
	8'd12:note  = {6'd17};
	8'd13:note  = {6'd17};
	8'd14:note  = {6'd15};
	8'd15:note  = {6'd13};
	8'd16:note  = {6'd15};
	//第三小节
	8'd17:note  = {6'd10};
	8'd18:note  = {6'd13};
	8'd19:note  = {6'd22};
	8'd20:note  = {6'd20};
	8'd21:note  = {6'd20};
	8'd22:note  = {6'd18};
	8'd23:note  = {6'd 0};
	//第四小节
	8'd24:note  = {6'd17};
	8'd25:note  = {6'd18};
	8'd26:note  = {6'd17};
	8'd27:note  = {6'd15};
	8'd28:note  = {6'd15};
	8'd29:note  = {6'd10};
	//第五小节
	8'd30:note  = {6'd10};
	8'd31:note  = {6'd13};
	8'd32:note  = {6'd22};
	8'd33:note  = {6'd20};
	8'd34:note  = {6'd20};
	8'd35:note  = {6'd18};
	8'd36:note  = {6'd 0};
	8'd37:note  = {6'd17};
	//第六小节
	8'd38:note  = {6'd17};
	8'd39:note  = {6'd18};
	8'd40:note  = {6'd17};
	8'd41:note  = {6'd17};
	8'd42:note  = {6'd15};
	8'd43:note  = {6'd13};
	8'd44:note  = {6'd15};
	//第七小节
	8'd45:note  = {6'd10};
	8'd46:note  = {6'd13};
	8'd47:note  = {6'd22};
	8'd48:note  = {6'd20};
	8'd49:note  = {6'd20};
	8'd50:note  = {6'd18};
	8'd51:note  = {6'd 0};
	//第八小节
	8'd52:note  = {6'd17};
	8'd53:note  = {6'd18};
	8'd54:note = {6'd18};
	8'd55:note = {6'd22};
	8'd56:note = {6'd22};
	8'd57:note = {6'd22};
	8'd58:note = {6'd22};
	8'd59:note = {6'd22};
	//第九小节
	8'd 60:note = {6'd 0};
	8'd 61:note = {6'd13};
	8'd 62:note = {6'd10};
	8'd 63:note = {6'd12};
	8'd 64:note = {6'd13};
	8'd 65:note = {6'd 0};
	//第十小节
	8'd 66:note = {6'd15};
	8'd 67:note = {6'd13};
	8'd 68:note = {6'd12};
	8'd 69:note = {6'd12};
	8'd 70:note = {6'd13};
	//十一小节
	8'd 71:note = {6'd 0};
	8'd 72:note = {6'd13};
	8'd 73:note = {6'd10};
	8'd 74:note = {6'd12};
	8'd 75:note = {6'd13};
	8'd 76:note = {6'd 0};
	//十二小节
	8'd 77:note = {6'd17};
	8'd 78:note = {6'd15};
	8'd 79:note = {6'd15};
	8'd 80:note = {6'd15};
	8'd 81:note = {6'd17};
	//十三小节
	8'd 82:note = {6'd 0};
	8'd 83:note = {6'd13};
	8'd 84:note = {6'd 8};
	8'd 85:note = {6'd12};
	8'd 86:note = {6'd13};
	8'd 87:note = {6'd 0};
	//十四小节
	8'd 88:note = {6'd17};
	8'd 89:note = {6'd13};
	8'd 90:note = {6'd13};
	8'd 91:note = {6'd13};
	8'd 92:note = {6'd15};
	8'd 93:note = {6'd12};
	//十五小节
	8'd 94:note = {6'd12};
	//十六小节
	8'd 95:note = {6'd21};
	8'd 96:note = {6'd16};
	8'd 97:note = {6'd11};
	8'd 98:note = {6'd16};
	8'd 99:note = {6'd21};
	//十七小节
	8'd 100:note = {6'd 0};
	8'd 101:note = {6'd13};
	8'd 102:note = {6'd10};
	8'd 103:note = {6'd12};
	8'd 104:note = {6'd13};
	8'd 105:note = {6'd 0};
	//十八小节
	8'd 106:note = {6'd15};
	8'd 107:note = {6'd13};
	8'd 108:note = {6'd12};
	8'd 109:note = {6'd12};
	8'd 110:note = {6'd13};
	//十九小节
	8'd 111:note = {6'd 0};
	8'd 112:note = {6'd13};
	8'd 113:note = {6'd10};
	8'd 114:note = {6'd12};
	8'd 115:note = {6'd13};
	8'd 116:note = {6'd 0};
	//二十小节
	8'd 117:note = {6'd17};
	8'd 118:note = {6'd15};
	8'd 119:note = {6'd15};
	8'd 120:note = {6'd15};
	8'd 121:note = {6'd17};
	//二十一小节
	8'd 122:note = {6'd 0};
	8'd 123:note = {6'd15};
	8'd 124:note = {6'd 8};
	8'd 125:note = {6'd12};
	8'd 126:note = {6'd13};
	8'd 127:note = {6'd 0};
	//二十二小节
	8'd 128:note = {6'd17};
	8'd 129:note = {6'd13};
	8'd 130:note = {6'd13};
	8'd 131:note = {6'd13};
	8'd 132:note = {6'd15};
	8'd 133:note = {6'd12};
	//二十三小节
	8'd 134:note = {6'd12};
	8'd 135:note = {6'd20};
	8'd 136:note = {6'd15};
	8'd 137:note = {6'd22};
	8'd 138:note = {6'd15};
	8'd 139:note = {6'd29};
	//二十四小节
	8'd 140:note = {6'd29};
	8'd 141:note = {6'd10};
	8'd 142:note = {6'd12};//转1=E
	//二十五小节
	8'd 143:note = {6'd13};
	8'd 144:note = {6'd13};
	8'd 145:note = {6'd13};
	8'd 146:note = {6'd17};
	8'd 147:note = {6'd17};
	//二十六小节
	8'd 148:note = {6'd17};
	8'd 149:note = {6'd15};
	8'd 150:note = {6'd 0};
	8'd 151:note = {6'd 8};
	8'd 152:note = {6'd 8};
	//二十七小节
	8'd 153:note = {6'd17};
	8'd 154:note = {6'd17};
	8'd 155:note = {6'd17};
	8'd 156:note = {6'd15};
	8'd 157:note = {6'd15};
	//二十八小节
	8'd 158:note = {6'd15};
	8'd 159:note = {6'd13};
	8'd 160:note = {6'd13};
	8'd 161:note = {6'd12};
	8'd 162:note = {6'd10};
	//二十九小节
	8'd 163:note = {6'd10};
	8'd 164:note = {6'd13};
	8'd 165:note = {6'd13};
	8'd 166:note = {6'd12};
	8'd 167:note = {6'd 8};
	//三十小节
	8'd 168:note = {6'd 8};
	8'd 169:note = {6'd13};
	8'd 170:note = {6'd 0};
	8'd 171:note = {6'd13};
	8'd 172:note = {6'd13};
	//三十一小节
	8'd 173:note = {6'd15};
	8'd 174:note = {6'd10};
	8'd 175:note = {6'd12};
	8'd 176:note = {6'd13};
	8'd 177:note = {6'd12};
	//三十二小节
	8'd 178:note = {6'd12};
	//三十三小节
	8'd 179:note = {6'd13};
	8'd 180:note = {6'd13};
	8'd 181:note = {6'd13};
	8'd 182:note = {6'd17};
	8'd 183:note = {6'd17};
	//三十四小节
	8'd 184:note = {6'd17};
	8'd 185:note = {6'd15};
	8'd 186:note = {6'd 0};
	8'd 187:note = {6'd 8};
	8'd 188:note = {6'd 8};
	//三十五小节
	8'd 189:note = {6'd17};
	8'd 190:note = {6'd17};
	8'd 191:note = {6'd17};
	8'd 192:note = {6'd15};
	8'd 193:note = {6'd15};
	//三十六小节
	8'd 194:note = {6'd15};
	8'd 195:note = {6'd13};
	8'd 196:note = {6'd13};
	8'd 197:note = {6'd12};
	8'd 198:note = {6'd10};
	//三十七小节
	8'd 199:note = {6'd10};
	8'd 200:note = {6'd13};
	8'd 201:note = {6'd13};
	8'd 202:note = {6'd12};
	8'd 203:note = {6'd 8};
	//三十八小节
	8'd 204:note = {6'd 8};
	8'd 205:note = {6'd13};
	8'd 206:note = {6'd 0};
	8'd 207:note = {6'd13};
	8'd 208:note = {6'd13};
	//三十九小节
	8'd 209:note = {6'd13};
	8'd 210:note = {6'd10};
	8'd 211:note = {6'd12};
	8'd 212:note = {6'd13};
	8'd 213:note = {6'd12};
	//四十小节
	8'd 214:note = {6'd12};
	endcase
end

     
always@(negedge clk) begin//节拍表
	case(count_note)
	//奇迹再现
	8'd0 :beat = {5'd 2};
	8'd1 :beat = {5'd 2};
	8'd2 :beat = {5'd 4};
	//第一小节
	8'd3 :beat = {5'd 2};
	8'd4 :beat = {5'd 2};
	8'd5 :beat = {5'd 2};
	8'd6 :beat = {5'd 2};
	8'd7 :beat = {5'd 2};
	8'd8 :beat = {5'd 2};
	8'd9 :beat = {5'd 4};
	//第二小节
	8'd10 :beat = {5'd 4};
	8'd11 :beat = {5'd 2};
	8'd12 :beat = {5'd 2};
	8'd13 :beat = {5'd 2};
	8'd14 :beat = {5'd 2};
	8'd15 :beat = {5'd 2};
	8'd16 :beat = {5'd 2};
	//第三小节
	8'd17 :beat = {5'd 2};
	8'd18 :beat = {5'd 2};
	8'd19 :beat = {5'd 2};
	8'd20 :beat = {5'd 2};
	8'd21 :beat = {5'd 2};
	8'd22 :beat = {5'd 2};
	8'd23 :beat = {5'd 4};
	//第四小节
	8'd24 :beat = {5'd 2};
	8'd25 :beat = {5'd 2};
	8'd26 :beat = {5'd 2};
	8'd27 :beat = {5'd 2};
	8'd28 :beat = {5'd 6};
	8'd29 :beat = {5'd 2};
	//第五小节
	8'd30 :beat = {5'd 2};
	8'd31 :beat = {5'd 2};
	8'd32 :beat = {5'd 2};
	8'd33 :beat = {5'd 2};
	8'd34 :beat = {5'd 2};
	8'd35 :beat = {5'd 2};
	8'd36 :beat = {5'd 2};
	8'd37 :beat = {5'd 2};
	//第六小节
	8'd38 :beat = {5'd 4};
	8'd39 :beat = {5'd 2};
	8'd40 :beat = {5'd 2};
	8'd41 :beat = {5'd 2};
	8'd42 :beat = {5'd 2};
	8'd43 :beat = {5'd 2};
	8'd44 :beat = {5'd 2};
	//第七小节
	8'd45 :beat = {5'd 2};
	8'd46 :beat = {5'd 2};
	8'd47 :beat = {5'd 2};
	8'd48 :beat = {5'd 2};
	8'd49 :beat = {5'd 2};
	8'd50 :beat = {5'd 2};
	8'd51 :beat = {5'd 4};
	//第八小节
	8'd52 :beat = {5'd 2};
	8'd53 :beat = {5'd 2};
	8'd54 :beat = {5'd 2};
	8'd55 :beat = {5'd 2};
	8'd56 :beat = {5'd 2};
	8'd57 :beat = {5'd 2};
	8'd58 :beat = {5'd 1};
	8'd59 :beat = {5'd 3};
	//第九小节
	8'd60 :beat = {5'd 4};
	8'd61 :beat = {5'd 2};
	8'd62 :beat = {5'd 2};
	8'd63 :beat = {5'd 2};
	8'd64 :beat = {5'd 2};
	8'd65 :beat = {5'd 4};
	//第十小节
	8'd66 :beat = {5'd 4};
	8'd67 :beat = {5'd 2};
	8'd68 :beat = {5'd 2};
	8'd69 :beat = {5'd 2};
	8'd70 :beat = {5'd 6};
	//十一小节
	8'd71 :beat = {5'd 4};
	8'd72 :beat = {5'd 2};
	8'd73 :beat = {5'd 2};
	8'd74 :beat = {5'd 2};
	8'd75 :beat = {5'd 2};
	8'd76 :beat = {5'd 4};
	//十二小节
	8'd77 :beat = {5'd 4};
	8'd78 :beat = {5'd 2};
	8'd79 :beat = {5'd 2};
	8'd80 :beat = {5'd 2};
	8'd81 :beat = {5'd 6};
	//十三小节
	8'd82 :beat = {5'd 4};
	8'd83 :beat = {5'd 2};
	8'd84 :beat = {5'd 2};
	8'd85 :beat = {5'd 2};
	8'd86 :beat = {5'd 2};
	8'd87 :beat = {5'd 4};
	//十四小节
	8'd88 :beat = {5'd 4};
	8'd89 :beat = {5'd 2};
	8'd90 :beat = {5'd 2};
	8'd91 :beat = {5'd 2};
	8'd92 :beat = {5'd 4};
	8'd93 :beat = {5'd 2};
	//十五小节
	8'd94 :beat = {5'd16};
	//十六小节
	8'd95 :beat = {5'd 2};
	8'd96 :beat = {5'd 4};
	8'd97 :beat = {5'd 4};
	8'd98 :beat = {5'd 2};
	8'd99 :beat = {5'd 4};
	//十七小节
	8'd100 :beat = {5'd 4};
	8'd101 :beat = {5'd 2};
	8'd102 :beat = {5'd 2};
	8'd103 :beat = {5'd 2};
	8'd104 :beat = {5'd 2};
	8'd105 :beat = {5'd 4};
	//十八小节
	8'd106 :beat = {5'd 4};
	8'd107 :beat = {5'd 2};
	8'd108 :beat = {5'd 2};
	8'd109 :beat = {5'd 2};
	8'd110 :beat = {5'd 6};
	//十九小节
	8'd111 :beat = {5'd 4};
	8'd112 :beat = {5'd 2};
	8'd113 :beat = {5'd 2};
	8'd114 :beat = {5'd 2};
	8'd115 :beat = {5'd 2};
	8'd116 :beat = {5'd 4};
	//二十小节
	8'd117 :beat = {5'd 4};
	8'd118 :beat = {5'd 2};
	8'd119 :beat = {5'd 2};
	8'd120 :beat = {5'd 2};
	8'd121 :beat = {5'd 6};
	//二十一小节
	8'd122 :beat = {5'd 4};
	8'd123 :beat = {5'd 2};
	8'd124 :beat = {5'd 2};
	8'd125 :beat = {5'd 2};
	8'd126 :beat = {5'd 2};
	8'd127 :beat = {5'd 4};
	//二十二小节
	8'd128 :beat = {5'd 4};
	8'd129 :beat = {5'd 2};
	8'd130 :beat = {5'd 2};
	8'd131 :beat = {5'd 2};
	8'd132 :beat = {5'd 4};
	8'd133 :beat = {5'd 2};
	//二十三小节
	8'd134 :beat = {5'd 4};
	8'd135 :beat = {5'd 2};
	8'd136 :beat = {5'd 2};
	8'd137 :beat = {5'd 2};
	8'd138 :beat = {5'd 2};
	8'd139 :beat = {5'd 4};
	//二十四小节
	8'd140 :beat = {5'd12};
	8'd141 :beat = {5'd 2};
	8'd142 :beat = {5'd 2};
	//二十五小节
	8'd143 :beat = {5'd 4};
	8'd144 :beat = {5'd 4};
	8'd145 :beat = {5'd 4};
	8'd146 :beat = {5'd 2};
	8'd147 :beat = {5'd 2};
	//二十六小节
	8'd148 :beat = {5'd 2};
	8'd149 :beat = {5'd 6};
	8'd150 :beat = {5'd 4};
	8'd151 :beat = {5'd 2};
	8'd152 :beat = {5'd 2};
	//二十七小节
	8'd153 :beat = {5'd 4};
	8'd154 :beat = {5'd 4};
	8'd155 :beat = {5'd 4};
	8'd156 :beat = {5'd 2};
	8'd157 :beat = {5'd 2};
	//二十八小节
	8'd158 :beat = {5'd 2};
	8'd159 :beat = {5'd 6};
	8'd160 :beat = {5'd 4};
	8'd161 :beat = {5'd 2};
	8'd162 :beat = {5'd 2};
	//二十九小节
	8'd163 :beat = {5'd 2};
	8'd164 :beat = {5'd 6};
	8'd165 :beat = {5'd 4};
	8'd166 :beat = {5'd 2};
	8'd167 :beat = {5'd 2};
	//三十小节
	8'd168 :beat = {5'd 2};
	8'd169 :beat = {5'd 6};
	8'd170 :beat = {5'd 4};
	8'd171 :beat = {5'd 2};
	8'd172 :beat = {5'd 2};
	//三十一小节
	8'd173 :beat = {5'd 4};
	8'd174 :beat = {5'd 4};
	8'd175 :beat = {5'd 2};
	8'd176 :beat = {5'd 4};
	8'd177 :beat = {5'd 2};
	//三十二小节
	8'd178 :beat = {5'd16};
	//三十三小节
	8'd179 :beat = {5'd 4};
	8'd180 :beat = {5'd 4};
	8'd181 :beat = {5'd 4};
	8'd182 :beat = {5'd 2};
	8'd183 :beat = {5'd 2};
	//三十四小节
	8'd184 :beat = {5'd 2};
	8'd185 :beat = {5'd 6};
	8'd186 :beat = {5'd 4};
	8'd187 :beat = {5'd 2};
	8'd188 :beat = {5'd 2};
	//三十五小节
	8'd189 :beat = {5'd 4};
	8'd190 :beat = {5'd 4};
	8'd191 :beat = {5'd 4};
	8'd192 :beat = {5'd 2};
	8'd193 :beat = {5'd 2};
	//三十六小节
	8'd194 :beat = {5'd 2};
	8'd195 :beat = {5'd 6};
	8'd196 :beat = {5'd 4};
	8'd197 :beat = {5'd 2};
	8'd198 :beat = {5'd 2};
	//三十七小节
	8'd199 :beat = {5'd 2};
	8'd200 :beat = {5'd 6};
	8'd201 :beat = {5'd 4};
	8'd202 :beat = {5'd 2};
	8'd203 :beat = {5'd 2};
	//三十八小节
	8'd204 :beat = {5'd 2};
	8'd205 :beat = {5'd 6};
	8'd206 :beat = {5'd 4};
	8'd207 :beat = {5'd 2};
	8'd208 :beat = {5'd 2};
	//三十九小节
	8'd209 :beat = {5'd 4};
	8'd210 :beat = {5'd 4};
	8'd211 :beat = {5'd 2};
	8'd212 :beat = {5'd 4};
	8'd213 :beat = {5'd 2};
	//四十小节
	8'd214 :beat = {5'd24};	
    endcase
end	
	
 endmodule