$(function() {
  $("input.tokeninput").tokenInput("/api/users.json", {
    crossDomain: false,
    prePopulate: $("input.tokeninput").data("pre"),
    theme: "facebook"
  });
});