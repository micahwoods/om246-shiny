# ui for OM246 shinyapp

library(shiny)
library(shinyWidgets)
library(lubridate)

# ui
ui <- (fluidPage(
  ## This is for embedding in an iframe on my website that will resize
  ## automatically to the app window size
  tags$head(
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/iframe-resizer/4.3.1/iframeResizer.contentWindow.js",
                type = "text/javascript")
  ),
  
  tags$head(includeHTML((
    "google_analytics.html"
  ))),
  
  
  tabsetPanel(
    tabPanel(
      setBackgroundImage(src = "imgs/7t.jpg"),
      title = "Getting started",
      
      br(),
      tags$p(
        "Welcome to an app for rapid calculation of a few things from OM246 data."),
      
      tags$p(
        "By looking at the change in total organic matter over time, and at the amount of sand added ",
        "between two sampling dates, this app can calculate the site-specific organic matter ",
        "accumulation rate. When this is known, the app can find the exact amount of sand required ",
        "to produce a specified level of OM in the soil."
      )
      ),
      
      tabPanel(title = "OM accumulation rate",
               sidebarLayout(
                 sidebarPanel(
                   numericInput(
                     "depth",
                     "Depth of soil layer (cm)",
                     min = 1,
                     max = 20,
                     value = 6,
                     step = 0.1,
                     width = "100px"
                   ),
                   numericInput(
                     "om1",
                     "Starting OM %",
                     min = 0,
                     max = 30,
                     value = 6.7,
                     step = 0.1,
                     width = "100px"
                   ),
                   numericInput(
                     "om2",
                     label = "Ending OM %",
                     min = 0,
                     max = 30,
                     value = 7.1,
                     step = 0.1,
                     width = "100px"
                   ),
                   dateRangeInput("date",
                                  label = "Date range (starting OM% & ending OM%)",
                                  start = today() - years(1)),
                   numericInput(
                     "topdressing",
                     label = "Sand added (mm)",
                     min = 0,
                     max = 20,
                     value = 5,
                     step = 0.1,
                     width = "100px"
                   ),
                   submitButton()
                 ),
                 
                 mainPanel(br(),
                           textOutput(outputId = "text1"),
                           )
               )),
      
      ## topdressing requirement
      tabPanel(title = "Sand requirement",
               sidebarLayout(
                 sidebarPanel(
                
                
                 
                uiOutput("rate"),
                
                 dateInput(inputId = "future_date",
                                label = "Date to achieve desired OM %",
                                value = today() + years(1)
                           ),
               
                 submitButton(text = "Calculate sand required")
                 ),
                 
                 mainPanel(br(),
                           textOutput(outputId = "text2"),
                           "Is the mm of sand y'all need."
                 )
               )),
  
  ## tabpanel for more info
  tabPanel(title = "Details",
           includeMarkdown("om246_details.md")
  )
  )
  )
  )