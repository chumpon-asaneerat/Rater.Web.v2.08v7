; (function () {
    let onModelLoaded = (sender, evtData) => {
        riot.mount('question-page');
        page.modelLoaded.remove(onModelLoaded);
    };
    page.modelLoaded.add(onModelLoaded);
})();
