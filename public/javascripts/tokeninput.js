$(function(){

    $("input.tokeninput").each(function(index){
        $(this).tokenInput($(this).attr('data-source'), {
            crossDomain: false,
            prePopulate: $("input.tokeninput").data("pre"),
            theme: "facebook"
        });
    });
});