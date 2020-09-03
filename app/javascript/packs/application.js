// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
//= require jquery3
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
//= require_tree .


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


$(document).on('turbolinks:load', function() {

  //Remove Ingredient
  $('form').on('click', '.remove_record', function(event) {
    $(this).prev('input[type=hidden').val('1');
    $(this).closest('tr').hide();
    return event.preventDefault();
  })

  //Add Ingredient
  $('form').on('click', '.add_fields', function(event) {
    $('.fields').append($(this).data('fields'));
    return event.preventDefault();
  })
  $('#sidebarCollapse').on('click', function () {
    $('#sidebar').toggleClass('active');
    $('i.arrow').toggleClass('fa-arrow-right');
    $('i.arrow').toggleClass('fa-arrow-left');
  });

    // Add text to search bar
  $('a.dropdown-toggle').on('click', function () {
    $("a.add_to_search").on('click', function(event) {
      var textToAdd = $(this).attr("data-text");
      var currentText = $("input[data-field='search_field']").val();
      var $searchBar = $("input[data-field='search_field']");
      if(currentText.slice(-1) != ","){
        if(currentText === "") {
          var textCenter = "";
        } else {
          var textCenter = ", "
        }
      } else {
          var textCenter = " ";
      }
      $searchBar.val(currentText + textCenter + textToAdd);
      return event.preventDefault();
    })
    $("a.dropdown-toggle").closest("a").off('click');
  })
})
