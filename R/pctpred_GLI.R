#' Convert spirometric values to \% predicted using GLI-2012 equations
#'
#' This function takes absolute spirometry measurements (FEV1, FVC, etc)
#' in lt plus demographic data (age, height, gender and ethnicity) and converts
#' them to percent (\%) predicted based on the GLI-2012 equations.
#'
#' @param age Age in years
#' @param height Height in meters
#' @param gender Gender (1 = male, 2 = female) or a factor with two levels (first = male). Default is 1.
#' @param ethnicity Ethnicity (1 = Caucasian, 2 = African-American, 3 = NE Asian, 4 = SE Asian,
#' 5 = Other/mixed). Default is 1.
#' @param FEV1 Forced Expiratory Volume in 1 second (lt)
#' @param FVC Forced Vital Capacity (lt)
#' @param FEV1FVC FEV1 / FVC ratio
#' @param FEF2575 Forced Expiratory Flow between 25\% and 75\% of FVC (lt/s)
#' @param FEF75 Forced Expiratory Flow at 75\% of FVC (lt/s)
#' @param FEV075 Forced Expiratory Volume in 0.75 sec (lt)
#' @param FEV075FVC FEV0.75 / FVC ratio 
#'
#' @details At least one of the spirometric measurement arguments must be set (i.e. be
#' non-\code{NULL}). Arguments \code{age}, \code{height}, \code{gender} and
#' \code{ethnicity} must be vectors of length equal to the length of the
#' spirometric measurement vector(s), or of length one, in which case their
#' value is recycled. If any input vector is not of equal length, the function
#' stops with an error.
#'
#' @return If only one spirometry argument is supplied, the function
#' returns a numeric vector. If more are supplied, the function returns 
#' a data.frame with the same number of columns.
#'
#' @examples
#' # Random data, 4 patients, one parameter supplied (FEV1)
#' pctpred_GLI(age=seq(25,40,5), height=c(1.8, 1.9, 1.75, 1.85),
#'       gender=c(2,1,2,1), FEV1=c(3.5, 4, 3.6, 3.9))
#'
#' @importFrom stats reshape
#' 
#' @export
pctpred_GLI <- function(age, height, gender=1, ethnicity=1,
        FEV1=NULL, FVC=NULL, FEV1FVC=NULL, FEF2575=NULL,
        FEF75=NULL, FEV075=NULL, FEV075FVC=NULL) {
  spiro_val <- list(FEV1=FEV1, FVC=FVC, FEV1FVC=FEV1FVC, FEF2575=FEF2575,
              FEF75=FEF75, FEV075=FEV075, FEV075FVC=FEV075FVC)
  spiro_val <- spiro_val[!sapply(spiro_val, is.null)]
  spiro_val_len <- unique(sapply(spiro_val, length))
  somat_val <- rspiro_check_somat(age, height, gender, ethnicity)
  rspiro_check_input(spiro_val, somat_val)
  
  param <- names(spiro_val)
  dat <- with(somat_val, getLMS(age, height, gender, ethnicity, param))
  if (nrow(dat)==1 && spiro_val_len>1) {
    dat <- dat[rep(1,spiro_val_len),]
    rownames(dat) <- NULL
    dat$id <- 1:nrow(dat)
  }
  
  val <- as.data.frame.matrix(do.call(cbind, spiro_val))
  val$id <- 1:nrow(val)
  val <- reshape(val, direction="long", varying=param, times=param, timevar="f", v.names="obs")
  dat <- merge(dat, val)

  dat$pctpred <- with(dat, obs/M*100)

  datw <- reshape(dat[,c("id","f", "age","height","ethnicity","gender","pctpred")],
                  v.names="pctpred", idvar="id", direction="wide", timevar="f")
  rownames(datw) <- NULL
  datw <- datw[order(datw$id),]

  datw[,paste("pctpred", unique(param), sep=".")]
}


