#' Scores assigned by 3 raters to 4 subjects.
#'
#' This small dataset contains data from a reliability experiment where 3 raters scored 4 subjects on a continuous scale. All raters
#' rated each subject once.
#' @format This dataset has 4 rows (for the 4 subjects) and 4 columns. All 4 columns are mandatory when using the ICC functions of
#' this package. Rater3 only rated 2 of the 4 subjects (i.e. subjects 2 and 3), while each of the other raters rated all 4 subjects.
#' Therefore, some missing ratings in the form of "NA" appear in the column associated with the Rater3.
#'  \describe{
#'     \item{Subject}{This variable represents the target or subject number and may contain duplicate value to indicate multiple ratings assigned to the same subjects by the same judge}
#'     \item{Rater1}{All ratings from judge 1}
#'     \item{Rater2}{All ratings from judge 2}
#'     \item{Rater3}{All ratings from judge 3}
#'  }
#'
#' @source Gwet, K.L. (2014) \emph{Handbook of Inter-Rater Reliability}, 4th Edition. Advanced Analytics, LLC.
"iccdata3"
