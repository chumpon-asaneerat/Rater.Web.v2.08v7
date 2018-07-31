/** 
 * @typedef presentation
 * @type {presentation}
 * @property {string} name The presentation name.
 * @property {Map} slides The slides associative array.
 */

/**
 * Constructor.
 * @constructor
 * @this {presentation}
 * @param {string} name The presentation name.
 */
function presentation(name) {
    this.name = name;
    /** @private */
    this.slides = new Map();
}

/**
 * Add or update slide object with specificed slideId as key.
 * @param {string} slideId The slideId that used as key.
 * @param {slide} slide The slide object that associated with slideId key.
 */
presentation.prototype.add = function (slideId, slide) {
    this.slides.set(slideId, slide);
    slide.presentation = this;
};

/**
 * Show all slide name in current presentation.
 */
presentation.prototype.showAll = function () {
    this.slides.forEach(function(slide) {
        console.log(slide.slideName);
    });
};

/** 
 * @typedef slide
 * @type {slide}
 * @property {string} slideId The slide id.
 * @property {string} slideName The slide name.
 * @property {presentation} presentation The owner presentation object.
 */

/**
 * Constructor
 * @constructor
 * @this {slide}
 * @param {string} slideId The slide unique id.
 * @param {string} slideName The slide name.
 */
function slide(slideId, slideName) {
    this.slideId = slideId;
    this.slideName = slideName;
    /** @protected */
    this.presentation = null;
}
