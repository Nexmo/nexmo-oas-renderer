class Navigation {
  constructor() {
    this.toggleMobileNavBtn();
    this.scrollToItem();

    document.addEventListener('turbolinks:before-render', (event) => {
      window.futureNavigation = event.originalEvent.data.newBody.querySelector('.js-navigation').innerHTML
    });

    document.addEventListener('turbolinks:load', () => this.injectFutureNavigation());
  }

  toggleMobileNavBtn() {
    if (document.getElementById('Vlt-sidenav').length === 0) {
      document.getElementById('Vlt-sidenav-mobile-trigger').hidden = true;
    }
  }

  injectFutureNavigation() {
    if (window.futureNavigation && !window.navigationAnimationInProgress) {
      document.getElementsByClassName('js-navigation')[0].innerHTML = window.futureNavigation;
      window.futureNavigation = undefined;
      this.toggleMobileNavBtn();
      this.scrollToItem();
    }
  };

  scrollToItem() {
    setTimeout(function() {
      const sidebarActive = document.querySelector('.Vlt-sidemenu__link_active')
      if (sidebarActive) {
        sidebarActive.scrollIntoView({ behavior: 'smooth', block: 'start', inline: 'nearest' });
      }
    }, 100);
  }
}
