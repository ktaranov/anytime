
## anytime: Use Boost Date_Time to convert date(time) data to POSIXt
##
## Copyright (C) 2015 - 2017  Dirk Eddelbuettel
##
## This file is part of anytime.
##
## anytime is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 2 of the License, or
## (at your option) any later version.
##
## anytime is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with anytime.  If not, see <http://www.gnu.org/licenses/>.

##' These function use the Boost Date_Time library to parse
##' datetimes (and dates) from strings, integers, factors or even numeric values
##' (which are cast to strings internally). They return a vector of
##' \code{POSIXct} objects (or \code{Date} objects in the case of \code{anydate}).
##' \code{POSIXct} objects represent dates and time as (possibly
##' fractional) seconds since the \sQuote{epoch} of January 1, 1970.
##' A timezone can be set, if none is supplied \sQuote{UTC} is set.
##'
##' A number of fixed formats are tried in succession. These include
##' the standard ISO format \sQuote{YYYY-MM-DD HH:MM:SS} as well as
##' different local variants including several forms popular in the
##' United States.  Two-digits years and clearly ambigous formats such
##' as \sQuote{03/04/05} are ignored.  In the case of parsing failure
##' a \code{NA} value is returned.
##'
##' Fractional seconds are supported as well.  As R itself only supports
##' microseconds, the Boost compile-time option for nano-second resolution
##' has not been enabled.
##'
##' @section Notes:
##' By default, the (internal) conversion to (fractional) seconds since the epoch is
##' relative to the locatime of this system, and therefore not completely
##' independent of the settings of the local system. This is to strike a
##' balance between ease of use and functionality.  A more-full featured
##' conversion could be possibly be added with support for arbitrary
##' reference times, but this is (at least) currently outside the scope of
##' this package. See the \pkg{RcppCCTZ} package which offers some
##' timezone-shifting and differencing functionality. As of version 0.0.5 one
##' can also parse relative to UTC avoiding the localtime issue,
##'
##' Times and timezones can be tricky. This package offers a heuristic approach,
##' it is likely that some input formats may not be parsed, or worse, be parsed
##' incorrectly. This is not quite a \href{https://xkcd.com/327/}{Bobby Tables}
##' situation but care must always be taken with user-supplied input.
##'
##' The Boost Date_Time library cannot parse single digit months or
##' days. So while \sQuote{2016/09/02} works (as expected),
##' \sQuote{2016/9/2} will not. Other non-standard formats may also
##' fail.
##'
##' There is a known issue (discussed at length in
##' \href{https://github.com/eddelbuettel/anytime/issues/5}{issue
##' ticket 5}) where Australian times are off by an hour. This seems
##' to affect only Windows, not Linux.
##'
##' When given a vector, R will coerce it to the type of the first
##' element. Should that be \code{NA}, surprising things can
##' happen: \code{c(NA, Sys.Date())} forces both values to
##' \code{numeric} and the date will not be parsed correctly (as its
##' integer value becomes numeric before our code sees it). On the
##' other hand, \code{c(Sys.Date(), NA)} works as expected parsing as
##' type Date with one missing value. See
##' \href{https://github.com/eddelbuettel/anytime/issues/11}{issue
##' ticket 11}) for more.
##'
##' @section Operating System Impact:
##' On Windows systems, accessing the \code{isdst} flag on dates or times
##' before January 1, 1970, can lead to a crash. Therefore, the lookup of this
##' value has been disabled for those dates and times, which could therefore be
##' off by an hour (the common value that needs to be corrected).
##' It should not affect dates, but may affect datetime objects.
##'
##' @section Old Heuristic:
##' Up until version 0.2.2, numeric input smaller than an internal cutoff value
##' was interpreted as a date, even if \code{anytime()} was called.  While
##' convenient, it is also inconsistent as we otherwise take numeric values to
##' be offsets to the epoch. Newer version are consistent: for \code{anydate}, a
##' value is taken as \emph{date offset} relative to the epoch (of January 1, 1970).
##' For \code{anytime}, it is taken as \emph{seconds offset}. So \code{anytime(60)}
##' is one minute past the epoch, and \code{anydate(60)} is sixty days past it.
##' The old behaviour can be enabled by setting the \code{oldHeuristic} argument to
##' \code{anytime} (and \code{utctime}) to \code{TRUE}.  Additionally, the default
##' value can be set via \code{getOption("anytimeOldHeuristic")} which can be set
##' to \code{TRUE} in startup file. Note that all other inputs such character,
##' factor or ordered are not affected.
##'
##' @title Parse POSIXct or Date objects from input data
##' @param x A vector of type character, integer or numeric with date(time)
##' expressions to be parsed and converted.
##' @param tz A string with the timezone, defaults to the result of the (internal)
##' \code{getTZ} function if unset. The \code{getTZ} function returns the timezone
##' values stored in local package environment, and set at package load time. Also
##' note that this argument applies to the \emph{output}: the returned object will
##' have this timezone set. The timezone is \emph{not} used for the parsing which
##' will always be to localtime, or to UTC is the \code{asUTC} variable is set (as
##' it is in the related functions \code{\link{utctime}} and \code{\link{utcdate}}).
##' So one can think of the argument as \sQuote{shift parsed time object to this
##' timezone}. This is similar to what \code{format()} in base R does, but our
##' return value is still a \code{POSIXt} object instead of a character value.
##' @param asUTC A logical value indicating if parsing should be to UTC; default
##' is false implying localtime.
##' @param useR A logical value indicating if conversion should be done via code
##' from R (via package \pkg{RApiDatetime}) or via the Boost routines.
##' @param oldHeuristic Behave versions up to and including 0.2.2 did and interpret
##' a numeric or integer value that could be seen as a YYYYMMDD as a date. If
##' the default value \code{FALSE} is seen, then date offset for used for dates,
##' and second offsets for datetimes. A default value can also be set via the
##' \code{anytimeOldHeuristic} option.
##' @return A vector of \code{POSIXct} elements, or, in the case of \code{anydate},
##' a vector of \code{Date} objects.
##' @seealso \code{\link{anytime-package}}
##' @references This StackOverflow answer provided the initial idea:
##' \url{http://stackoverflow.com/a/3787188/143305}.
##' @author Dirk Eddelbuettel
##' @examples
##' ## See the source code for a full list of formats, and the
##' ## or the reference in help('anytime-package') for details
##' times <- c("2004-03-21 12:45:33.123456",
##'           "2004/03/21 12:45:33.123456",
##'           "20040321 124533.123456",
##'           "03/21/2004 12:45:33.123456",
##'           "03-21-2004 12:45:33.123456",
##'           "2004-03-21",
##'           "20040321",
##'           "03/21/2004",
##'           "03-21-2004",
##'           "20010101")
##' anytime(times)
##' anydate(times)
##' utctime(times)
##' utcdate(times)
##'
##' ## show effect of tz argument
##' anytime("2001-02-03 04:05:06")
##' ## adjust parsed time to given TZ argument
##' anytime("2001-02-03 04:05:06", tz="America/Los_Angeles")
##' ## somewhat equvalent base R functionality
##' format(anytime("2001-02-03 04:05:06"), tz="America/Los_Angeles")
anytime <- function(x, tz=getTZ(), asUTC=FALSE, useR=FALSE,
                    oldHeuristic=getOption("anytimeOldHeuristic", FALSE)) {

    if (inherits(x, "POSIXt")) {
        return(as.POSIXct(x, tz=tz))
    }

    if (inherits(x, "Date")) {
        ## we format and reparse to get proper midnight in TZ treatment
        ## if we used as.Date() we would get midnight at UTC which is rarely desired
        ## x <- format(x)
        ## or not -- stick with what R does
        return(as.POSIXct(x))
    }

    if (inherits(x, "factor")) {
        x <- as.character(x)
    }

    anytime_cpp(x, tz=tz, asUTC=asUTC, useR=useR, oldHeuristic=oldHeuristic)
}

##' @rdname anytime
anydate <- function(x, tz=getTZ(), asUTC=FALSE, useR=FALSE) {
    ## input is Date, pass through
    if (inherits(x, "Date")) return(x)

    ## input is factor or order, convert
    if (inherits(x, "factor")) x <- as.character(x)

    ## otherwise call anytime_cpp
    d <- anytime_cpp(x=x, tz=tz, asUTC=asUTC, asDate=TRUE, useR=useR, oldHeuristic=TRUE)

    ## one code path could result in POSIXct, if so convert
    if (inherits(d, "POSIXt")) d <- as.Date(d, tz=tz)

    ## return result
    d
}

##' @rdname anytime
utctime <- function(x, tz=getTZ(), useR=FALSE,
                    oldHeuristic=getOption("anytimeOldHeuristic", FALSE)) {
    anytime(x=x, tz=tz, asUTC=TRUE, useR=useR, oldHeuristic=oldHeuristic)
}

##' @rdname anytime
utcdate <- function(x, tz=getTZ(), useR=FALSE) {
    ## input is Date, pass through
    if (inherits(x, "Date")) return(x)

    ## input is factor or order, convert
    if (inherits(x, "factor")) x <- as.character(x)

    ## otherwise call anytime_cpp
    d <- anytime_cpp(x=x, tz=tz, asUTC=TRUE, asDate=TRUE, useR=useR, oldHeuristic=TRUE)

    ## one code path could result in POSIXct, if so convert
    if (inherits(d, "POSIXt")) d <- as.Date(d, tz=tz)

    ## return result
    d
}

testFormat <- function(fmt, s, tz="") {
    if (isRStudio()) {				#nocov start
        warning("This function cannot run inside of older RStudio versions.")
        return(NA)
    }						#nocov end
    testFormat_impl(fmt, s, tz=tz)
}

testOutput <- function(fmt, s) {
    if (isRStudio()) {				#nocov start
        warning("This function cannot run inside of older RStudio versions.")
        return(NA)
    }						#nocov end
    testOutput_impl(fmt, s)
}
