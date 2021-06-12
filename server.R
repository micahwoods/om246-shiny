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
  
  ifelse(i == 1, sand_mm <-0, sand_mm <- sand_mm)
  return(sand_mm)    
}




server <- function(input, output, session) {
 
  output$text1 <- renderText({ 
    
    rate <- accum_rate(input$topdressing, input$depth, input$om1, input$om2)
    
    # fert requirement = Required - amount present
    # fert = guideline + plant harvest - soil test
    # note, added 1 g to fert requirement to be sure not to
    # underestimate due to rounding effects
    # plant harvest is annual N / kratio
    # convert all to g/m2 by the 6.7 factor based on 10 cm
    # deep rootzone with bulk density of 1.5
    
   
    
    paste("If you apply", input$topdressing, "mm of sand
          to a ", input$depth, " cm layer of the rootzone with a starting OM of ", input$om1, 
          "% and ending OM of", input$om2, "the accumulation rate of OM is",
          round(rate, 1), "grams OM per kg of soil.")
         
  })
  
  
}