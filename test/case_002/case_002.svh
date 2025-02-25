`ifndef _case_002_svh_
`define _case_002_svh_

task case_002();

automatic integer   i = 0;
automatic integer   j = 0;

$display("Running case 002");
$display("Transmitting a proper packet to RMII port 1 with the MAC destination of RMII port 0");

testbench.ethernet_message[0]   = 8'h55;
testbench.ethernet_message[1]   = 8'h55;
testbench.ethernet_message[2]   = 8'h55;
testbench.ethernet_message[3]   = 8'h55;
testbench.ethernet_message[4]   = 8'h55;
testbench.ethernet_message[5]   = 8'h55;
testbench.ethernet_message[6]   = 8'h55;

testbench.ethernet_message[7]   = 8'hD5;

testbench.ethernet_message[8]   = 8'hF6;
testbench.ethernet_message[9]   = 8'h90;
testbench.ethernet_message[10]  = 8'h2A;
testbench.ethernet_message[11]  = 8'h94;
testbench.ethernet_message[12]  = 8'h2D;
testbench.ethernet_message[13]  = 8'h5E;

testbench.ethernet_message[14]  = 8'hB8;
testbench.ethernet_message[15]  = 8'h27;
testbench.ethernet_message[16]  = 8'hEB;
testbench.ethernet_message[17]  = 8'hBA;
testbench.ethernet_message[18]  = 8'h99;
testbench.ethernet_message[19]  = 8'hD6;
//type
testbench.ethernet_message[20]  = 8'h08;
testbench.ethernet_message[21]  = 8'h00;
//ipv4 version header len
testbench.ethernet_message[22]  = 8'h45;
//ipv4 tos
testbench.ethernet_message[23]  = 8'h00;
//ipv4 total length
testbench.ethernet_message[24]  = 8'h00;
testbench.ethernet_message[25]  = 8'h2A;
//ipv4 id
testbench.ethernet_message[26]  = 8'h83;
testbench.ethernet_message[27]  = 8'h4F;
//ipv4 flags
testbench.ethernet_message[28]  = 8'h40;
testbench.ethernet_message[29]  = 8'h00;
//ipv4 tl
testbench.ethernet_message[30]  = 8'h40;
//ipv4 protocol
testbench.ethernet_message[31]  = 8'h11;
//ipv4 header checksum
testbench.ethernet_message[32]  = 8'h66;
testbench.ethernet_message[33]  = 8'h76;
//ipv4 source ip
testbench.ethernet_message[34]  = 8'hAC;
testbench.ethernet_message[35]  = 8'h10;
testbench.ethernet_message[36]  = 8'h7C;
testbench.ethernet_message[37]  = 8'h6B;
//ipv4 destination ip
testbench.ethernet_message[38]  = 8'hAC;
testbench.ethernet_message[39]  = 8'h10;
testbench.ethernet_message[40]  = 8'h7C;
testbench.ethernet_message[41]  = 8'h71;
//udp source port
testbench.ethernet_message[42]  = 8'h44;
testbench.ethernet_message[43]  = 8'h44;
//udp destination port
testbench.ethernet_message[44]  = 8'h44;
testbench.ethernet_message[45]  = 8'h44;
//udp length
testbench.ethernet_message[46]  = 8'h00;
testbench.ethernet_message[47]  = 8'h16;
//udp checksum
testbench.ethernet_message[48]  = 8'h4E;
testbench.ethernet_message[49]  = 8'h59;
//udp payload
testbench.ethernet_message[50]  = 8'hAB;
testbench.ethernet_message[51]  = 8'hCD;
testbench.ethernet_message[52]  = 8'h61;
testbench.ethernet_message[53]  = 8'h97;
testbench.ethernet_message[54]  = 8'hE1;
testbench.ethernet_message[55]  = 8'hC2;
testbench.ethernet_message[56]  = 8'h04;
testbench.ethernet_message[57]  = 8'hA6;
testbench.ethernet_message[58]  = 8'hE3;
testbench.ethernet_message[59]  = 8'h12;
testbench.ethernet_message[60]  = 8'h01;
testbench.ethernet_message[61]  = 8'h00;
testbench.ethernet_message[62]  = 8'h00;
testbench.ethernet_message[63]  = 8'h02;
//pad
testbench.ethernet_message[64]  = 8'h00;
testbench.ethernet_message[65]  = 8'h00;
testbench.ethernet_message[66]  = 8'h00;
testbench.ethernet_message[67]  = 8'h00;
//crc32
testbench.ethernet_message[68]  = 8'h2F;
testbench.ethernet_message[69]  = 8'hB0;
testbench.ethernet_message[70]  = 8'hDF;
testbench.ethernet_message[71]  = 8'hC5;


for (i=0;i<72;i=i+1) begin
    @(posedge testbench.clock);
    testbench.ethernet_transmit_data_valid[1]       =   1;
    testbench.ethernet_transmit_data[1]             =   testbench.ethernet_message[i][1:0];
    @(posedge testbench.clock);
    testbench.ethernet_transmit_data[1]             =   testbench.ethernet_message[i][3:2];
    @(posedge testbench.clock);
    testbench.ethernet_transmit_data[1]             =   testbench.ethernet_message[i][5:4];
    @(posedge testbench.clock);
    testbench.ethernet_transmit_data[1]             =   testbench.ethernet_message[i][7:6];
end
@(posedge testbench.clock);
testbench.ethernet_transmit_data[1]          =   0;
testbench.ethernet_transmit_data_valid[1]    =   0;

fork : f0
    begin
        #1ms;
        $fatal(0, "%t : timeout while waiting for checksum valid", $time);
        disable f0;
    end
    begin
        wait (testbench.switch_core.genblk1[1].rmii_port.ethernet_packet_parser_checksum_result_enable == 1);
        disable f0;
    end
join
@(posedge testbench.switch_core.genblk1[1].rmii_port.clock);
@(posedge testbench.switch_core.genblk1[1].rmii_port.clock);
assert (testbench.switch_core.genblk1[1].rmii_port.ethernet_packet_parser_good_packet != 0) $display ("Good packet detected correctly on RMII port 1");
    else $fatal("Packet was detected as bad when it should have been good");

fork : f1
    begin
        #1ms;
        $fatal(0, "%t : timeout while waiting for RMII port 0 to start trasmitting", $time);
        disable f1;
    end
    begin
        wait (testbench.switch_core.genblk1[1].rmii_port.rmii_transmit_data_valid == 1);
        $display("Switch routed packet correctly to RMII port 1");
        disable f1;
    end
join

endtask: case_002

`endif