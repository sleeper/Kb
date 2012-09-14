var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Kb.Raphael.Ticket = (function() {
  var Avatar, Title;

  Ticket.prototype.width = 70;

  Ticket.prototype.height = 90;

  Ticket.prototype.fill_color = '223.19625301042-#f7ec9a:0-#f6ea8d:13.400906-#f5e98a:45.673525-#f8ed9d:80.933785-#f5e98a:100';

  Avatar = (function() {

    Avatar.prototype.x_offset = 50;

    Avatar.prototype.y_offset = 70;

    Avatar.prototype.width = 30;

    Avatar.prototype.height = 30;

    function Avatar(paper, img, tx, ty) {
      this.paper = paper;
      this.img = img;
      this.x = tx + this.x_offset;
      this.y = ty + this.y_offset;
      this.el = this.paper.image(this.img, this.x, this.y, this.width, this.height);
    }

    Avatar.prototype.move = function(x, y) {
      this.x = x + this.x_offset;
      this.y = y + this.y_offset;
      return this.el.attr({
        x: this.x,
        y: this.y
      });
    };

    return Avatar;

  })();

  Title = (function() {

    Title.prototype.y_offset = 10;

    Title.prototype.x_offset = 5;

    Title.prototype.resize = function() {
      var font_size, height, lower, middle, original_height, original_width, title, title_height, upper, _results;
      original_height = this.title_frame.getAttribute("height");
      original_width = this.title_frame.getAttribute("width");
      title = $(this.title);
      title_height = title.height();
      if (title_height <= original_height) {
        return;
      }
      font_size = parseInt(title.css("font-size"), 10);
      upper = font_size;
      lower = 2;
      _results = [];
      while ((upper - lower) > 1) {
        middle = (upper + lower) / 2;
        title.css("font-size", middle);
        height = title.height();
        if (height === original_height) {
          break;
        } else if (height > original_height) {
          _results.push(upper = middle);
        } else {
          _results.push(lower = middle);
        }
      }
      return _results;
    };

    function Title(paper, text, x, y, width, height) {
      var body;
      this.paper = paper;
      this.text = text;
      this.x = x;
      this.y = y;
      this.width = width;
      this.height = height;
      this.title_frame = document.createElementNS("http://www.w3.org/2000/svg", "foreignObject");
      this.title_frame.setAttribute("x", this.x + this.x_offset);
      this.title_frame.setAttribute("y", this.y + this.y_offset + 5);
      this.title_frame.setAttribute("width", this.width - this.x_offset - 5);
      this.title_frame.setAttribute("height", this.height - this.y_offset - 5);
      body = document.createElement("body");
      this.title_frame.appendChild(body);
      this.title = document.createElement("div");
      body.appendChild(this.title);
      $(this.title).html(this.text);
      this.paper.canvas.appendChild(this.title_frame);
      this.resize();
    }

    Title.prototype.move = function(x, y) {
      this.x = x;
      this.y = y;
      this.title_frame.setAttribute("x", this.x + this.x_offset);
      return this.title_frame.setAttribute("y", this.y + this.y_offset + 5);
    };

    Title.prototype.update_title = function(text) {
      this.text = text;
      $(this.title).html(this.text);
      return this.resize();
    };

    return Title;

  })();

  function Ticket(board, model) {
    this.board = board;
    this.model = model;
    this.up = __bind(this.up, this);

    this.start = __bind(this.start, this);

    this.dragged = __bind(this.dragged, this);

    this.board.paper;
  }

  Ticket.prototype.dragged = function(dx, dy) {
    var col, sl, _ref, _ref1;
    this.x = this.ox + dx;
    this.y = this.oy + dy;
    this.frame.attr({
      x: this.x,
      y: this.y
    });
    this.title.move(this.x, this.y);
    this.avatar.move(this.x, this.y);
    _ref = this.board.getColumnAndSwimlane(this.x, this.y), col = _ref[0], sl = _ref[1];
    if (col !== this.cur_col || sl !== this.cur_sl) {
      eve("cell.leaving", this.el, this.cur_col, this.cur_sl);
      if ((col != null) && (sl != null)) {
        eve("cell.entering", this.el, col, sl);
      }
    }
    return _ref1 = [col, sl], this.cur_col = _ref1[0], this.cur_sl = _ref1[1], _ref1;
  };

  Ticket.prototype.start = function() {
    var _ref, _ref1;
    this.frame.animate({
      opacity: .25
    }, 500, ">");
    this.ox = this.frame.attr("x");
    this.oy = this.frame.attr("y");
    _ref = this.board.getColumnAndSwimlane(this.ox, this.oy), this.ocol = _ref[0], this.osl = _ref[1];
    return _ref1 = [this.ocol, this.osl], this.cur_col = _ref1[0], this.cur_sl = _ref1[1], _ref1;
  };

  Ticket.prototype.up = function() {
    var force_move, x, y, _ref, _ref1;
    if (!(this.cur_col != null) || !(this.cur_sl != null)) {
      this.cur_col = this.ocol;
      this.cur_sl = this.osl;
      _ref = [this.ox, this.oy], this.x = _ref[0], this.y = _ref[1];
      force_move = true;
    }
    eve("cell.dropped", this.el, this.cur_col, this.cur_sl);
    this.frame.animate({
      opacity: 1
    }, 500, ">");
    _ref1 = this.board.compute_relative_coordinates(this.cur_col, this.cur_sl, this.x, this.y), x = _ref1[0], y = _ref1[1];
    this.model.set({
      column: this.cur_col,
      swimlane: this.cur_sl,
      x: x,
      y: y
    });
    if (force_move) {
      return this.move();
    }
  };

  Ticket.prototype.move = function() {
    var _ref;
    _ref = this.board.compute_absolute_coordinates(this.model.get('column'), this.model.get('swimlane'), this.model.get('x'), this.model.get('y')), this.x = _ref[0], this.y = _ref[1];
    this.frame.attr({
      x: this.x,
      y: this.y
    });
    this.title.move(this.x, this.y);
    return this.avatar.move(this.x, this.y);
  };

  Ticket.prototype.draw_frame = function() {
    var blur1, filter1, merge1, offset1,
      _this = this;
    this.frame = this.board.paper.rect(this.x, this.y, this.width, this.height);
    this.frame.attr({
      fill: this.fill_color
    });
    this.frame.node.setAttribute("class", "ticket");
    $(this.frame.node).on("window:resized", function() {
      return _this.title.resize();
    });
    filter1 = this.board.paper.filterCreate("filter1");
    this.frame.filterInstall(filter1);
    blur1 = Raphael.filterOps.feGaussianBlur({
      stdDeviation: "1.2",
      "in": "SourceAlpha",
      result: "blur1"
    });
    offset1 = Raphael.filterOps.feOffset({
      "in": "blur1",
      dx: 2,
      dy: 2,
      result: "offsetBlur"
    });
    merge1 = Raphael.filterOps.feMerge(["offsetBlur", "SourceGraphic"]);
    filter1.appendOperation(blur1);
    filter1.appendOperation(offset1);
    return filter1.appendOperation(merge1);
  };

  Ticket.prototype.update_title = function() {
    return this.title.update_title(this.model.get('title'));
  };

  Ticket.prototype.draw = function() {
    var _ref;
    _ref = this.board.compute_absolute_coordinates(this.model.get('column'), this.model.get('swimlane'), this.model.get('x'), this.model.get('y')), this.x = _ref[0], this.y = _ref[1];
    this.draw_frame();
    this.title = new Title(this.board.paper, this.model.get('title'), this.x, this.y, this.width, this.height);
    this.avatar = new Avatar(this.board.paper, "../assets/imgs/" + (this.model.get('avatar')), this.x, this.y);
    this.frame.drag(this.dragged, this.start, this.up);
    return this;
  };

  return Ticket;

})();
