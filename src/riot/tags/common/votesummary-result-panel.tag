<votesummary-result-panel class="container-fluid mt-1">
    <div class="row">
        <div class="col-12 QSetBorder">
            <label class="QSetText">
                <b>{qset.QSetDescription}</b>
                <b>({qset.BeginDate}</b> - <b>{qset.EndDate})</b>
            </label>
            <virtual each={ques in questions}>
                <div class="col-12 QBorder">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-12">
                                <label class="QText"><b>{ques.QSeq}. {ques.QSlideText}</b></label>
                            </div>
                        </div>
                        <div class="row mb-2">
                            <virtual each={item in ques.choices}>
                                <div class="col-5 offset-1 m-0 m-auto p-0">
                                    <label class="CText">{item.QSSeq}. {item.QItemText}</label>
                                </div>
                            </virtual>
                        </div>
                        <div class="container-fluid">
                            <div class="row">
                                <virtual each={org in ques.orgs}>
                                    <div class="col-xl-4 col-lg-6 col-md-6 col-sm-12 col-xs-12">                                    
                                        <div data-is="votesummary-pie-chart" opts.data={org}>
                                        </div>
                                    </div>
                                </virtual>
                            </div>
                        </div>
                    </div>
                    <br>
                </div>
            </virtual>
        </div>
    </div>
    <style>
        :scope {
            width: 95%;
            font-size: 1rem;
        }
        .QSetBorder {
            display: block;
            margin: 0 auto;
            padding: 0;
            border: 1px solid silver;
            background-color: whitesmoke;
        }
        .QSetText {
            display: block;
            margin: 0 auto;
            padding-left: 5px;
            padding-right: 5px;
            margin-bottom: 2px;
            border: 1px solid darkorange;
            color: whitesmoke;
            background-color: darkorange;
        }
        .QBorder {
            display: block;
            margin: 0 auto;
            padding: 2px;
            border: 0px;
        }
        .QText {
            display: block;
            margin: 5px auto;
            margin-bottom: 3px;
            padding-left: 5px;
            padding-right: 5px;            
            border: 1px solid cornflowerblue;
            border-radius: 5px;
            color: whitesmoke;
            background-color: cornflowerblue;
        }
        .CText {
            margin: 0 auto;
            padding: 0;
        }
    </style>
    <script>
        let self = this;

        let refresh = () => {
            self.data = opts.data;
            self.qset = (self.data && self.data.result) ? self.data.result : null;
            self.questions = (self.qset) ? self.qset.questions : null;

            self.update();
        };

        let onModelLoaded = (sender, evtData) => {
            refresh();
        };

        this.on('mount', () => {
            refresh();
            page.modelLoaded.add(onModelLoaded);
        });

        this.on('unmount', () => {
            page.modelLoaded.remove(onModelLoaded);
        });
    </script>
</votesummary-result-panel>