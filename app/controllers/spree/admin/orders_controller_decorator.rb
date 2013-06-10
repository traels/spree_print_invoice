Spree::Admin::OrdersController.class_eval do
  before_filter :save_current_locale, only: :show
  after_filter :current_locale, only: :show

  def show
    load_order
    respond_with(@order) do |format|
      format.pdf do
        template = params[:template] || 'invoice'
        I18n.locale = params[:language].to_sym unless params[:language].nil?
        page_size = Spree::PrintInvoice::Config[:page_size]
        page_layout = Spree::PrintInvoice::Config[:page_layout].to_sym
        pdf = Prawn::Document.new(page_size: page_size, page_layout: page_layout)
        render pdf: pdf, layout: false, template: "spree/admin/orders/#{template}.pdf.prawn"
      end
    end
  end

  def save_current_locale
    @current_locale = I18n.locale
  end

  def current_locale
    I18n.locale = @current_locale
  end
end
