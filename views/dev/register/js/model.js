; (function () {
    let onModelLoaded = (sender, evtData) => {
        riot.mount('dev-page');
        page.modelLoaded.remove(onModelLoaded);
    };
    page.modelLoaded.add(onModelLoaded);
})();
