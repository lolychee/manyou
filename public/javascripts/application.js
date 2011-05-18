// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var Manyou = {
    "topics" : {
        "edit" : function(container_string){
            var container = $(container_string);
            var form = container.find('form');

            form.find('.media-box').sortable({
                axis: 'y',
                opacity: 0.8,
                handle: '.move-button',
                cancel: '.title'
            });
            form.disableSelection();

            $('.block', form).live('load', function(event){
                var target = $(this);
                if(target.hasClass('can-move')){
                    target.append('<a href="javascript:void(0)" class="move-button" title="拖动调整照片顺序">移动</a>');
                }
                if(target.hasClass('can-close')){
                    target.append('<a href="javascript:void(0)" class="close-button" title="移除这个元素">移除</a>');
                }
                if(target.hasClass('can-accordion')){
                    var label = target.find('.label');
                    var field = target.find('.field');
                    label.attr('title', '点击折叠');
                    label.append('<span class="summary"></span>');
                    var summary = label.find('.summary');

                    label.toggle(function(){
                        field.slideUp();
                        summary.html(function(){
                            value = field.find('input, textarea').val();

                            return ' : ' + (value == '' ? '空' : value)
                        });
                        target.toggleClass('accordion');
                        label.attr('title', '点击展开');
                    }, function(){
                        field.slideDown();
                        summary.html('');
                        target.toggleClass('accordion');
                        label.attr('title', '点击折叠');
                    });
                }
            });
            $('.block', form).trigger('load');

            form.click(function(event){
              var target = $(event.target);

              if(target.hasClass('close-button')){

                //do some ajax request

                //if success
                target.parent().remove();
                event.preventDefault();
              }// endif

            });

            //$('#form-submit').click(function(){form.submit()});
            //$('#form-reset').click(function(){form.reset()});

            $('#add-image-button').click(function(event){
                $( "#dialog:ui-dialog" ).dialog( "destroy" );
                $('#add-image-dialog').dialog({
                    "width" : "480",
                    "height" : "300",
                    "modal" : true
                });
                $('#add-image-dialog').tabs();
                event.preventDefault();
            });
            $('#add-video-button').click(function(event){
                $( "#dialog:ui-dialog" ).dialog( "destroy" );
                $('#add-video-dialog').dialog({
                    "width" : "480",
                    "height" : "300",
                    "modal" : true
                });
                //$('#add-video-dialog').tabs();
                event.preventDefault();
            });
            $('#add-music-button').click(function(event){
                $( "#dialog:ui-dialog" ).dialog( "destroy" );
                $('#add-music-dialog').dialog({
                    "width" : "480",
                    "height" : "300",
                    "modal" : true
                });
                //$('#add-image-dialog').tabs();
                event.preventDefault();
            });
        }
    }
};
