var circles, color, edges, force, graph_data, height, i, links_number, nodes_number, tick, vis, width, _i, _j;

width = 800;

height = 600;

vis = d3.select('#graph').append('svg');

vis.attr('width', width);

vis.attr('height', height);

graph_data = {};

nodes_number = 50;

graph_data['nodes'] = [];

for (i = _i = 1; 1 <= nodes_number ? _i <= nodes_number : _i >= nodes_number; i = 1 <= nodes_number ? ++_i : --_i) {
  graph_data['nodes'].push({
    x: parseInt(width / 2 - Math.random() * width / 20),
    y: parseInt(height / 2 - Math.random() * height / 20)
  });
}

links_number = parseInt(nodes_number * (2 / 3));

graph_data['links'] = [];

for (i = _j = 1; 1 <= links_number ? _j <= links_number : _j >= links_number; i = 1 <= links_number ? ++_j : --_j) {
  graph_data['links'].push({
    source: graph_data['nodes'][parseInt(Math.random() * nodes_number)],
    target: graph_data['nodes'][parseInt(Math.random() * nodes_number)]
  });
}

tick = function() {
  edges.attr('x1', function(d) {
    return d.source.x;
  }).attr('y1', function(d) {
    return d.source.y;
  }).attr('x2', function(d) {
    return d.target.x;
  }).attr('y2', function(d) {
    return d.target.y;
  });
  return circles.attr('cx', function(d) {
    return d.x;
  }).attr('cy', function(d) {
    return d.y;
  });
};

force = d3.layout.force().size([width, height]).nodes(graph_data.nodes).links(graph_data.links).gravity(0.02).distance(50).start();

force.on("tick", tick);

color = d3.scale.category20c();

circles = vis.selectAll("circle").data(graph_data['nodes']).enter().append("circle").attr("class", "node").attr("cx", function(d) {
  return d.x;
}).attr("cy", function(d) {
  return d.y;
}).attr("r", "15").attr("fill", function(d, i) {
  var link, neighbors, _k, _len, _ref;
  neighbors = 0;
  _ref = graph_data['links'];
  for (_k = 0, _len = _ref.length; _k < _len; _k++) {
    link = _ref[_k];
    if (link.source.index === i) {
      neighbors++;
    }
    if (link.target.index === i) {
      neighbors++;
    }
  }
  console.log("" + i + " -> " + neighbors);
  return color(neighbors);
}).call(force.drag);

edges = vis.selectAll("line").data(graph_data['links']).enter().append("line").attr("x1", function(d) {
  return d.source.x;
}).attr("y1", function(d) {
  return d.source.y;
}).attr("x2", function(d) {
  return d.target.x;
}).attr("y2", function(d) {
  return d.target.y;
}).style("stroke", "rgba(0,0,0,0.5)");
