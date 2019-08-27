class Scroll {
  constructor() {
    const self = this;
    const body = document.getElementsByClassName('Vlt-main')[0];

    document.addEventListener('DOMContentLoaded', function() {
      body.addEventListener('scroll', self.onScroll);
    });
  }

  onScroll(event) {
    const scrollTop = event.target.scrollTop;
    const codeNav = document.getElementsByClassName('Nxd-api__code__header')[0];

    if (scrollTop > 70 && codeNav) {
      codeNav.classList.add('Nxd-api__code__header--sticky');
    } else if (codeNav) {
      codeNav.classList.remove('Nxd-api__code__header--sticky');
    }
  }
}
