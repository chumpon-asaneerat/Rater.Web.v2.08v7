; (function () {
    let onModelLoaded = (sender, evtData) => {
        riot.mount('exclusive-page');
        page.modelLoaded.remove(onModelLoaded);
    };
    page.modelLoaded.add(onModelLoaded);
})();
