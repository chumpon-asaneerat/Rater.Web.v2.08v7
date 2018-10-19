<votesummary-result-panel class="container-fluid mt-1">
    <div class="row m-0 m-auto p-0">
        <virtual if={data !== null}>
            <div class="col-12">
                <label class="QText"><b>{data.criteria.QSeq}. {data.criteria.QSlideText}</b></label>
            </div>
            <virtual if={data.results !== null}>
                <virtual each={item in data.results}>
                    <div class="col-5 offset-1 m-0 m-auto p-0">
                        <label class="CText">{item.Choice}. {item.QItemText} ({item.Pct}%)</label>
                    </div>
                </virtual>
            </virtual>
        </virtual>
    </div>
    <style>
        :scope {
            width: 95%;
            font-size: 1rem;
        }
        .QText {
            display: block;
            padding-left: 5px;
            padding-right: 5px;
            border: 1px solid cornflowerblue;
            border-radius: 5px;
            color: whitesmoke;
            background-color: cornflowerblue;
        }
        .CText {
            margin: 0;
            padding: 0;
        }
    </style>
    <script>
        let self = this;
        this.data = opts.data;
        console.log(this.data);
    </script>
</votesummary-result-panel>