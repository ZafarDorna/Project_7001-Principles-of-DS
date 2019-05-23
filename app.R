library(shiny)
library(ggplot2)
library(dplyr)

b <- read.csv("Project_WQD7001.csv", stringsAsFactors = FALSE)
v_country= b$country %>% unique() %>% sort()

ui <- fluidPage(
  titlePanel("Country wise Website rank, Thus depicting Socio-Economic Scenario of the country"),
  sidebarLayout(
   
     sidebarPanel(
      
      selectInput("countryInput", "Country",
                  choices = v_country,
                  selected = "Malaysia")
                 ),
    
    mainPanel(plotOutput("coolplot")
              )
  )
)


server <- function(input, output) {
  
  output$coolplot <- renderPlot({
    new_col<-c("chartreuse4","navy","grey50","deepskyblue3","orangered4","orange4","mediumorchid4","darkorchid4","goldenrod","green3")
    filtered <-
      b %>% filter(country== input$countryInput & Trustworthiness=="Excellent" & Privacy=="Excellent"& Child_Safety=="Excellent") %>% 
      arrange(desc(Country_Rank))
      ggplot(filtered, aes(x=factor(website,level=website),y=Country_Rank,fill=website))+
      geom_bar(stat="identity")+coord_flip()+
      scale_fill_manual(values=c(new_col,new_col,new_col,new_col))+
      theme(legend.position = "none")+labs(x="website",y="Rank")
  
  })
  
  
}
shinyApp(ui = ui, server = server)