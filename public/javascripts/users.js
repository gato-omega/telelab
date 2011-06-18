//Add datatables
$(document).ready(function() {
    $('#users_table').dataTable({
        "sScrollY": 200,
        "bJQueryUI": true,
        "sPaginationType": "full_numbers"
    });
});