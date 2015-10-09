module inplace_dec6466 (
                      clk,
                      reset_n,
                      in_data,
                      in_valid
                     );

  input clk;
  input reset_n;
  input [65:0] in_data;
  input in_valid;


  wire [1:0]  sync_header;
  reg  [57:0] data_prev;
  wire [57:0] data_to_save;


//  assign sync_header = in_data[1:0];
//we detect the sync head at tail
  assign sync_header = in_data[65:64];
  assign data_to_save = reset_n==1'b0                                         ? 58'h0 :
                        in_valid                    ? in_data[65-2:8-2] ://now the sync head is at tail
                                                                    data_prev ;

  always @(posedge clk)
    begin
      data_prev <= data_to_save;
    end

  wire [63:0] data_shifted_39;
  wire [63:0] data_shifted_58;
  wire [63:0] block_payload;
  wire [65:0] data;

  assign data_shifted_39 = {in_data[26-2:2-2], data_prev[57:19]};//now the sync head is at tail
  assign data_shifted_58 = {in_data[7-2:2-2], data_prev};//now the sync head is at tail
  assign block_payload = in_data[65-2:2-2] ^ data_shifted_39 ^ data_shifted_58;//now the sync head is at tail
  assign data = {sync_header,block_payload};


endmodule
