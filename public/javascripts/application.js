define(function(require, exports, module){
    seajs.config({
        base: "/javascripts/",
        charset: "utf-8",
        timeout: 20000,
        debug: 2
    });

    //require('jquery-ui.min');

    var header_init = function(){
        var header = $("#header");

        // #session-menu start
        var menu = $("#session-menu");
        var user_profile = menu.find("> .user-profile");
        menu.
        mouseover(function(){
            user_profile.show();
        }).
        mouseout(function(){
            user_profile.hide();
        });
        // #session-menu end


    };

    header_init();

    exports.editor = function(textarea, options){
        require("tiny_mce/jquery.tinymce");

        if (!(textarea instanceof jQuery)){
            textarea = $(textarea);
        }

        if (!(options instanceof Object)){
            options = new Object();
        }

        options.script_url  = "/javascripts/tiny_mce/tiny_mce.js";

        options.mode        = "textareas";
        options.theme       = "advanced";
        options.plugins     = "bbcode";

        options.entity_encoding = "numeric";

        options.theme_advanced_toolbar_location     = "top";
        options.theme_advanced_toolbar_align        = "left";
        //options.theme_advanced_statusbar_location   = "bottom";
        //options.theme_advanced_resizing             = true;

        options.theme_advanced_buttons1 = options.theme_advanced_buttons1 || "bold,italic,strikethrough,|,bullist,numlist,blockquote,|,link,unlink,undo,redo";
        options.theme_advanced_buttons2 = options.theme_advanced_buttons2 || "";
        options.theme_advanced_buttons3 = options.theme_advanced_buttons3 || "";


        textarea.tinymce(options);
    };
});
