# Generic Lisp Development Image #

This Docker image is meant to be used for development of Lisp applications in a
uniform environment. The goal of this image is to gather all the major open
source Lisp implementations into one place.

The image tagged as `base` containss nothing beyond the Lisp
implementations. The image tagged as `ql` and `latest` contain Quicklisp and
enough external libraries to compile most libraries from Quicklisp. Please
submit a pull request if you find any package in Quicklisp that can't be
compiled.

Currently, the following Lisps are supported:

+ SBCL
+ CCL
+ ECL
+ ABCL
