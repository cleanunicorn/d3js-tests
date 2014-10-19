var circles, color, dragend, dragmove, dragstart, edges, force, graph_data, height, i, links_number, node_drag, nodes_number, tick, vis, width, _i, _j;

width = 800;

height = 600;

vis = d3.select('#graph').append('svg');

vis.attr('width', width);

vis.attr('height', height);

graph_data = {};

nodes_number = 40;

graph_data['nodes'] = [];

for (i = _i = 1; 1 <= nodes_number ? _i <= nodes_number : _i >= nodes_number; i = 1 <= nodes_number ? ++_i : --_i) {
  graph_data['nodes'].push({
    x: parseInt(Math.random() * width),
    y: parseInt(Math.random() * height),
    color: parseInt(Math.random() * 255)
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

force = d3.layout.force().size([width, height]).nodes(graph_data.nodes).links(graph_data.links).gravity(0.03).distance(50).start();

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

node_drag = d3.behavior.drag().on("dragstart", dragstart).on("drag", dragmove).on("dragend", dragend);

dragstart = function(d, i) {
  return force.stop();
};

dragmove = function(d, i) {
  d.px += d3.event.dx;
  d.py += d3.event.dy;
  d.x += d3.event.dx;
  d.y += d3.event.dy;
  return tick();
};

dragend = function(d, i) {
  tick();
  return force.resume();
};

color = d3.scale.category20();

circles = vis.selectAll("circle").data(graph_data['nodes']).enter().append("circle").attr("class", "node").attr("cx", function(d) {
  return d.x;
}).attr("cy", function(d) {
  return d.y;
}).attr("r", "15").attr("fill", function(d) {
  return color(d.color);
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

force.on("tick", tick);
