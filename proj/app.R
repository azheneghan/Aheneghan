#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

ui <- fluidPage(
  withMathJax(),
  tags$div(HTML("<script type='text/x-mathjax-config' >
            MathJax.Hub.Config({
            tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
            });
            </script >
            ")),
  ### 
  br(), br(), 
  wellPanel(style = "background-color:lightskyblue;",  
            # App title ----
            titlePanel(h2("Simulating Binomial Distribution", align = "center",
                          style = "color:midnightblue; font-family:verdana; 
                      font-variant: small-caps; font-weight: bold;"))),
  ###
  sidebarLayout(    # siderbarLayout:       
    sidebarPanel( style = "background-color:lightskyblue;", 
                  tags$div( h4("User Input Panel", align = "center",
                               style = "color:darkred; font-family:verdana; 
                      font-variant: small-caps; font-weight: bold;")),
                  #
                  br(),
                  ##
                  # slider input: number of experiments
                  sliderInput(inputId = "x",
                              label = "Number of Experiments",
                              min = 1,
                              max = 1000,
                              value = 500),
                  # slider input: number of trials per experiment
                  sliderInput(inputId = "n",
                              label = "Number of Trials",
                              min = 1,
                              max = 100,
                              value = 50),
                  # slider input: probability of success
                  sliderInput(inputId = "p",
                              label = "Probability of Success",
                              min = 0,
                              max = 1,
                              value = 0.5)),
    mainPanel( style = "background-color:khaki1; text-align: center;", 
               plotOutput(outputId = "distPlot")
    )
  ))
###
server <- function(input, output) {
  output$distPlot <- renderPlot({
    ##
    binom.score <- rbinom(input$x, input$n, input$p)
    ##
    par(bg = "khaki1")
    hist(binom.score, probability = TRUE, col = "deeppink", border = "darkgreen",
         xlab = "Histogram of Generated Binomial Data",
         main = "Simulated Binomial Distribution")
    d <- density(binom.score) # returns the density data
    lines(d)
  }, height = 400, width = 800)
}
###
shinyApp(ui = ui, server = server)
