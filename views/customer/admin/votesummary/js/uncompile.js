var chartSetup = {
    backgroundColor: '#FCFFC5', // if include css change .highcharts-background instead.
    type: 'column'
};
var chartTitle = {
    /*
    text: 'Compare Organizations',
    useHTML: true,
    style: {
        'margin': '5px auto',
        color: '#FF00FF',
        'background-color': 'green',
        fontWeight: 'bold',
        border: '1px solid black',
        width: '20%',
        padding: '5px',
    }
    */
    useHTML: true,
    text: '<div class="lhsTitle">My custom title</div><div class="rhsTitle">Right content</div>',
    align: 'left',
    x: 10
};
var chartSubTitle = {
    //text: 'Source: WorldClimate.com'
};
var chartXAxis = {
    categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    crosshair: true
};
var chartYAxis = {
    min: 0,
    max: 4,
    title: {
        text: 'Average'
    }
};
var chartToolTip = {
    /*
    headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
        '<td style="padding:0"><b>{point.y:.2f}</b></td></tr>',
    footerFormat: '</table>',
    useHTML: true,
    */
    shared: true
};

var chartSeries = [{
    name: 'EDL',
    data: [2.34, 3.42, 2.61, 3.19, 2.98, 2.56, 2.87, 2.43, 3.34, 3.33, 2.75, 3.41]

}, {
    name: 'Marketting',
    data: [3.34, 2.42, 3.61, 1.19, 3.98, 3.56, 3.87, 3.45, 3.34, 1.33, 3.75, 1.41]

}, {
    name: 'Supports',
    data: [2.34, 3.42, 2.61, 2.19, 2.98, 2.56, 2.87, 2.41, 1.34, 3.33, 2.75, 2.41]

}, {
    name: 'Engineering',
    data: [3.11, 2.11, 3.11, 2.11, 3.11, 2.11, 3.11, 3.11, 2.11, 3.11, 2.11, 3.11]

}];

function getData() {
    return {
        chart: chartSetup,
        title: chartTitle,
        subtitle: chartSubTitle,
        xAxis: chartXAxis,
        yAxis: chartYAxis,
        tooltip: chartToolTip,
        series: chartSeries
    };
};
//console.log('init chart...');
Highcharts.chart('container1', getData());

