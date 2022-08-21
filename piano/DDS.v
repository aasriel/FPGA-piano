module DDS(
 input clk,
 input rst_n,
 input key_value,
 input [2:0] yinjie,
 input [2:0] yinjie_box,
 input stat,
 input [15:0] fcw,
 output reg [24:0] count
 );//��λ�ۼ���
 
 reg [15:0] fcw_r;
  
    always @( negedge clk )//����״̬�����̸ı�����
	    begin
		    if(stat == 1'b0)
			    fcw_r <= fcw*yinjie;
			if(stat == 1'b1)
			    fcw_r <= fcw*yinjie_box;
		end
  
  
    always @( negedge clk or negedge rst_n)//��ַ�ۼӣ��½��ظı�
        begin
			if(!rst_n)
				count <= 0;
		    else if(~key_value)
				count<=count+fcw_r;//�ı��ۼ����ֿɸı����Ƶ��
			else
				count <= 0;
        end
     
 endmodule