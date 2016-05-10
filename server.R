library(shiny)
library(igraph)
library(networkD3)

function(input, output) {

	d <- read.csv("beinecke.csv")

	go <- reactive({
		s <- d[d$weight > quantile(d$weight, input$weight),]
		g <- graph.data.frame(s, directed = FALSE)
		g <- delete.vertices(g, which(degree(g) < 2))
		wc <- cluster_walktrap(g)
		igraph_to_networkD3(g, group = membership(wc))
	})

	output$force <- renderForceNetwork({
		forceNetwork(Links = go()$links, Nodes = go()$nodes, Source = "source", Target = "target", NodeID = "name", Group = "group", zoom = TRUE, bounded = TRUE, fontSize = 30, opacity = 1, charge = -400, colourScale = JS("d3.scale.category10()"))
	})

}