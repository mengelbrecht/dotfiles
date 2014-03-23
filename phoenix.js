// Phoenix Config <https://github.com/sdegutis/Phoenix>

var keys = [];

// Remembers hotkey bindings.
function bind(key, mods, callback) {
  keys.push(api.bind(key, mods, callback));
}

// ############################################################################
// Modal activation
// ############################################################################

// Modal activator
// This hotkey enables/disables all other hotkeys.
var active = false;

api.bind('ä', ['cmd'], function() { active ? disableKeys() : enableKeys(); });

// These keys end Phoenix mode.
bind('escape', [], function() { disableKeys(); });
bind('return', [], function() { disableKeys(); });

// ############################################################################
// Bindings
// ############################################################################

bind('x', [], function() { App.focusOrStart('Xcode'); });
bind('s', [], function() { App.focusOrStart('Sublime Text'); });
bind('t', [], function() { App.focusOrStart('Terminal'); });
bind('f', [], function() { App.focusOrStart('Firefox'); });

bind('right', [], function() { Window.focusedWindow().nudgeRight(50); });
bind('left',  [], function() { Window.focusedWindow().nudgeLeft(50); });
bind('up',    [], function() { Window.focusedWindow().nudgeUp(50); });
bind('down',  [], function() { Window.focusedWindow().nudgeDown(50); });

bind('right', ['cmd'], function() { Window.focusedWindow().toRightHalf(); });
bind('left',  ['cmd'], function() { Window.focusedWindow().toLeftHalf(); });
bind('up',    ['cmd'], function() { Window.focusedWindow().toFullScreen(); });
bind('down',  ['cmd'], function() { Window.focusedWindow().moveToNextScreen(); });

bind('right', ['shift'], function() { Window.focusedWindow().growWidth(50); });
bind('left',  ['shift'], function() { Window.focusedWindow().shrinkWidth(50); });
bind('up',    ['shift'], function() { Window.focusedWindow().shrinkHeight(50); });
bind('down',  ['shift'], function() { Window.focusedWindow().growHeight(50); });

bind('right', ['alt'], function() { Window.focusedWindow().moveBottomRight(); });
bind('left',  ['alt'], function() { Window.focusedWindow().moveTopLeft(); });
bind('up',    ['alt'], function() { Window.focusedWindow().moveTopRight(); });
bind('down',  ['alt'], function() { Window.focusedWindow().moveBottomLeft(); });

// ############################################################################
// Helpers
// ############################################################################

// Disables all remembered keys.
function disableKeys() {
  active = false;
  _(keys).each(function(key) { key.disable(); });
  api.alert("done", 0.5);
}

// Enables all remembered keys.
function enableKeys() {
  active = true;
  _(keys).each(function(key) { key.enable(); });
  api.alert("Phoenix", 0.5);
}

// ### Helper methods `Window`
//
// #### Window#toGrid()
//
// This method can be used to push a window to a certain position and size on
// the screen by using four floats instead of pixel sizes.  Examples:
//
//     // Window position: top-left; width: 25%, height: 50%
//     someWindow.toGrid( 0, 0, 0.25, 0.5 );
//
//     // Window position: 30% top, 20% left; width: 50%, height: 35%
//     someWindow.toGrid( 0.3, 0.2, 0.5, 0.35 );
//
// The window will be automatically focused.  Returns the window instance.
Window.prototype.toGrid = function(x, y, width, height) {
  var win = this;
  var screen = win.screen().frameWithoutDockOrMenu();

  win.setFrame({
    x: Math.round(x * screen.width) + screen.x,
    y: Math.round(y * screen.height) + screen.y,
    width: Math.round(width * screen.width),
    height: Math.round(height * screen.height)
  });

  win.focusWindow();
};

Window.prototype.toFullScreen = function() { return this.toGrid(0, 0, 1, 1); };
Window.prototype.toLeftHalf = function() { return this.toGrid(0, 0, 0.5, 1); };
Window.prototype.toRightHalf = function() { return this.toGrid(0.5, 0, 0.5, 1); };

Window.prototype.nudgeLeft = function(pixels) {
  var win = this;
  var frame = win.frame();
  frame.x = frame.x >= pixels ? frame.x - pixels : 0;
  win.setFrame( frame );
};

Window.prototype.nudgeRight = function(pixels) {
  var win = this;
  var frame = win.frame();
  var maxLeft = win.screen().frameIncludingDockAndMenu().width - frame.width;
  frame.x = frame.x < maxLeft - pixels ? frame.x + pixels : maxLeft;
  win.setFrame( frame );
};

Window.prototype.nudgeUp = function(pixels) {
  var win = this;
  var frame = win.frame();
  frame.y = frame.y >= pixels ? frame.y - pixels : 0;
  win.setFrame( frame );
};

Window.prototype.nudgeDown = function(pixels) {
  var win = this;
  var frame = win.frame();
  var maxTop = win.screen().frameIncludingDockAndMenu().height - frame.height;
  frame.y = frame.y < maxTop - pixels ? frame.y + pixels : maxTop;
  win.setFrame( frame );
};

Window.prototype.moveTopLeft = function () {
  var win = this;
  var wframe = win.frame();
  var sframe = win.screen().frameWithoutDockOrMenu();
  win.setFrame({
    x: sframe.x,
    y: sframe.y,
    width: wframe.width,
    height: wframe.height
  });
};

Window.prototype.moveTopRight = function () {
  var win = this;
  var wframe = win.frame();
  var sframe = win.screen().frameIncludingDockAndMenu();
  win.setFrame({
    x: (sframe.x + sframe.width) - wframe.width,
    y: sframe.y,
    width: wframe.width,
    height: wframe.height
  });
};

Window.prototype.moveBottomLeft = function () {
  var win = this;
  var wframe = win.frame();
  var sframe = win.screen().frameWithoutDockOrMenu();
  win.setFrame({
    x: sframe.x,
    y: (sframe.y + sframe.height) - wframe.height,
    width: wframe.width,
    height: wframe.height
  });
};

Window.prototype.moveBottomRight = function () {
  var win = this;
  var wframe = win.frame();
  var sframe = win.screen().frameIncludingDockAndMenu();
  win.setFrame({
    x: (sframe.x + sframe.width) - wframe.width,
    y: (sframe.y + sframe.height) - wframe.height,
    width: wframe.width,
    height: wframe.height
  });
};

Window.prototype.moveToScreen = function(screen) {
  var win = Window.focusedWindow();
  var frame = win.frame();
  var oldScreenRect = win.screen().frameWithoutDockOrMenu();
  var newScreenRect = screen.frameWithoutDockOrMenu();
  var xRatio = newScreenRect.width / oldScreenRect.width;
  var yRatio = newScreenRect.height / oldScreenRect.height;

  win.setFrame({
    x: (Math.round(frame.x - oldScreenRect.x) * xRatio) + newScreenRect.x,
    y: (Math.round(frame.y - oldScreenRect.y) * yRatio) + newScreenRect.y,
    width: Math.round(frame.width * xRatio),
    height: Math.round(frame.height * yRatio)
  });
};

Window.prototype.moveToNextScreen = function() { return this.moveToScreen(this.screen().nextScreen()); };
Window.prototype.moveToPreviousScreen = function() { return this.moveToScreen(this.screen().previousScreen()); };

Window.prototype.growWidth = function(pixels) {
  var win = this;
  var frame = win.frame();
  var screenFrame = win.screen().frameIncludingDockAndMenu();
  frame.width += pixels;
  win.setFrame(frame);
};

Window.prototype.growHeight = function(pixels) {
  var win = this;
  var frame = win.frame();
  var screenFrame = win.screen().frameIncludingDockAndMenu();
  frame.height += pixels;
  win.setFrame(frame);
};

Window.prototype.shrinkWidth = function(pixels) {
  var win = this;
  var frame = win.frame();
  var screenFrame = win.screen().frameIncludingDockAndMenu();
  frame.width -= pixels;
  win.setFrame(frame);
};

Window.prototype.shrinkHeight = function(pixels) {
  var win = this;
  var frame = win.frame();
  var screenFrame = win.screen().frameWithoutDockOrMenu();
  frame.height -= pixels;
  win.setFrame(frame);
};

// ### Helper methods `App`

App.allWithTitle = function(title) {
  return _(this.runningApps()).filter( function( app ) {
    if (app.title() === title)
      return true;
  });
};

App.focusOrStart = function (title) {
  var apps = App.allWithTitle(title);
  if (_.isEmpty(apps)) {
    api.alert(" Starting " + title);
    api.launch(title)
    return;
  }

  var windows = _.chain(apps)
    .map(function(x) { return x.allWindows(); })
    .flatten()
    .value();

  activeWindows = _(windows).reject(function(win) { return win.isWindowMinimized(); });
  if (_.isEmpty(activeWindows)) {
    api.alert("All windows minimized for " + title);
    return;
  }

  activeWindows.forEach(function(win) { win.focusWindow(); });
};

// ############################################################################
// Init
// ############################################################################

// Initially disable all hotkeys
disableKeys();
