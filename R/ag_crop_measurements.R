#' @include checkers.R utils.R
#' 
#' Crop measurements Class
#' 
#' @description subclass for representing the crop measurements data. It inherents from AgAPI client class 
#' all the basic parameters and methods.
#'
#' @title ExpSite
#'
#' @docType class
#'
#' @format R6 class
#'
#' @field user specifies the user name, defaults to NULL 
#' @field password specifies the password, defaults to NULL
#' @field user specifies the user name, defaults to NULL 
#' @field password specifies the password, defaults to NULL
#' @field authentication specifies the password, defaults to NULL
#' @field token specifies the password, defaults to NULL
#' @field user_agent specifies the password, defaults to NULL
#' @field serverURL specifies the password, defaults to 
#'                  http://research.cip.cgiar.org/agrofims/api/dev/
#' @field version specifies the version, defaults to 0051
#' @field endPoint specifies the end point value,   tableName/method.php 
#' @importFrom R6 R6Class
#' 
#' @export
#' 
AgExpSite <- R6::R6Class(
  
  classname = "AgExpSite",
  inherit = AgAPIClient,
  # private = list(
  #   super$endPoint = "/exp-site/getAll?id="
  # ),
  
  public = list(
    
    siteId = NA, #siteId 
    site_crop_id = "NA",
    initialize = function(user=NULL, password=NULL, authentication=NULL, token=NULL, user_agent=NULL,
                          serverURL, version ){ #, endPoint) {
      super$initialize(user, password, authentication, token, user_agent, serverURL, version)#, endPoint)
    },
    
    ag_get_expsite_studyId = function(studyDbId, format, ...){},
    ag_get_sitedesc_studyId = function(studyDbId, format, ...){},
    ag_get_cropsite_studyId  = function(studyDbId, format, ...){}
  )
)

#' @title  Get all experiment-site data from an agronomic study by its agronomical study database ID
#' @description retrieve data from databases with AgAPI standard
#' @field ... argument inherents by AgaAPIClient
#' @field studyDbID character agronomical study id
#' @field format support in three data structures: json, list and data.frames
#' @importFrom R6 R6Class
#' @importFrom httr content
#' @importFrom jsonlite fromJSON
#' @importFrom tibble rownames_to_column
#' @author Omar Benites
#' @export 
#' 
AgExpSite$set(which = "public", name = "ag_get_cropmea_studyId",  
                                function(siteCropId =NULL,
                                         format=c("json","list","data.frame"),
                                         ...){
  
  format <- match.arg(format)
  super$endPoint <- "/exp-site/getAll?id="
  url  <- paste0(self$serverURL, self$version, super$endPoint) #everything before the URL
  #url  <- paste0(self$serverURL, self$version, self$endPoint) #everything before the URL
  print(url)
  
  headerParams <- character()
  
  queryParams <- list(id = siteCropId) #everythig after the ? in the URL 
  
  res <- self$call_api(
    url = url, 
    method = "GET",
    queryParams = queryParams, #, #TODO
    #headerParams = headerParams, #TODO
    #body = body,
    ...
  )
  cont <- httr::content(res, as = "text", encoding = "UTF-8")
  
  if(format=="json"){
    out <-  cont
  } else if(format=="list"){
    out <- jsonlite::fromJSON(cont,simplifyVector = "vector")
  } else if(format=="data.frame") {
    out <- as_data_frame_agapi(cont)
  }
  return(out)
},
overwrite = TRUE)
