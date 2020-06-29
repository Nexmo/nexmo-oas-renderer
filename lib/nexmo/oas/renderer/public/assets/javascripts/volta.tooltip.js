/**
 * Copyright (c) 2001-present, Vonage.
 *
 * Tooltips (requires popper.js, tooltip.js)
 */
'use strict';

Volta.tooltip = function () {
    var _class = {
        bottom: 'Vlt-tooltip--bottom',
        left: 'Vlt-tooltip--left',
        tooltip: 'Vlt-tooltip',
        top: 'Vlt-tooltip--top',
        right: 'Vlt-tooltip--right',
        large: 'Vlt-tooltip--large'
    }

    return {
        create: create,
        init: attachTooltipHandlers
    }

    /**
     *	@public
     *
     *	@description Create a Tooltip instance for every Vlt-tooltip
     */
    function attachTooltipHandlers() {
        document.querySelectorAll('.' + _class.tooltip).forEach(create);
    }

    /**
     *	@public
     *
     *	@description Create a Tooltip instance
     *	@param {HTMLElement} tooltip
     *  @return {object} a Tooltip element
     */
    function create(tooltip) {
        var placement;
        var size;

        if (Volta._hasClass(tooltip, _class.bottom)) {
            placement = 'bottom';
        } else if (Volta._hasClass(tooltip, _class.top)) {
            placement = 'top';
        } else if (Volta._hasClass(tooltip, _class.left)) {
            placement = 'left';
        } else if (Volta._hasClass(tooltip, _class.right)) {
            placement = 'right';
        }

        if (Volta._hasClass(tooltip, _class.large)) {
            size = ' Vlt-tooltip--large';
        } else {
            size='';
        }

        var template =
            '<div class="Vlt-tooltip--js' + size + '" role="tooltip">' +
            '<div class="tooltip-arrow Vlt-tooltip__arrow"></div>' +
            '<div class="tooltip-inner Vlt-tooltip__content"></div>' +
            '</div>';

        var title = tooltip.title;
        //remove the title so deafult title does not show
        tooltip.title = "";

        return new Tooltip(tooltip, {
            html: true,
            template: template,
            title: title,
            placement: placement
        });
    }
}();