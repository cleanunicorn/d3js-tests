width = 800
height = 600

vis = d3.select('#graph').append('svg')
vis.attr 'width', width
vis.attr 'height', height

# Our graph data
graph_data = {}

# Graph nodes
nodes_number = 50
graph_data['nodes'] = []
for i in [1..nodes_number]
  graph_data['nodes'].push({
    x: parseInt(width / 2 - Math.random() * width / 20)
    y: parseInt(height / 2 - Math.random() * height / 20)
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
tick = ()->
  # Links
  edges
    .attr('x1', (d)-> return d.source.x)
    .attr('y1', (d)-> return d.source.y)
    .attr('x2', (d)-> return d.target.x)
    .attr('y2', (d)-> return d.target.y)
  # Nodes
  circles.attr('cx', (d)-> return d.x)
    .attr('cy', (d)-> return d.y)

force = d3.layout.force()
  .size([width, height])
  .nodes(graph_data.nodes)
  .links(graph_data.links)
  .gravity(0.02)
  .distance(50)
  .start()

force.on("tick", tick)

# Add nodes
color = d3.scale.category20c()

circles = vis.selectAll("circle")
  .data(graph_data['nodes'])
  .enter()
  .append("circle")
  .attr("class", "node")
  .attr("cx", (d)-> return d.x)
  .attr("cy", (d)-> return d.y)
  .attr("r", "15")
  .attr("fill",
        (d, i)->
          # Count neighbors
          neighbors = 0
          for link in graph_data['links']
            if (link.source.index is i)
              neighbors++
            if (link.target.index is i)
              neighbors++
          console.log "#{i} -> #{neighbors}"
          return color(neighbors)
  )
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
