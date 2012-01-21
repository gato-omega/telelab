// Messages datatable (per each device)
$(function()
{
    try
    {
        conexiones_datatable=$("table[datatable][messages]").dataTable({
            "aoColumns": [
                { "sWidth": "25px" },
                { "sWidth": "200px", 'sClass' : 'black_links' },
                { "sWidth": "auto" }],
            "bJQueryUI": true,
            "bPaginate": true,
            "bLengthChange": false,
            "bFilter": true,
            "bSort": true,
            "bInfo": false,
            "bAutoWidth": false
        });
    }
    catch(err)
    {
        $("table[datatable][conexiones]").html('COULD NOT INITILIZE MESSAGES DATATABLE');
    }

});