window.MyNamespace = window.MyNamespace or {}
window.MyNamespace.Uri = window.MyNamespace.Uri or {}

((ns) ->
  ns.SetQueryStringParameter = (url, parameterName, parameterValue) ->
    otherQueryStringParameters = ""
    urlParts = url.split("?")
    baseUrl = urlParts[0]
    queryString = urlParts[1]
    itemSeparator = ""
    if queryString
      queryStringParts = queryString.split("&")
      i = 0

      while i < queryStringParts.length
        unless queryStringParts[i].split("=")[0] is parameterName
          otherQueryStringParameters += itemSeparator + queryStringParts[i]
          itemSeparator = "&"
        i++
    newQueryStringParameter = itemSeparator + parameterName + "=" + parameterValue
    baseUrl + "?" + otherQueryStringParameters + newQueryStringParameter
) window.MyNamespace.Uri

$(document).ready ->
  $("#print_invoice_language").change (e) ->
	  selected_language = $(this).val()
	  invoice_buttons = $('[data-hook="admin_order_print_buttons"]').children(".button")
	  invoice_buttons.each (index) ->
		  originalUrl = $(this).prop("href")
		  changedUrl = MyNamespace.Uri.SetQueryStringParameter(originalUrl, "language", selected_language)
		  $(this).prop("href", changedUrl)
