library("dplyr")
library("boxr")
library("stringr")

### Command Line args ###
args <- commandArgs(trailingOnly = FALSE) 
fileNames_all <- args[6]
fileLocation <- fileNames_all
### END Command line args ###

### Box auth ###
boxr::box_auth(client_id = "XXXXXXXX",
               client_secret = "XXXXXXX")
## END Box auth ###

### Upload files from The University of South Florida's Cloud Computing Cluster to Box ###
# box to circe if DIR does not exist function
box_to_circe <- function(dir_name, working_dir){
  box_dir <- as.character(dir_name)
  box.d <- boxr::box_dir_create(dir_name = box_dir, parent_dir_id = "XXXXXXX")
  #setwd(as.character(working_dir))
  files_in_dir <- list.files(path = working_dir,
                             full.names = T)
  for(i in 1:length(files_in_dir)){
    box_ul(
      dir_id = as.character(box.d[2]) ,
      file = as.character(files_in_dir[i]),
      pb = options()$boxr.progress,
      description = NULL
    )
    boxr::box_auth(client_id = "XXXXX",
                   client_secret = "XXXXX")
  }
}
fileLocation <- gsub(pattern = "/$", replacement = "", fileLocation) # fix line if user inserts trailing '/'
put_dir <- fileLocation
put_name <- substr(x = fileLocation, # strip date from parameter
                   start = nchar(fileLocation) - 6,
                   stop = nchar(fileLocation))
query_term <- gsub("-", " AND ", put_name) # create search term for box funtion
box_current_ls <- boxr::box_ls() %>% as.data.frame() %>% select(id) # get all ids in current dir
get_id <- data.frame() # create empty df
get_id <- boxr::box_search_folders(query = query_term, # search for current folder. If exist, get folder id
                                   ancestor_folder_id = "XXXXX",
                                   content_types = "name") %>%
  as.data.frame()
get_id <- get_id$id[1]
if(length(get_id) > 0){ # check if get_id is still empty, if not, upload remining files
  print("dir exist. Starting upload remaining files")
  circe_df <- data.frame(files = list.files(path = fileLocation, # get df of circe files in DIR
                                            full.names = F))
  box_files_in_dir <- boxr::box_ls(dir_id = get_id, # get df of box files in DIR
                                   limit = 800) %>% as.data.frame() %>% select(name)
  box_df <- data.frame(files = box_files_in_dir)
  box_df <- box_df %>% dplyr::rename(files = "name")
  upload_files <- data.frame(files = subset(circe_df, !(files %in% box_df$files)))
  setwd(fileLocation)
  for(i in 1:nrow(upload_files)){
    box_ul(
      dir_id = as.character(get_id[1]) ,
      file = as.character(upload_files[i,]),
      pb = options()$boxr.progress,
      description = NULL
    )
  }
}else( # if get_id is empty
  box_to_circe(dir_name = put_name,
               working_dir = put_dir)
)
### END Upload files from The University of South Florida's Cloud Computing Cluster to Box ###
