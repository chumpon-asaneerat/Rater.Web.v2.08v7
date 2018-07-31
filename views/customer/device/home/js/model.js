; (function () {
    let onModelLoaded = (sender, evtData) => {
        riot.mount('device-page');
        page.modelLoaded.remove(onModelLoaded);
    };
    page.modelLoaded.add(onModelLoaded);
})();
