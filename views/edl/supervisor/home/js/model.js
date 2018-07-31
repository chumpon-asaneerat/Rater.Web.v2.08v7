; (function () {
    let onModelLoaded = (sender, evtData) => {
        riot.mount('edl-supervisor-page');
        page.modelLoaded.remove(onModelLoaded);
    };
    page.modelLoaded.add(onModelLoaded);
})();
