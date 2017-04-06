$(function() {
  if($('#delaunay').length > 0) {
    var canvas = d3.select("#delaunay").append("canvas");

    function draw() {
      var width = $(window).width(),
          height = $('.header-section').height() + $('nav').height() + 1,
          τ = 2 * Math.PI,
          gravity = .005;

      var sample = poissonDiscSampler(width, height, 100),
          nodes = [{x: 0, y: 0}],
          s;

      while (s = sample()) nodes.push(s);

      var voronoi = d3.geom.voronoi()
          .x(function(d) { return d.x; })
          .y(function(d) { return d.y; });

      var links = voronoi.links(nodes);

      canvas
          .attr("width", width)
          .attr("height", height)
          .attr("class", "delaunay")

      var context = canvas.node().getContext("2d");

        for (var i = 0, n = nodes.length; i < n; ++i) {
          var node = nodes[i];
          node.y += (node.cy - node.y) * gravity;
          node.x += (node.cx - node.x) * gravity;
        }

        context.clearRect(0, 0, width, height);

        context.beginPath();
        for (var i = 0, n = links.length; i < n; ++i) {
          var link = links[i];
          context.moveTo(link.source.x, link.source.y);
          context.lineTo(link.target.x, link.target.y);
        }
        context.lineWidth = 1;
        context.strokeStyle = "#444444";
        context.stroke();

        context.beginPath();
        for (var i = 0, n = nodes.length; i < n; ++i) {
          var node = nodes[i];
          context.moveTo(node.x, node.y);
          context.rect(node.x - 2, node.y - 2, 4, 4);
        }
        context.lineWidth = 3;
        context.strokeStyle = "#444444";
        context.stroke();
        context.fillStyle = "#000000";
        context.fill();
    }

    // Based on https://www.jasondavies.com/poisson-disc/
    function poissonDiscSampler(width, height, radius) {
      var k = 30, // maximum number of samples before rejection
          radius2 = radius * radius,
          R = 3 * radius2,
          cellSize = radius * Math.SQRT1_2,
          gridWidth = Math.ceil(width / cellSize),
          gridHeight = Math.ceil(height / cellSize),
          grid = new Array(gridWidth * gridHeight),
          queue = [],
          queueSize = 0,
          sampleSize = 0;

      return function() {
        if (!sampleSize) return sample(Math.random() * width, Math.random() * height);

        // Pick a random existing sample and remove it from the queue.
        while (queueSize) {
          var i = Math.random() * queueSize | 0,
              s = queue[i];

          // Make a new candidate between [radius, 2 * radius] from the existing sample.
          for (var j = 0; j < k; ++j) {
            var a = 2 * Math.PI * Math.random(),
                r = Math.sqrt(Math.random() * R + radius2),
                x = s.x + r * Math.cos(a),
                y = s.y + r * Math.sin(a);

            // Reject candidates that are outside the allowed extent,
            // or closer than 2 * radius to any existing sample.
            if (0 <= x && x < width && 0 <= y && y < height && far(x, y)) return sample(x, y);
          }

          queue[i] = queue[--queueSize];
          queue.length = queueSize;
        }
      };

      function far(x, y) {
        var i = x / cellSize | 0,
            j = y / cellSize | 0,
            i0 = Math.max(i - 2, 0),
            j0 = Math.max(j - 2, 0),
            i1 = Math.min(i + 3, gridWidth),
            j1 = Math.min(j + 3, gridHeight);

        for (j = j0; j < j1; ++j) {
          var o = j * gridWidth;
          for (i = i0; i < i1; ++i) {
            if (s = grid[o + i]) {
              var s,
                  dx = s.x - x,
                  dy = s.y - y;
              if (dx * dx + dy * dy < radius2) return false;
            }
          }
        }

        return true;
      }

      function sample(x, y) {
        var s = {x: x, y: y, cx: x, cy: y};
        queue.push(s);
        grid[gridWidth * (y / cellSize | 0) + (x / cellSize | 0)] = s;
        ++sampleSize;
        ++queueSize;
        return s;
      }
    }

    draw();

    var interval;
    window.addEventListener('resize', function(){
      window.clearInterval(interval);
      interval = window.setInterval(function() { draw(); window.clearInterval(interval); }, 30);
    });

  }
});
