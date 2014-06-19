// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//for customer field autocomplete on new rfq view.
$(function() {
    return $('#contract_customer_name_autocomplete').autocomplete({
        minLength: 1,
        source: $('#contract_customer_name_autocomplete').data('autocomplete-source'),  //'#..' can NOT be replaced with this
        select: function(event, ui) {
            //alert('fired!');
            $('#contract_customer_name_autocomplete').val(ui.item.value);
        },
    });
});

$(function() {
	$( "#contract_sign_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#contract_contract_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#contract_start_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#contract_end_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
});