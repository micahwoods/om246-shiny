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
## I adjust this to account for time, om_rate is g/kg/per year
sand_req <- function(om_now, om_goal, depth, om_rate, now_date, target_date) {
  
  # om rate set to be on a per day basis
  rate_daily <- om_rate / 365
  
  number_of_days <- as.numeric(target_date - now_date)
  
  ## om mass at end of time duration in g/kg if nothing done
  om_mass_nothing <- (om_now * 10 + 
                        (rate_daily * number_of_days))
  
  mass_nothing <- 100^2 * depth * bulk_density(om_mass_nothing / 10)
  om_mass_max <- om_mass_nothing / 1000 * mass_nothing
  
  for (i in 1:100) {
    om_step <- (om_mass_max * (1 - i/100)) /
      (mass_nothing * (1 - i/100) +
         (100^2 * depth * (i / 100) * 1.56)) * 100 
    if (om_step <= om_goal) break
  }
  sand_mm <- ((depth * 10) / 100) * i   # adjust this by depth
  
  ifelse(i == 1, sand_mm <- 0, sand_mm <- sand_mm)
  return(sand_mm)    
}
