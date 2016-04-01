`timescale 1ns/10ps

module tb ();
	timeunit 1ns;
	timeprecision 10ps;

	wire x,y;
	wire v=x+y;//net cont assignment, only one
	var logic l=1;//default to be var, var init, can be assign latter below
	initial #1 l = 2;

	var bit bb=1'b1;//2-state var
	var string a="sdf";
	var string a8={8{a}};

	initial begin
		#100 $display ("hello world");
	end

	typedef logic [7:0] bit8;
	bit8 ssy; //var declaration with assign 
	assign ssy=1;

	//built in net type for digital AMS(DMS) mode that speedup AMS simulation
	nettype real myNetType;
	nettype real wrealavg with CDS_res_wrealavg; //these are built in wire that take average value in drivers
	nettype wrealavg myWrealavg;
	myWrealavg ssy_real;
	assign ssy_real=1;
	assign ssy_real=2;
	initial #1 $display("ssy_real is average %f",ssy_real);


	//class with polymorph
	class memory#(int size=100,type T=bit);
		T arr[size];
		task set(int index, T val);
			if(index>=0 && index <size) 
				arr[index] = val;
		endtask

		task show(int index);
			if(index>=0 && index <size) 
				$display("%b", arr[index]);
		endtask
	endclass

	memory #(.size(10),.T(byte)) inst_mem = new;
	initial begin
		inst_mem.set(0,0);
		inst_mem.set(1,1);
		inst_mem.show(1);
	end

	//array
	wire  [7:0] www;
	assign www=1;
	assign www[1]=1;

	wire  wwww [2:0];
	wire  wwww1 [2]; //equal to wwww1[0:2]
	int   wwww2 [] = '{1,2,3,4,5};
	assign wwww[2]=1;
	assign wwww= '{0,1,2};

	wire [7:0] wwwww [2:0];
	assign wwwww[2][7]=1;//unpack come first
	initial begin
		$display("dimensions of wwwww %d", $dimensions(wwwww));
		$display("left of wwwww %d", $left(wwwww,1));
		$display("left of wwwww %d", $left(wwwww,2));
		$display("right of wwww2 %d", $right(wwww2));
	end

	//dynamic array new
	initial begin
		integer myaddr [];
		integer myaddr2 [];
		myaddr = new[50];
		myaddr2 = new[60] (myaddr);
		$display("myaddr2 size  %d", $size(myaddr2));
		myaddr.delete();
	end

	//dynamic array reference
	string strarr[];
	initial begin
		strarr=new[50];
		func(strarr);
		$display("strarr[0] is  %s", strarr[0]);
	end
	task automatic func(ref string stra[]) ;
		stra[0] = "abc";
	endtask

	//associative array
	string arr_assoc[string];
	initial  begin
		arr_assoc["sdf"]="efg";
		if(arr_assoc.exists("sdf"))
			arr_assoc.delete("sdf");
	end

	//queue
	string strQ64 [$:63]; // queue with max size of 64
	string strQ [$] ; //unbounded queue
	typedef int intQ[$];
	intQ ssyintQ;
	initial  begin
		ssyintQ.insert(0,1);
		$display("size of ssyintQ is  %d", ssyintQ.size());
	end
endmodule

bit b;
task t;
	int b;
	b= 5 + $unit::b ; // refering to current compilation unit
endtask

program ssy_program ();
	//existence of program dictate the run time of the whole simulation
	initial  begin
		//dynamic string array
		string dynstr[];
		dynstr=new[10];
		dynstr[1]="sdf";
		#100
		$display ("hello program");
	end
endprogram


