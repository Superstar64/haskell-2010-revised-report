# Haskell 2010 Revised Language Report

## How to Build

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
