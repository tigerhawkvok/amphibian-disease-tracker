
/*
 * Drag-drop initialization
 *
 * If not using an application framework, place the code from
 * `integration.coffee` after this comment.
 */

(function() {
  if (window.dropperParams == null) {
    window.dropperParams = new Object();
  }


  /*
   * Watch DOM for element availability.
   *
   * Directly lifted from
   * http://ryanmorr.com/using-mutation-observers-to-watch-for-element-availability/
   */

  
(function(win){
    'use strict';

    var listeners = [],
    doc = win.document,
    MutationObserver = win.MutationObserver || win.WebKitMutationObserver,
    observer;

    function ready(selector, fn){
        // Store the selector and callback to be monitored
        listeners.push({
            selector: selector,
            fn: fn
        });
        if(!observer){
            // Watch for changes in the document
            observer = new MutationObserver(check);
            observer.observe(doc.documentElement, {
                childList: true,
                subtree: true
            });
        }
        // Check if the element is currently in the DOM
        check();
    }

    function check(){
        // Check the DOM for elements matching a stored selector
        for(var i = 0, len = listeners.length, listener, elements; i < len; i++){
            listener = listeners[i];
            // Query for elements matching the specified selector
            elements = doc.querySelectorAll(listener.selector);
            for(var j = 0, jLen = elements.length, element; j < jLen; j++){
                element = elements[j];
                // Make sure the callback isn't invoked with the
                // same element more than once
                if(!element.ready){
                    element.ready = true;
                    // Invoke the callback with the element
                    listener.fn.call(element, element);
                }
            }
        }
    }

    // Expose 'ready'
    win.ready = ready;

})(this);
;

  $(function() {
    var base, base1, uploadButton;
    console.info("Configuring dropper parameters");
    window.dropperParams.metaPath = "/helpers/js-dragdrop/";
    if ((base = window.dropperParams).uploadPath == null) {
      base.uploadPath = "uploaded/";
    }
    window.dropperParams.dependencyPath = window.dropperParams.metaPath + "bower_components/";
    window.dropperParams.showProgress = true;
    if ((base1 = window.dropperParams).dropTargetSelector == null) {
      base1.dropTargetSelector = "#file-uploader";
    }
    uploadButton = "<button class=\"upload-image media-uploader btn btn-primary pull-right\" id=\"do-upload-file\" type=\"button\"><span class=\"glyphicon glyphicon-cloud-upload\"></span></button>";
    window.dropperParams.clickTargets = ["#do-upload-file"];
    window.dropperParams.mimeTypes = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-excel,text/csv,application/zip,application/x-7z-compressed,application/x-zip-compressed,image/*,application/7z,application/vnd.google-earth.kml+xml,application/vnd.google-earth.kmz,application/pdf";
    console.log(window.dropperParams);
    return (window.dropperParams.initialize = function() {
      return loadJS(window.dropperParams.metaPath + "js/drop-upload.min.js", function() {
        return ready(dropperParams.dropTargetSelector, function(element) {
          console.info(dropperParams.dropTargetSelector + " is ready, binding");
          $(window.dropperParams.dropTargetSelector).parent().after(uploadButton);
          window.dropperParams.hasInitialized = true;
          return window.dropperParams.handleDragDropImage(dropperParams.dropTargetSelector, dropperParams.postUploadHandler);
        });
      });
    })();
  });

}).call(this);

//# sourceMappingURL=js/maps/client-upload.js.map
