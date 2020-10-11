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

  //New Tags/Categories confirmation dialogue
  $("input.submit.recipe").on('click', function(event) {
    var catContents = $("input#categories").val();
    var tagContents = $("input#tags").val();

    jQuery.ajax({
      url: "/check_tags.json", 
      data: { 
        tags: tagContents, 
        categories: catContents 
      },
      type: "GET",
      dataType: "json",
      async: false
      }) 

      .done(function( data ) {
        console.log(data.list);
        if(data.list == "")
          return true;
        if( confirm(`You are about to create new Tags and/or Categories. Please check the following list for any errors: ${data.list}`) ) 
          return true;
      })

      .fail(function( xhr, status, errorThrown) {
        alert( "Sorry, there was a problem!" );
        console.log( "Error: " + errorThrown );
        console.log( "Status: " + status );
        console.dir( xhr );
      })
  })

  //Remove Ingredient
  $('form').on('click', '.remove_record', function(event) {
    $(this).prev('input[type=hidden').val('1');
    $(this).closest('tr').hide();
    return event.preventDefault();
  })

  //Add Ingredient
  $('form').on('click', '.add_fields', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $('.fields').append($(this).data('fields').replace(regexp, time));
    $("button.add-to-tags").last().on('click', function(event) {
      var textToAdd = $(this).closest("tr").find(".ingredient-name").val();
      var currentText = $("#tags").val();
      var $tagsBar = $("#tags");
      if(currentText.slice(-1) != ","){
        if(currentText === "") {
          var textCenter = "";
        } else {
          var textCenter = ", "
        }
      } else {
          var textCenter = " ";
      }
      $tagsBar.val(currentText + textCenter + textToAdd);
      return event.preventDefault();
    })
    return event.preventDefault();
  })

  //Add to tags
  $("button.add-to-tags").on('click', function(event) {
    var textToAdd = $(this).closest("tr").find(".ingredient-name").val();
    var currentText = $("#tags").val();
    var $tagsBar = $("#tags");
    if(currentText.slice(-1) != ","){
      if(currentText === "") {
        var textCenter = "";
      } else {
        var textCenter = ", "
      }
    } else {
        var textCenter = " ";
    }
    $tagsBar.val(currentText + textCenter + textToAdd);
    return event.preventDefault();
  })

  //Collapse Sidebar
  $('#sidebarCollapse').on('click', function() {
    $('#sidebar').toggleClass('active');
    $('i.arrow').toggleClass('fa-arrow-right');
    $('i.arrow').toggleClass('fa-arrow-left');
  });

  // Add text to search bar
  $('a.dropdown-toggle').on('click', function() {
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
  
  /**
   * @fileoverview dragscroll - scroll area by dragging
   * @version 0.0.8
   *
   * @license MIT, see http://github.com/asvd/dragscroll
   * @copyright 2015 asvd <heliosframework@gmail.com> 
   */


  (function(root, factory) {
    if (typeof define === 'function' && define.amd) {
        define(['exports'], factory);
    } else if (typeof exports !== 'undefined') {
        factory(exports);
    } else {
        factory((root.dragscroll = {}));
    }
  }(this, function (exports) {
    var _window = window;
    var _document = document;
    var mousemove = 'mousemove';
    var mouseup = 'mouseup';
    var mousedown = 'mousedown';
    var EventListener = 'EventListener';
    var addEventListener = 'add'+EventListener;
    var removeEventListener = 'remove'+EventListener;
    var newScrollX;

    var dragged = [];
    var reset = function(i, el) {
        for (i = 0; i < dragged.length;) {
            el = dragged[i++];
            el = el.container || el;
            el[removeEventListener](mousedown, el.md, 0);
            _window[removeEventListener](mouseup, el.mu, 0);
            _window[removeEventListener](mousemove, el.mm, 0);
        }

        // cloning into array since HTMLCollection is updated dynamically
        dragged = [].slice.call(_document.getElementsByClassName('dragscroll'));
        for (i = 0; i < dragged.length;) {
            (function(el, lastClientX, lastClientY, pushed, scroller, cont){
                (cont = el.container || el)[addEventListener](
                    mousedown,
                    cont.md = function(e) {
                        if (!el.hasAttribute('nochilddrag') ||
                            _document.elementFromPoint(
                                e.pageX
                            ) == cont
                        ) {
                            pushed = 1;
                            lastClientX = e.clientX;

                            e.preventDefault();
                        }
                    }, 0
                );

                _window[addEventListener](
                    mouseup, cont.mu = function() {pushed = 0;}, 0
                );

                _window[addEventListener](
                    mousemove,
                    cont.mm = function(e) {
                        if (pushed) {
                            (scroller = el.scroller||el).scrollLeft -=
                                newScrollX = (- lastClientX + (lastClientX=e.clientX));
                            if (el == _document.body) {
                                (scroller = _document.documentElement).scrollLeft -= newScrollX;
                            }
                        }
                    }, 0
                );
            })(dragged[i++]);
        }
    }

      
    if (_document.readyState == 'complete') {
        reset();
    } else {
        _window[addEventListener]('load', reset, 0);
    }

    exports.reset = reset;
  }));
})

