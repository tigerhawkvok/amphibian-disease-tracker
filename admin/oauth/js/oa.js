var activityIndicatorOff, activityIndicatorOn, animateLoad, bindClicks, bindDismissalRemoval, bsAlert, byteCount, d$, decode64, deepJQuery, delay, doCORSget, e, encode64, foo, formatScientificNames, getLocation, getMaxZ, getPosterFromSrc, goTo, insertGoogleOAuth, isBlank, isBool, isEmpty, isHovered, isJson, isNull, isNumber, jsonTo64, lightboxImages, loadJS, loggedIn, mapNewWindows, openLink, openTab, overlayOff, overlayOn, p$, prepURI, randomInt, removeSimpleLogin, replaceLoginPrompt, roundNumber, roundNumberSigfig, safariDialogHelper, startLoad, stopLoad, stopLoadError, testAPI, toFloat, toInt, toObject, toastStatusMessage, uri,
  slice = [].slice;

try {
  uri = new Object();
  uri.o = $.url();
  uri.urlString = uri.o.attr('protocol') + '://' + uri.o.attr('host') + uri.o.attr("directory");
  uri.query = uri.o.attr("fragment");
} catch (_error) {
  e = _error;
  console.warn("PURL not installed!");
}

window.locationData = new Object();

locationData.params = {
  enableHighAccuracy: true
};

locationData.last = void 0;

window.debounce_timer = null;

if (window.adminParams == null) {
  window.adminParams = new Object();
}

isBool = function(str, strict) {
  if (strict == null) {
    strict = false;
  }
  if (strict) {
    return typeof str === "boolean";
  }
  try {
    if (typeof str === "boolean") {
      return str === true || str === false;
    }
    if (typeof str === "string") {
      return str.toLowerCase() === "true" || str.toLowerCase() === "false";
    }
    if (typeof str === "number") {
      return str === 1 || str === 0;
    }
    return false;
  } catch (_error) {
    e = _error;
    return false;
  }
};

isEmpty = function(str) {
  return !str || str.length === 0;
};

isBlank = function(str) {
  return !str || /^\s*$/.test(str);
};

isNull = function(str) {
  try {
    if (isEmpty(str) || isBlank(str) || (str == null)) {
      if (!(str === false || str === 0)) {
        return true;
      }
    }
  } catch (_error) {
    e = _error;
    return false;
  }
  return false;
};

isJson = function(str) {
  if (typeof str === 'object') {
    return true;
  }
  try {
    JSON.parse(str);
    return true;
  } catch (_error) {
    e = _error;
    return false;
  }
  return false;
};

isNumber = function(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
};

toFloat = function(str) {
  if (!isNumber(str) || isNull(str)) {
    return 0;
  }
  return parseFloat(str);
};

toInt = function(str) {
  if (!isNumber(str) || isNull(str)) {
    return 0;
  }
  return parseInt(str);
};

String.prototype.toBool = function() {
  return this.toString().toLowerCase() === 'true';
};

Boolean.prototype.toBool = function() {
  return this.toString() === 'true';
};

Number.prototype.toBool = function() {
  return this.toString() === "1";
};

String.prototype.addSlashes = function() {
  return this.replace(/[\\"']/g, '\\$&').replace(/\u0000/g, '\\0');
};

Array.prototype.max = function() {
  return Math.max.apply(null, this);
};

Array.prototype.min = function() {
  return Math.min.apply(null, this);
};

Object.size = function(obj) {
  var key, size;
  if (typeof obj !== "object") {
    try {
      return obj.length;
    } catch (_error) {
      e = _error;
      console.error("Passed argument isn't an object and doesn't have a .length parameter");
      console.warn(e.message);
    }
  }
  size = 0;
  for (key in obj) {
    if (obj.hasOwnProperty(key)) {
      size++;
    }
  }
  return size;
};

delay = function(ms, f) {
  return setTimeout(f, ms);
};

roundNumber = function(number, digits) {
  var multiple;
  if (digits == null) {
    digits = 0;
  }
  multiple = Math.pow(10, digits);
  return Math.round(number * multiple) / multiple;
};

roundNumberSigfig = function(number, digits) {
  var digArr, needDigits, newNumber, significand, trailingDigits;
  if (digits == null) {
    digits = 0;
  }
  newNumber = roundNumber(number, digits).toString();
  digArr = newNumber.split(".");
  if (digArr.length === 1) {
    return newNumber + "." + (Array(digits + 1).join("0"));
  }
  trailingDigits = digArr.pop();
  significand = digArr[0] + ".";
  if (trailingDigits.length === digits) {
    return newNumber;
  }
  needDigits = digits - trailingDigits.length;
  trailingDigits += Array(needDigits + 1).join("0");
  return "" + significand + trailingDigits;
};

jsonTo64 = function(obj) {
  var objString;
  if (typeof obj === "array") {
    obj = toObject(arr);
  }
  objString = JSON.stringify(obj);
  return encodeURIComponent(encode64(objString));
};

encode64 = function(string) {
  try {
    return Base64.encode(string);
  } catch (_error) {
    e = _error;
    console.warn("Bad encode string provided");
    return string;
  }
};

decode64 = function(string) {
  try {
    return Base64.decode(string);
  } catch (_error) {
    e = _error;
    console.warn("Bad decode string provided");
    return string;
  }
};

jQuery.fn.polymerSelected = function(setSelected, attrLookup) {
  var attr, itemSelector, val;
  if (setSelected == null) {
    setSelected = void 0;
  }
  if (attrLookup == null) {
    attrLookup = "attrForSelected";
  }

  /*
   * See
   * https://elements.polymer-project.org/elements/paper-menu
   * https://elements.polymer-project.org/elements/paper-radio-group
   *
   * @param attrLookup is based on
   * https://elements.polymer-project.org/elements/iron-selector?active=Polymer.IronSelectableBehavior
   */
  attr = $(this).attr(attrLookup);
  if (setSelected != null) {
    if (!isBool(setSelected)) {
      try {
        return $(this).get(0).select(setSelected);
      } catch (_error) {
        e = _error;
        return false;
      }
    } else {
      $(this).parent().children().removeAttribute("aria-selected");
      $(this).parent().children().removeAttribute("active");
      $(this).parent().children().removeClass("iron-selected");
      $(this).prop("selected", setSelected);
      $(this).prop("active", setSelected);
      $(this).prop("aria-selected", setSelected);
      if (setSelected === true) {
        return $(this).addClass("iron-selected");
      }
    }
  } else {
    val = void 0;
    try {
      val = $(this).get(0).selected;
      if (isNumber(val) && !isNull(attr)) {
        itemSelector = $(this).find("paper-item")[toInt(val)];
        val = $(itemSelector).attr(attr);
      }
    } catch (_error) {
      e = _error;
      return false;
    }
    if (val === "null" || (val == null)) {
      val = void 0;
    }
    return val;
  }
};

jQuery.fn.polymerChecked = function(setChecked) {
  var val;
  if (setChecked == null) {
    setChecked = void 0;
  }
  if (setChecked != null) {
    return jQuery(this).prop("checked", setChecked);
  } else {
    val = jQuery(this)[0].checked;
    if (val === "null" || (val == null)) {
      val = void 0;
    }
    return val;
  }
};

isHovered = function(selector) {
  return $(selector + ":hover").length > 0;
};

jQuery.fn.exists = function() {
  return jQuery(this).length > 0;
};

jQuery.fn.isVisible = function() {
  return jQuery(this).is(":visible") && jQuery(this).css("visibility") !== "hidden";
};

jQuery.fn.hasChildren = function() {
  return Object.size(jQuery(this).children()) > 3;
};

byteCount = (function(_this) {
  return function(s) {
    return encodeURI(s).split(/%..|./).length - 1;
  };
})(this);

function shuffle(o) { //v1.0
    for (var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
};

toObject = function(array) {
  var element, index, rv;
  rv = new Object();
  for (index in array) {
    element = array[index];
    if (element !== void 0) {
      rv[index] = element;
    }
  }
  return rv;
};

loadJS = function(src, callback, doCallbackOnError) {
  var errorFunction, onLoadFunction, s;
  if (callback == null) {
    callback = new Object();
  }
  if (doCallbackOnError == null) {
    doCallbackOnError = true;
  }

  /*
   * Load a new javascript file
   *
   * If it's already been loaded, jump straight to the callback
   *
   * @param string src The source URL of the file
   * @param function callback Function to execute after the script has
   *                          been loaded
   * @param bool doCallbackOnError Should the callback be executed if
   *                               loading the script produces an error?
   */
  if ($("script[src='" + src + "']").exists()) {
    if (typeof callback === "function") {
      try {
        callback();
      } catch (_error) {
        e = _error;
        console.error("Script is already loaded, but there was an error executing the callback function - " + e.message);
      }
    }
    return true;
  }
  s = document.createElement("script");
  s.setAttribute("src", src);
  s.setAttribute("async", "async");
  s.setAttribute("type", "text/javascript");
  s.src = src;
  s.async = true;
  onLoadFunction = function() {
    var state;
    state = s.readyState;
    try {
      if (!callback.done && (!state || /loaded|complete/.test(state))) {
        callback.done = true;
        if (typeof callback === "function") {
          try {
            return callback();
          } catch (_error) {
            e = _error;
            console.error("Postload callback error for " + src + " - " + e.message);
            return console.warn(e.stack);
          }
        }
      }
    } catch (_error) {
      e = _error;
      return console.error("Onload error - " + e.message);
    }
  };
  errorFunction = function() {
    console.warn("There may have been a problem loading " + src);
    try {
      if (!callback.done) {
        callback.done = true;
        if (typeof callback === "function" && doCallbackOnError) {
          try {
            return callback();
          } catch (_error) {
            e = _error;
            return console.error("Post error callback error - " + e.message);
          }
        }
      }
    } catch (_error) {
      e = _error;
      return console.error("There was an error in the error handler! " + e.message);
    }
  };
  s.setAttribute("onload", onLoadFunction);
  s.setAttribute("onreadystate", onLoadFunction);
  s.setAttribute("onerror", errorFunction);
  s.onload = s.onreadystate = onLoadFunction;
  s.onerror = errorFunction;
  document.getElementsByTagName('head')[0].appendChild(s);
  return true;
};

String.prototype.toTitleCase = function() {
  var i, j, len, len1, lower, lowerRegEx, lowers, str, upper, upperRegEx, uppers;
  str = this.replace(/([^\W_]+[^\s-]*) */g, function(txt) {
    return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
  });
  lowers = ["A", "An", "The", "And", "But", "Or", "For", "Nor", "As", "At", "By", "For", "From", "In", "Into", "Near", "Of", "On", "Onto", "To", "With"];
  for (i = 0, len = lowers.length; i < len; i++) {
    lower = lowers[i];
    lowerRegEx = new RegExp("\\s" + lower + "\\s", "g");
    str = str.replace(lowerRegEx, function(txt) {
      return txt.toLowerCase();
    });
  }
  uppers = ["Id", "Tv"];
  for (j = 0, len1 = uppers.length; j < len1; j++) {
    upper = uppers[j];
    upperRegEx = new RegExp("\\b" + upper + "\\b", "g");
    str = str.replace(upperRegEx, upper.toUpperCase());
  }
  return str;
};

Function.prototype.debounce = function() {
  var args, delayed, execAsap, func, threshold, timeout;
  threshold = arguments[0], execAsap = arguments[1], timeout = arguments[2], args = 4 <= arguments.length ? slice.call(arguments, 3) : [];
  if (threshold == null) {
    threshold = 300;
  }
  if (execAsap == null) {
    execAsap = false;
  }
  if (timeout == null) {
    timeout = debounce_timer;
  }
  func = this;
  delayed = function() {
    if (!execAsap) {
      func.apply(func, args);
    }
    return console.log("Debounce applied");
  };
  if (timeout != null) {
    try {
      clearTimeout(timeout);
    } catch (_error) {
      e = _error;
    }
  } else if (execAsap) {
    func.apply(obj, args);
    console.log("Executed immediately");
  }
  return setTimeout(delayed, threshold);
};

randomInt = function(lower, upper) {
  var ref, ref1, start;
  if (lower == null) {
    lower = 0;
  }
  if (upper == null) {
    upper = 1;
  }
  start = Math.random();
  if (lower == null) {
    ref = [0, lower], lower = ref[0], upper = ref[1];
  }
  if (lower > upper) {
    ref1 = [upper, lower], lower = ref1[0], upper = ref1[1];
  }
  return Math.floor(start * (upper - lower + 1) + lower);
};

animateLoad = function(elId) {
  var selector;
  if (elId == null) {
    elId = "loader";
  }

  /*
   * Suggested CSS to go with this:
   *
   * #loader {
   *     position:fixed;
   *     top:50%;
   *     left:50%;
   * }
   * #loader.good::shadow .circle {
   *     border-color: rgba(46,190,17,0.9);
   * }
   * #loader.bad::shadow .circle {
   *     border-color:rgba(255,0,0,0.9);
   * }
   *
   * Uses Polymer 1.0
   */
  if (isNumber(elId)) {
    elId = "loader";
  }
  if (elId.slice(0, 1) === "#") {
    selector = elId;
    elId = elId.slice(1);
  } else {
    selector = "#" + elId;
  }
  try {
    if (!$(selector).exists()) {
      $("body").append("<paper-spinner id=\"" + elId + "\" active></paper-spinner");
    } else {
      $(selector).attr("active", true);
    }
    return false;
  } catch (_error) {
    e = _error;
    return console.log('Could not animate loader', e.message);
  }
};

startLoad = animateLoad;

stopLoad = function(elId, fadeOut) {
  var selector;
  if (elId == null) {
    elId = "loader";
  }
  if (fadeOut == null) {
    fadeOut = 1000;
  }
  if (elId.slice(0, 1) === "#") {
    selector = elId;
    elId = elId.slice(1);
  } else {
    selector = "#" + elId;
  }
  try {
    if ($(selector).exists()) {
      $(selector).addClass("good");
      return delay(fadeOut, function() {
        $(selector).removeClass("good");
        return $(selector).removeAttr("active");
      });
    }
  } catch (_error) {
    e = _error;
    return console.log('Could not stop load animation', e.message);
  }
};

stopLoadError = function(message, elId, fadeOut) {
  var selector;
  if (elId == null) {
    elId = "loader";
  }
  if (fadeOut == null) {
    fadeOut = 5000;
  }
  if (elId.slice(0, 1) === "#") {
    selector = elId;
    elId = elId.slice(1);
  } else {
    selector = "#" + elId;
  }
  try {
    if ($(selector).exists()) {
      $(selector).addClass("bad");
      if (message != null) {
        toastStatusMessage(message, "", fadeOut);
      }
      return delay(fadeOut, function() {
        $(selector).removeClass("bad");
        return $(selector).removeAttr("active");
      });
    }
  } catch (_error) {
    e = _error;
    return console.log('Could not stop load error animation', e.message);
  }
};

toastStatusMessage = function(message, className, duration, selector) {
  var html, ref;
  if (className == null) {
    className = "";
  }
  if (duration == null) {
    duration = 3000;
  }
  if (selector == null) {
    selector = "#status-message";
  }

  /*
   * Pop up a status message
   */
  if (((ref = window.metaTracker) != null ? ref.isToasting : void 0) == null) {
    if (window.metaTracker == null) {
      window.metaTracker = new Object();
      window.metaTracker.isToasting = false;
    }
  }
  if (window.metaTracker.isToasting) {
    delay(250, function() {
      return toastStatusMessage(message, className, duration, selector);
    });
    return false;
  }
  window.metaTracker.isToasting = true;
  if (!isNumber(duration)) {
    duration = 3000;
  }
  if (selector.slice(0, 1) === !"#") {
    selector = "#" + selector;
  }
  if (!$(selector).exists()) {
    html = "<paper-toast id=\"" + (selector.slice(1)) + "\" duration=\"" + duration + "\"></paper-toast>";
    $(html).appendTo("body");
  }
  $(selector).attr("text", message).text(message).addClass(className);
  $(selector).get(0).show();
  return delay(duration + 500, function() {
    $(selector).empty();
    $(selector).removeClass(className);
    $(selector).attr("text", "");
    return window.metaTracker.isToasting = false;
  });
};

openLink = function(url) {
  if (url == null) {
    return false;
  }
  window.open(url);
  return false;
};

openTab = function(url) {
  return openLink(url);
};

goTo = function(url) {
  if (url == null) {
    return false;
  }
  window.location.href = url;
  return false;
};

mapNewWindows = function(stopPropagation) {
  if (stopPropagation == null) {
    stopPropagation = true;
  }
  return $(".newwindow").each(function() {
    var curHref, openInNewWindow;
    curHref = $(this).attr("href");
    if (curHref == null) {
      curHref = $(this).attr("data-href");
    }
    openInNewWindow = function(url) {
      if (url == null) {
        return false;
      }
      window.open(url);
      return false;
    };
    $(this).click(function(e) {
      if (stopPropagation) {
        e.preventDefault();
        e.stopPropagation();
      }
      return openInNewWindow(curHref);
    });
    return $(this).keypress(function() {
      return openInNewWindow(curHref);
    });
  });
};

deepJQuery = function(selector) {

  /*
   * Do a shadow-piercing selector
   *
   * Cross-browser, works with Chrome, Firefox, Opera, Safari, and IE
   * Falls back to standard jQuery selector when everything fails.
   */
  try {
    if (!$("html /deep/ " + selector).exists()) {
      throw "Bad /deep/ selector";
    }
    return $("html /deep/ " + selector);
  } catch (_error) {
    e = _error;
    try {
      if (!$("html >>> " + selector).exists()) {
        throw "Bad >>> selector";
      }
      return $("html >>> " + selector);
    } catch (_error) {
      e = _error;
      return $(selector);
    }
  }
};

d$ = function(selector) {
  return deepJQuery(selector);
};

bindClicks = function(selector) {
  if (selector == null) {
    selector = ".click";
  }

  /*
   * Helper function. Bind everything with a selector
   * to execute a function data-function or to go to a
   * URL data-href.
   */
  $(selector).each(function() {
    var callable, url;
    try {
      url = $(this).attr("data-href");
      if (!isNull(url)) {
        $(this).unbind();
        try {
          if (url === uri.o.attr("path") && $(this).prop("tagName").toLowerCase() === "paper-tab") {
            $(this).parent().prop("selected", $(this).index());
          }
        } catch (_error) {
          e = _error;
          console.warn("tagname lower case error");
        }
        $(this).click(function() {
          var ref, ref1, ref2;
          if (((ref = $(this).attr("newTab")) != null ? ref.toBool() : void 0) || ((ref1 = $(this).attr("newtab")) != null ? ref1.toBool() : void 0) || ((ref2 = $(this).attr("data-newtab")) != null ? ref2.toBool() : void 0)) {
            return openTab(url);
          } else {
            return goTo(url);
          }
        });
        return url;
      } else {
        callable = $(this).attr("data-function");
        if (callable != null) {
          $(this).unbind();
          return $(this).click(function() {
            try {
              console.log("Executing bound function " + callable + "()");
              return window[callable]();
            } catch (_error) {
              e = _error;
              return console.error("'" + callable + "()' is a bad function - " + e.message);
            }
          });
        }
      }
    } catch (_error) {
      e = _error;
      return console.error("There was a problem binding to #" + ($(this).attr("id")) + " - " + e.message);
    }
  });
  return false;
};

getPosterFromSrc = function(srcString) {

  /*
   * Take the "src" attribute of a video and get the
   * "png" screencap from it, and return the value.
   */
  var dummy, split;
  try {
    split = srcString.split(".");
    dummy = split.pop();
    split.push("png");
    return split.join(".");
  } catch (_error) {
    e = _error;
    return "";
  }
};

doCORSget = function(url, args, callback, callbackFail) {
  var corsFail, createCORSRequest, settings, xhr;
  if (callback == null) {
    callback = void 0;
  }
  if (callbackFail == null) {
    callbackFail = void 0;
  }
  corsFail = function() {
    if (typeof callbackFail === "function") {
      return callbackFail();
    } else {
      throw new Error("There was an error performing the CORS request");
    }
  };
  settings = {
    url: url,
    data: args,
    type: "get",
    crossDomain: true
  };
  try {
    $.ajax(settings).done(function(result) {
      if (typeof callback === "function") {
        callback();
        return false;
      }
      return console.log(response);
    }).fail(function(result, status) {
      return console.warn("Couldn't perform jQuery AJAX CORS. Attempting manually.");
    });
  } catch (_error) {
    e = _error;
    console.warn("There was an error using jQuery to perform the CORS request. Attemping manually.");
  }
  url = url + "?" + args;
  createCORSRequest = function(method, url) {
    var xhr;
    if (method == null) {
      method = "get";
    }
    xhr = new XMLHttpRequest();
    if ("withCredentials" in xhr) {
      xhr.open(method, url, true);
    } else if (typeof XDomainRequest !== "undefined") {
      xhr = new XDomainRequest();
      xhr.open(method, url);
    } else {
      xhr = null;
    }
    return xhr;
  };
  xhr = createCORSRequest("get", url);
  if (!xhr) {
    throw new Error("CORS not supported");
  }
  xhr.onload = function() {
    var response;
    response = xhr.responseText;
    if (typeof callback === "function") {
      callback(response);
    }
    console.log(response);
    return false;
  };
  xhr.onerror = function() {
    console.warn("Couldn't do manual XMLHttp CORS request");
    return corsFail();
  };
  xhr.send();
  return false;
};

lightboxImages = function(selector, lookDeeply) {
  var jqo, options;
  if (selector == null) {
    selector = ".lightboximage";
  }
  if (lookDeeply == null) {
    lookDeeply = false;
  }

  /*
   * Lightbox images with this selector
   *
   * If the image has it, wrap it in an anchor and bind;
   * otherwise just apply to the selector.
   *
   * Requires ImageLightbox
   * https://github.com/rejas/imagelightbox
   */
  options = {
    onStart: function() {
      return overlayOn();
    },
    onEnd: function() {
      overlayOff();
      return activityIndicatorOff();
    },
    onLoadStart: function() {
      return activityIndicatorOn();
    },
    onLoadEnd: function() {
      return activityIndicatorOff();
    },
    allowedTypes: 'png|jpg|jpeg|gif|bmp|webp',
    quitOnDocClick: true,
    quitOnImgClick: true
  };
  jqo = lookDeeply ? d$(selector) : $(selector);
  return loadJS("bower_components/imagelightbox/dist/imagelightbox.min.js", function() {
    jqo.click(function(e) {
      try {
        e.preventDefault();
        e.stopPropagation();
        $(this).imageLightbox(options).startImageLightbox();
        return console.warn("Event propagation was stopped when clicking on this.");
      } catch (_error) {
        e = _error;
        return console.error("Unable to lightbox this image!");
      }
    }).each(function() {
      var imgUrl, tagHtml;
      console.log("Using selectors '" + selector + "' / '" + this + "' for lightboximages");
      try {
        if ($(this).prop("tagName").toLowerCase() === "img" && $(this).parent().prop("tagName").toLowerCase() !== "a") {
          tagHtml = $(this).removeClass("lightboximage").prop("outerHTML");
          imgUrl = (function() {
            switch (false) {
              case !!isNull($(this).attr("data-layzr-retina")):
                return $(this).attr("data-layzr-retina");
              case !!isNull($(this).attr("data-layzr")):
                return $(this).attr("data-layzr");
              case !!isNull($(this).attr("data-lightbox-image")):
                return $(this).attr("data-lightbox-image");
              default:
                return $(this).attr("src");
            }
          }).call(this);
          $(this).replaceWith("<a href='" + imgUrl + "' class='lightboximage'>" + tagHtml + "</a>");
          return $("a[href='" + imgUrl + "']").imageLightbox(options);
        }
      } catch (_error) {
        e = _error;
        return console.log("Couldn't parse through the elements");
      }
    });
    return console.info("Lightboxed the following:", jqo);
  });
};

activityIndicatorOn = function() {
  return $('<div id="imagelightbox-loading"><div></div></div>').appendTo('body');
};

activityIndicatorOff = function() {
  $('#imagelightbox-loading').remove();
  return $("#imagelightbox-overlay").click(function() {
    return $("#imagelightbox").click();
  });
};

overlayOn = function() {
  return $('<div id="imagelightbox-overlay"></div>').appendTo('body');
};

overlayOff = function() {
  return $('#imagelightbox-overlay').remove();
};

formatScientificNames = function(selector) {
  if (selector == null) {
    selector = ".sciname";
  }
  return $(".sciname").each(function() {
    var nameStyle;
    nameStyle = $(this).css("font-style") === "italic" ? "normal" : "italic";
    return $(this).css("font-style", nameStyle);
  });
};

prepURI = function(string) {
  string = encodeURIComponent(string);
  return string.replace(/%20/g, "+");
};

window.locationData = new Object();

locationData.params = {
  enableHighAccuracy: true
};

locationData.last = void 0;

getLocation = function(callback) {
  var geoFail, geoSuccess;
  if (callback == null) {
    callback = void 0;
  }
  geoSuccess = function(pos, callback) {
    window.locationData.lat = pos.coords.latitude;
    window.locationData.lng = pos.coords.longitude;
    window.locationData.acc = pos.coords.accuracy;
    window.locationData.last = Date.now();
    if (callback != null) {
      callback(window.locationData);
    }
    return false;
  };
  geoFail = function(error, callback) {
    var locationError;
    locationError = (function() {
      switch (error.code) {
        case 0:
          return "There was an error while retrieving your location: " + error.message;
        case 1:
          return "The user prevented this page from retrieving a location";
        case 2:
          return "The browser was unable to determine your location: " + error.message;
        case 3:
          return "The browser timed out retrieving your location.";
      }
    })();
    console.error(locationError);
    if (callback != null) {
      callback(false);
    }
    return false;
  };
  if (navigator.geolocation) {
    return navigator.geolocation.getCurrentPosition(geoSuccess, geoFail, window.locationData.params);
  } else {
    console.warn("This browser doesn't support geolocation!");
    if (callback != null) {
      return callback(false);
    }
  }
};

getMaxZ = function() {
  var mapFunction;
  mapFunction = function() {
    return $.map($("body *"), function(e, n) {
      if ($(e).css("position") !== "static") {
        return parseInt($(e).css("z-index") || 1);
      }
    });
  };
  return Math.max.apply(null, mapFunction());
};

foo = function() {
  toastStatusMessage("Sorry, this feature is not yet finished");
  stopLoad();
  return false;
};

safariDialogHelper = function(selector, counter, callback) {
  var delayTimer, newCount;
  if (selector == null) {
    selector = "#download-chooser";
  }
  if (counter == null) {
    counter = 0;
  }

  /*
   * Help Safari display paper-dialogs
   */
  if (typeof callback !== "function") {
    callback = function() {
      return bindDismissalRemoval();
    };
  }
  if (counter < 10) {
    try {
      d$(selector).get(0).open();
      if (typeof callback === "function") {
        callback();
      }
      return stopLoad();
    } catch (_error) {
      e = _error;
      newCount = counter + 1;
      delayTimer = 250;
      return delay(delayTimer, function() {
        console.warn("Trying again to display dialog after " + (newCount * delayTimer) + "ms");
        return safariDialogHelper(selector, newCount, callback);
      });
    }
  } else {
    return stopLoadError("Unable to show dialog. Please try again.");
  }
};

bindDismissalRemoval = function() {
  return $("[dialog-dismiss]").unbind().click(function() {
    return $(this).parents("paper-dialog").remove();
  });
};

p$ = function(selector) {
  try {
    return $$(selector)[0];
  } catch (_error) {
    return $(selector).get(0);
  }
};

bsAlert = function(message, type, fallbackContainer, selector) {
  var html, topContainer;
  if (type == null) {
    type = "warning";
  }
  if (fallbackContainer == null) {
    fallbackContainer = "body";
  }
  if (selector == null) {
    selector = "#bs-alert";
  }

  /*
   * Pop up a status message
   * Uses the Bootstrap alert dialog
   *
   * See
   * http://getbootstrap.com/components/#alerts
   * for available types
   */
  if (!$(selector).exists()) {
    html = "<div class=\"alert alert-" + type + " alert-dismissable\" role=\"alert\" id=\"" + (selector.slice(1)) + "\">\n  <button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button>\n    <div class=\"alert-message\"></div>\n</div>";
    topContainer = $("main").exists() ? "main" : $("article").exists() ? "article" : fallbackContainer;
    $(topContainer).prepend(html);
  }
  return $(selector + " .alert-message").html(message);
};

$(function() {
  bindClicks();
  formatScientificNames();
  lightboxImages();
  try {
    $("body").tooltip({
      selector: "[data-toggle='tooltip']"
    });
  } catch (_error) {
    e = _error;
    console.warn("Tooltips were attempted to be set up, but do not exist");
  }
  try {
    checkAdmin();
    if ((typeof adminParams !== "undefined" && adminParams !== null ? adminParams.loadAdminUi : void 0) === true) {
      return loadJS("js/admin.min.js", function() {
        console.info("Loaded admin file");
        return loadAdminUi();
      });
    } else {
      return console.info("No admin setup requested");
    }
  } catch (_error) {}
});


/*
 * Handling the Facebook signin
 * https://developers.facebook.com/docs/reference/javascript/FB.getLoginStatus/
 */

if (typeof FB !== "undefined" && FB !== null) {

  /*
   * Here we subscribe to the auth.authResponseChange JavaScript
   * event. This event is fired
   * for any authentication related change, such as login, logout or
   * session refresh. This means that
   * whenever someone who was previously logged out tries to log in
   * again, the correct case below
   * will be handled.
   */
  FB.Event.subscribe("auth.authResponseChange", function(response) {
    if (response.status === 'connected') {
      return loggedIn();
    } else if (response.status === 'not_authorized') {
      return removeSimpleLogin();
    } else {
      return removeSimpleLogin();
    }
  });
  FB.getLoginStatus(function(response) {

    /*
     * This function will only rarely be called, and instead the 
     * subscribed event notifier will be called. This is being  left here 
     * for completion.
     */
    var accessToken, uid;
    if (response.status === "connected") {
      uid = response.authResponse.userID;
      return accessToken = response.authResponse.accessToken;
    } else if (response.status === 'not_authorized') {
      return removeSimpleLogin();
    } else {
      return removeSimpleLogin();
    }
  });
  testAPI = function() {
    console.log('Welcome!  Fetching your information.... ');
    return FB.api('/me', function(response) {
      return console.log('Good to see you, #{response.name}.');
    });
  };
  loggedIn = function() {
    var auth;
    auth = FB.getAuthResponse();
    return FB.api("/me", function(response) {
      return console.log(response.email);
    });
  };
  removeSimpleLogin = function() {
    return $("#basic_fb_login").remove();
  };
}


/*
 * Handling Google OAuth
 */

if (typeof oa === "undefined" || oa === null) {
  window.oa = new Object();
}

oa.googleOAuthCallback = function(googleClient) {

  /*
   * Sample:
  {
  "status": {
    "method": "AUTO",
    "signed_in": true,
    "google_logged_in": true
  },
  "_aa": "0",
  "expires_at": "1448075227",
  "issued_at": "1448071627",
  "response_type": "code token id_token gsession",
  "cookie_policy": "single_host_origin",
  "g_user_cookie_policy": "single_host_origin",
  "client_id": "680725378779.apps.googleusercontent.com",
  "prompt": "none",
  "session_state": "2135f83652337d54fa78c0505055673fb0a575c3..df84",
  "authuser": "0",
  "id_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjM4OWRkNWU1OGYxYzUyN2QzMTQ0ODY5NzQ3ZDVkN2YzM2Q3MGFlMTcifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXRfaGFzaCI6IjlyZGg4T0hZaWhUR05kY2FkeHY4WUEiLCJhdWQiOiI2ODA3MjUzNzg3NzkuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJjX2hhc2giOiI4RlU1X090dXdTSXVsRl9aZzhlb0ZBIiwic3ViIjoiMTExNTE3ODg5NTc5MzM3NDIyNjYyIiwiYXpwIjoiNjgwNzI1Mzc4Nzc5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiaWF0IjoxNDQ4MDcxNjI2LCJleHAiOjE0NDgwNzUyMjZ9.bn7N_j35vnlN1NU5ODKjXvmZe3HgTdio71eaw4ybbu_DJNvPL-w8vHJKFkJp_4Bpqq0AWowTbak9p4qD_dumVJTCoiwTnrPrmSebKvOOg4tkwErPLJEUqf5DtYOM22xWISTNoLPHCdTdNroVtvj0tjblr7qFwiWhbHhXkqCWLLKivqQGcsXBsms__9vR8pFfigE5PYPq8EVQkJ958bw0GBX2TilyeOzKaFLfIkeNi-QR45cum40JKxg-M2rvYDwb14cXzXIlXfks9Pf5Dd0uoY6nWo2_qd6_njxdDiRPndZgigbn6CqXxOzqC5gTSXzUyBOYOLYQg7yvcdPcr1Tajw",
  "scope": "https:\/\/www.googleapis.com\/auth\/plus.login https:\/\/www.googleapis.com\/auth\/plus.moments.write https:\/\/www.googleapis.com\/auth\/plus.me https:\/\/www.googleapis.com\/auth\/plus.profile.agerange.read https:\/\/www.googleapis.com\/auth\/plus.profile.language.read https:\/\/www.googleapis.com\/auth\/plus.circles.members.read",
  "code": "4\/xwl-MpYfnSk_-WdqD_xk9qBleRfg8eTvuI9QUF6mKyc",
  "expires_in": "3600",
  "token_type": "Bearer",
  "access_token": "ya29.MwJSoCnRPFcB_Pr7vGTnDmOHST15fKNfNV5SWfngLMEon4rqsIHVJP2HFbUrUOvX9Zeg",
  "state": ""
  }
   */
  var accesstoken, args, atj, authtokens, email, id, idtoken, image, name, profile, url;
  if (googleClient == null) {
    console.warn("A bad Google client was returned from the server!");
    return false;
  }
  window.googleClient = googleClient;
  console.info("Google said", googleClient);
  try {
    profile = googleClient != null ? googleClient.getBasicProfile() : void 0;
  } catch (_error) {}
  if (profile != null) {
    console.info("Profile", profile);
    name = profile.getName();
    email = profile.getEmail();
    id = profile.getId();
    image = profile.getImageUrl();
  }
  authtokens = googleClient.getAuthResponse();
  atj = jsonTo64(authtokens);
  idtoken = googleClient.getAuthResponse().id_token;
  accesstoken = googleClient.getAuthResponse().access_token;
  url = "oauth_login_handler.php";
  args = "provider=google&token=" + idtoken + "&access=" + accesstoken + "&tokens=" + atj;
  return $.post(url, args, "json").done(function(result) {

    /*
     * Should get back something like
    {
      "locale": "en",
      "family_name": "Kahn",
      "given_name": "Philip",
      "picture": "https:\/\/lh6.googleusercontent.com\/-3NU8bfRpuG8\/AAAAAAAAAAI\/AAAAAAAAiSY\/ABIlYyYUn4E\/s96-c\/photo.jpg",
      "name": "Philip Kahn",
      "exp": 1448092406.0,
      "iat": 1448088806.0,
      "email": "tigerhawkvok@gmail.com",
      "azp": "680725378779.apps.googleusercontent.com",
      "email_verified": true,
      "sub": "111517889579337422662",
      "aud": "680725378779.apps.googleusercontent.com",
      "at_hash": "6iCYFYkh2tq6SonCCA1iKg",
      "iss": "accounts.google.com"
    }
     */
    var oneTimeHash, password, subscriber, testHtml;
    console.info("POST got back the following result:", result);
    if (result.status !== true) {
      console.error("Couldn't validate with Google - " + result.error);
      return false;
    }
    email = result.identifier;
    password = result.verifier;
    oneTimeHash = result.token_data.at_hash;
    subscriber = result.token_data.sub;
    testHtml = "<p>Will use credentials:</p>\n<p>Username: <code>" + email + "</code></p>\n<p>Derived Password: <code>" + password + "</code></p>";
    $("main").append(testHtml);
    return false;
  });
};

oa.googleBadCallback = function(result) {
  return console.error(result);
};

window.onSignInCallback = oa.googleOAuthCallback;

window.onFailureCallback = oa.googleBadCallback;

insertGoogleOAuth = function(clientId, containerSelector) {
  var html;
  if (containerSelector == null) {
    containerSelector = ".oauth-container";
  }
  if (clientId != null) {
    clientId = "data-clientid='" + clientId + "'";
  } else {
    clientId = "";
  }
  html = "\"\n  <div id='gConnect'>\n  <div class='g-signin2'\n    data-onload='false'\n    " + clientId + "\n    data-onsuccess='onSignInCallback'\n    data-onfailure='onFailureCallback'>\n  </div>\n</div>";
  if ($(containerSelector).exists()) {
    $(containerSelector).append(html);
  }
  return loadJS("https://apis.google.com/js/platform.js");
};

replaceLoginPrompt = function() {
  return false;
};


/*
 * Bootstrap all the OAuth peices together
 */

$(function() {
  return insertGoogleOAuth();
});


/*
 * Handling Twitter signins
 */

//# sourceMappingURL=maps/oa.js.map
