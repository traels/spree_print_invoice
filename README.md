# Spree Print Invoice

[![Build Status](https://secure.travis-ci.org/futhr/spree_print_invoice.png?branch=master)](http://travis-ci.org/futhr/spree_print_invoice)
[![Dependency Status](https://gemnasium.com/futhr/spree_print_invoice.png)](https://gemnasium.com/futhr/spree_print_invoice)
[![Coverage Status](https://coveralls.io/repos/futhr/spree_print_invoice/badge.png?branch=master)](https://coveralls.io/r/futhr/spree_print_invoice)

**NOTE: THIS IS WIP FORK FOR SPREE 2.x**

This extension provides a "Print Invoice" button on the Admin Orders view screen which generates a PDF of the order details.

## Installation

1. The gem relies only on the prawn gem, to install you need to add the following lines to your Gemfile
```ruby
gem 'spree_print_invoice' , github: 'spree/spree_print_invoice'
```

2. run bundler
```
bundle install
```

3. Enjoy! now displays the items variant options

## Configuration

1. Set the logo path preference to include your store/company logo.
```ruby
Spree::PrintInvoice::Config.set(print_invoice_logo_path: '/path/to/public/images/company-logo.png')
```

2. Add your own own footer texts to the locale. The current footer works with `:footer_left1`, `:footer_left2` and `:footer_right1`, `:footer_right2` where the 1 version is on the left in bold, and the 2 version the "value" on the right.

3. Override any of the partial templates. they are `address`, `footer`, `totals`, `header`, `bye`, and the `line_items`. In bye the text `:thanks` is printed.  The `:extra_note` hook has been deprecated as Spree no longer supports hooks.

4. Set `:suppress_anonymous_address` option to get blank addresses for anonymous email addresses (as created by my spree_last_address extension for empty/unknown user info)

5. Enable packaging slips, by setting
```ruby
Spree::PrintInvoice::Config.set(print_buttons: 'invoice,packaging_slip') # comma separated list
```

Use above feature for your own template if you want. For each button_name, define button_name_print text in your locale.

## Todo

* Tests :/
* Next receipts and then product related stuff with barcodes.

## Contributing

* Fork the repo
* Clone your repo `git clone git@github.com:mrhelpful/spree_print_invoice.git`
* Create branch for your pull request `git checkout -b fix-something`
* Run `bundle`
* Run `bundle exec rake test_app` to create the test application in `spec/dummy`
* Make your changes
* Ensure specs pass by running `bundle exec rake`
* Make sure yor changes has test coverage `open coverage/index.html`
* Submit your pull request

## Prawn-handler

A Rails template handler for PDF library [Prawn](http://prawn.majesticseacreature.com/). Prawn-handler is lightweight, simple, and less of a hassle to use.

### Usage

3. Name PDF view files like `foo.pdf.prawn`. Inside, use the `pdf` method to access a `Prawn::Document` object. In addition, this handler allows for lazy method calls: you don't have to specify the receiver explicitely, which cleans up the resulting view code.

For example, the following code with formal calls:
```ruby
pdf.bounding_box [100, 600], width: 200 do
  pdf.text 'The rain in spain falls mainly on the plains ' * 5
  pdf.stroke do
    pdf.line pdf.bounds.top_left,    pdf.bounds.top_right
    pdf.line pdf.bounds.bottom_left, pdf.bounds.bottom_right
  end
end
```

Is equivalent to this one with lazy calls:
```ruby
bounding_box [100, 600], width: 200 do
  text 'The rain in spain falls mainly on the plains ' * 5
  stroke do
    line bounds.top_left,    bounds.top_right
    line bounds.bottom_left, bounds.bottom_right
  end
end
```

This is accomplished without `instance_eval`, so that access to instance variables set by the controller is retained.

## Kudos

* Initially written by [Roman Le Négrate](http://roman.flucti.com) ([contact](mailto:roman.lenegrate@gmail.com)).
* Adopted to Rails 3 by [Torsten Rüger](http://github.com/dancinglightning)

Copyright (c) 2013 Roman Le Négrate, Torsten Rüger, released under the New BSD License
