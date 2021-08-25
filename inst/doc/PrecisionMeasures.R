## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(irrICC)
library(scales)

## -----------------------------------------------------------------------------
  icc1a.fn(iccdata1)
  ci.ICC1a(iccdata1)
  pval.ICC1a(iccdata1)
  pvals.ICC1a(iccdata1)

## -----------------------------------------------------------------------------
  ci.ICC1a(iccdata1,conflev = 0.90)

## -----------------------------------------------------------------------------
  pvals.ICC1a(iccdata1,rho.zero = c(0.15,0.25,0.45))

## -----------------------------------------------------------------------------
  icc1b.fn(iccdata1)
  ci.ICC1b(iccdata1)
  pval.ICC1b(iccdata1)
  pvals.ICC1b(iccdata1)

## -----------------------------------------------------------------------------
  ci.ICC1b(iccdata1,conflev = 0.90)

## -----------------------------------------------------------------------------
  pvals.ICC1b(iccdata1,gam.zero = c(0.15,0.25,0.45))

## -----------------------------------------------------------------------------
  icc2.inter.fn(iccdata1)
  ci.ICC2r.inter(iccdata1)
  ci.ICC2a.inter(iccdata1)
  pval.ICC2r.inter(iccdata1)
  pvals.ICC2r.inter(iccdata1)
  pvals.ICC2a.inter(iccdata1)

## -----------------------------------------------------------------------------
  pvals.ICC2r.inter(iccdata1,rho.zero = c(0.25,0.45))

## -----------------------------------------------------------------------------
  pvals.ICC2a.inter(iccdata1,gam.zero = c(0.25,0.45))

## -----------------------------------------------------------------------------
  icc2.nointer.fn(iccdata1)
  ci.ICC2r.nointer(iccdata1)
  ci.ICC2a.nointer(iccdata1)
  pvals.ICC2r.nointer(iccdata1)
  pvals.ICC2a.nointer(iccdata1)

## -----------------------------------------------------------------------------
  icc3.inter.fn(iccdata1)
  ci.ICC3r.inter(iccdata1)
  ci.ICC3a.inter(iccdata1)
  pvals.ICC3r.inter(iccdata1)
  pvals.ICC3a.inter(iccdata1)

## -----------------------------------------------------------------------------
  icc3.nointer.fn(iccdata1)
  ci.ICC3r.nointer(iccdata1)
  pvals.ICC3r.nointer(iccdata1)

