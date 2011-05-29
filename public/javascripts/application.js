define(function(require, exports, module){
    seajs.config({
        base: '/javascripts/',
        charset: 'utf-8',
        timeout: 20000,
        debug: 2
    });

    require('jquery.min');
    require('jquery-ui.min');
});
