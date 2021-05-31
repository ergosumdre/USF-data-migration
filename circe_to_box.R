# This script was created to copy files from USF's CIRCE directly to Box.  
library("boxr")
library("dplyr")

# setwd()
# box auth
box_auth(client_id = "XXXXXXXXXXXXXX", 
         client_secret = "XXXXXXXXXXXXX")

# get circe dir str
box_dir <- substr(getwd(), start = nchar(getwd()) - 6, stop = nchar(getwd()))

# create box dir with circe dir str
boxr::box_dir_create(dir_name = box_dir, parent_dir_id = "XXXXXXXXX")

# searches for new box dir and sets wd
new_id <- box_search(box_dir, type = "folder") %>% 
  as.data.frame() %>% select(id, name) %>% 
  filter(name == box_dir) %>% select(id)
new_id <- as.character(new_id$id)
boxr::box_setwd(new_id)

# upload local dir to box in new dir
box_push(dir_id = new_id, local_dir = getwd(),ignore_dots = TRUE,overwrite = FALSE,delete = FALSE)
