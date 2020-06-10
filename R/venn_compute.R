# require(VennDiagram)

#' Read list of elements from files in lists.
#'
#' @param list_paths A list of strings representing paths of files.
#' @param list_names A list of strings as names of sets.
#' @return A list of list of character elements from files in \code{list_paths}.
#'  Each list contains the elementos of the files.
#' @examples \dontrun{
#' read.lists_from_files(c('genes_1.txt', '/home/user/Documents/bio/genes_2.txt'), c("g1", "g2"))
#' read.lists_from_files(c('genes_1.txt', 'D:\\bio\\genes_2.txt', 'genes_3.txt'), c("g1", "g2", "g3"))
#' }
#' @export
read.lists_from_files <- function(list_paths, list_names){
  all_sets <- list()
  for (path_file in list_paths){
    fid <- file(path_file, "r")
    all_sets <- c(all_sets, list(readLines(fid, warn = FALSE)))
    close(fid)
  }
  
  names(all_sets) <- list_names
  all_sets
}

venn_compute.join_name <- function(name1, name2){
  paste(name1, name2, sep="_")
}

#' Compute specific elements of intersections in Venn diagram from sets
#' specified in list of lists of characters as returned by
#' \code{read.lists_from_files}.
#' 
#' @param named_sets A named list of character elements to include in Venn
#'  diagram.
#' @param output_dir A string represent output directory to write files.
#' @param inmem A boolean to indicate writing in files (FALSE) or
#'  in memory (TRUE as default).
#' @return A named list of specific elements in Venn diagram.
#' @examples
#' a <- list(c("1", "2", "3"), c("1", "5"), c("1", "5", "7"))
#' names(a) <- c("a", "b", "c")
#' venn.compute_specific(a)
#' \dontrun{
#' venn.compute_specific(a, FALSE, "/home/user/Pictures")
#' }
#' @importFrom utils combn
#' @export
venn.compute_specific <- function(named_sets, inmem=TRUE, output_dir=NULL){
  n_els <- length(named_sets)
  els <- n_els
  set_names <- names(named_sets)
  u_set <- list()
  if (inmem){
    specifics <- list()
    specifics_name <- list() 
  }
  
  while (els > 0){
    intersect_names <- utils::combn(set_names, els)
    combo <- utils::combn(named_sets, els)
    n_combo <- choose(n_els, els)
    for (c_combo in 1:n_combo){
      name_file <- Reduce(venn_compute.join_name, intersect_names[, c_combo])
      specific <- setdiff(Reduce(intersect, combo[, c_combo]), u_set)
      u_set <- union(u_set, specific)
      if (!inmem){
        fid <- file(file.path(output_dir, paste(name_file, ".txt", sep="")))
        writeLines(specific, con = fid)
        close(fid)               
      } else {
        specifics <- c(specifics, list(specific))
        specifics_name <- c(specifics_name, name_file)
      }
    }
    els <- els - 1
  }
  if (inmem){
    names(specifics) <- specifics_name
    specifics
  }
}

#' Compute specific elements of Venn diagram and plot.
#' 
#' This function ever write in files the intersection elements using convention
#' of \code{namedlist1_namedlist2_namedlist3.txt} and png image with the same
#' convention for full list of sets,
#' \code{namedlist1_namedlist2_namedlist3.png}.
#' 
#' @param named_sets A named list of character elements to include in Venn
#'  diagram.
#' @param output_dir A string represent output directory to write files.
#' @examples
#' \dontrun{
#' a <- list(c("1", "2", "3"), c("1", "5"), c("1", "5", "7"))
#' names(a) <- c("a", "b", "c")
#' venn.compute_plot(a, "/home/user/Pictures")
#' b <- read.lists_from_files(c('genes_1.txt', 'genes_2.txt', 'genes_3.txt'), c("g1", "g2", "g3"))
#' venn.compute_plot(b, "pictures")
#' }
#' @export
venn.compute_plot <- function(named_sets, output_dir){
  venn.compute_specific(named_sets, FALSE, output_dir)
  VennDiagram::venn.diagram(x=named_sets,
               category.names = names(named_sets),
               filename = file.path(output_dir,
                                    paste(Reduce(venn_compute.join_name, names(named_sets)), ".png", sep="")),
               imagetype="png"
              )
}
