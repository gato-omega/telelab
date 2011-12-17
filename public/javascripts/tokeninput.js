$(function(){
    $("input.tokeninput").each(function(index){
        $(this).tokenInput($(this).data('source'), {
            crossDomain: false,
            prePopulate: $(this).data("pre"),
            theme: "facebook"
        });
    });
});