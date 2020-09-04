#' Length Frequency Graph w/Summary Stats
#'
#'This makes a length-frequency graph for any particular species, with a summary data table placed below the graph. It works off of a previously made dataset with columns for Scientificname", "Commonname", "sl" (Standard Length), "COUNT", and "Gear"
#' @param len_dat dataframe of FWC length frequency data. Has columns "Scientificname", "Commonname", "sl" (Standard Length), "COUNT", and "Gear"
#' @param species a string representing the species you want to plot
#' @import dplyr
#' @import ggplot2
#' @importFrom tidyr uncount
#' @importFrom gridExtra tableGrob
#' @import patchwork
#' @return a length frequency histogram plot and a summary table
#' @examples
#' data(example_len_dat)
#' Make_LF_Plot(len_dat= example_len_dat, species = "Lutjanus griseus")
#' @export

Make_LF_Plot <- function(len_dat, species) {
  len_dat_expanded<- len_dat %>% uncount(COUNT)
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
