module XFIPCS_LOCK_FSM (
	in_enable,
                     clk,
                     reset_n,

                     sh_valid,
                     signal_ok,
                     slip_done_set,
                     test_sh_set,

                     block_lock,
                     slip
                    );
input in_enable;
input           clk;
input           reset_n;
input           signal_ok;
input           sh_valid;
input           slip_done_set;
input           test_sh_set;
output          block_lock;
output          slip;

reg             block_lock;
reg     [2:0]   lock_state;
reg     [6:0]   sh_cnt;
reg     [4:0]   sh_invalid_cnt;
reg             slip;
wire            slip_done;
reg             block_lock_nxt;
reg     [2:0]   lock_state_nxt;
reg     [6:0]   sh_cnt_nxt;
reg     [4:0]   sh_invalid_cnt_nxt;
reg             slip_done_nxt;
reg             slip_done_clear_nxt;
reg             slip_done_clear;
reg             slip_nxt;
reg             slip_done_prev;
reg             test_sh;
reg             test_sh_nxt;

parameter LOCK_INIT  = 3'b000;
parameter RESET_CNT  = 3'b001;
parameter TEST_SH    = 3'b010;
parameter VALID_SH   = 3'b011;
parameter GOOD_64    = 3'b100;
parameter INVALID_SH = 3'b101;
parameter SLIP       = 3'b110;

assign slip_done = (slip_done_prev || slip_done_set) && ~slip_done_clear;

always @( * )
begin : fsm
  lock_state_nxt = lock_state;
  block_lock_nxt = block_lock;
  sh_cnt_nxt = sh_cnt;
  sh_invalid_cnt_nxt = sh_invalid_cnt;
  test_sh_nxt = test_sh || test_sh_set;
  slip_nxt = 1'b0;
  slip_done_clear_nxt = 1'b0;
  if (reset_n == 1'b0 || signal_ok == 1'b0)
  begin
    lock_state_nxt = LOCK_INIT;
    block_lock_nxt = 1'b0;
    sh_invalid_cnt_nxt = 5'h00;
    test_sh_nxt = 1'b0;
  end
  else if(in_enable)
  begin
    case (lock_state)
      LOCK_INIT :
        begin
          lock_state_nxt = RESET_CNT;
          sh_cnt_nxt = 7'h00;
          sh_invalid_cnt_nxt = 5'h00 ;
          slip_done_clear_nxt = 1'b1;
        end
      RESET_CNT :
        begin
          if (test_sh == 1'b1)
          begin
            lock_state_nxt = TEST_SH;
            test_sh_nxt = 1'b0;
          end
          else slip_done_clear_nxt = 1'b1;
        end
      TEST_SH :
        begin
          if (sh_valid == 1'b1)
            begin
              lock_state_nxt = VALID_SH;
              sh_cnt_nxt = sh_cnt + 1;
            end
          else
            begin
              lock_state_nxt = INVALID_SH;
              sh_cnt_nxt = sh_cnt + 1;
              sh_invalid_cnt_nxt = sh_invalid_cnt + 1;
            end
        end
      VALID_SH :
        begin
          if (sh_cnt[6] == 1'b1 && sh_invalid_cnt == 5'h00)
            begin
              lock_state_nxt = GOOD_64;
              block_lock_nxt = 1'b1;
            end
          else if (sh_cnt[6] == 1'b1)
            begin
              lock_state_nxt = RESET_CNT;
              sh_cnt_nxt = 7'h00;
              sh_invalid_cnt_nxt = 5'h00 ;
              slip_done_clear_nxt = 1'b1;
            end
          else if (test_sh && sh_cnt[6] == 1'b0)
            begin
              lock_state_nxt = TEST_SH;
              test_sh_nxt = 1'b0;
            end
          else sh_cnt_nxt = sh_cnt + 1;
        end
      INVALID_SH :
        begin
          if (sh_invalid_cnt[4] == 1'b1 || block_lock == 1'b0)
            begin
              lock_state_nxt = SLIP;
              block_lock_nxt = 1'b0;
              slip_nxt = 1'b1;
            end
          else if (sh_cnt[6] == 1'b1)
            begin
              lock_state_nxt = RESET_CNT;
              sh_cnt_nxt = 7'h00;
              sh_invalid_cnt_nxt = 5'h00 ;
              slip_done_clear_nxt = 1'b1;
            end
          else if (test_sh == 1'b1)
            begin
              lock_state_nxt = TEST_SH;
              test_sh_nxt = 1'b0;
            end
          else
            begin
              sh_cnt_nxt = sh_cnt + 1;
              sh_invalid_cnt_nxt = sh_invalid_cnt + 1;
            end
        end
      GOOD_64 :
        begin
          lock_state_nxt = RESET_CNT;
          sh_cnt_nxt = 7'h00;
          sh_invalid_cnt_nxt = 5'h00 ;
          slip_done_clear_nxt = 1'b1;
        end
      SLIP :
        if (slip_done == 1'b1)
          begin
            lock_state_nxt = RESET_CNT;
            sh_cnt_nxt = 7'h00;
            sh_invalid_cnt_nxt = 5'h00 ;
            slip_done_clear_nxt = 1'b1;
          end
        else slip_nxt = 1'b1;
      default :
        begin
          lock_state_nxt = lock_state;
          block_lock_nxt = block_lock;
        end
    endcase
  end
end

always @(posedge clk)
  begin : flops
    block_lock      <= block_lock_nxt;
    lock_state      <= lock_state_nxt;
    sh_cnt          <= sh_cnt_nxt;
    sh_invalid_cnt  <= sh_invalid_cnt_nxt;
    slip            <= slip_nxt;
    slip_done_prev  <= slip_done;
    slip_done_clear <= slip_done_clear_nxt;
    test_sh         <= test_sh_nxt;
  end

endmodule
