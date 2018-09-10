<votesummary-result-panel class="container-fluid mt-1">
    <div class="row">
        <virtual if={slide !== null}>
            <div class="col-12">
                <label class="QText"><b>{slide.No}. {slide.QSlideTextNative}</b></label>
            </div>
            <virtual if={slide.items !== null}>
                <virtual each={item in slide.items}>
                    <div class="col-5 offset-1 m-auto p-0">
                        <label class="CText">{item.No}. {item.QItemTextNative}</label>
                    </div>
                </virtual>
            </virtual>
        </virtual>
    </div>
    <style>
        .QText {
            display: block;
            padding-left: 5px;
            padding-right: 5px;
            font-size: 1rem;
            border: 1px solid cornflowerblue;
            border-radius: 5px;
            color: whitesmoke;
            background-color: cornflowerblue;
        }
        .CText {
            margin: 0;
            padding: 0;
            font-size: 1rem;
        }
    </style>
    <script>
        let self = this;
        this.QSetId = opts.qsetId;
        this.QSeq = opts.qseq;
        this.slide = null;

        let onQModelChanged = (sender, evtData) => {
            self.refreshQModel();            
        };
        window.report.onQModelChanged.add(onQModelChanged);

        this.on('mount', function () {
            self.refreshQModel();
        });

        this.refreshQModel = () => {
            // refresh QModel.
            self.slide = report.getSlide(this.QSetId, this.QSeq);
            //console.log('slide: ', self.slide);
            self.update();
        };
    </script>
</votesummary-result-panel>