# Common Lisp Docker Images for Development #

Homepage: [https://people.csail.mit.edu/etimmons/software/lisp-devel-docker.html](https://people.csail.mit.edu/etimmons/software/lisp-devel-docker.html)

Github: [https://github.com/daewok/lisp-devel-docker](https://github.com/daewok/lisp-devel-docker)

Docker Hub: [https://hub.docker.com/r/daewok/lisp-devel/](https://hub.docker.com/r/daewok/lisp-devel/)

See also: [slime-docker](https://people.csail.mit.edu/etimmons/software/slime-docker.html)

### About ###

Common Lisp is a great language, but it *can* be a bit of a pain to get started
with it, particularly if you are running Windows or OSX. And if you do get your
favorite implementation installed and working, you then have to deal with
installing foreign libraries to get your favorite packages from Quicklisp
working. This project attempts to make the whole setup process easier, letting
users get right into coding, by providing a series of
[Docker](https://www.docker.com/) images.

These images are sufficient for a newbie to get coding and also form a good
starting point for teams of Common Lisp developers that need to work in the
exact same environment.

These images are *not* meant for packaging Common Lisp code for deployment. They
are very heavy weight from their "batteries included" approach. Look for
extensible, lightweight deployment images to be developed in the near future.

### Images ###

There are three tags defined in this repository, `base`, `ql`, and
`latest`. `ql` and `latest` are the same image, built off `base`. There may be
more tags defined in the future for versioning (i.e., monthly versions when a
new Quicklisp release comes out).

#### Base Image ####

This image is based off Debian Jessie. It contains only the bare necessities
needed to run four Common Lisp implementations:

+ SCBL
+ CCL
+ ECL
+ ABCL

Additionally, a Linux user (and group) is created with UID 1000 and name
`lisp`. It is recommended that you use this user when running one of these
images.

##### ASDF Integration #####

ASDF user translations have been modified to not use the user's home
directory. This is primarily in case you decide to run the image as a user that
does not exist in the image (e.g., your UID on your machine is 1002 and you want
to make sure that mounted folders are writeable by the container user). Instead,
ASDF uses
`/var/cache/common-lisp/${ASDF_DOCKER_OUTPUT_SUBDIR}/${IMPLEMENTATION}/` for its
build cache. The implementation is auto detected, but the subdir can be
controlled by the user by specifying `ASDF_DOCKER_OUTPUT_SUBDIR` as an
environment variable when running the image.

Additionally, `/usr/local/share/common-lisp/slime/` is added to ASDF's source
registry, to allow for easy mounting of Slime/Swank

##### Usage #####

To get started experimenting with SBCL, you can run the following:

    docker run --rm -it daewok/lisp-devel:base sbcl

But, it's pretty common that you'll want to actually, you know, work on code
that isn't lost when the container goes down! To do that, simply mount your
folder containing your code like so:

    docker run --rm -it -v /path/to/local/code:/usr/local/share/common-lisp/source daewok/lisp-devel:base sbcl

Your code will even be discoverable by ASDF!

#### QL Image ####

OK, enough with the bare bones, how about an image you can do *something*
with. The `ql` and `latest` tags point to an image that has
[Quicklisp](https://www.quicklisp.org/) installed, along with the foreign
libraries necessary to compile every library currently in Quicklisp. As such, it
is much larger than the base image.

Quicklisp is installed to the path `/usr/local/share/common-lisp/quicklisp`
which is owned by `lisp:lisp`.

This image behaves exactly the same as the base image, except that it loads
Quicklisp on start, so simply run:

    docker run --rm -it daewok/lisp-devel:latest sbcl

and start playing with Quicklisp!

### Notes and Gotchas ###

+ Lisp is more fun when you're using Emacs and Slime to interact with it! See
  [slime-docker](https://people.csail.mit.edu/etimmons/software/slime-docker.html)
  for information on a library that makes setting that up easy!

+ Please [open an issue](https://github.com/daewok/lisp-devel-docker/issues) if
  you find a package in Quicklisp that is missing a dependency in the `ql`
  image.

+ If you do not use the `lisp` or `root` users when using the Quicklisp image,
  you will have issues with Quicklisp being loaded because other users do not
  have init files that load Quicklisp's `setup.lisp`. You will need to either
  Quicklisp explicitly or create a new user (the init files are placed in
  `/etc/skel` so new users will have them by default). Additionally, make sure
  the new user is in the `lisp` group (to access the Quicklisp folder).
