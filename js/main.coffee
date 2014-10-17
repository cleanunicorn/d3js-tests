width = 400
height = 400

vis = d3.select('#graph').append('svg')
vis.attr 'width', width
vis.attr 'height', height

# Our graph data
graph_data = {}

# Graph nodes
graph_data['nodes'] = [
  {x: 100, y: 200}
  {x: 150, y: 200}
  {x: 120, y: 120}
]

# Graph links
graph_data['links'] = [
  {source: graph_data['nodes'][0], target: graph_data['nodes'][1]}
  {source: graph_data['nodes'][2], target: graph_data['nodes'][1]}
]

# Force
force = d3.layout.force()
  .size([width, height])
  .nodes(graph_data.nodes)
  .links(graph_data.links)
  .gravity(0.03)
  .distance(100)
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
circles = vis.selectAll("circle")
  .data(graph_data['nodes'])
  .enter()
  .append("circle")
  .attr("class", "node")
  .attr("cx", (d)-> return d.x)
  .attr("cy", (d)-> return d.y)
  .attr("r", "5")
  .attr("fill", "black")
  .attr("stroke", "#ff0000")
  .call(node_drag)

# Links
edges = vis.selectAll("line")
  .data(graph_data['links'])
  .enter()
  .append("line")
  .attr("x1", (d)-> return d.source.x)
  .attr("y1", (d)-> return d.source.y)
  .attr("x2", (d)-> return d.target.x)
  .attr("y2", (d)-> return d.target.y)
  .style("stroke", "rgb(6,120,155)")

force.on("tick", tick)

