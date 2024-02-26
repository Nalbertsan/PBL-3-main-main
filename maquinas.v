module maquinas (
    input clk,       // Sinal de clock
    input reset,   // Sinal de reset ativo baixo
    input PG, CH, RO, ST,
    output GC,        // Saída Garrafa completa
    output EV,        // Saída válvula de enchimento
    output VE,         // Saída válvula de vedação
	 output M,
	 output SEM_GARRAFA, GARRAFA_VAZIA, GARRAFA_CHEIA, GARRAFA_CHEIA_VEDADA
);
wire [2:0] tipo_saida;

maq_esteira(clk, 0 , ST, PG, M);
maq_enc_veda (clk, 0 , PG, CH, RO, GC, EV, VE, tipo_saida);

assign SEM_GARRAFA = (tipo_saida == 3'b000 && ST);
assign GARRAFA_VAZIA = (tipo_saida == 3'b001 && ST);
assign GARRAFA_CHEIA = (tipo_saida == 3'b010 && ST);
assign GARRAFA_CHEIA_VEDADA = (tipo_saida == 3'b011 && ST);
endmodule
