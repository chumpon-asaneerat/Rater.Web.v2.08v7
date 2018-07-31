/**
 * Constructor.
 * @constructor
 * @this {logger}
 * @param {string} selector The DOM element.
 */
function logger(selector) {
    this.$element = $(selector);
    return this;
};

/**
 * Append message to target log DOM element.
 * @param {string} msg The message to write.
 */
logger.prototype.log = function(msg) {
    if (this.$element)
        this.$element.append('<p>' + msg + '</p>');
};

/**
 * Clear all message in target log DOM element.
 */
logger.prototype.clear = function() {
    if (this.$element)
        this.$element.empty();
};
