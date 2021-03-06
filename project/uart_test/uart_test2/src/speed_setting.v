`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:01:24 07/08/2020 
// Design Name: 
// Module Name:    speed_setting 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module speed_setting(
				clk,rst_n,
				bps_start,clk_bps
			);

input clk;	// 25MHz主时钟
input rst_n;	//低电平复位信号
input bps_start;	//接收到数据后，波特率时钟启动信号置位
output clk_bps;	// clk_bps的高电平为接收或者发送数据位的中间采样点 

`define CLK_PERIORD	40	//定义时钟周期为40ns(25MHz)
`define BPS_SET		192	//定义通信波特率为19200bps

`define BPS_PARA	(10_000_000/`CLK_PERIORD/`BPS_SET)//10_000_000/`CLK_PERIORD/192;		//波特率为19200时的分频计数值
`define BPS_PARA_2	(`BPS_PARA/2)//BPS_PARA/2;	//波特率为19200时的分频计数值的一半，用于数据采样

reg[15:0] cnt;			//分频计数
reg clk_bps_r;			//波特率时钟寄存器

//----------------------------------------------------------

always @ (posedge clk or negedge rst_n)
	if(!rst_n) cnt <= 16'd0;
	else if((cnt == `BPS_PARA) || !bps_start) cnt <= 16'd0;	//波特率计数清零
	else cnt <= cnt+1'b1;			//波特率时钟计数启动

always @ (posedge clk or negedge rst_n)
	if(!rst_n) clk_bps_r <= 1'b0;
	else if(cnt == `BPS_PARA_2) clk_bps_r <= 1'b1;	// clk_bps_r高电平为接收数据位的中间采样点,同时也作为发送数据的数据改变点
	else clk_bps_r <= 1'b0;

assign clk_bps = clk_bps_r;

endmodule


