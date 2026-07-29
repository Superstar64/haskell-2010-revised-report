# Haskell 2010 Revised Language Report

This repository contains the files required to build the revised version of the Haskell 2010 language report.

## How to Build the PDF report

In order to build the report you have to install Typst version `0.15` or later.

The `Makefile` contains a target to build the report, but the two following commands also work:

```console
> typst compile haskell-2010-revised.typ
```
builds the report in pdf form.

```console
> typst watch haskell-2010-revised.typ
```
continuously watches for file changes and rebuilds the pdf on every change.

## Building HTML

The `Makefile` contains a html target, but the layout has not yet been optimized for HTML, and there are various bugs that have to be fixed.

## How to Contribute

The contribution process is documented in [CONTRIBUTING.md](CONTRIBUTING.md)

We have adopted the [Haskell Foundation Guidelines for Respectful Communication](https://haskell.foundation/guidelines-for-respectful-communication/) for this project.
