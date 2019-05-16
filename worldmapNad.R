##worldmap chloropeth
# Download .shp file on the web:
download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip" , destfile="world_shape_file.zip")
#system("unzip world_shape_file.zip")

install.packages("leaflet")
install.packages("rgdal")
install.packages("choroplethr")
library(leaflet)
library(rgdal)
library(shiny)
library(choroplethr)


# Read the file with the rgdal library in R
world_spdf=readOGR( dsn= getwd() , layer="TM_WORLD_BORDERS_SIMPL-0.3")

# Look at the info provided with the geospatial object
head(world_spdf@data)
summary(world_spdf@data)

# Modify these info
world_spdf@data$POP2005[ which(world_spdf@data$POP2005 == 0)] = NA
world_spdf@data$POP2005 = as.numeric(as.character(world_spdf@data$POP2005)) / 1000000 %>% round(2)

# Create a color palette for the map:
mypalette = colorNumeric( palette="viridis", domain=world_spdf@data$POP2005, na.color="transparent")
mypalette(c(45,43))

# Basic choropleth with leaflet?
leaflet(world_spdf) %>% 
  addTiles()  %>% 
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( fillColor = ~mypalette(POP2005), stroke=FALSE )

# Color by quantile
m=leaflet(world_spdf)%>% addTiles()  %>% setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5, color = ~colorQuantile("YlOrRd", POP2005)(POP2005) )
m

# Numeric palette
#m=leaflet(world_spdf)%>% addTiles()  %>% setView( lat=10, lng=0 , zoom=2) %>%
 # addPolygons( stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5, color = ~colorNumeric("YlOrRd", POP2005)(POP2005) )
#m

# Bin
#m=leaflet(world_spdf)%>% addTiles()  %>% setView( lat=10, lng=0 , zoom=2) %>%
 # addPolygons( stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5, color = ~colorBin("YlOrRd", POP2005)(POP2005) )
#m

# Create a color palette with handmade bins.
mybins=c(0,10,20,50,100,500,Inf)
mypalette = colorBin( palette="YlOrBr", domain=world_spdf@data$POP2005, na.color="transparent", bins=mybins)

# Prepar the text for the tooltip:
mytext=paste("Country: ", world_spdf@data$NAME,"<br/>", "Area: ", world_spdf@data$AREA, "<br/>", "Population: ", round(world_spdf@data$POP2005, 2), sep="") %>%
  lapply(htmltools::HTML)

# Final Map
leaflet(data = world_spdf) %>% 
  addTiles()  %>% 
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( 
    fillColor = ~mypalette(POP2005), stroke=TRUE, fillOpacity = 0.9, color="white", weight=0.3,
    highlight = highlightOptions( weight = 5, color = ~colorNumeric("Blues", POP2005)(POP2005), dashArray = "", fillOpacity = 0.3, bringToFront = TRUE),
    label = world_spdf$NAME,
    labelOptions = labelOptions( style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "13px", direction = "auto")
  ) %>%
  addLegend( pal=mypalette, values=~POP2005, opacity=0.9, title = "Population (M)", position = "bottomleft" )

#leaflet(data=world_spdf) %>%
 # addTiles() %>%
  #setView(lat = 10,lng = 0, zoom = 2) %>%
  #addPolygons(fillColor = "green", 
   #           highlight = highlightOptions(weight = 5, 
    #                                       color = "red", 
     #                                      fillOpacity = 0.7,
      #                                     bringToFront = T),
       #       label = mysdpf$NAME)