
$.rails.confirmed = (link) ->
  linkclass = link.attr 'class'
  link.removeAttr('data-confirm')
  link.trigger('click.rails')
  
  if linkclass == 'reset-link'
  	window.location.replace(""+link.context.href+"");