// Datatable initialization 4all
$(document).ready(function() {
    $("table[datatable][fulltable]").dataTable({
        "bJQueryUI": true,
        "sPaginationType": "full_numbers"
    });

    $("table[datatable][minitable]").dataTable({
        "bJQueryUI": true,
        "bPaginate": false,
        "bLengthChange": false,
        "bFilter": false,
        "bSort": false,
        "bInfo": false,
        "bAutoWidth": false
    });

});