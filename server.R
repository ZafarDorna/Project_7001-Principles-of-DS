#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(plotly)
suppressMessages(library(ggplot2)) 
suppressMessages(library(readr))
suppressMessages(library(RColorBrewer))
suppressMessages(library(dplyr))
suppressMessages(library(gridExtra))
suppressMessages(library(stringr))
suppressMessages(library(tidyr))
suppressMessages(library(treemap))

web_data<-read.csv("Project_WQD7001.csv",stringsAsFactor=FALSE)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  var_region=web_data$region %>% unique() %>% sort()
  var_category=web_data$category %>% unique() %>% sort()
  v_country= web_data$country %>% unique() %>% sort()
  
  
  
  
  
  output$Rajuplot <- renderPlot({
    
    if (input$regionInput != "All") {
      web_data <- web_data %>% filter(region==input$regionInput)
    }
    
    if (input$catInput != "All") {
      web_data <- web_data %>% filter(category==input$catInput)
    }
    
    by_visitor <- web_data %>% select(site,Avg_Daily_Visitors) %>% group_by(site) %>%
      summarise(total_daily_visitors=sum(as.numeric(Avg_Daily_Visitors))) %>% arrange(desc(total_daily_visitors)) %>% slice(1:10)
    
    
    by_pageview <- web_data %>% select(site,Avg_Daily_Pageviews) %>% group_by(site) %>%
      summarise(total_daily_pageviews=sum(as.numeric(Avg_Daily_Pageviews))) %>% arrange(desc(total_daily_pageviews)) %>% slice(1:10)
    
    
    by_visitor$site <- factor(by_visitor$site, levels = by_visitor$site[order(by_visitor$total_daily_visitors,decreasing = T)])
    p1 <- ggplot(by_visitor, aes(site,total_daily_visitors)) + geom_bar(stat="identity",fill="blue")+labs(title="Top sites by daily visitors") + ylab("daily visitors")
    
    
    by_pageview$site <- factor(by_pageview$site, levels = by_pageview$site[order(by_pageview$total_daily_pageviews,decreasing = T)])
    p2 <- ggplot(by_pageview, aes(site,total_daily_pageviews)) + geom_bar(stat="identity",fill="red")+labs(title="Top sites by daily page views") + ylab("daily page views")
    #ggarrange(p1,p2,ncol = 1, nrow = 2)
    ggarrange(p1,p2)
    
  })
  
  
   
  output$treeoutput <-renderPlot(
    
    {
      if (input$countryInput2=="ALL") {
        tr1<-web_data %>% select(Hosted_by,Location) %>% group_by(Hosted_by,Location)%>%summarise(n=n())%>% arrange(desc(n)) %>%filter(n>30)
      }
      else
      {
        tr1<-web_data %>% select(Hosted_by,Location) %>% group_by(Hosted_by,Location)%>%summarise(n=n())%>% arrange(desc(n)) %>%filter(n>30 & Location == input$countryInput2)
      }
      tr1$label<-paste(tr1$Hosted_by,tr1$Location,tr1$n,sep="\n")
      treemap(tr1,index=c("label"),  
               vSize = "n",  
               type="index", 
               palette = "Set2", 
               title="Who is hosting more number of websites all over World",
              fontsize.title = 14 
      
      )
      
      
    }
    
    
    
  )
  
  
  
  
  
  output$results <- renderTable({
    filtered <-
      bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput
      )
    filtered
  })
  
  
  
  
  
  output$Zaplot <- renderPlot({
    new_col<-c("chartreuse4","navy","grey50","deepskyblue3","orangered4","orange4","mediumorchid4","darkorchid4","goldenrod","green3")
    filtered <-
      web_data %>% filter(country== input$countryInputs & Trustworthiness=="Excellent" & Privacy=="Excellent"& Child_Safety=="Excellent") %>% 
      arrange(desc(Country_Rank))
    ggplot(filtered, aes(x=factor(website,level=website),y=Country_Rank,fill=website))+
      geom_bar(stat="identity")+coord_flip()+
      scale_fill_manual(values=c(new_col,new_col,new_col,new_col))+
      theme(legend.position = "none")+labs(x="website",y="Rank")
  })
  
  output$Vistorplot <- renderPlotly({
    web_data$Child_Safety <- as.factor(web_data$Child_Safety)
    theme_set(theme_bw() + theme(legend.position = "top"))
    p <- ggplot(web_data, aes(x = Avg_Daily_Visitors, y = category, text = website)) + 
      geom_point(aes(color = Child_Safety, size = Reach_Day), alpha = 0.5) +
      scale_color_manual(values = c("#7DCEA0", "#AED6F1", "#E74C3C", "#A569BD", "#7F8C8D", "#BA4A00")) +
      scale_size(range = c(2, 15))
    
    print(ggplotly(p, tooltip="text"))
  })
  
  
  
})
