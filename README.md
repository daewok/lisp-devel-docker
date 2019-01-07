# Common Lisp Docker Images for Development #

Github: [https://github.com/daewok/lisp-devel-docker](https://github.com/daewok/lisp-devel-docker)

Docker Hub: [https://hub.docker.com/r/daewok/lisp-devel/](https://hub.docker.com/r/daewok/lisp-devel/)

See also: [slime-docker](https://github.com/daewok/slime-docker)

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

+ SBCL
+ CCL
+ ECL
+ ABCL

The entrypoint to the image is configured to automatically create and switch to
a user named `lisp` when executing commands. The UID of the Lisp user is
configured by the environment variable `LISP_DEVEL_UID`. It defaults to 0, but
most people will probably want to set this to 1000 (or whatever their UID on
their host machine is).

##### ASDF Integration #####

`/usr/local/share/common-lisp/slime/` is added to ASDF's source
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

Quicklisp is installed to the path `/home/lisp/quicklisp`.

This image behaves exactly the same as the base image, except that it loads
Quicklisp on start, so simply run:

    docker run --rm -it daewok/lisp-devel:latest sbcl

and start playing with Quicklisp!

### Notes and Gotchas ###

+ Lisp is more fun when you're using Emacs and Slime to interact with it! See
  [slime-docker](https://github.com/daewok/slime-docker)
  for information on a library that makes setting that up easy!

+ Please [open an issue](https://github.com/daewok/lisp-devel-docker/issues) if
  you find a package in Quicklisp that is missing a dependency in the `ql`
  image.

+ SBCL does its best to turn off Address Space Layout Randomization (ASLR) when
  it starts. However, Docker's default security profile (if seccomp is compiled
  in) prevents SBCL from doing this. If you are afraid this might be an issue (I
  haven't personally seen an issue yet, but it was presumably done for a reason)
  or you're just tired of seeing:

> WARNING:
>
> Couldn't re-execute SBCL with proper personality flags (/proc isn't mounted? setuid?)
>
> Trying to continue anyway.

  whenever you start SBCL, you can either use a more lax seccomp profile by
  adding `--security-opt=seccomp=/path/to/docker-sbcl-seccomp.json` to the run
  command (docker-sbcl-seccomp.json is found in the project's git repo). Or you
  can disable seccomp altogether (not recommended!) by adding
  `--security-opt=seccomp=unconfined`. I will make a good faith effort to keep
  `docker-sbcl-seccomp.json` up to date with Docker's defaults, but no
  guarantees are provided!
