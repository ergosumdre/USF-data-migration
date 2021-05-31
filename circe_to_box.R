# This script was created to copy files from USF's CIRCE directly to Box.  
library("boxr")
library("dplyr")

# setwd()
# box auth
boxr::box_auth(client_id = "XXXXXXXXX", 
               client_secret = "XXXXXXXXX")

# get circe dir str
box_dir <- substr(getwd(), 
                  start = nchar(getwd()) - 6, 
                  stop = nchar(getwd()))

# create box dir with circe dir str
box.d <- boxr::box_dir_create(dir_name = box_dir, 
                              parent_dir_id = "XXXXXXXXX")

# upload local dir to box in new dir
boxr::box_push(dir_id = box.d[2], 
               local_dir = getwd(),
               ignore_dots = TRUE,
               overwrite = FALSE,
               delete = FALSE)

