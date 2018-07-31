; (function () {
    let onModelLoaded = (sender, evtData) => {
        riot.mount('edl-staff-page');
        page.modelLoaded.remove(onModelLoaded);
    };
    page.modelLoaded.add(onModelLoaded);
})();
