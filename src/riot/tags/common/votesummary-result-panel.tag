<votesummary-result-panel class="container-fluid mt-1">
    <div class="row">
        <virtual if={qset}>
            <div class="col-12 QSetBorder">
                <label class="QSetText" onclick={collapseClick}>
                    <div class="collapse-button">
                        <virtual if={!collapsed}>
                            <span class="fas fa-sort-down" style="transform: translate(0, -2px);"></span>
                        </virtual>
                        <virtual if={collapsed}>
                            <span class="fas fa-caret-right" style="padding-top: 1px; padding-left: 4px;"></span>
                        </virtual>
                    </div>
                    <b>&nbsp;#{No}.&nbsp;</b>
                    <b>{qset.QSetDescription}</b>
                    <b>({qset.BeginDate}</b> - <b>{qset.EndDate})</b>
                    <div class="close-button" onclick={closeClick}>
                        <span class="far fa-times-circle"></span>
                    </div>
                </label>
                <div ref="resultPanel" class="client-area">
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
        </virtual>
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
            cursor: pointer;
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
            cursor: pointer;
        }
        .collapse-button {
            display: inline-block;
            float: left;
            margin: 0 auto;
            padding: 0;
            margin-right: 5px;
            cursor: pointer;
        }
        .close-button {
            display: inline-block;
            float: right;
            margin: 0 auto;
            padding: 0;
            margin-left: 5px;
            cursor: pointer;
        }
        .client-area {
            margin: 0 auto;
            padding: 0;
            display: block;
            cursor: pointer;
        }
        .client-area.hide {
            display: none;
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
        let collapsed = false;

        let refresh = () => {
            self.data = opts.data;
            self.No = (self.data) ? self.data.No : 0;
            self.qset = (self.data && self.data.result) ? self.data.result : null;
            self.questions = (self.qset) ? self.qset.questions : null;
            self.update();
        };

        let onModelLoaded = (sender, evtData) => {
            //console.log('model loade detected.')
            refresh();
        };

        this.on('mount', () => {
            refresh();
            page.modelLoaded.add(onModelLoaded);
        });

        this.on('unmount', () => {
            page.modelLoaded.remove(onModelLoaded);
        });

        this.collapseClick= (e) => {
            //console.log('Collapse')
            $panels = $(self.refs['resultPanel'])
            if ($panels) {
                let $panel = $($panels[0]);
                $panel.toggleClass('hide');
                if ($panel.hasClass('hide')) 
                    self.collapsed = true;
                else self.collapsed = false;
            }            
        };

        this.closeClick = (e) => {
            let $self = $(self.root);
            $parent = $self.parent();
            $self.remove();
        };
    </script>
</votesummary-result-panel>