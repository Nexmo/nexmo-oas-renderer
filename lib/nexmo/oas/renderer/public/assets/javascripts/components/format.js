class Format {
  constructor() {
    this.formatSelector = document.getElementsByClassName('js-format-selector')[0]
    if (this.formatSelector) {
      this.formatChanged(this.formatSelector.value, false)
      this.formatSelector.addEventListener('change', (event) => {
        this.formatChanged(event.target.value)
      })

      this.restoreFormat()
    }
  }

  formatChanged(format, persist = true) {
    for (var item of document.getElementsByClassName('js-format')) {
      item.hidden = true
    }
    for (var item of document.querySelectorAll(`.js-format[data-format='${format}']`)) {
      item.hidden = false
    }

    if (persist) {
      this.persistFormat(format)
    }
  }

  persistFormat(format) {
    if (window.localStorage) {
      window.localStorage.setItem('format', format)
    }
  }

  restoreFormat() {
    if (window.localStorage) {
      const format = window.localStorage.getItem('format')
      if (format) {
        this.formatSelector.value = format
        this.formatChanged(format, false)
      }
    }
  }
}
