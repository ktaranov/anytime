\name{NEWS}
\title{News for Package \pkg{anytime}}
\newcommand{\ghpr}{\href{https://github.com/eddelbuettel/anytime/pull/#1}{##1}}
\newcommand{\ghit}{\href{https://github.com/eddelbuettel/anytime/issues/#1}{##1}}

\section{Changes in anytime version 0.3.1 (2018-07-03)}{
  \itemize{
    \item Numeric input is now preserved rather than silently cast to
    the return object type (\ghpr{69} fixing \ghit{68}).
    \item New assertion function \code{assertDate()} and \code{assertTime()}.
    \item Unit tests were expanded for the new functions, for conversion
    from integer as well as for \code{yyyymmdd()}.
  }
}

\section{Changes in anytime version 0.3.0 (2017-06-05)}{
  \itemize{
    \item Numeric input is now always an offset to epoch, with
    \code{anytime()} using seconds, and \code{anydate()} using dates.
    (\ghpr{65} fixing \ghit{63}).
    \item Old behaviour can be re-enabled with an option also supporting
    a global setting \code{getOption("anytimeOldHeuristic")}
    \item RStudio versions 1.1.129 or later can run all functions
    without fear of crashing due to a change in their use of Boost.
    \item Replaced \code{init.c} with registration code inside of
    \code{RcppExports.cpp} thanks to Rcpp 0.12.11.
  }
}

\section{Changes in anytime version 0.2.2 (2017-03-21)}{
  \itemize{
    \item Address corner case of integer-typed (large) values
    corresponding to \code{POSIXct} time (PR \ghpr{57} closing \ghit{#56})
    \item Add special case for \sQuote{Europe/London} and 31 Oct 1971
    BST change to avoid a one-hour offset error (\ghpr{58} fixing
    \ghit{36} and \ghit{51})
    \item Address another corner case of numeric values corresponding to
    \code{Date} types which are now returned as \code{Date}
    \item Added file \code{init.c} with calls to \code{R_registerRoutines()}
    \code{and R_useDynamicSymbols()}; already used \code{.registration=TRUE}
    in \code{useDynLib} in \code{NAMESPACE}
  }
}

\section{Changes in anytime version 0.2.1 (2017-02-09)}{
  \itemize{
    \item The new \code{DatetimeVector} class from \CRANpkg{Rcpp} is now
    used, and proper versioned Depends: have been added (PR \ghpr{43})
    \item The \code{anydate} and \code{utcdate} functions convert again
    from factor and ordered (PR \ghpr{46} closing \ghit{44})
    \item A format similar to RFC 28122 but with additonal timezone text
    can now be parsed (PR \ghpr{48} closing \ghit{47})
    \item Conversion from \code{POSIXt} to \code{Date} now also respect
    the timezone (PR \ghpr{50} closing \ghit{49})
    \item The internal \code{.onLoad} functions was updated
    \item The Travis setup uses https to fetch the run script
  }
}

\section{Changes in anytime version 0.2.0 (2016-12-24)}{
  \itemize{
    \item Added (exported) helper functions iso8601(), rfc2822() and
    rfc3339() to format date(time) objects according to standards
    \item Conversion to dates is now more robust thanks to improved
    internal processing (PR \ghpr{39} closing \ghit{36})
    \item The ISO 8601 format is now recognised, however the timezone
    information is not parsed by Boost Date_Time (which is a known
    upstream limitation) (PR \ghpr{38} closing \ghit{37})
    \item The 'allFormats.R' test script was significantly strengthened
    (\ghpr{40})
    \item Test scripts like 'simpleTests.R' have as also been
    strengthened (\ghpr{41}); on Windows and in one file two tests need
    to be skipped.
    \item A new 'bulkTest.R' test script was added testing parsing
    against what R returns
  }
}

\section{Changes in anytime version 0.1.2 (2016-12-13)}{
  \itemize{
    \item The (internal) string processing and splitting now uses Boost
    algorithm functions which avoids a (bizarre) bug on
    Windows. (\ghit{33})
    \item Test coverage was increased.

  }
}

\section{Changes in anytime version 0.1.1 (2016-11-27)}{
  \itemize{
    \item Both \code{anydate()} and \code{utcdate()} no longer attempt
    to convert an input value that is already of type \code{Date}.
    \item The string splitter (needed for the 'all-digits' formats
    extending Boost Date_time) is now more defensive about the input
    argument and more robust. Thanks to Bob Jansen for the heads-up
    (PR \ghpr{30} closing issue \ghit{29}).
    \item Code coverage reporting has been added (PR \ghpr{31}).
  }
}

\section{Changes in anytime version 0.1.0 (2016-11-06)}{
  \itemize{
    \item New functions \code{utctime()} and \code{utcdate()} were
    added to parse input as coordinated universal time; the
    functionality is also available in \code{anytime()} and
    \code{anydate()} via a new argument \code{asUTC} (PR \ghpr{22})
    \item New (date)time format for RFC822-alike dates, and expanded
    existing datetime formats to all support fractional seconds (PR
    \ghpr{21})
    \item Extended functionality to support not only \sQuote{YYYYMMDD}
    (without a separator, and not covered by Boost) but also with
    \sQuote{HHMM}, \sQuote{HHMMSS} and \sQuote{HHMMSS.ffffff} (PR
    \ghpr{30} fixing issue \ghit{29})
    \item Extended functionality to support \sQuote{HHMMSS[.ffffff]}
    following other date formats.
    \item Documentation and tests have been expanded; typos corrected
    \item New (unexported) helper functions \code{setTZ},
    \code{testOutput}, \code{setDebug}
    \item The \code{testFormat} (and \code{testOutput}) functions cannot
    be called under RStudio (PR \ghpr{27} fixing issue \ghit{25}).
    \item More robust support for non-finite values such as \code{NA},
    \code{NaN} or \code{Inf} (Fixing issue \ghit{16})
  }
}

\section{Changes in anytime version 0.0.4 (2016-10-20)}{
  \itemize{
    \item Before converting via \code{lexical_cast}, assign to atomic
    type via template logic to avoid an UBSAN issue (PR \ghpr{15}
    closing issue \ghit{14})
    \item More robust initialization and timezone information gathering.
    \item More robust processing of non-finite input also coping with
    non-finite values such as \code{NA}, \code{NaN} and \code{Inf} which
    all return \code{NA}
    \item Allow numeric \code{POSIXt} representation on input, also
    creating proper \code{POSIXct} (or, if requested, \code{Date})
  }
}

\section{Changes in anytime version 0.0.3 (2016-10-13)}{
  \itemize{
    \item Added (non-exported) helper function \code{testFormat()}
    \item Do not access \code{tm_isdst} on Windows for dates before the epoch
    (pull request \ghpr{13} fixing issue \ghit{12}); added test as well
  }
}

\section{Changes in anytime version 0.0.2 (2016-09-15)}{
  \itemize{
    \item Refactored to use a simple class wrapped around two vector
    with (string) formats and locales; this allow for adding formats;
    also adds accessor for formats (\ghpr{4}, closes \ghit{1} and
    \ghit{3}).
    \item New function \code{addFormats()} and \code{getFormats()}.
    \item Relaxed one tests which showed problems on some platforms.
    \item Added \code{as.POSIXlt()} step to \code{anydate()} ensuring
    all \code{POSIXlt} components are set (\ghpr{6} fixing \ghit{5}).
  }
}

\section{Changes in anytime version 0.0.1 (2016-09-12)}{
  \itemize{
    \item Initial release with \code{anytime()} and \code{anydate}
  }
}
