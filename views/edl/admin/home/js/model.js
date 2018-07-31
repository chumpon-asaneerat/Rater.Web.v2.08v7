; (function () {
    let onModelLoaded = (sender, evtData) => {
        riot.mount('edl-admin-page');
        page.modelLoaded.remove(onModelLoaded);
    };
    page.modelLoaded.add(onModelLoaded);
})();
