document.addEventListener("DOMContentLoaded", function() {

  // Toggle text on accordion button for response fields
  let responseDescriptionTogglers = document.getElementsByClassName('response-description-toggle');

  [...responseDescriptionTogglers].forEach(function(element) {
    element.addEventListener('click', function(event) {
      let text = event.target.textContent;
      let newText;
      if (text.indexOf('View') != -1) {
        newText = text.replace("View", "Hide");
      } else {
        newText = text.replace("Hide", "View");
      }
      event.target.textContent = newText;
    });
  });

});
