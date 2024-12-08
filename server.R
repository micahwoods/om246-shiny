
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
          input$date[2],
          input$future_date
        )
      paste(
        "Adding ",
        tags$strong(round(sand_mm, digits = 1),
                    "mm of sand "),
        "to the ",
        input$depth_sand,
        " cm depth by ",
        input$future_date,
        " will result in a total organic matter content of ",
        input$om_want,
        "%",
        " if the accumulation rate remains at ",
        round(input$accum_rate, digits = 2),
        " g/kg/year.",
        sep = ""
      )
      
    })
  

  ## choose the unit of sand quantity
  output$unit<- renderUI({
    selectInput(
      "unit",
      label = "Select unit for sand quantity:",
      choices = c("millimeters (mm)" = "mm",
                  "kilograms per hectare (kg/ha)" = "kg",
                  "pounds per 1000 ft² (lbs/1000 ft²)" = "lbs",
                  "cubic feet per 1000 ft² (ft³/1000 ft²)" = "ft"),
      selected = "mm" 
    )
  })
  
  ## enter the sand amount and adjust precision based on units
  output$sand_to_convert <- renderUI({
    req(input$unit)
    
    selected_unit <- input$unit
    step <- 0.1  
    default_value <- 1  
    
    if (selected_unit == "mm") {
      step <- 0.1
      value <- if (is.null(input$sand_to_convert)) default_value else round(as.numeric(input$sand_to_convert), 1)
    } else if (selected_unit %in% c("kg", "lbs")) {
      step <- 1
      value <- if (is.null(input$sand_to_convert)) default_value else round(as.numeric(input$sand_to_convert))
    } else if (selected_unit == "ft") {
      step <- 0.1
      value <- if (is.null(input$sand_to_convert)) default_value else round(as.numeric(input$sand_to_convert), 1)
    }
    
    # Simplified label without redundancy
    numericInput("sand_to_convert", 
                 label = "Enter sand quantity:", 
                 value = value, 
                 step = step)
  })
  
   # conversion table
  output$convert_table <- renderTable({
    req(input$sand_to_convert)
    
    value <- as.numeric(input$sand_to_convert)
    unit <- input$unit
    
    # conversion equations
    conversions <- switch(
      unit,
      "mm" = c("mm" = value, 
               "kg" = value * 15600, 
               "lbs" = value * 319.2159, 
               "ft" = value * 3.280733),
      "kg" = c("mm" = value / 15600, 
               "kg" = value, 
               "lbs" = value * (1/.454) / 107.639, 
               "ft" = value / 15600 * 3.280733),
      "lbs" = c("mm" = value / 319.2159, 
                "kg" = value / 319.2159 * 15600, 
                "lbs" = value, 
                "ft" = value / 319.2159 * 3.280733),
      "ft" = c("mm" = value / 3.280733, 
               "kg" = value / 3.280733 * 15600, 
               "lbs" = value / 3.280733 * 319.2159, 
               "ft" = value)
    )
    
    # Apply formatting to each unit
    formatted_conversions <- c(
      "mm" = sprintf("%.1f", conversions["mm"]),  # One decimal place
      "kg" = round(conversions["kg"]),      # Integer
      "lbs" = round(conversions["lbs"]),  # Integer
      "ft" = sprintf("%.1f", conversions["ft"])  # One decimal place
    )
    
    # Create a dataframe for display
    data.frame(
      Unit = c("mm", "kg/ha", "lbs/1000 ft²", "ft³/1000 ft²"),
      Value = formatted_conversions,
      stringsAsFactors = FALSE
    )
  }, sanitize.text.function = identity)

}
