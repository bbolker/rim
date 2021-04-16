rmaxima - an interface to maxima for R
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

Development version of the yet-to-be-released rmaxima CRAN package.
rmaxima provides an interface to the powerful and fairly complete maxima
computer algebra system

This repository is a fork from the original version created by Kseniia
Shumelchyk and Hans W. Borcher
[shumelchyk/rmaxima](https://github.com/shumelchyk/rmaxima), which is
currently not maintained.

# Installation

## Requirements

-   this package currently only works under Linux (and has not been
    tested under MacOS)
-   you can install it without having Maxima installed, but obviously
    need to install Maxima in order to use it.

## Steps

If you want to install the latest version (currently the only one
available) install the R package `drat` first and add this github
account as a repo:

``` r
install.packages("drat")
drat::addRepo("rcst")
```

Now you can easily install it the usual way:

``` r
install.packages("rmaxima")
```
