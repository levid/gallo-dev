d3test = ->
  # dataset = [ 25, 7, 5, 26, 11, 8, 25, 14, 23, 19, 14, 11, 22, 29, 11, 13, 12, 17, 18, 10, 24, 18, 25, 9, 3 ]
  # Example 1
  dataset = []                                  # Initialize empty array
  for i in [1..25] by 1                         # Loop 25 times
    newNumber = Math.round(Math.random() * 30)  # New random number (0-30)
    dataset.push(newNumber)                     # Add new number to array

  d3.select("#graph").selectAll("graph")
    .data(dataset)
    .enter()
    .append("div")
    .text((d) ->
      if d isnt 0
        return d
    )
    .style("color", (d) ->
      if (d > 15)
        "#ffffff"
      else
        "#000000"
    )
    .attr("class", "bar")
    .style("height", (d) ->
      barHeight = d * 5  # Scale up by factor of 5
      barHeight + "px"
    )


  # Remember, selectAll() will return empty references to all circles (which don’t exist yet), data() binds our data to the elements we’re about to create, enter() returns a placeholder reference to the new element, and append() finally adds a circle to the DOM.
  # Example 2
  dataset2 = [ 5, 10, 15, 20, 25 ]
  w = 500
  h = 50
  svg = d3.select("#container").append("svg")
  svg.attr("width", w).attr("height", h)
  circles = svg.selectAll("circle")
    .data(dataset2)
    .enter()
    .append("circle")

  circles.attr("cx", (d, i) ->
    (i * 50) + 25
  )
  .attr("cy", h/2)
  .attr("r", (d) ->
    d
  )
  .attr("fill", "yellow")
  .attr("stroke", "orange")
  .attr("stroke-width", (d) ->
    d/2
  )

  # Example 3
  w = 500
  h = 200
  barPadding = 1
  dataset3 = [ 25, 7, 5, 26, 11, 8, 25, 14, 23, 19, 14, 11, 22, 29, 11, 13, 12, 17, 18, 10, 24, 18, 25, 9, 3 ]
  svg = d3.select("#container").append("svg")
  svg.attr("width", w).attr("height", h)
  svg.selectAll("rect")
    .data(dataset)
    .enter()
    .append("rect")
    .attr("y", (d) ->
      h - (d * 4)
    )
    .attr("width", w / dataset3.length - barPadding)
    .attr("height", (d) ->
      d * 4
    )
    .attr("x", (d, i) ->
      i * (w / dataset3.length)
    )
    .attr("fill", (d) ->
      "rgb(0, 0, " + (d * 10) + ")"
    )

  svg.selectAll("text")
    .data(dataset)
    .enter()
    .append("text")
    .text((d) ->
      d
    )
    .attr("x", (d, i) ->
      i * (w / dataset.length) + (w / dataset.length - barPadding) / 2
    )
    .attr("y", (d) ->
      h - (d * 4) + 14
    )
    .attr("font-family", "sans-serif")
    .attr("font-size", "11px")
    .attr("fill", "white")
    .attr("text-anchor", "middle")

  # Example 4
  dataset4 = [
    [ 5,     20 ],
    [ 480,   90 ],
    [ 250,   50 ],
    [ 100,   33 ],
    [ 330,   95 ],
    [ 410,   12 ],
    [ 475,   44 ],
    [ 25,    67 ],
    [ 85,    21 ],
    [ 220,   88 ]
  ]

  w = 500
  h = 100
  svg = d3.select("#container").append("svg")
  svg.attr("width", w).attr("height", h)
  scatterplot = svg.selectAll("circle")
    .data(dataset4)
    .enter()
    .append("circle")
    .attr("cx", (d) ->
      d[0]
    )
    .attr("cy", (d) ->
      d[1]
    )
    .attr("r", (d) ->
      Math.sqrt(h - d[1])
    )

  svg.selectAll("text")
    .data(dataset4)
    .enter()
    .append("text")
    .text((d) ->
      "#{d[0]},#{d[1]}"
    )
    .attr("x", (d) ->
      d[0]
    )
    .attr("y", (d) ->
      d[1]
    )
    .attr("font-family", "sans-serif")
    .attr("font-size", "11px")
    .attr("fill", "red")

  # Example 5
  # dataset5 = [
  #   [ 5,     20 ],
  #   [ 480,   90 ],
  #   [ 250,   50 ],
  #   [ 100,   33 ],
  #   [ 330,   95 ],
  #   [ 410,   12 ],
  #   [ 475,   44 ],
  #   [ 25,    67 ],
  #   [ 85,    21 ],
  #   [ 220,   88 ],
  #   [ 600,  150 ]
  # ]

  dataset5 = [];
  numDataPoints = 50;
  xRange = Math.random() * 1000;
  yRange = Math.random() * 1000;
  for i in [1..numDataPoints] by 1
      newNumber1 = Math.round(Math.random() * xRange)
      newNumber2 = Math.round(Math.random() * yRange)
      dataset5.push([newNumber1, newNumber2])

  w = 500
  h = 300
  padding = 30
  # scale = d3.scale.linear()
  #   .domain([100, 500])
  #   .range([10, 350])

  # nice() — This tells the scale to take whatever input domain that you gave to range() and expand both ends to the nearest round value. From the D3 wiki: “For example, for a domain of [0.20147987687960267, 0.996679553296417], the nice domain is [0.2, 1].” This is useful for normal people, who find it hard to read numbers like 0.20147987687960267.
  # rangeRound() — Use rangeRound() in place of range() and all values output by the scale will be rounded to the nearest whole number. This is useful if you want shapes to have exact pixel values, to avoid the fuzzy edges that may arise with antialiasing.
  # clamp() — By default, a linear scale can return values outside of the specified range. For example, if given a value outside of its expected input domain, a scale will return a number also outside of the output range. Calling .clamp(true) on a scale, however, forces all output values to be within the specified range. Meaning, excessive values will be rounded to the range’s low or high value (whichever is nearest).
  formatAsPercentage = d3.format(".1%")

  xScale = d3.scale.linear()
    .domain([0, d3.max(dataset5, (d) ->
      d[0]
    )])
    .rangeRound([padding, w - padding * 2])

  yScale = d3.scale.linear()
    .domain([0, d3.max(dataset5, (d) ->
      d[1]
    )])
    .rangeRound([h - padding, padding])

  rScale = d3.scale.linear()
    .domain([0, d3.max(dataset5, (d) ->
      d[1]
    )])
    .rangeRound([2, 5])

  xAxis = d3.svg.axis()
    .scale(xScale)
    .orient("bottom")
    .ticks(5)
    .tickFormat(formatAsPercentage)

  yAxis = d3.svg.axis()
    .scale(yScale)
    .orient("left")
    .ticks(5)
    .tickFormat(formatAsPercentage)

  animateFirstStep = () ->
    d3.select(this)
      .transition()
        .delay(0)
        .duration(1000)
        .attr("r", (d) ->
          rScale(d[1]) + 10
        )
        .each("end", animateSecondStep)

  animateSecondStep = () ->
    d3.select(this)
      .transition()
        .duration(1000)
        .attr("r", (d) ->
          rScale(d[1]) + 40
        )

  svg = d3.select("#container").append("svg")
  svg.attr("width", w).attr("height", h)
  scatterplot = svg.selectAll("circle")
    .data(dataset5)
    .enter()
    .append("circle")
    .attr("cx", (d) ->
      xScale(d[0])
    )
    .attr("cy", (d) ->
      yScale(d[1])
    )
    .attr("r", (d) ->
      rScale(d[1])
    )
    .on("mouseover", () ->
      d3.select(this).style("fill", "aliceblue")
    )
    .on("mouseout", () ->
      d3.select(this).style("fill", "white")
    )
    .on("mousedown", animateFirstStep)

  # svg.selectAll("text")
  #   .data(dataset5)
  #   .enter()
  #   .append("text")
  #   .text((d) ->
  #     "#{d[0]},#{d[1]}"
  #   )
  #   .attr("x", (d) ->
  #     xScale(d[0])
  #   )
  #   .attr("y", (d) ->
  #     yScale(d[1])
  #   )
  #   .attr("font-family", "sans-serif")
  #   .attr("font-size", "11px")
  #   .attr("fill", "red")

  svg.append("g")
    .attr("class", "axis")
    .attr("transform", "translate(0,#{h - padding})")
    .call(xAxis)

  svg.append("g")
    .attr("class", "axis")
    .attr("transform", "translate(#{padding},0)")
    .call(yAxis)


  # Example 6

  # Suppose there is currently one div with id "d3TutoGraphContainer" in the DOM
  # We append a 600x300 empty SVG container in the div
  chart = d3.select("#container").append("svg").attr("width", "600").attr("height", "300")

  # Create the bar chart which consists of ten SVG rectangles, one for each piece of data
  rects = chart.selectAll("rect").data([1, 4, 5, 6, 24, 8, 12, 1, 1, 20]).enter().append("rect").attr("stroke", "none").attr("fill", "rgb(7, 130, 180)").attr("x", 0).attr("y", (d, i) ->
    25 * i
  ).attr("width", (d) ->
    20 * d
  ).attr("height", "20")

  # Transition on click managed by jQuery
  rects.on "click", ->

    # Generate randomly a data set with 10 elements
    newData = []
    i = 0

    while i < 10
      newData.push Math.floor(24 * Math.random())
      i += 1

    # Generate a random color
    newColor = "rgb(" + Math.floor(255 * Math.random()) + ", " + Math.floor(255 * Math.random()) + ", " + Math.floor(255 * Math.random()) + ")"
    rects.data(newData).transition().duration(2000).delay(200).attr("width", (d) ->
      d * 20
    ).attr "fill", newColor

  # http://vallandingham.me/bubble_charts_in_d3.html
  # http://vallandingham.me/vis/gates/
  class BubbleChart
    constructor: (data) ->
      @data = data
      @width = 940
      @height = 600

      # @tooltip = CustomTooltip("gates_tooltip", 240)

      # locations the nodes will move towards
      # depending on which view is currently being
      # used
      @center = {x: @width / 2, y: @height / 2}
      @year_centers = {
        "2008": {x: @width / 3, y: @height / 2},
        "2009": {x: @width / 2, y: @height / 2},
        "2010": {x: 2 * @width / 3, y: @height / 2}
      }

      # used when setting up force and
      # moving around nodes
      @layout_gravity = -0.01
      @damper = 0.1

      # these will be set in create_nodes and create_vis
      @vis = null
      @nodes = []
      @force = null
      @circles = null

      # nice looking colors - no reason to buck the trend
      @fill_color = d3.scale.ordinal()
        .domain(["low", "medium", "high"])
        .range(["#d84b2a", "#beccae", "#7aa25c"])

      # use the max total_amount in the data as the max in the scale's domain
      max_amount = d3.max(@data, (d) -> parseInt(d.total_amount))
      @radius_scale = d3.scale.pow().exponent(0.5).domain([0, max_amount]).range([2, 85])

      this.create_nodes()
      this.create_vis()

    # create node objects from original data
    # that will serve as the data behind each
    # bubble in the vis, then add each node
    # to @nodes to be used later
    create_nodes: () =>
      @data.forEach (d) =>
        node = {
          id: d.id
          radius: @radius_scale(parseInt(d.total_amount))
          value: d.total_amount
          name: d.grant_title
          org: d.organization
          group: d.group
          year: d.start_year
          x: Math.random() * 900
          y: Math.random() * 800
        }
        @nodes.push node

      @nodes.sort (a,b) -> b.value - a.value


    # create svg at #vis and then
    # create circle representation for each node
    create_vis: () =>
      @vis = d3.select("#container").append("svg")
        .attr("width", @width)
        .attr("height", @height)
        .attr("id", "svg_vis")

      # @lines = @vis.selectAll("line")
      #   .data(@nodes)
      #   .enter().append("line")

      @circles = @vis.selectAll("circle")
        .data(@nodes, (d) -> d.id)


      # used because we need 'this' in the
      # mouse callbacks
      that = this

      # radius will be set to 0 initially.
      # see transition below
      @circles.enter().append("circle")
        .attr("r", 0)
        .attr("fill", (d) => @fill_color(d.group))
        .attr("stroke-width", 2)
        .attr("stroke", (d) => d3.rgb(@fill_color(d.group)).darker())
        .attr("id", (d) -> "bubble_#{d.id}")
        .on("mouseover", (d,i) -> that.show_details(d,i,this))
        .on("mouseout", (d,i) -> that.hide_details(d,i,this))

      # Fancy transition to make bubbles appear, ending with the
      # correct radius
      @circles.transition().duration(2000).attr("r", (d) -> d.radius)


    # Charge function that is called for each node.
    # Charge is proportional to the diameter of the
    # circle (which is stored in the radius attribute
    # of the circle's associated data.
    # This is done to allow for accurate collision
    # detection with nodes of different sizes.
    # Charge is negative because we want nodes to
    # repel.
    # Dividing by 8 scales down the charge to be
    # appropriate for the visualization dimensions.
    charge: (d) ->
      -Math.pow(d.radius, 2.0) / 8

    # Starts up the force layout with
    # the default values
    start: () =>
      @force = d3.layout.force()
        .nodes(@nodes)
        .size([@width, @height])

      # @force.on "tick", ->
      #   @lines.attr("x1", (d) ->
      #     d.source.x
      #   ).attr("y1", (d) ->
      #     d.source.y
      #   ).attr("x2", (d) ->
      #     d.target.x
      #   ).attr "y2", (d) ->
      #     d.target.y

      #   @circles.attr("cx", (d) ->
      #     d.x
      #   ).attr "cy", (d) ->
      #     d.y


    # Sets up force layout to display
    # all nodes in one circle.
    display_group_all: () =>
      @force.gravity(@layout_gravity)
        .charge(this.charge)
        .friction(0.9)
        .on "tick", (e) =>
          @circles.each(this.move_towards_center(e.alpha))
            .attr("cx", (d) -> d.x)
            .attr("cy", (d) -> d.y)
      @force.start()

      this.hide_years()

    # Moves all circles towards the @center
    # of the visualization
    move_towards_center: (alpha) =>
      (d) =>
        d.x = d.x + (@center.x - d.x) * (@damper + 0.02) * alpha
        d.y = d.y + (@center.y - d.y) * (@damper + 0.02) * alpha

    # sets the display of bubbles to be separated
    # into each year. Does this by calling move_towards_year
    display_by_year: () =>
      @force.gravity(@layout_gravity)
        .charge(this.charge)
        .friction(0.9)
        .on "tick", (e) =>
          @circles.each(this.move_towards_year(e.alpha))
            .attr("cx", (d) -> d.x)
            .attr("cy", (d) -> d.y)
      @force.start()

      this.display_years()

    # move all circles to their associated @year_centers
    move_towards_year: (alpha) =>
      (d) =>
        target = @year_centers[d.year]
        d.x = d.x + (target.x - d.x) * (@damper + 0.02) * alpha * 1.1
        d.y = d.y + (target.y - d.y) * (@damper + 0.02) * alpha * 1.1

    # Method to display year titles
    display_years: () =>
      years_x = {"2008": 160, "2009": @width / 2, "2010": @width - 160}
      years_data = d3.keys(years_x)
      years = @vis.selectAll(".years")
        .data(years_data)

      years.enter().append("text")
        .attr("class", "years")
        .attr("x", (d) => years_x[d] )
        .attr("y", 40)
        .attr("text-anchor", "middle")
        .text((d) -> d)

    # Method to hide year titiles
    hide_years: () =>
      years = @vis.selectAll(".years").remove()

    show_details: (data, i, element) =>
      d3.select(element).attr("stroke", "black")
      content = "
        <span class=\"name\">Title:</span><span class=\"value\"> #{data.name}</span><br/>
        <span class=\"name\">Amount:</span><span class=\"value\"> $#{data.value}</span><br/>
        <span class=\"name\">Year:</span><span class=\"value\"> #{data.year}</span>"
      # @tooltip.showTooltip(content,d3.event)


    hide_details: (data, i, element) =>
      d3.select(element).attr("stroke", (d) => d3.rgb(@fill_color(d.group)).darker())
      # @tooltip.hideTooltip()


  root = exports ? this

  $ ->
    chart = null

    render_vis = (csv) ->
      chart = new BubbleChart csv
      chart.start()
      root.display_all()
    root.display_all = () =>
      chart.display_group_all()
    root.display_year = () =>
      chart.display_by_year()
    root.toggle_view = (view_type) =>
      if view_type == 'year'
        root.display_year()
      else
        root.display_all()

    d3.csv "data/gates_money.csv", render_vis
