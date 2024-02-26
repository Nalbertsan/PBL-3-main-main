module Level_to_Pulse (
    input clk,       // Clock de entrada
    input level_in,  // Sinal de nível de entrada
    output pulse_out  // Saída do pulso
);


reg FFD1;
reg FFD2;

initial begin
	FFD1 = 1'b0;
	FFD2 = 1'b0;
end
always @(posedge clk) begin
    FFD1 <= level_in;
	 FFD2 <= FFD1 & level_in;
end
wire aneg;
not(aneg, FFD2);
and(pulse_out, FFD1, aneg);
endmodule
