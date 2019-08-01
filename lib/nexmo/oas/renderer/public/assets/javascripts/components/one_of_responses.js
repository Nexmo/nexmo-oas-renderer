class OneOfResponses {
  constructor() {
    var responses = [...document.getElementsByClassName('Nxd-api__responses')];

    var self = this;
    responses.forEach(function(response) {
      response.addEventListener('click', (event) => {
        self.responseClicked(event);
      })
    });
  }

  responseClicked(event) {
    document.
      querySelectorAll(`[data-response-group="${event.target.dataset.responseGroup}"] > .Nxd-api__response`).
      forEach(function(element) {
        this.toggleOneOfResponses(element, event.target.dataset.target)
      }, this);
  }

  toggleOneOfResponses(element, target) {
    element.classList.toggle(
      'hide',
      element.dataset.target !== target
    );
  }
}
