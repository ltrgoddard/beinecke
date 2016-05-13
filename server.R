library(shiny)
library(igraph)
library(networkD3)
source("igraph_to_networkD3_mod.R")

d <- read.csv("beinecke.csv")
g <- graph.data.frame(d, directed = FALSE)

function(input, output) {

	graph <- reactive({
        g <- delete.edges(g, which(E(g)$value <= quantile(E(g)$value, input$weight / 100)))
        g <- delete.vertices(g, which(degree(g) < 2))
        if(input$colours == TRUE) {
		    wc <- cluster_walktrap(g)
		    igraph_to_networkD3_mod(g, group = membership(wc))
        } else { igraph_to_networkD3_mod(g, group = V(g)) }
	})

    charge <- reactive({input$charge})

	output$force <- renderForceNetwork({ forceNetwork(Links = graph()$links, Nodes = graph()$nodes, Source = "source", Target = "target", Value = "value", NodeID = "name", Group = "group", zoom = TRUE, bounded = FALSE, fontSize = 30, opacity = 1, charge = charge(), linkWidth = JS("function(d) { return Math.sqrt(d.value)/3; }"), colourScale = JS("d3.scale.category10()")) })

}
