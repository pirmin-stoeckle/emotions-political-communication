library(here)
library(fs)

dir_create(here("data", "raw"))        # raw data
dir_create(here("data", "processed"))  # intermediate data
dir_create(here(c("scripts",           # storing all .R, .Rmd, .py files
                  "figures",           # output figures
                  "output",            # output files
                  "previous",          # previous versions keep for record
                  "paper",             # current versions of the document
                  "notes",             # random notes
                  "documents"          # supporting documents
)
)
)