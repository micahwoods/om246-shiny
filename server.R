
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
      tags$strong(round(rate, 2), " grams per kg of soil per year"),
      sep = ""
    )
  })
  
  # UI for the topdressing tab depends on input from the accumulation tab
  output$rate <- renderUI({
    years <- as.numeric((input$date[2] - input$date[1]) / 365)
    rate <-
      round(
        accum_rate(input$topdressing, input$depth, input$om1, input$om2) / years,
        digits = 20
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
        min = 0.1,
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
        value = round(rate, 2),
        step = 0.01,
        width = "120px"
      ),
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
  
  ## sand req, adjusted by days
  output$text2 <-
    renderText({
      sand_mm <-
        sand_req(
          input$om_now_input,
          input$om_want,
          input$depth_sand,
          input$accum_rate,
          input$future_date[1],
          input$future_date[2]
        )
      
      # Display the result or the message
      if (is.character(sand_mm)) {
        return(sand_mm)  # Error message
      } else {
        return( 
          paste(
          "Adding ",
          tags$strong(round(sand_mm, digits = 1),
                      "mm of sand "),
          "to the ",
          input$depth_sand,
          " cm depth by ",
          input$future_date[2],
          " will result in a total organic matter content of ",
          input$om_want,
          "%",
          " if the accumulation rate remains at ",
          round(input$accum_rate, digits = 2),
          " g/kg/year.",
          sep = ""
        )
        )
      }
    })
  

  ## update step size when unit changes, without rebuilding the input widget
  observeEvent(input$unit, {
    step <- switch(input$unit,
      "mm"   = 0.1,
      "kg"   = 1,
      "t"    = 0.1,
      "lbs"  = 1,
      "ft"   = 0.1,
      "tons" = 0.1
    )
    updateNumericInput(session, "sand_to_convert", step = step)
  })

  # conversion table: convert input to mm first, then to all units
  output$convert_table <- renderTable({
    req(input$sand_to_convert, input$unit)

    value <- as.numeric(input$sand_to_convert)
    mm <- switch(input$unit,
      "mm"   = value,
      "kg"   = value / 15600,
      "t"    = value / 15.6,
      "lbs"  = value / 319.2159,
      "ft"   = value / 3.280733,
      "tons" = value / (319.2159 * 43.56 / 2000)
    )

    data.frame(
      Unit = c("mm",
               "kg/ha",
               "t/ha (metric tons)",
               "lbs/1000 ft\u00b2",
               "ft\u00b3/1000 ft\u00b2",
               "short tons/acre (US tons)"),
      Value = c(
        sprintf("%.1f",  mm),
        as.character(round(mm * 15600)),
        sprintf("%.1f",  mm * 15.6),
        as.character(round(mm * 319.2159)),
        sprintf("%.1f",  mm * 3.280733),
        sprintf("%.2f",  mm * 319.2159 * 43.56 / 2000)
      ),
      stringsAsFactors = FALSE
    )
  }, sanitize.text.function = identity)

}

