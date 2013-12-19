// Based on https://gist.github.com/gfreezy/6060661

slate.config("windowHintsShowIcons", true);
slate.config("windowHintsIgnoreHiddenWindows", false);
slate.config("windowHintsSpread", true);
slate.config("windowHintsSpreadSearchWidth", 60);
slate.config("secondsBeforeRepeat", 0.2);
slate.config("secondsBetweenRepeat", 0.0);
slate.config("gridBackgroundColor", [75, 77, 81, 0.6]);
slate.config("gridCellBackgroundColor", [75, 77, 81, 0.6]);

var pushRight = slate.operation("push", {
    "direction": "right",
    "style": "bar-resize:screenSizeX/2"
});

var pushLeft = slate.operation("push", {
    "direction": "left",
    "style": "bar-resize:screenSizeX/2"
});

var throwNextLeft = slate.operation("throw", {
    "width": "screenSizeX/2",
    "height": "screenSizeY",
    "screen": "next"
});

var throwNextRight = slate.operation("throw", {
    "x": "screenOriginX+(screenSizeX)/2",
    "y": "screenOriginY",
    "width": "screenSizeX/2",
    "height": "screenSizeY",
    "screen": "next"
});

var fullscreen = slate.operation("move", {
    "x": "screenOriginX",
    "y": "screenOriginY",
    "width": "screenSizeX",
    "height": "screenSizeY"
});

var throwNextFullscreen = slate.operation("throw", {
    "x": "screenOriginX",
    "y": "screenOriginY",
    "width": "screenSizeX",
    "height": "screenSizeY",
    "screen": "next"
});

var grid = slate.operation("grid", {
    "grids": {
        "1440x900": {
            "width": 8,
            "height": 6
        },
        "1920x1080": {
            "width": 8,
            "height": 6
        },
        "1920x1200": {
            "width": 8,
            "height": 6
        }
    },
    "padding": 5
});

var growRight = slate.operation("resize", {
    "width" : "+10%",
    "height" : "+0"
});

var shrinkRight = slate.operation("resize", {
    "width" : "-10%",
    "height" : "+0"
});

var moveTopLeft = slate.operation("corner", {
    "direction": "top-left"
});

var growDown = slate.operation("resize", {
    "width" : "+0",
    "height" : "+10%"
});

var shrinkDown = slate.operation("resize", {
    "width" : "+0",
    "height" : "-10%"
});

var moveTopRight = slate.operation("corner", {
    "direction": "top-right"
});

var moveBottomRight = slate.operation("corner", {
    "direction": "bottom-right"
});

var switcher = slate.operation("hint");

var throwNext = function(win) {
    if (!win) {
        return;
    }
    var winRect = win.rect();
    var screen = win.screen().visibleRect();

    var newX = (winRect.x - screen.x) / screen.width + "*screenSizeX+screenOriginX";
    var newY = (winRect.y - screen.y) / screen.height + "*screenSizeY+screenOriginY";
    var newWidth = winRect.width / screen.width + "*screenSizeX";
    var newHeight = winRect.height / screen.height + "*screenSizeY";
    var throwNext = slate.operation("throw", {
        "x": newX,
        "y": newY,
        "width": newWidth,
        "height": newHeight,
        "screen": "next"
    });
    win.doOperation(throwNext);
};

var pushedLeft = function(win) {
    if (!win) {
        return false;
    }
    var winRect = win.rect();
    var screen = win.screen().visibleRect();

    if (winRect.x === screen.x &&
        winRect.y === screen.y &&
        winRect.width === screen.width / 2 &&
        winRect.height === screen.height
    ) {
        return true;
    }
    return false;
};

var pushedRight = function(win) {
    if (!win) {
        return false;
    }
    var winRect = win.rect();
    var screen = win.screen().visibleRect();

    if (winRect.x === screen.x + screen.width / 2 &&
        winRect.y === screen.y &&
        winRect.width === screen.width / 2 &&
        winRect.height === screen.height
    ) {
        return true;
    }
    return false;
};

var isFullscreen = function(win) {
    if (!win) {
        return false;
    }
    var winRect = win.rect();
    var screen = win.screen().visibleRect();
    if (winRect.width === screen.width &&
        winRect.height === screen.height
    ) {
        return true;
    }
    return false;
};


slate.bind("left:alt,cmd", function(win) {
    if (!win) {
        return false;
    }
    if (pushedLeft(win)) {
        win.doOperation(throwNextLeft);
    } else {
        win.doOperation(pushLeft);
    }
});

slate.bind("right:alt,cmd", function(win) {
    if (!win) {
        return false;
    }

    if (pushedRight(win)) {
        win.doOperation(throwNextRight);
    } else {
        win.doOperation(pushRight);
    }
});

slate.bind("up:alt,cmd", function(win) {
    if (!win) {
        return false;
    }

    if (isFullscreen(win)) {
        win.doOperation(throwNextFullscreen);
    } else {
        win.doOperation(fullscreen);
    }
});

slate.bind("down:alt,cmd", function(win) {
    if (!win) {
        return false;
    }

    if (pushedLeft(win)) {
        win.doOperation(throwNextLeft);
    } else if (pushedRight(win)) {
        win.doOperation(throwNextRight);
    } else if (isFullscreen(win)) {
        win.doOperation(throwNextFullscreen);
    } else {
        throwNext(win);
    }
});


slate.bind("left:ctrl,alt,cmd", shrinkRight);
slate.bind("right:ctrl,alt,cmd", growRight);
slate.bind("up:ctrl,alt,cmd", shrinkDown);
slate.bind("down:ctrl,alt,cmd", growDown);

slate.bind("up:ctrl,alt", throwNext);
slate.bind("down:ctrl,alt", moveBottomRight);
slate.bind("left:ctrl,alt", moveTopLeft);
slate.bind("right:ctrl,alt", moveTopRight);

slate.bind("g:alt,cmd", grid);
slate.bind("h:alt,cmd", switcher);

slate.source(".slate.js.local")
