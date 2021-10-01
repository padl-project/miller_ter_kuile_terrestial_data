rm(list = ls())

#------------------------------------
#read the batch file and load all the libraries
library(EMLassemblyline)
library(XML)
library(readxl)
library(dplyr)
library(googlesheets4)

#####user edit zone

## Download metadata file
metadata_folder <- "https://drive.google.com/drive/folders/1kG14ZSwvdf1Jc1owZ1vZPXDJW2x4UYpl"

metadata_file <- drive_ls(as_id(metadata_folder))

## Download all file to local computer. 
drive_download(
  file = as_id(metadata_file$id),
  path = paste0(getwd(), "/EML/", "metadata"),
  type = "xlsx")



#change the following number based on each of the datasets
dataset_id=101

folder_path<- here::here("EML")
#end user edit zone###########

######################################
#loading all the functions
source(paste0(folder_path,'EML_generation/EML_funs/get_meta_xlsx.R'))
source(paste0(folder_path,'EML_generation/EML_funs/generate_EML_Assemblyline.R'))

#read the metadata content out of xlsx
metadata <- get_meta_xlsx(folder_path=folder_path,dataset_id=dataset_id)

#fill the EML content into the template
eml_in_template <- generate_EML_Assemblyline(project_path= paste0(folder_path,"project.",dataset_id,"/"),
                                             excel_input=metadata,
                                             dataset_id_input=dataset_id)

# Export EML --------------------------------------------------------------------
do.call(make_eml, eml_in_template[names(eml_in_template) %in% names(formals(make_eml))])

