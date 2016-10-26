$(window).load(function() {
  return $('a[data-target]').click(function(e) {
    var $this, new_target, url;
    e.preventDefault();
    $this = $(this);
    if ($this.data('target') === 'Add to') {
      url = $this.data('addurl');
      $('a[data-target]').addClass('btn-danger');
      $('a[data-target]').removeClass('btn-success');
      
      new_target = "Remove from";
    } else {
      url = $this.data('removeurl');
      $(this).removeClass('btn-danger');
      $(this).addClass('btn-success');
      new_target = "Add to";
    }
    return $.ajax({
      url: url,
      type: 'put',
      success: function(data) {
        $('.cart-count').html(data);
        
        $this.find('span').html(new_target);
        return $this.data('target', new_target);
      }
    });
  });
});





