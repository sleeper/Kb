(($) ->
  pluginName = 'jquery.rsize.paragraph'
  defaults = 
    step_limit: 200
    # set to false to NOT align middle (vertically)
    align_middle: true
    # set to false this to NOT center the text (horizontally)
    align_center: true

  class RSize
    constructor: (@element, options)->
      @options = $.extend {}, defaults, options

      @element = $(@element)

      @_defaults = defaults
      @_name = pluginName

#      @quickfit_helper = QuickfitHelper.instance(@options)

    fit: () ->
      @element.css 'white-space', 'normal'
      original_text = @element.html()
      # take measurements
      @original_width = @element.width()
      @original_height = @element.height()

      @element.html("") # empty out the object

      if !@original_width || !@original_height
        console.info('Set static height/width on target DIV before using boxfit!') if window.console?
        @element.html(original_text)
      else
        if $(original_text).find("span.rsize").length is 0
          span = $("<span></span>").addClass("rsize").html(original_text)
          @element.html span
        else
          @element.html original_text
          span = $(original_text).find('span.rsize')[0]

      @inner_span = span

      if @options.align_middle
        @element.css "display", "table"
        @inner_span.css "display", "table-cell"
        @inner_span.css "vertical-align", "middle"
      if @options.align_center
        @element.css "text-align", "center"
        @inner_span.css "text-align", "center"

      if @element.height() > @original_height
        @downsize()


    downsize: ()->
      current_step = 0
      font_size = parseInt @inner_span.css("font-size"), 10

      upper = font_size
      lower = 2 # min font size

      while upper - lower > 1
        middle = (upper + lower) / 2
        @inner_span.css "font-size", middle
        height = @element.height()

        if height == @original_height
          break
        else if height > @original_height
          upper = middle
        else # height < original_height
          lower = middle


      return @


  $.fn.rsize = (options) ->
    @each ()->
      new RSize(@, options).fit()

)(jQuery, window)

