module buzzer(
 input clk,//����ʱ��(48MHZ)
 input rst_n,//��λ�ź�
 input [12:0] key_value,//���������������
 input [12:0] key_flag,//����������Ч�ź�
 input [2:0] yinjie,//������״̬������
 input stat,//״̬��־
 input [5:0] note,//����
 output PWM_out//pwm���
);

reg  [17:0]   CNT;		//ʱ�Ӽ�����				
reg [17:0] cycle;	//pwm����ֵ
reg PWM;
reg [2:0] yinjie_box;//���ֺ�״̬�¸���note�ı�����

	initial begin
		cycle = 18'd0;
		yinjie_box = 3'd1;
	end  
  
  
	//�����������������pwmƵ��Ϊ��48MHz/cycle
always @(negedge clk or negedge rst_n) begin
	     if(!rst_n)
			 CNT <= 18'd0;
		 else if(CNT >= cycle - 1)
		     CNT <= 18'd0;
		 else begin
			 if(stat == 1'b0)
				 CNT <= CNT + yinjie;  
		     if(stat == 1'b1)
				 CNT <= CNT + yinjie_box;  
		 end
end


//�ı�Ƶ��
always@(negedge clk) begin
		if(stat == 1'b0) begin//������״̬
			if(key_flag[0] && ~key_value[0])
		        cycle <= 18'd183465;//C1
			if(key_flag[1] && ~key_value[1])
				cycle <= 18'd173172;//C1#/D1B
			if(key_flag[2] && ~key_value[2])
				cycle <= 18'd163454;//D1
			if(key_flag[3] && ~key_value[3])
				cycle <= 18'd154276;//D1#/E1B
			if(key_flag[4] && ~key_value[4])
				cycle <= 18'd145618;//E1
			if(key_flag[5] && ~key_value[5])	
				cycle <= 18'd137288;//F1
			if(key_flag[6] && ~key_value[6])
				cycle <= 18'd129733;//F1#/G1B
			if(key_flag[7] && ~key_value[7])
				cycle <= 18'd122449;//G1
			if(key_flag[8] && ~key_value[8])
				cycle <= 18'd115579;//G1#/A1B
			if(key_flag[9] && ~key_value[9])
				cycle <= 18'd109091;//A1
			if(key_flag[10] && ~key_value[10])
				cycle <= 18'd102969;//A1#/B1B
			if(key_flag[11] && ~key_value[11])
				cycle <= 18'd97190;//B1
			if(key_flag[12] && ~key_value[12])
				cycle <= 18'd91734;//C2
		end
		if(stat == 1'b1) begin//���ֺ�״̬
			case(note%12)
		        6'd0:begin
				    if(note/12)
					    cycle <= 18'd97190;
					else
					    cycle <= 0;
				end
		    	6'd1:cycle <= 18'd183465;
		    	6'd2:cycle <= 18'd173172;
		    	6'd3:cycle <= 18'd163454;
	    		6'd4:cycle <= 18'd154276;
	    		6'd5:cycle <= 18'd145618;
		    	6'd6:cycle <= 18'd137288;
		    	6'd7:cycle <= 18'd129733;
	    		6'd8:cycle <= 18'd122449;
	    		6'd9:cycle <= 18'd115579;
	    		6'd10:cycle <= 18'd109091;
		    	6'd11:cycle <= 18'd102969;
		    	default:cycle <= 0;
	    	endcase
		end
end

//���ֺ�״̬�¸���note�ı�����
always @(negedge clk)
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

//����ռ�ձ�
always @(negedge clk) begin 
      if(CNT == 16'd0)
		    PWM <= 1'b1;
		else if(CNT < cycle/2) //50%ռ�ձ�
		    PWM <= 1'b1;
		else
          PWM <= 1'b0;		
end

assign	PWM_out = (key_value[12:0] != 13'h1FFF || stat == 1'b1)? PWM:1'b0;//��������ʱ���pwm
	
endmodule

