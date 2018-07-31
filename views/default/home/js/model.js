; (function () {
    let onModelLoaded = (sender, evtData) => {
        riot.mount('default-page');
        page.modelLoaded.remove(onModelLoaded);
    };
    page.modelLoaded.add(onModelLoaded);
})();
