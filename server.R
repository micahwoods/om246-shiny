
server <- function(input, output, session) {
  ## om accumulation rate
  output$text1 <- renderText({
    years <- as.numeric((input$date[2] - input$date[1]) / 365)
    rate <-
      accum_rate(input$topdressing, input$depth, input$om1, input$om2) / years
    
    paste(
      "If you have applied ",
      input$topdressing,
      " mm of sand
          to a ",
      input$depth,
      " cm layer of the rootzone with a starting OM of ",
      input$om1,
      "% on ",
      as.Date(input$date[1]),
      " and ending OM of ",
      input$om2,
      "% on ",
      as.Date(input$date[2]),
      ", the total organic material accumulation rate is:",
      br(),
      br(),
      tags$strong(round(rate, 1), " grams per kg of soil per year"),
      sep = ""
    )
  })
  
  # UI for the topdressing tab depends on input from the accumulation tab
  output$rate <- renderUI({
    years <- as.numeric((input$date[2] - input$date[1]) / 365)
    rate <-
      round(
        accum_rate(input$topdressing, input$depth, input$om1, input$om2) / years,
        digits = 1
      )
    
    tagList(
      numericInput(
        "depth_sand",
        "Depth of soil layer (cm)",
        min = 1,
        max = 10,
        value = input$depth,
        step = 0.1,
        width = "100px"
      ),
      numericInput(
        "om_now_input",
        "Current OM %",
        min = 0,
        max = 30,
        value = input$om2,
        step = 0.1,
        width = "100px"
      ),
      numericInput(
        "om_want",
        label = "Desired OM %",
        min = 0,
        max = 30,
        value = input$om2,
        step = 0.1,
        width = "100px"
      ),
      numericInput(
        "accum_rate",
        label = "Site-specific OM accumulation rate (g/kg/year)",
        min = 0,
        max = 100,
        value = rate,
        step = 1,
        width = "120px"
      ),
    )
  })
  
  ## sand req, adjusted by days
  output$text2 <-
    renderText({
      sand_mm <-
        sand_req(
          input$om_now_input,
          input$om_want,
          input$depth_sand,
          input$accum_rate,
          input$date[2],
          input$future_date
        )
      paste(
        "Adding ",
        tags$strong(round(sand_mm, digits = 2),
                    "mm of sand "),
        "to the ",
        input$depth_sand,
        " cm depth by ",
        input$future_date,
        " will result in a total organic matter content of ",
        input$om_want,
        "%",
        " if the accumulation rate remains at ",
        input$accum_rate,
        " g/kg.",
        sep = ""
      )
      
    })
  
  observe({
    if (input$date[1] >= input$date[2])
      showModal(
        modalDialog(
          title = "Please choose an end date that comes after the start date",
          "The accumulation rate can't be calculated backwards!",
          easyClose = TRUE,
          footer = NULL
        )
      )
  })
  
}
