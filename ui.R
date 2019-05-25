#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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
var_region=web_data$region %>% unique() %>% sort()
var_category=web_data$category %>% unique() %>% sort()
v_country= web_data$country %>% unique() %>% sort()

# Define UI for application that draws a histogram
shinyUI(
  
  
  navbarPage("What we do ONLINE !",
           
             
             
             
             tabPanel("Website Rank",  
                      
                      titlePanel("What's our favorite websites?"),
                      sidebarLayout(
                        
                        sidebarPanel(
                          
                          selectInput("countryInputs", "Country",
                                      choices = v_country,
                                      selected = "Malaysia")
                        ),
                        
                        mainPanel(plotOutput("Zaplot"))))    ,
            
                 tabPanel("Websites Popularity ",
                      titlePanel("Popularity of Websites by Category"),
                      verticalLayout(sidebarPanel(
                        selectInput("regionInput", "Select Region",choices = c('All',var_region)),
                        selectInput("catInput", "Select Category",choices = c("All", var_category))),
                      mainPanel(plotOutput("Rajuplot")))),
             
             tabPanel("Child Safe", titlePanel("Most child friendly websites by category"),
                      mainPanel(plotlyOutput("Vistorplot",height = "150%", width = "150%"))),
            
             
              tabPanel("Hosting",
                      titlePanel("Who control the world wide web ?"),
                      
                      sidebarPanel(
                        selectInput("countryInput2", "Country",
                                    choices = c( "ALL"  ,"United States", "Germany","United Kingdom"
                                                 ,"Russian Federation","Ireland","Netherlands","Luxembourg"))),
                      mainPanel( plotOutput("treeoutput"))),
             tabPanel("About",
                h3("This dataset includes information on websites, global traffic rank and average visitor count and relevant information with regards to website."),
                h3("Our product app is 'What we Do Online', which emphasizes on activities of users, website content, evaluation of website by security, privacy and child friendly across the globe.")
)
             )
  
  
    
)

