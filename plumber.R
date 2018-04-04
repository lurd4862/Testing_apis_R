# script name:
# plumber.R

# set API title and description to show up in curl "http://127.0.0.1:8000/mean"/__swagger__/
#' @apiTitle Run predictions for the total hours of sleep of an animal
#' @apiDescription This API takes various animal's data on factors related to sleep and predicts how long the animal will sleep on its next cycle.
#' indicates hours of sleep

# load model
# this path would have to be adapted if you would deploy this
# load("/Users/shiringlander/Documents/Github/shirinsplayground/data/model_rf.RData")
example_model <<- 
	readRDS("/home/stefan/Temp/Creating_an_api_in_R/data/example_model.rds")
# readRDS("/usr/etc/learning_api_in_R/data/example_model.rds")

#' Log system time, request method and HTTP user agent of the incoming request
#' @filter logger
function(req){
	cat("System time:", as.character(Sys.time()), "\n",
			"Request method:", req$REQUEST_METHOD, req$PATH_INFO, "\n",
			"HTTP user agent:", req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n")
	plumber::forward()
}

# core function follows below:
# define parameters with type and description
# name endpoint
# return output as html/text
# specify 200 (okay) return

#' predict Chronic Kidney Disease of test case with Random Forest model
#' @param	vore Character variable. Options are : carni, herbi, insecti, omni.
#' @param	bodywt:numeric Numeric variable. Weight in lb of the animal.
#' @param	brainwt:numeric Numeric variable. Weight in lb of the animal.
#' @param	awake:numeric Numeric variable. Time animal has been awake.
#' @get /predict
#' @html
#' @response 200 Returns the hour(s) prediction from the Random Forest model predicting hours of next sleep
calculate_prediction <- function(vore,bodywt,brainwt,awake) {
	
	# if(!all(c("vore","bodywt","brainwt","awake") %>% map_lgl(exists))){
	# 	stop("You must specify all parameters")
	# 	# res$status <- 400
	# 	# res$body <- "You must specify all parameters"
	# }
	# make data frame from parameters
	input_data <<- data.frame(vore,bodywt,brainwt,awake,
														stringsAsFactors = FALSE)
	
	input_data <- 
		input_data %>% 
		mutate(
			bodywt = bodywt %>% as.numeric(),
			brainwt = brainwt %>% as.numeric(),
			awake = awake %>% as.numeric()
		)
	
	# # and make sure they really are the right format
	# if(all(input_data["vore"] %>% class != "character")){
	# 	res$status <- 400
	# 	res$body <- "Parameters have to be in the right format. vore - character"
	# }
	
	# if( all(input_data[c("bodywt","brainwt","awake")] %>% class != "numeric") ){
	# 	res$status <- 400
	# 	res$body <- "Parameters have to be in the right format. vore - character"
	# }
	
	# # validation for parameter
	# if (any(is.na(input_data))) {
	# 	res$status <- 400
	# 	res$body <- "Parameters have to be numeric or integers - NA's intriduced by coercion"
	# }
	
	# predict and return result
	pred_rf <<- predict(example_model, input_data)
	paste("----------------\nNext sleep cycle predicted to be", as.character(pred_rf), "\n----------------\n")
}
