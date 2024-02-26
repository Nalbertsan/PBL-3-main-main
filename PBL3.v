module PBL3 (CH0, CH1, CH2, clk, OUT_7SEG, dig0, dig1, dig2, dig3, reset, LED_RGB, PG, ST, B0, B1, LED0,LED1,LED2,LED3,LED4,LED5,LED6,LED7,LED8,LED9);
    
    input clk, reset;   // Sinal de reset ativo baixo
    input PG, ST;			// Presença de garrafa e Start/stop
	 wire CH, RO;		//Enchimento e rolha
    wire GC;        // Saída Garrafa completa
    wire EV;        // Saída válvula de enchimento
    wire M;				//Saída do motor
    wire SEM_GARRAFA, GARRAFA_VAZIA, GARRAFA_CHEIA, GARRAFA_CHEIA_VEDADA; // Estado da garrafa
	 wire [2:0] tipo_saida; //saida da maquina de enchimento
	 wire VE; //Vedeção
	 wire ST_fitrada, PG_fitrada;

	
	input CH0, CH1, CH2, B0, B1;
	//ESSE OUT AQUI SÃO OS SEGMENTOS DO MOSTRADOR, O OUT[0] É O SEGMENTO_A E O OUT[6] É O SEGMENTO_G
	output [6:0]OUT_7SEG;
	//DIGITOS DO MOSTRADOR
	output dig0, dig1, dig2, dig3, LED0, LED1, LED2, LED3, LED4, LED5, LED6 ,LED7 ,LED8, LED9, LED_RGB;
	wire [3:0] teste_uni_gar, teste_deze_gar, teste_uni_rol, cont_duzia;
	wire [1:0] teste_deze_rol;
	wire BB;
	wire [3:0] unidade_gar, dezena_gar, unidade_r, jjk;
	wire [2:0] quant_recargas;
	wire [6:0] SEG_unidade_gar, SEG_dezena_gar, SEG_dezena_rolha, SEG_unidade_rolha;
	wire [1:0] sel_7seg, dezena_r;
	wire [14:0] clock_dividido;
	wire tem_recarga, rolha_menor_5, r_zerada;
	wire unidade_completa_gar, dig0_inv, dig1_inv, dig2_inv, dig3_inv;
	
	//Divisor de Clock
	div_clock divisor (clk, 0, clock_dividido);
	
	//Logica do botão
	assign B0_inv = ~B0;
	assign B1_inv = ~B1;
	
	//debouncers
	debouncer debouncer0 (B0_inv, clock_dividido[14], 1, CH);
	debouncer debouncer1 (B1_inv, clock_dividido[14], 1, RO_pre);
	debouncer debouncer2 (ST, clock_dividido[14], 1, ST_fitrada);
	debouncer debouncer3 (PG, clock_dividido[14], 1, PG_fitrada);
	and And9 (RO, RO_pre, r_zerada);
	//Módulo do display
	modulo_display modulo_display (VE, GC, ~ST_fitrada, C, clock_dividido[14], OUT_7SEG, dig0, dig1, dig2, dig3, RC, RD, r_zerada);
	
	//Maquinas de estados
	maq_esteira(clock_dividido[14], 0 , ST_fitrada, PG, M);
	maq_enc_veda (clock_dividido[14], 0 , PG, CH, RO, GC, EV, VE, tipo_saida);
	maq_desp (clock_dividido[14],~ST_fitrada, r_zerada, RC, RD, AL, C);
	
	//Sáidas
	assign LED9 = M;
	assign SEM_GARRAFA = (tipo_saida == 3'b000 && ST_fitrada);
	assign GARRAFA_VAZIA = (tipo_saida == 3'b001 && ST_fitrada);
	assign GARRAFA_CHEIA = (tipo_saida == 3'b010 && ST_fitrada);
	assign GARRAFA_CHEIA_VEDADA = (tipo_saida == 3'b011 && ST_fitrada);
	assign LED_RGB = AL;
	assign LED4 = VE;
	assign LED8 = SEM_GARRAFA;
	assign LED7 = GARRAFA_VAZIA;
	assign LED6 = GARRAFA_CHEIA ;
	assign LED5 = GARRAFA_CHEIA_VEDADA;

	
endmodule