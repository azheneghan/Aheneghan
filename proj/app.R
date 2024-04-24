#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

##  Working data set
penguin0 <- na.omit(read.csv(file="https://raw.githubusercontent.com/azheneghan/aheneghan/main/datasets/w03-penguins.csv"))
penguin0$BMI = (penguin0$body_mass_g/4000)
x.names = names(penguin0)[-c(1,2,3,7,8,9)]
y.names =names(penguin0)[-c(1,2,3,7,8,9)]
##
#UI
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
            titlePanel(h2("Analysis of Penguin Data", align = "center",
                          style = "color:midnightblue; font-family:verdana; 
                      font-variant: small-caps; font-weight: bold;")),
  ),
  ###
  sidebarLayout(
    sidebarPanel(style = "background-color:lightskyblue;", 
                 radioButtons(inputId = "island", 
                              label = "Location",
                              choices = c("Biscoe",
                                          "Dream",
                                          "Torgersen",
                                          "All"),
                              inline = FALSE,
                              selected = "All"),
                 br(),
                 ###
                 selectInput(inputId = "Y",
                             label = "Response Variable: Y",
                             choices = y.names),
                 
                 selectInput(inputId = "X",
                             label =  "Predictor Variable: X",
                             choices = x.names,
                             selected = x.names[2]),
                 ####
                 hr(),
                 ###
                 sliderInput(inputId = "newX", 
                             label = "New Value for Prediction:", 
                             value = 117, 
                             min = 0, 
                             max = 235, 
                             step = 0.1),
    ),
    ###
    mainPanel(style = "background-color:lightgray; text-align: center;", 
              tabsetPanel(type = "tabs",
                          tabPanel(h5("Scatter Plot", style ="color:darkred;"), plotOutput("plot")),
                          tabPanel(h5("Regression Coefficients", style ="color:darkred;"), tableOutput("table")),
                          tabPanel(h5("Diagnostics", style ="color:darkred;"), plotOutput("diagnosis")),
                          tabPanel(h5("Prediction", style ="color:darkred;"), plotOutput("predPlt"))
              )
              
    )
  )
)

## Server function
server <- function(input, output) {
  #### Subsetting data based on Island Location
  workDat = function(){
    if (input$island == "Biscoe") {
      workingData = penguin0[which(penguin0$island == "Biscoe"),]
    } else if (input$island == "Dream") {
      workingData = penguin0[which(penguin0$island == "Dream"),]
    } else if (input$island == "Torgersen") {
      workingData = penguin0[which(penguin0$island == "Torgersen"),]
    } else {
      workingData = penguin0
    }
    workingData 
  }
  ######################################
  #######   Scatter Plot
  ######################################
  output$plot <- renderPlot({
    par(bg="khaki1")
    dataset = workDat()[,-1]
    #####
    plot(dataset[,input$X], dataset[,input$Y], 
         xlab = input$X,
         ylab = input$Y,
         main = paste("Relationship between", input$Y, "and", input$X)
    )
    ##
    abline(lm(dataset[,input$Y] ~ dataset[,input$X]), col = "blue", lwd = 2)
  })
  
  ######################################
  #######   Regression Coefficiients
  ######################################
  output$table <- renderTable({
    br()
    br()
    dataset = workDat()[,-1]
    m0 = lm(dataset[,input$Y] ~ dataset[,input$X])
    #summary(m0)
    regcoef = data.frame(coef(summary(m0)))
    
    ##
    regcoef$Pvalue = regcoef[,names(regcoef)[4]]
    ###
    regcoef$Variable = c("Intercept", input$X)
    regcoef[,c(6, 1:3, 5)]
    
  })
  ######################################
  #######   Diagnostics
  ######################################
  output$diagnosis <- renderPlot({
    par(bg="khaki1")
    dataset = workDat()[,-1]
    #####
    m1=lm(dataset[,input$Y] ~ dataset[,input$X])
    par(mfrow=c(2,2))
    plot(m1)
  })   
  
  ######################################
  #######       Prediction Plot
  ######################################
  output$predPlt <- renderPlot({
    par(bg="khaki1")
    dataset = workDat()[,-1]
    ###
    m3 = lm(dataset[,input$Y] ~ dataset[,input$X])
    pred.y = coef(m3)[1] + coef(m3)[2]*input$newX
    #####
    plot(dataset[,input$X], dataset[,input$Y], 
         xlab = input$X,
         ylab = input$Y,
         main = paste("Relationship Between", input$Y, "and", input$X)
    )
    ##
    abline(m3, col = "deeppink", lwd = 1, lty=2)
    points(input$newX, pred.y, pch = 19, col = "deeppink", cex = 2)
  })
}
###
shinyApp(ui = ui, server = server)
