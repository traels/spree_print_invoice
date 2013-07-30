# Spree Print Invoice

[![Build Status](https://secure.travis-ci.org/futhr/spree_print_invoice.png?branch=2-0-stable)](http://travis-ci.org/futhr/spree_print_invoice)
[![Dependency Status](https://gemnasium.com/futhr/spree_print_invoice.png)](https://gemnasium.com/futhr/spree_print_invoice)
[![Coverage Status](https://coveralls.io/repos/futhr/spree_print_invoice/badge.png?branch=2-0-stable)](https://coveralls.io/r/futhr/spree_print_invoice)

This extension provides a "Print Invoice" button on the Admin Orders view screen which generates a PDF of the order details.

## Installation

Add to your `Gemfile`
```ruby
gem 'spree_print_invoice' , github: 'futhr/spree_print_invoice', branch: '2-0-stable'
```

Run
```
bundle install
rails g spree_print_invoice:install
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

## Prawn-handler

A Rails template handler for PDF library [Prawn][1]. Prawn-handler is lightweight, simple, and less of a hassle to use.

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

### Contributing

In the spirit of [free software][2], **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using prerelease versions
* by reporting [bugs][3]
* by suggesting new features
* by writing [translations][6]
* by writing or editing documentation
* by writing specifications
* by writing code (*no patch is too small*: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by resolving [issues][3]
* by reviewing patches

Starting point:

* Fork the repo
* Clone your repo
* Run `bundle install`
* Run `bundle exec rake test_app` to create the test application in `spec/test_app`
* Make your changes and follow this [Style Guide][4]
* Ensure specs pass by running `bundle exec rspec spec`
* Submit your pull request

Copyright (c) 2013 [Roman Le Négrate][7], [Torsten Rüger][8] and other [contributors][9], released under the [New BSD License][5]

[1]: http://prawn.majesticseacreature.com
[2]: http://www.fsf.org/licensing/essays/free-sw.html
[3]: https://github.com/futhr/spree_print_invoice/issues
[4]: https://github.com/thoughtbot/guide
[5]: https://github.com/futhr/spree_print_invoice/blob/2-0-stable/LICENSE.md
[6]: http://www.localeapp.com/projects/4941
[7]: https://github.com/Roman2K
[8]: http://github.com/dancinglightning
[9]: https://github.com/futhr/spree_print_invoice/contributors
