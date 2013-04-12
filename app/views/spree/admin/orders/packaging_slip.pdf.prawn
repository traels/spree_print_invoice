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

    repeat(lambda { |pg| pg == 1 }) do
        render :partial => "address"
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
