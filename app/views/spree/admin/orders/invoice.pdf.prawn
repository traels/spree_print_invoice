define_grid(columns: 5, rows: 8, gutter: 10)

# HEADER
repeat(:all) do
  grid([0,0], [0,2]).bounding_box do
    image "#{Rails.root.to_s}/public/assets/#{Spree::PrintInvoice::Config[:print_invoice_logo_path]}"
  end

  grid([0,3], [0,4]).bounding_box do
    font "Helvetica", size: 9, style: :bold
    text Spree.t(:customer_invoice), align: :right, style: :bold, size: 18
    move_down 4
    font "Helvetica", size: 9, style: :bold
    text "#{Spree.t(:order_number)} #{@order.number}", align: :right
    move_down 2
    font "Helvetica", size: 9
    text "#{Spree.t(:on_date)}: #{I18n.l(@order.completed_at.to_date, format: :long)}", align: :right
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

    billing = "#{bill_address.firstname} #{bill_address.lastname} #{bill_address.address1}"
    billing << "\n#{bill_address.address2}" unless bill_address.address2.blank?
    billing << "\n#{@order.bill_address.city}, #{@order.bill_address.state_text} #{@order.bill_address.zipcode}"
    billing << "\n#{bill_address.country.name}"
    billing << "\n#{bill_address.phone}"

    shipping = "#{ship_address.firstname} #{ship_address.lastname} #{ship_address.address1}"
    shipping << "\n#{ship_address.address2}" unless ship_address.address2.blank?
    shipping << "\n#{@order.ship_address.city}, #{@order.ship_address.state_text} #{@order.ship_address.zipcode}"
    shipping << "\n#{ship_address.country.name}"
    shipping << "\n#{ship_address.phone}"

    data = [[address_cell_billing, address_cell_shipping], [billing, shipping]]
    table(data, position: :center, column_widths: [270, 270])
  end

  move_down 10
  @column_widths = [270, 100, 65, 40, 65]
  header =  [
    make_cell(content: Spree.t(:item_description), font_style: :bold),
    make_cell(content: Spree.t(:item_name, scope: :print_invoice), font_style: :bold),
    make_cell(content: Spree.t(:price), font_style: :bold),
    make_cell(content: Spree.t(:qty), font_style: :bold),
    make_cell(content: Spree.t(:total), font_style: :bold)
  ]
  data = [header]

  @order.line_items.each do |item|
    item_price = number_to_currency(item.price)
    line_total = number_to_currency(item.price * item.quantity)
    row = [item.variant.product.description, item.variant.product.name, item_price, item.quantity.to_s, line_total]
    data += [row]
  end

  table(data, header: true, position: :center, column_widths: @column_widths) do
    row(0).style align: :center
    column(0).style align: :left
    column(1).style align: :left
    column(2).style align: :right
    column(3).style align: :right
    column(4).style align: :right
    column(2).style padding_right: 10
    column(4).style padding_right: 10
  end

  # TOTALS
  move_down 10
  totals = []
  totals << [make_cell( content: Spree.t(:subtotal), font_style: :bold), number_to_currency(@order.item_total)]
  @order.adjustments.each do |charge|
    totals << [make_cell(content: charge.label + ':', font_style: :bold), number_to_currency(charge.amount)]
  end
  totals << [make_cell(content: Spree.t(:order_total), font_style: :bold), number_to_currency(@order.total)]

  # PAYMENTS
  total_payments = 0.0
  @order.payments.each do |payment|
    p_gateway = payment.source_type.match(/Paypal/).nil? ? 'unidentified' : 'PayPal'
    p_id = payment.identifier
    p_date = I18n.l(payment.updated_at.to_date, format: :long)
    totals << [make_cell(content: Spree.t(:order_payment_via, gateway: p_gateway, number: p_id, date: p_date), font_style: :bold), number_to_currency(payment.amount)]
    total_payments += payment.amount
  end
  totals << [make_cell(content: Spree.t(:balance), font_style: :bold), number_to_currency(@order.total - total_payments)]

  table(totals, column_widths: [475, 65]) do
    row(0).style align: :right
    row(1).style align: :right
    row(2).style align: :right
    row(3).style align: :right
    row(4).style align: :right
    column(0).style borders: []
    column(1).style padding_right: 10
    row(4).column(1).style background_color: 'c1c1c1'
  end

  move_down 20
  text Spree.t(:note), align: :left, size: 12
  move_down 4
  text Spree.t(:return_message), align: :left, size: 9
end

# FOOTER
repeat(:all) do
  grid([7,0], [7,4]).bounding_box do
    @column_widths = [270, 270]
    footer0 = [
      make_cell(content: Spree.t(:no_vat), colspan: 2),
    ]
    footer1 = [
      make_cell(content: Spree.t(:footer_left1)),
      make_cell(content: Spree.t(:footer_right1)),
    ]
    footer2 = [
      make_cell(content: Spree.t(:footer_left2)),
      make_cell(content: Spree.t(:footer_right2)),
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
string  = "#{Spree.t(:page)} <page> #{Spree.t(:of)} <total>"
options = {
  at: [bounds.right - 150, 0],
  width: 150,
  align: :right,
  start_count_at: 1,
  color: '000000'
}
number_pages string, options
