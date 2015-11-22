/*
 * 16-bit Ladner-Fischer Adder
 *
 * Steve Barrus
 */

module LadnerFischer16 (A, B, Cin, S, Cout);
    input [15:0] A, B;
    input Cin;
    output [15:0] S;
    output Cout;

    /* First generate the propigate and generate signals for each bit */
    wire [1:0] r1c16, r1c15, r1c14, r1c13, r1c12, r1c11, r1c10, r1c9;
    wire [1:0] r1c8, r1c7, r1c6, r1c5, r1c4, r1c3, r1c2, r1c1;

    pg16 ipg16(.A(A), .B(B), .pg15(r1c16),.pg14(r1c15),.pg13(r1c14),
        .pg12(r1c13),.pg11(r1c12),.pg10(r1c11),.pg9(r1c10),.pg8(r1c9),
        .pg7(r1c8),.pg6(r1c7),.pg5(r1c6),.pg4(r1c5),.pg3(r1c4),.pg2(r1c3),
        .pg1(r1c2),.pg0(r1c1));

    /* First row */
    wire [1:0] r2c15, r2c13, r2c11, r2c9, r2c7, r2c5, r2c3;
    wire r2c1;

    black ir1c15(.pg(r1c15), .pg0(r1c14), .pgo(r2c15));
    black ir1c13(.pg(r1c13), .pg0(r1c12), .pgo(r2c13));
    black ir1c11(.pg(r1c11), .pg0(r1c10), .pgo(r2c11));
    black ir1c9(.pg(r1c9), .pg0(r1c8), .pgo(r2c9));
    black ir1c7(.pg(r1c7), .pg0(r1c6), .pgo(r2c7));
    black ir1c5(.pg(r1c5), .pg0(r1c4), .pgo(r2c5));
    black ir1c3(.pg(r1c3), .pg0(r1c2), .pgo(r2c3));
    gray ir1c1(.pg(r1c1), .pg0(Cin), .pgo(r2c1));

    /* Second row */
    wire [1:0] r3c15, r3c11, r3c7;
    wire r3c3;

    black ir2c15(.pg(r2c15), .pg0(r2c13), .pgo(r3c15));
    black ir2c11(.pg(r2c11), .pg0(r2c9), .pgo(r3c11));
    black ir2c7(.pg(r2c7), .pg0(r2c5), .pgo(r3c7));
    gray ir2c3(.pg(r2c3), .pg0(r2c1), .pgo(r3c3));

    /* Third row */
    wire [1:0] r4c15, r4c13;
    wire r4c7, r4c5;

    black ir3c15(.pg(r3c15), .pg0(r3c11), .pgo(r4c15));
    black ir3c13(.pg(r2c13), .pg0(r3c11), .pgo(r4c13));
    gray ir3c7(.pg(r3c7), .pg0(r3c3), .pgo(r4c7));
    gray ir3c5(.pg(r2c5), .pg0(r3c3), .pgo(r4c5));

    /* Fourth row */
    wire r5c15, r5c13, r5c11, r5c9;

    gray ir4c15(.pg(r4c15), .pg0(r4c7), .pgo(r5c15));
    gray ir4c13(.pg(r4c13), .pg0(r4c7), .pgo(r5c13));
    gray ir4c11(.pg(r3c11), .pg0(r4c7), .pgo(r5c11));
    gray ir4c9(.pg(r2c9), .pg0(r4c7), .pgo(r5c9));

    /* Fifth row */
    wire r6c14, r6c12, r6c10, r6c8, r6c6, r6c4, r6c2;

    gray ir6c14(.pg(r1c14), .pg0(r5c13), .pgo(r6c14));
    gray ir6c12(.pg(r1c12), .pg0(r5c11), .pgo(r6c12));
    gray ir6c10(.pg(r1c10), .pg0(r5c9), .pgo(r6c10));
    gray ir6c8(.pg(r1c8), .pg0(r4c7), .pgo(r6c8));
    gray ir6c6(.pg(r1c6), .pg0(r4c5), .pgo(r6c6));
    gray ir6c4(.pg(r1c4), .pg0(r3c3), .pgo(r6c4));
    gray ir6c2(.pg(r1c2), .pg0(r2c1), .pgo(r6c2));

    /* Finaly produce the sum */
    xor16 ixor16(.A({r5c15,r6c14,r5c13,r6c12,r5c11,r6c10,r5c9,
        r6c8,r4c7,r6c6,r4c5,r6c4,r3c3,r6c2,r2c1,Cin}), .B({r1c16[1],
        r1c15[1],r1c14[1],r1c13[1],r1c12[1],r1c11[1],r1c10[1],r1c9[1],
        r1c8[1],r1c7[1],r1c6[1],r1c5[1],r1c4[1],r1c3[1],r1c2[1],
        r1c1[1]}), .S(S));

    /* Generate Cout */
    gray gcout(.pg(r1c16), .pg0(r5c15), .pgo(Cout));

endmodule

