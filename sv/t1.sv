//package definition
package types;
	class D #(parameter int l=1);
		int md = l;
	endclass : D

	class C #(parameter int m = 2) extends D #(.l(4));
		int mc = m;
	endclass :C
endpackage: types

//port declaration is <direction> + <kind> + <type> +<name>
module t1 (input var int i1,
input  int i2,
output o1);
	//localparam can not be customized on instantiation
	localparam ll=1;
	import types::*;

	class B extends C #(.m(3));
		function print() ;
		begin
			//%m can print hierachy
			$display("%m.mc %d md %d",mc,md);
		end
		endfunction
	endclass :B

	B bB = new;
	initial begin
		//forced type conversion
		void'(bB.print());
	end

	typedef enum {FALSE,TRUE} boolT;
	typedef struct packed {
		integer t1;
		integer t2;
	} ssypack;
	
	class ssy #(parameter boolT yesorno=FALSE);
		string s1;
		string s2[100];
		string s3[];
		logic [1:0][3:0] ttt2 ;
		logic [2:0][3:0] ttt [1:0];
		boolT yn=yesorno.first();
		ssypack sp;
		struct {logic [3:0] ssy; bit sb;} v1;
	
		string fada[0:3][];
		logic da [][0:3];
	
		//associative array
		int myArr[byte];
		int myArr1[string];
	
	
		//queue
		typedef int q_t[$];
		q_t q;
		q_t q1;
		q_t q2;
		
		//const can only be assign here
		const int j=8;
	
		//local availabel to only this class
		local int u1;
		//only to this class and its sub class
		protected int u2;
		//global const with init value at declaration
		const int u3=1;
		//instance const initialized at new 
		const int u4;
	
	
		function new ();
		begin
			int i;
			u4 = 1;
			s1 = "s1";
			s2[0] = "s20";
			s2[1] = "s21";
			s3 = new[10];
			s3[9] = "s39";
	
			s3 = new[20](s3);
			$display ("s39 %s",s3[9]);
	
			$display ("in new %s",s1);
			v1.ssy= 4'b0;
			ttt[1][2][3] =1'b0;
			ttt[1][2][2] =1'bz;
			//ttt[1:0][2][2] =2'b11;//operation on unpack will fail
			ttt[1][2][2:1] =2'b11;//this is ok on packed array
			//ttt[1][2:1][2] =2'b11;//this fail on non last index
	//		$display("dim of ttt2 %d" ,$unpacked_dimensions(ttt2));
			$display("size of ttt2 1 %d" ,$size(ttt2,1));
	
	
			for(i=0;i<=3;i=i+1) begin
				fada[i] = new [10];
			end
	
			da = new[10];
			da[9][1]=1'b0;
	
	
			//associative array
			myArr[-55] = 56;
			myArr1["haha"] = 55;
			if(myArr1.exists("haha")) begin
				$display("szie of myArr %d" , myArr.num());
			end
	
			//queue
			q.push_front(1);
			q.push_front(2);
			q.push_front(3);
			q.push_front(4);
	
			q1 = q.find with (item>2);
			q2 = q.find_index with (item == 3);
	
			$display("q size %d",q.size());
	
			$display("q %d",q.pop_back());
			$display("q %d",q.pop_front());
			$display("q %d",q.pop_front());
			$display("q %d",q.pop_front());
	
			$display("q1 size %d",q1.size());
			$display("q2 size %d",q2.size());
			
			//const assignment fail
			//j=2;
		end
		endfunction : new
	endclass :ssy
	
	//class that can only `be inherent and not be instance
	virtual class vclass ;
	endclass : vclass
	
	ssy #(TRUE) dc;
	
	initial begin
		dc = new ;
		//ssy dc1 = new;
		dc.s1 = "s1";
		dc.s2[99] = "s2100";
		$display ("%s",dc.s1);
		$display ("%s",dc.s2[99]);
		$display ("%s",dc.s3[9]);
		if(dc.yn==TRUE) begin
			$display("TRUE");
		end
	end

	initial begin
		reg [3:0] op;
		op = 4'b000X;
		//wildcase comaprision ==? and !=?
		//the dont compare those positions with X and Z on right hand side
		if(op==?4'b000X) begin
			$display("000X==?000X");
		end
		//unique make sure that the if and case statements
		//have exclusive branches
		// the simulator and synthesizer should check this
		// and optimize the synthesis result
		unique if(op!=?4'b100X) begin
			$display("000X!=?100X");
		end
	end
	


	reg clk;
	initial begin
		clk = 0;
		forever begin
			#10ns clk = !clk;
		end
	
	end

	typedef struct packed {int a; int b,c;} packT;
	packT p1 = packT'{a:1,b:2,c:3};
	typedef logic [1:0] t;
	t t1 = t'{1:0,0:1};

	initial begin
		for(integer i=0;i<10;i++) begin
			$display("integer %d",i);
		end
	end

	class c;
		int arr[];
	endclass: c

	c carr[5];
	initial begin
		foreach (carr[i]) begin
			$display("carr i %d",i);
			carr[i] = new;
			carr[i].arr= new[i];
			foreach (carr[i].arr[j]) begin
				carr[i].arr[j] = i*10 +j;
			end
		end

		foreach (carr[i]) begin
			foreach (carr[i].arr[j]) begin
				$display("carr arr %d",carr[i].arr[j]);
			end
		end
	end


	reg seqreg;
	always_ff @(posedge clk) begin
		seqreg <= 1'b1;
	end

	reg comreg;
	always_comb   begin
		comreg = seqreg;
	end

	class R1 ;
		//rand can have overlapped value in range
		rand int i1;
		//while randc enumerate each permutation  without overlapp
		randc int ic1;
		rand int a;

		constraint c1 {i1>0 && i1<3;}
		constraint cc1 {ic1>0 && ic1<10;}
		//constrain with precondition
		constraint c2 {
		(i1==1) -> {a inside {3,4,[5:10]};}
		(i1==2) -> {a inside {30,40,[50:100]};}
		}

		//constraint with wait on range and value,
		//here weight is for each element of range
		rand int b;
		constraint c3 {b dist {100:=1,[101:109]:=1,110:=2};}
		rand int c;
		//wait for thw whole range
		constraint c4 {c dist {100:=1,[101:109]:/1,110:=2};}

		//if else constraint
		rand int d;
		constraint d4 {if(c==100) d<100; else (d>100 && d<200);}

		//giving order od chosing value
		rand bit e1;
		rand bit [7:0] e2;
		//with thsi con1, it is almost impossible for e2==1 to hold, so e1 will almost be 0 all the time
		constraint con1 {e1->(e2==1);}
		// but with this , we can first determine e1 to be 0 and 1 equally posible
		constraint con2 {solve e1 before e2;}
	endclass : R1

	R1 r1= new;
	initial begin
		for(int i=0;i<=20;i++) begin	
			//randomize(null) just check for satisfiability, not really run
			//can add "with {class_property < limit;}" struct after randomize to constrain value 
			//r1.rand_mode(1/0) to active/deactive all variables in r1
			//r1.e1.rand_mode(1/0) to active/deactive variable e1
			//similarly, we can use randomize_mode for constrains instead of variables
			//specifying which variables to be randomize with randomize(e1)
			assert(r1.randomize());
			$display("ran i %d i1 %d ic1 %d a %d b %d",i , r1.i1,r1.ic1, r1.a,r1.b);
		end
	end

	initial begin
		for(int i=0;i<=20;i++) begin
			assert(r1.randomize());
			$display("e1 %d e2 %d",r1.e1,r1.e2);
		end
	end

	int f1;
	initial begin
		int value;
		integer v2;
		//globally randomize and inline constraint
		void'(std::randomize(f1) with {f1>0;});
		for(int i=0;i<10;i++) begin
			//urandom function that return unsign and thread stable
			value = $urandom(222);
			v2    = $urandom_range (30,1); // besure that larger one come first
			$display("urandom res %D urandom_range res %D",value, v2);
		end
	end

	int g1 ;
	initial begin
		//randomely generate value with weight
		randcase 
		2: g1 = 1;
		3: g1 = 2;
		5: g1 = 5;
		endcase
		$display("randcase res %d",g1);
		randsequence (test) 
			test: one two three four done;
			one : if(g1==1) up else down;
			two : smile |frown;
			three : 
				case (g1)
				1: t1;
				2: t2;
				default : t3;
				endcase;
			four : repeat (10) t4;
			done : {$display("done");};
			up   : {$display("up")  ;};
			down : {$display("down");};
			smile: {$display("smile");};
			frown: {$display("frown");};
			t1: {$display("t1");};
			t2: {$display("t2");};
			t3: {$display("t3");};
			t4: {$display("t4");};
		endsequence
	end
		
	int va,vb,vc,vd;
	int ve,vf;
	always @(posedge clk) begin
		$display("posedge of clk at $d",$stime);
	end

	initial begin
		va=0;
		#9 va=1;
		#20 va =2;
	end
	//notice the difference of va and ssybus.va
	//va get value 1 at 9, after the -2ns of the posedge 10ns
	//so 1 will not be caputured by ssybus.va
	//it will only be caputured at the next posedge at 30ns
	always @(va) begin
		$display("va is %d at %d",va,$stime);
	end
	always @(ssybus.va) begin
		$display("ssybus.va is %d at %d",ssybus.va,$stime);
	end
	//with clk as default clock
	default clocking ssybus @(posedge clk);
		//with sampling input 1ns before posedge clk
		// and driving output 1ns after posedge clk
		//of course, without specification the default is 1step for input and 0 for output
		default input #2ns output #2ns;
		//I can also move the posedge above here
		//default input posedge
		input va;
		output vb;
		//override c to use 1 delta step before posedge clk
		input #1step vc;
		//override to use negedge clk on output d
		output negedge vd;
		output vf;
	endclocking

	initial begin
		//output of cb can only be driven by <=
		ssybus.vb <=0;
		//even if we set it to 1 at 11, it will appear at ssybus.vb at 2ns after next posedge at 30
		//the same is for vb
		#11 ssybus.vb <= 1;
		#20 ssybus.vb <= 2;
	end

	always @(vb) begin
		$display("vb is %d at %d",vb,$stime);
	end

	always @(ssybus.vb) begin
		$display("ssybus.vb is %d at %d",ssybus.vb,$stime);
	end
	
	initial begin
		ve =0;
		ssybus.vf<=0;
		$display("current time is %d",$stime);
		## 2;
		$display("after 2 cycles time is %d",$stime);
		ve=1;
		ssybus.vf <= ##2 ve;
		$display("before 2 cycle ve %d vf %d",ve,ssybus.vf);
		##3
		$display("after 2 cycle ve %d vf %d",ve,ssybus.vf);


	end

endmodule : t1

program testprogram;
	initial begin
		//$exit can only be used in program
		$display("exiting program");
		$exit();
	end
endprogram : testprogram

//an interface can have different direction in different place
//such as the slave and master case
interface simple_bus;
	logic req,gnt;
	modport master (output req,input gnt);
	modport slave (input req,output gnt);
endinterface :simple_bus

module slavemod(simple_bus sb);
endmodule : slavemod

//determining dir in definition
module mastermod(simple_bus.master sb);
endmodule : mastermod


module topmod ; 
simple_bus  sb();

//determining dir with instnace
slavemod sm(.sb(sb.slave));
mastermod mm(.sb(sb));

endmodule : topmod
