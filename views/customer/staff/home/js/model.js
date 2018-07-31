; (function () {
    let onModelLoaded = (sender, evtData) => {
        riot.mount('staff-page');
        page.modelLoaded.remove(onModelLoaded);
    };
    page.modelLoaded.add(onModelLoaded);
})();
