class App {
    constructor() {

    }
}

; (function () {
    // set global app variable in window.
    window.app = window.app || new App();

    riot.compile(function () {
        var tags = riot.mount('master');
    });
})();