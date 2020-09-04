#' Removes outliers from data
#'
#' Removes outliers from a vector of data based on a minimum and maximum threshold
#' @param data vector of data
#' @param min_val mimimun value allowed in dataset
#' @param max_val maximum value allowed in dataset
#' @importFrom dplyr filter
#' @importFrom dplyr "%>%"
#' @export

remove_outliers<- function(data, min_val, max_val){
  result<- as.data.frame(data)
  names(result)<- "V1"
  result<- result %>% filter(V1 >= min_val & V1 <= max_val) %>% as.vector()
  return(result)
}
