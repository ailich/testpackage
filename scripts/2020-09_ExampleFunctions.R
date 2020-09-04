# M Schrandt
# September 2020 R Club Meeting
# Example functions

#### Length Frequency Graph w/Summary Stats ####
# This makes a length-frequency graph for any particular species, with a
#    summary data table placed below the graph
# It works off of a previously made dataset with columns for
#    species, Gear, and sl (standard length)
# Relies on the following packages: tidyverse, gridExtra, patchwork
Make_LF_Plot <- function(species) {
  Plot <- len_dat_expanded %>%
    filter(Scientificname == species) %>%
    ggplot() +
    geom_histogram(aes(x=sl), color = "black", fill = NA, binwidth = 10) +
    labs(x = "Standard length (mm)", y = "Frequency") +
    facet_wrap(~ Gear, ncol = 1) +
    theme_classic() +
    theme(panel.border = element_rect(color = "black", fill = NA)) +
    theme(strip.background = element_rect(fill = "gray90"))
  
  #get length summary data
  summary <- len_dat_expanded %>%
    filter(Scientificname == species) %>%
    group_by(Gear) %>%
    summarise(min_sl = min(sl),
              max_sl = max(sl),
              mean_sl = round(mean(sl), digits = 2),
              sd_sl = round(sd(sl), digits = 2),
              Num_lengths = n()) %>%
    ungroup()
  
  #add summary table below histogram
  Plot_final <- Plot / gridExtra::tableGrob(summary, rows = NULL) +
    plot_layout(heights = c(2,0.8)) +
    plot_annotation(title = paste(species), theme= theme(plot.title = element_text(face = "italic")))
  
  return(Plot_final)
}
# Example use:
# Make_LF_Plot(species = "Lutjanus griseus")



#### Calculate Habitat Suitability Index Table for Gag grouper ####
# Calculates HSI for individual categorical environmental variables
#    in the catch data set

#inputs needed = 
# 1. Data frame of all catch (positive and zero)
#    This data frame should include columns for Reference, Tot_Num_Gag, and categorical
#    environmental variables (like bottom type)
# 2. Categorical environmental variable name (not in quotes)

# returns a table of standardized S (suitability) values for each level of the variable
CalcHSI_cat <- function(DataInput, EnvVariable) {
  
  #if passing a column name, need to use enquo here
  EnvVariable <- enquo(EnvVariable)
  #print a message saying which environmental variable is being run
  print(paste0("Calculating HSI for ", as_label(EnvVariable)))
  
  # Need to calculate the number of references within each interval that caught gag
  dataprep <- dat %>%
    select(reference, Tot_Num_Gag, !! EnvVariable) %>%
    #get total number of references in the dataset
    mutate(Total_refs = n()) %>%
    group_by(!! EnvVariable, Total_refs) %>%
    #count number of references with gag and number of references in the interval/category
    summarise(RefsWGag = length(which(Tot_Num_Gag > 0)),
              RefsInInt = n())
  
  # Now we can calculate suitability
  # I did this in multiple steps so we can keep all the "parts" of the equation in the table
  S_Table <- dataprep %>%
    mutate(ResourceUse = RefsWGag / RefsInInt,
           ResourceAvail = RefsInInt / Total_refs,
           S = ResourceUse/ResourceAvail,) %>%
    mutate(Std_S = S / max(.$S))
  
  return(as.data.frame(S_Table)) 
  
}

# Example use:
# BottomType_HSI <- CalcHSI_cat(DataInput = dat, EnvVariable = BottomType)