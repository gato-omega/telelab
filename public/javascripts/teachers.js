//Add datatables
$(document).ready(function() {
    $('#teachers_table').dataTable({
        "sScrollY": 200,
        "bJQueryUI": true,
        "sPaginationType": "full_numbers"
    });
});