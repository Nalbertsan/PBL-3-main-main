module maq_desp (
	 input clk,
	 input reset,
    input RO, RC, RD, // Entradas
    output Al, C // Saídas
);

// Parâmetros de estados
parameter Alarme = 2'b10;
parameter Desligado = 2'b00;
parameter Ligado = 2'b01;

// Declaração de estados
reg [1:0] current_state, next_state;

always @ ( posedge clk , posedge
reset ) begin
    if (reset) begin
        current_state <= Desligado; // Estado inicial
    end 
	 else begin
        current_state <= next_state; // Atualiza o estado atual
    end
end

// Lógica de estado
always @* begin
    case (current_state)
        Desligado: begin
            if (!RO && !RC)
                next_state = Alarme;
            else if ( RC && RD)
                next_state = Ligado;
            else
                next_state = Desligado;
        end
        Ligado: begin
            if (!RD)
                next_state = Desligado;
            else
                next_state = Ligado;
        end
        Alarme: begin
				if ( RC )
                next_state = Ligado;
            else
                next_state = Alarme;
        end
		  default: next_state = Desligado;
			
    endcase
end

// Lógica de saída (Mealy)
assign Al = (current_state == Alarme);
assign C = (current_state == Ligado);

endmodule
