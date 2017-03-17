function CrystalBenchmark() {
  var data = [
    ["Crystal",115969],
    ["Go", 92356],
    ["Java", 85710],
    ["Python", 85655],
    ["Ruby", 50003]
];



var chart = document.getElementById("benchmark"),
    axisMargin = 30,
    margin = 20,
    valueMargin = 4,
    width = chart.offsetWidth,
    axisLabelHeight = 20,
    height = 280,
    barHeight = 30,
    barPadding = 10,
    data, bar, svg, scale, xAxis, labelWidth = 0;

max = d3.max(data.map(function(i){
  return i[1];
}));

svg = d3.select(chart)
  .append("svg")
  .attr("width", width)
  .attr("height", height)



bar = svg.selectAll("g")
  .data(data)
  .enter()
  .append("g");

bar.attr("class", "bar")
  .attr("cx",0)
  .attr("transform", function(d, i) {
     return "translate(" + 0 + "," + (i * (barHeight + barPadding) + barPadding) + ")";
  });

bar.append("text")
  .attr("class", "label")
  .attr("y", barHeight / 2)
  .attr("dy", ".35em") //vertical align middle
  .text(function(d){
    return d[0];
  }).each(function() {
    labelWidth = Math.ceil(Math.max(labelWidth, this.getBBox().width));
  });
labelWidth += margin;

scale = d3.scale.linear()
  .domain([0, 120000])
  .range([0, width - margin*2 - labelWidth]);

xAxis = d3.svg.axis()
  .scale(scale)
  .ticks(5)
  .tickSize(7)
  .tickPadding(10)
  .tickFormat(function(d){
    if(d==0) return 0;
    return d/1000 + "k";
  })
  .orient("bottom");

bar.append("rect")
  .attr("transform", "translate("+labelWidth+", 0)")
  .attr("height", barHeight)
  .attr("width", function(d){
    return scale(d[1]);
  });

svg.insert("g",":first-child")
 .attr("class", "axis")
 .attr("transform", "translate(" + (labelWidth) + ","+ (height - axisMargin - axisLabelHeight)+")")
 .call(xAxis);

svg.append("text")
  .attr("class","axis-name")
  .text("Throughput (req/s)")
  .attr("y",height - axisLabelHeight /2)
  .attr("x",labelWidth -3);

  function setWidth (value) {
      width = value;
      scale.range([0, width - margin*2 - labelWidth]);
      bar.selectAll("rect")
          .attr("width", function(d) { return scale(d[1]);});
      svg.select(".axis")
          .call(xAxis);
  }
  window.addEventListener('resize', function(){
    setWidth(chart.offsetWidth);
  });
}


$(function() {
  if($('#benchmark').length > 0) {
    CrystalBenchmark();
  }
});
