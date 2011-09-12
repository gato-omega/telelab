$(function() {
  $("input.tokeninput").tokenInput("/json_users.json", {
    crossDomain: false,
    prePopulate: $("input.tokeninput").data("pre"),
    theme: "facebook"
  });
});