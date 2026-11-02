===============================================================================
README.txt for plausexog code version 2.1.0

yyyy-mm-dd: 2014-08-16 [v 1.0.0]
yyyy-mm-dd: 2017-06-18 [v 2.1.0]
contact: damian.clarke@usach.cl
===============================================================================

This folder contains the ado plausexog.ado and the help file plausexog.hlp whi-
ch run Conley et al's (2012) Plausibly Exogenous inference routines in Stata.  
The heart of this code comes from Hansen's original code, however this has been
augmented to include additional error capture, functionality with missing data
and factor variables/wildcards, automated graphing, and additional documentati-
on.

Version 2.0.0 has added the feature to use any distribution for the LTZ approch
instead of assuming a Gaussian prior as described by Conley et al. This requir-
es the user written ado mvtnorm for simulating multivariate normal draws.

An updated version of plausexog now exists (3.0.0 onwards) which has simplified
syntax (only for the LTZ option).  Functionality and exported results are the 
same.  However, to ensure backwards compatability exists for any code using pri-
or versions of plausexog, this version will permanently be available which works
with the original syntax.
