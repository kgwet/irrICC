#' Dataset of quantitative ratings assigned by 4 judges to 5 targets/subjects,
#' which belongs to 2 groups A and B.
#'
#' This dataset contains quantitative ratings from a reliability experiment
#' where 4 judges named J1-J4 scored on a continuous scale, 5 subjects belonging
#' to 2 groups A and B. Each subject was rated 3 times by each judge.
#'
#' @format This dataset has 15 rows (3 rows for each of the 5 subjects) and 6
#' columns. All 5
#' columns are mandatory when using ICC functions from this package.
#'  \describe{
#'     \item{Group}{This column contains the group number}
#'     \item{Target}{This variable represents the target or subject number}
#'     \item{J1}{All ratings from judge 1}
#'     \item{J2}{All ratings from judge 2}
#'     \item{J3}{All ratings from judge 3}
#'     \item{J4}{All ratings from judge 4}
#'  }
#'
#' @source Gwet, K.L. (2021) \emph{Handbook of Inter-Rater Reliability:
#' Volume 1}, 5th Edition. AgreeStat Analytics.
"agree.icc"
