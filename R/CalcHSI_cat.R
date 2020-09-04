#' Calculate Habitat Suitability Index Table for Gag grouper
#'
#'Calculates HSI for individual categorical environmental variables in the catch data set
#' @param dat Data frame of all catch (positive and zero). This data frame should include columns for Reference, Tot_Num_Gag, and categorical environmental variables (like bottom type)
#' @param EnvVariable Categorical environmental variable name (not in quotes)
#' @return returns a table of standardized S (suitability) values for each level of the variable
#' @import dplyr
#' @examples
#' data(example_HSI_dat)
#' BottomType_HSI <- CalcHSI_cat(dat = example_HSI_dat, EnvVariable = Bottom)
#' @export

CalcHSI_cat <- function(dat, EnvVariable) {

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
