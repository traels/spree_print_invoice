define_grid(:columns => 5, :rows => 8, :gutter => 10)

# HEADER
repeat(:all) do
    grid([0,0], [0,2]).bounding_box do
        image "#{Rails.root.to_s}/public/assets/#{Spree::PrintInvoice::Config[:print_invoice_logo_path]}"
    end

    grid([0,3], [0,4]).bounding_box do
        font "Helvetica", :size => 9, :style => :bold
        text I18n.t(:packaging_slip), :align => :right, :style => :bold, :size => 18
        move_down 4
        font "Helvetica",  :size => 9,  :style => :bold
        text "#{I18n.t(:order_number)} #{@order.number}", :align => :right
        move_down 2
        font "Helvetica", :size => 9
        text "#{I18n.t(:on_date)}: #{I18n.l @order.completed_at.to_date, :format => :long}", :align => :right
    end
end

# CONTENT
grid([1,0], [6,4]).bounding_box do

    # address block on first page only
    repeat(lambda { |pg| pg == 1 }) do
        bill_address = @order.bill_address
        ship_address = @order.ship_address
        anonymous = @order.email =~ /@example.net$/

        move_down 2
        address_cell_billing = make_cell(:content => t(:billing_address), :font_style => :bold)
        address_cell_shipping = make_cell(:content => t(:shipping_address), :font_style => :bold)

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

        data = [ [address_cell_billing, address_cell_shipping], [billing, shipping] ]
        table(data, :position => :center, :column_widths => [270, 270] )
    end

    move_down 10
    @column_widths = [270, 230, 40]
    header =  [
        make_cell( :content => t(:item_description), :font_style => :bold),
        make_cell( :content => t(:item_name, :scope => :print_invoice), :font_style => :bold) ,
        make_cell( :content => t(:qty), :font_style => :bold),
    ]
    data = [header]

    @order.line_items.each do |item|
        row = [item.variant.product.description, item.variant.product.name, item.quantity.to_s]
        data += [row]
    end

    table(data, :header => true, :position => :center, :column_widths => @column_widths ) do
        row(0).style :align => :center 
        column(0).style :align => :left 
        column(1).style :align => :left 
        column(2).style :align => :center
    end


    move_down 20
    text I18n.t(:note), :align => :left,  :size => 12
    move_down 4
    text I18n.t(:anomaly_message), :align => :left, :size => 9
    
    move_down 20
    bounding_box([0, cursor], :width => 540, :height => 250) do
        transparent(0.5) { stroke_bounds }
    end


end    

# FOOTER
repeat(:all) do    
    grid([7,0], [7,4]).bounding_box do
        @column_widths = [270, 270]
        footer0 =  [
            make_cell( :content => I18n.t(:no_vat) , :colspan => 2),
        ]
        footer1 =  [
            make_cell( :content => "CERAMIQUE ISABELLE -  1, Kerforn F56950 Crach (France)" ),
            make_cell( :content => "+33(0)297 550 457 - shopping@ceramique-isabelle.fr" ),
        ]
        footer2 =  [
            make_cell( :content => "N° SIRET 415 073 592 00016" ),
            make_cell( :content => "MAISON DES ARTISTES - PARIS N° B702155" ),
        ]
        data = [footer0, footer1, footer2]

        table(data, :position => :center, :column_widths => @column_widths) do
            row(0).style :borders => []
            row(1).style :borders => []
            row(2).style :borders => []
            column(0).style :align => :left
            column(1).style :align => :right
            row(0).column(0).style :align => :center
        end

    end
end


# PAGE NUMBER
string = "page <page> #{t(:of)} <total>"
options = { :at => [bounds.right - 150, 0],
          :width => 150,
          :align => :right,
          :start_count_at => 1,
          :color => "000000" }
number_pages string, options
