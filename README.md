# Venn Compute

This R package is intended to compute specific elements in intersections of Venn
diagram instead of plot.

- Custom reader of files to create list of character arrays (such requiered for
  this package and VennDiagram).
- Compute specific elements in intersections of Venn diagram in memory or write
  to files.
- Plot with VennDiagram.

## How to install

You can install from GitHub as:

```r
devtools::install_github("cosmoscalibur/venn.compute")
```

If an error about TAR executable is showed (common in Linux with Anaconda), you
need to setup your TAR path.

```r
Sys.setenv(TAR = "/bin/tar")
```

## How to use

First, load the package.

```r
library(venn.compute)
```

### Read files

This is a custom reader to include multiple files and associate its custom
names, returned a named list of character arrays (each element is an element
line of the file).

```r
sets <- read.lists_from_files(c(file.path("tests", "primes.txt"),
                                file.path("tests", "even.txt"),
                                file.path("tests", "fibo.txt")),
                              c("primes", "even", "fibo"))
```

### Compute intersections and specific elements

Now you can compute specific elements of Venn diagram intersections.

```r
venn.compute_specific(sets)
```

If you need to write sets in files, add an output path. Files are written
using convention of join sets name with underscore.

```r
venn.compute_specific(sets, output_dir = file.path("tests", "output"))
```

### Plot Venn diagram

Finally, if you want to save plot, invoke this function with the same arguments
as before.

```r
venn.compute_plot(sets, output_dir = file.path("tests", "output"))
```

