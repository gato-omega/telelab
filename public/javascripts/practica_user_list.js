$(function() {
  $("#practica_user_list").tokenInput("/json_users.json", {
    crossDomain: false,
    prePopulate: $("#practica_user_list").data("pre"),
    theme: "facebook"
  });
});