width = 800
height = 600

vis = d3.select('#graph').append('svg')
vis.attr 'width', width
vis.attr 'height', height

# Our graph data
graph_data = {}

# Graph nodes
nodes_number = 40
graph_data['nodes'] = []
for i in [1..nodes_number]
  graph_data['nodes'].push({
    x: parseInt(Math.random()*width)
    y: parseInt(Math.random()*height)
    color: parseInt(Math.random()*255)
  })

# Graph links
links_number = parseInt(nodes_number * (2 / 3))
graph_data['links'] = []
for i in [1..links_number]
  graph_data['links'].push({
    source: graph_data['nodes'][parseInt(Math.random()*nodes_number)]
    target: graph_data['nodes'][parseInt(Math.random()*nodes_number)]
  })

# Force
force = d3.layout.force()
  .size([width, height])
  .nodes(graph_data.nodes)
  .links(graph_data.links)
  .gravity(0.03)
  .distance(50)
  .start()

tick = ()->
  edges
    .attr('x1', (d)-> return d.source.x)
    .attr('y1', (d)-> return d.source.y)
    .attr('x2', (d)-> return d.target.x)
    .attr('y2', (d)-> return d.target.y)

  circles.attr('cx', (d)-> return d.x)
    .attr('cy', (d)-> return d.y)

node_drag = d3.behavior.drag()
  .on("dragstart", dragstart)
  .on("drag", dragmove)
  .on("dragend", dragend)

dragstart = (d, i)->
  force.stop()

dragmove = (d, i)->
  d.px += d3.event.dx
  d.py += d3.event.dy
  d.x += d3.event.dx
  d.y += d3.event.dy
  tick()

dragend = (d, i)->
  # d.fixed = true
  tick()
  force.resume();

# Add nodes
color = d3.scale.category20()

circles = vis.selectAll("circle")
  .data(graph_data['nodes'])
  .enter()
  .append("circle")
  .attr("class", "node")
  .attr("cx", (d)-> return d.x)
  .attr("cy", (d)-> return d.y)
  .attr("r", "15")
  .attr("fill", (d)-> return color(d.color))
  .call(force.drag)

# Links
edges = vis.selectAll("line")
  .data(graph_data['links'])
  .enter()
  .append("line")
  .attr("x1", (d)-> return d.source.x)
  .attr("y1", (d)-> return d.source.y)
  .attr("x2", (d)-> return d.target.x)
  .attr("y2", (d)-> return d.target.y)
  .style("stroke", "rgba(0,0,0,0.5)")

force.on("tick", tick)

