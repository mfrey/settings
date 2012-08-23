
# set the CRAN repository to germany
repository <- getOption("repos")
repository["CRAN"] <- "http://mirrors.softliste.de/cran/"
options(repos = repository)
rm(repository)

# set evince as default pdf viewer
options("pdfviewer"="evince") 

# in bashrc has to be R_HISTFILE environment variable which denote the location of the history file
.Last <- function(){
  if(!any(commandArgs()=='--no-readline') && interactive()){
    require(utils)
    try(savehistory(Sys.getenv("R_HISTFILE")))
  }
}



