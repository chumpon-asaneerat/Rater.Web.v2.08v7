; (function () {
    let onModelLoaded = (sender, evtData) => {
        riot.mount('admin-page');
        page.modelLoaded.remove(onModelLoaded);
    };
    page.modelLoaded.add(onModelLoaded);
})();
