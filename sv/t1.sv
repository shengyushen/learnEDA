//package definition
package types;
	class D #(parameter int l=1);
		int md = l;
	endclass : D

	class C #(parameter int m = 2) extends D #(.l(4));
		int mc = m;
	endclass :C
endpackage: types

module t1 ;
	import types::*;

	class B extends C #(.m(3));
		function print() ;
		begin
			$display("mc %d md %d",mc,md);
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
			#100ms clk = !clk;
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
		rand int i1;
		constraint c1 {i1>0 && i1<10;}
	endclass : R1

	R1 r1= new;
	initial begin
		for(int i=0;i<=5;i++) begin
			assert(r1.randomize());
			$display("ran i %d res %d",i , r1.i1);
		end
	end


endmodule : t1
