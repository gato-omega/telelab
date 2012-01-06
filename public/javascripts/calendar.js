/**
 * User: german
 * Date: 13/09/11
 * Time: 05:16 PM
 * To change this template use File | Settings | File Templates.
 */
var new_event = false;
$(document).ready(function() {
    var calendar = $('#reservation_calendar').fullCalendar({
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'agendaWeek,agendaDay'
        },
        selectable: true,
        editable: true,
        allDayDefault: false,
        allDaySlot: false,
        ignoreTimezone: false,
        events: '/api/practicas.json',
        selectHelper: false,
        select: function(start, end) {
            var current_date = new Date();
            if (start > current_date) {
                var title = prompt('Event Title:');
                if (title) {
                    calendar.fullCalendar('renderEvent',
                        {
                            title: title,
                            start: start,
                            end: end
                        },
                        true // make the event "stick"
                    );
                    $("#practica_name").val(title);
                    $("#practica_event_attributes_start").val(start);
                    $("#practica_event_attributes_end").val(end);
                    if (new_event) {
                        var e = $('#reservation_calendar').fullCalendar('clientEvents');
                        $('#reservation_calendar').fullCalendar('removeEvents', e[e.length - 2]._id);
                    }
                    else new_event = true;
                    $.post('/practicas/free_devices', {'start':start.toString(), 'end':end.toString()});
                }
                calendar.fullCalendar('unselect');
            }
            else alert("La fecha y hora de inicio de la practica debe ser mayor a la fecha y hora actuales");
        }
    });
});