# Functions used for the OM246 and sand topdressing calculation

## returns bulk_density given OM
bulk_density <- function(om) {
  bd <- 100 / ((om / .22) + ((100 - om) / 1.56))
  return(bd)
}

## sand effect given om1, om2, depth, and sand added
accum_rate <- function(sand, depth, om1, om2) {
  
  start_mass <- 100^2 * depth * bulk_density(om1) 
  start_om_g <- (om1 * 10) * (start_mass / 1000)
  fraction_remaining <- ((depth * 10) - sand) / (depth * 10)
  end_om_g <- fraction_remaining * start_om_g
  
  ## if system were steady state, the addition of x amount of sand would leave mass at this
  end_mass <- fraction_remaining * start_mass + (sand * 1.56 * 1000)
  end_om_gkg <- (end_om_g / end_mass) * 1000
  
  ## this is the crucial value: the expected change in OM for a certain amount of sand 
  delta_om <- (om1 * 10) - end_om_gkg
  
  accum_rate <- om2 * 10 - om1 * 10 + delta_om
  return(accum_rate)
}

## function for topdressing amount

sand_req <- function(om_now, om_goal, depth, om_rate) {
  
  om_mass_nothing <- (om_now * 10 + om_rate)
  mass_nothing <- 100^2 * depth * bulk_density(om_mass_nothing / 10)
  om_mass_max <- om_mass_nothing / 1000 * mass_nothing
  
  for (i in 1:100) {
    ##  i <- 1
    om_step <- (om_mass_max * (1 - i/100)) /
      (mass_nothing * (1 - i/100) +
         (100^2 * depth * (i / 100) * 1.56)) * 100 
    if (om_step <= om_goal) break
  }
  sand_mm <- ((depth * 10) / 100) * i   # adjust this by depth
  
  ifelse(i == 1, sand_mm <- 0, sand_mm <- sand_mm)
  return(sand_mm)    
}

server <- function(input, output, session) {
 
  ## om accumulation rate
  output$text1 <- renderText({ 
    
    years <- as.numeric((input$date[2] - input$date[1]) / 365)
    rate <- accum_rate(input$topdressing, input$depth, input$om1, input$om2) / years
    
    paste("If you apply ", input$topdressing, " mm of sand
          to a ", input$depth, " cm layer of the rootzone with a starting OM of ", input$om1, 
          "% on ", as.Date(input$date[1]), " and ending OM of ", input$om2, "% on ", 
          as.Date(input$date[2]), ", the accumulation rate of total organic material is ",
          round(rate, 1), " grams OM per kg of soil per year.", sep = "")
         
  })
  
  output$rate <- renderUI({
    years <- as.numeric((input$date[2] - input$date[1]) / 365)
    rate <- round(accum_rate(input$topdressing, input$depth, input$om1, input$om2) / years, digits = 1)
    
    tagList(
      numericInput(
        "depth_sand",
        "Depth of soil layer (cm)",
        min = 1,
        max = 20,
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
  output$text2 <- renderText({
    
    years_from_now <- as.numeric(input$future_date - today()) / 365
    
    sand_mm <- sand_req(input$om_now_input, input$om_want, input$depth_sand, 
                        input$accum_rate / years_from_now)
    
    round(sand_mm, digits = 2)
  })
  
}

