document.addEventListener("DOMContentLoaded", function() {

  // Toggle text on accordion button for response fields
  var responseDescriptionTogglers = document.getElementsByClassName('response-description-toggle');

  Array.from(responseDescriptionTogglers).forEach(function(element) {
    element.addEventListener('click', function(event) {
      var text = event.target.textContent;
      var newText;
      if (text.indexOf('View') != -1) {
        newText = text.replace("View", "Hide");
      } else {
        newText = text.replace("Hide", "View");
      }
      event.target.textContent = newText;
    });
  });

  // Handle people clicking on oneOf tabs by changing every one on the page
  var oneOfTabs = document.querySelectorAll('[data-tab-link]');
    Array.from(oneOfTabs).forEach(function(element) {
        element.addEventListener('click', function (event) {
          var link = event.target.getAttribute('data-tab-link');
          var matchingTabs = document.querySelectorAll('[data-tab-link="'+link+'"]');
            Array.from(matchingTabs).forEach(function(element) {
              element.click();
            });
        });
    });

});
