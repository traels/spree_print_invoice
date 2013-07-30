require 'barby'
require 'barby/outputter/prawn_outputter'

define_grid(columns: 5, rows: 8, gutter: 10)

# HEADER
repeat(:all) do
  print_invoice_logo = Rails.root.join('app', 'assets', Spree::PrintInvoice::Config[:print_invoice_logo_path])
  if File.exists? print_invoice_logo
    image "#{print_invoice_logo}", vposition: :top, height: 40
  end

  grid([0,3], [0,4]).bounding_box do
    font "Helvetica", size: 9, style: :bold
    text Spree.t(:packaging_slip, scope: :print_invoice), align: :right, style: :bold, size: 18
    move_down 4
    font "Helvetica", size: 9, style: :bold
    text "#{Spree.t(:order_number)} #{@order.number}", align: :right
    move_down 2
    font "Helvetica", size: 9, style: :bold
    text "#{Spree.t(:on_date, scope: :print_invoice)}: #{I18n.l(@order.completed_at.to_date, format: :long)}", align: :right
  end

  # BARCODE
  bounding_box [385,640], width: 100 do
    barcode = Barby::Code39.new(@order.number)
    barcode.annotate_pdf(self, height: 20)
  end
end

# CONTENT
grid([1,0], [6,4]).bounding_box do

  # address block on first page only
  repeat(lambda { |pg| pg == 1 }) do
    bill_address = @order.bill_address
    ship_address = @order.ship_address
    anonymous    = @order.email =~ /@example.net$/

    move_down 2
    address_cell_billing  = make_cell(content: Spree.t(:billing_address), font_style: :bold)
    address_cell_shipping = make_cell(content: Spree.t(:shipping_address), font_style: :bold)

    billing = "#{bill_address.firstname} #{bill_address.lastname}"
    billing << "\n#{bill_address.address1}"
    billing << "\n#{bill_address.address2}" unless bill_address.address2.blank?
    billing << "\n#{@order.bill_address.city}, #{@order.bill_address.state_text} #{@order.bill_address.zipcode}"
    billing << "\n#{bill_address.country.name}"
    billing << "\n#{bill_address.phone}"

    shipping = "#{ship_address.firstname} #{ship_address.lastname}"
    shipping << "\n#{ship_address.address1}"
    shipping << "\n#{ship_address.address2}" unless ship_address.address2.blank?
    shipping << "\n#{@order.ship_address.city}, #{@order.ship_address.state_text} #{@order.ship_address.zipcode}"
    shipping << "\n#{ship_address.country.name}"
    shipping << "\n#{ship_address.phone}"

    data = [[address_cell_billing, address_cell_shipping], [billing, shipping]]
    table(data, position: :center, column_widths: [270, 270])
  end

  move_down 10
  @column_widths = [500, 40]
  header =  [
    make_cell(content: Spree.t(:name), font_style: :bold),
    make_cell(content: Spree.t(:qty), font_style: :bold),
  ]
  data = [header]

  @order.line_items.each do |item|
    row = [item.variant.product.name, item.quantity.to_s]
    data += [row]
  end

  table(data, header: true, position: :center, column_widths: @column_widths) do
    row(0).style align: :center
    column(0).style align: :left
    column(1).style align: :left
    column(2).style align: :center
  end

  move_down 20
  text Spree.t(:anomaly_message), align: :left, size: 9

  move_down 20
  bounding_box([0, cursor], width: 540, height: 250) do
    transparent(0.5) { stroke_bounds }
  end
end

# FOOTER
repeat(:all) do
  grid([7,0], [7,4]).bounding_box do
    @column_widths = [270, 270]
    footer0 = [
      make_cell(content: Spree.t(:vat, scope: :print_invoice) , colspan: 2),
    ]
    footer1 = [
      make_cell(content: Spree.t(:footer_left, scope: :print_invoice)),
      make_cell(content: Spree.t(:footer_right, scope: :print_invoice)),
    ]
    footer2 = [
      make_cell(content: Spree::PrintInvoice::Config[:footer_left]),
      make_cell(content: Spree::PrintInvoice::Config[:footer_right]),
    ]
    data = [footer0, footer1, footer2]

    table(data, position: :center, column_widths: @column_widths) do
      row(0).style borders: []
      row(1).style borders: []
      row(2).style borders: []
      column(0).style align: :left
      column(1).style align: :right
      row(0).column(0).style align: :center
    end
  end
end

# PAGE NUMBER
string  = "#{Spree.t(:page, scope: :print_invoice)} <page> #{Spree.t(:of, scope: :print_invoice)} <total>"
options = {
  at: [bounds.right - 150, 0],
  width: 150,
  align: :right,
  start_count_at: 1,
  color: "000000"
}
number_pages string, options
