$(function() {
    // Initialize visual things

    $( "a.button" ).button();

    //// Link-icon buttons
    // Visual link icons
    var new_buttons = $('a.new_button');
    var edit_buttons = $('a.edit_button');
    var show_buttons = $('a.show_button');
    var delete_buttons = $('a.delete_button');
    var register_buttons = $('a.register_button');

    new_buttons.html("<img src='/images/icons/new.png'>");
    edit_buttons.html("<img src='/images/icons/edit.png'>");
    show_buttons.html("<img src='/images/icons/show.png'>");
    delete_buttons.html("<img src='/images/icons/delete.png'>");
    register_buttons.html("<img src='/images/icons/register.png'>");

    //// Button to UI-button
    $('input.button').button();

    //// Countdown timers
    $('#countdown_timer').each(function(index){
        var time_remaining = $(this).data('time');
        $(this).countdown({until:time_remaining});
    });

    
    // Visual link tooltips 
//    $('a.new_button').simpletip({content: 'Nuevo'});
//    $('a.edit_button').simpletip({content: 'Editar'});
//    $('a.show_button').simpletip({content: 'Mostrar'});
//    $('a.delete_button').simpletip({content: 'Borrar'});
//
//    $('a.register_button').simpletip({content: 'Matricular'});

});
