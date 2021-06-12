# ui for OM246 shinyapp

library(shiny)
library(lubridate)

imgs <- c(
  "imgs/1.jpg",
  "imgs/2.jpg",
  "imgs/3.jpg",
  "imgs/4.jpg",
  "imgs/5.jpg",
  "imgs/6.jpg",
  "imgs/7.jpg",
  "imgs/8.jpg"
)

# imgs <- c(
#   "imgs/colton-jones-_ZX2WYM3_BM-unsplash.jpg",
#   "imgs/david-tostado-woMvsY6KHac-unsplash.jpg",
#   "imgs/hilary-bird-F_aYxIFPnfk-unsplash.jpg",
#   "imgs/lloyd-blunk-Sv0xUKiu6ek-unsplash.jpg"
# )

# ui
ui <- tagList(
  tags$head(
    tags$meta(charset = "utf-8"),
    tags$meta(
      `http-quiv` = "x-ua-compatible",
      content = "ie=edge"
    ),
    tags$meta(
      name = "viewport",
      content = "width=device-width, initial-scale=1"
    ),
    tags$link(
      type = "text/css",
      rel = "stylesheet",
      href = "css/styles.css"
    )
  ),
 
    navbarPage(
     title = "",
      tabPanel(
        title = "OM246",
        tags$div(
          class = "landing-wrapper",
          # child element 1: images
          tags$div(
            class = "landing-block background-content",
            # images: top -> bottom, left -> right
            tags$div(tags$img(src = imgs[2])),
            tags$div(tags$img(src = imgs[4])),
            tags$div(tags$img(src = imgs[6])),
            tags$div(tags$img(src = imgs[8]))
          ),
          # child element 2: content
          tags$div(
            class = "landing-block foreground-content",
            tags$div(
              class = "foreground-text",
              tags$h1("Howdy y'all"),
              tags$p(
                "What can you do here? ",
                "Make and download a chart, ",
                "calculate an OM accumulation rate ",
                "and sand topdressing requirement, and get ",
                "more info about the OM246 test."
              )
            )
          )
        )
      ),
## an input panel for adding key data
tabPanel(
  title = "OM accumulation rate",
  sidebarLayout(
    
    # Sidebar with a slider input
    sidebarPanel(
      
      dateRangeInput("date",
                     label = "Date range (starting OM% & ending OM%)",
                     start = today() - years(1)),
      
      numericInput("depth",
                   "Depth of soil layer (cm)",
                   min = 1,
                   max = 20,
                   value = 6,
                   step = 0.1),
      
      numericInput("om1",
                  "Starting OM %",
                  min = 0,
                  max = 30,
                  value = 6.7,
                  step = 0.1),
      numericInput("om2",
                   label = "Ending OM %",
                   min = 0, 
                   max = 30,
                   value = 7.1,
                   step = 0.1),
      numericInput("topdressing",
                   label = "Sand added (mm)",
                   min = 0,
                   max = 20,
                   value = 5,
                   step = 0.1),
      
      submitButton()
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      br(),
     textOutput(outputId = "text1")
    )
  )
),

## topdressing requirement
tabPanel(
  title = "Sand topdressing rate",
  "Under construction."
  
),
  
  ## a tabpanel for a chart
  tabPanel(
    title = "Chart",
    "Under construction."
    
  ),

## tabpanel for more info
tabPanel(
  title = "Details"
)
)
    )
  
