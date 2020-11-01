# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this
project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [UNRELEASED]

* Add a test suite.
* Document why recursively grepping directories with `-r` does not
  work.
* Use getopts (with "s") to ease parsing commandline options with
  parameters.
* Properly passthrough exit codes from grep to keep grep's over all
  exit code style: 0 = match found, 1 = no match found, 2 = error
* Revamp Makefile, mostly building the distribution tarballs.
* Add preliminary .spec file for building RPMs.

## [1.0.0] - 2020-06-18

* Initial release.
