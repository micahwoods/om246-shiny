## returns bulk_density given OM
bulk_density <- function(om) {
  bd <- 100 / ((om / .22) + ((100 - om) / 1.56))
  return(bd)
}

## sand effect given om1, om2, depth, and sand added
accum_rate <- function(sand, depth, om1, om2) {
  start_mass <- 100 ^ 2 * depth * bulk_density(om1)
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

## solves for sand req given user-specified inputs
sand_req <- function(om_now, 
                     om_goal, 
                     depth, 
                     om_rate,
                     now_date,
                     target_date) {
  
  years <- as.numeric(target_date - now_date) / 365
  
  if ((om_goal * 10 - om_rate) < om_now * 10) {
    sand_root <- function(sand) {
      start_mass <- 100 ^ 2 * depth * bulk_density(om_now)  
      start_om_g <- (om_now * 10) * (start_mass / 1000)     
      
      fraction_remaining <- ((depth * 10) - sand) / (depth * 10)
    
      end_mass <- fraction_remaining * start_mass + (sand * 1.56 * 1000)
      end_om_g <- fraction_remaining * start_om_g
      end_om_gkg <- (end_om_g / end_mass) * 1000 + (om_rate * years)      
      
     
      delta2 <- end_om_gkg - (om_goal * 10)
      return(delta2)  # Root is when delta2 = 0
    }
     # Solve for the amount of sand needed to make delta2 zero
    result <- tryCatch({
      uniroot(
      sand_root,
      lower = 0,                               
      upper = depth * 10,                      
      tol = 1e-6                               
    )
    }, warning = function(w) {
      return(NULL)
    }, error = function(e) {
      return(NULL)
    })
    
    if (is.null(result)) {
      return("This result is not possible with the given starting parameters.")
    } else {
      sand_mm <- result$root 
      return(sand_mm) 
    }
} else {
  return("This result is not possible with the given starting parameters.")
}
}

