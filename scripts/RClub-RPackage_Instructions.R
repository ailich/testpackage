#Creating an R-package from scratch can be can be confusing. Luckily, as with all thinsg R, there's a packahe for that
library(devtools)
library(roxygen2)

#Optional git/github setup
  #Install and setup git
    #https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
    #http://r-pkgs.had.co.nz/git.html
    #Create github account

#Create package skeleton
  #With Git/Github
    #On github create a new repository with your package name (e.g. testpackage)
    #In Rstudio click File -> New Project -> Version Control
    #Paste link to github repository
    devtools::create(getwd()) #Create package

  #Without github
    #Click File -> New Project -> New Directory -> R Package
      #Choose parent folder location
      #Name package (Will be a sub-fodler within parent folder)
      #Check option for git if you want version control
      #Alternatively can use devtools::create("folderpath/yourpackagename")
      #Can always add git later with usethis::use_git() #Initialize git repository

#You made a package and before you didn't want it on github, but now you do. How do you fix that?
  usethis::use_git() #Initialize git repository if you haven't already
  usethis::browse_github_token() #Should open web browser. Click "Generate token"
  usethis::use_github(private = TRUE, auth_token = "PasteTokenHere")
