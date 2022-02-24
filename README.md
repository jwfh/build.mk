# build.mk

[`build.mk`](https://github.com/jwfh/build.mk) is a build system for non-trivial software projects. Its goal is to abstract language-specific cruft away from users so that they can focus on writing code rather than building it.

### Features (Design Goals)

- Language support (Java, Python, Terraform, C++, CMake, Docker, etc.)
- Dependency management (Python via `poetry`, C++ via `vcpkg` or the like, etc.)
- Artifact deployment (to Amazon S3, Amazon ECR, etc.)

## Installation

Add [`build.mk`](https://github.com/jwfh/build.mk) to a Git project by including
it as a submodule `Mk` at the root of your project:

```sh
cd $(git rev-parse --show-toplevel)
git submodule add https://github.com/jwfh/build.mk Mk
```

Then create a `Makefile` in each subproject that should be built by [`build.mk`](https://github.com/jwfh/build.mk). Every `Makefile` must have the following line at the bottom of the file:

```make
.include "../Mk/build.mk"
```

Correct the relative path prefix according to the depth of the subproject that includes [`build.mk`](https://github.com/jwfh/build.mk).

## Dependencies

[`build.mk`](https://github.com/jwfh/build.mk) requires that BSD [`make(1)`](https://www.freebsd.org/cgi/man.cgi?make(1)) is installed, as the library is not compatible with GNU [`make(1)`](https://linux.die.net/man/1/make).

On FreeBSD, this is the case by default.

On macOS, `bmake(1)` can be easily installed from HomeBrew.

On other systems [`bmake`](https://www.crufty.net/help/sjg/bmake.html) can be built from source using the standard autotools and GNU [`make(1)`](https://linux.die.net/man/1/make) toolchain.

## Writing `Makefile`s

### Defining `USES`

`USES` tells `build.mk` which languages your project uses, and optionally which non-default features of those languages you would like to configure.

Supported `USES` values are:

- `python`
- `java`
- `terraform`
- `docker`
- `cmake`

Language features can be specified after the language and are separated by a colon.

For example, to include the `java` use-file with the `11` option to specify that the project builds with Java 11, we write

```make
USES=   java:11

.include "../Mk/build.mk"
```

Details about which features a particuar `USES` provides is available in the respective use-file, located in [`Uses/`](https://github.com/jwfh/build.mk/tree/main/Uses).

Each of the supported language use-files defines the types of artifacts that that language supports. Details about which artifacts a particuar `USES` provides are also located in the respective use-file.


## Contributing

Be aware that there are submodules in the Test directory for running unit tests. To hack on [`build.mk`](https://github.com/jwfh/build.mk), just clone the repository with its submodules.

Pull requests with new features are welcome, but should be accompanied by unit and/or integration tests.


## Alternatives

- [Gradle](https://gradle.org/)
- [CMake](https://cmake.org/) (with Make or Ninja)
- [Ninja](https://ninja-build.org/)
- Make ([BSD](https://www.freebsd.org/cgi/man.cgi?make(1)) or [GNU](https://linux.die.net/man/1/make))
- [Autotools](https://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html)

## Credit

The inspiration for this library is the FreeBSD ports collection's array of `make(1)` files in [https://cgit.freebsd.org/ports/tree/Mk](https://cgit.freebsd.org/ports/tree/Mk?h=main). I've borrowed bits here and there from this project, but for the most part treated it as a best practice and designed the library with my own goals in mind. The principal goal here is to create a build system that developers embed in a project to produce (compiled) artifacts, not to pull in already-made source archives and build them like the ports' `Makefiles` do.
