package jACBrFramework.sped;

/**
 *
 * @author Jose Mauro
 * @version Criado em: 30/01/2014 16:22:30, revisao: $Id$
 */
public enum MotivoInventario {
    
    // <editor-fold defaultstate="collapsed" desc="Enums">    
    FinalPeriodo(1, "01 – No final no período"),
    MudancaTributacao(2, "02 – Na mudança de forma de tributação da mercadoria (ICMS)"),
    BaixaCadastral(3, "03 – Na solicitação da baixa cadastral, paralisação temporária e outras situações"),
    RegimePagamento(4, "04 – Na alteração de regime de pagamento – condição do contribuinte"),
    DeterminacaoFiscos(5, "05 – Por determinação dos fiscos");
    // </editor-fold>
    // <editor-fold defaultstate="collapsed" desc="Attributes">    
    /**
     * Descricao do motivo de inventario
     */
    private String descricao;
    /**
     * Codigo do motivo de inventario
     */
    private int codigo;
    // </editor-fold>
    // <editor-fold defaultstate="collapsed" desc="Constructors">  
    MotivoInventario(int pCodigo, String pDescricao) {
        codigo = pCodigo;
        descricao = pDescricao;
    }
    // </editor-fold>
    // <editor-fold defaultstate="collapsed" desc="Methods">    
    /**
     * Descricao do motivo de inventario
     * @return the descricao
     */
    public String getDescricao() {
        return descricao;
    }

    /**
     * Codigo do motivo de inventario
     * @return the codigo
     */
    public int getCodigo() {
        return codigo;
    }
    // </editor-fold>           
}