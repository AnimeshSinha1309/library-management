## server.R

# load functions
source('functions/cf_algorithm.R') # collaborative filtering
source('functions/similarity_measures.R') # similarity measures

# define functions
get_user_ratings <- function(value_list) {
  dat <- data.table(book_id = sapply(strsplit(names(value_list), "_"), function(x) ifelse(length(x) > 1, x[[2]], NA)),
                    rating = unlist(as.character(value_list)))
  dat <- dat[!is.null(rating) & !is.na(book_id)]
  dat[rating == " ", rating := 0]
  dat[, ':=' (book_id = as.numeric(book_id), rating = as.numeric(rating))]
  dat <- dat[rating > 0]
  
  # get the indices of the ratings
  # add the user ratings to the existing rating matrix
  user_ratings <- sparseMatrix(i = dat$book_id, 
                               j = rep(1,nrow(dat)), 
                               x = dat$rating, 
                               dims = c(nrow(ratingmat), 1))
}

# read in data
books <- fread('data/books.csv')
ratings <- fread('data/ratings_cleaned.csv')

# reshape to books x user matrix 
ratingmat <- sparseMatrix(ratings$book_id, ratings$user_id, x=ratings$rating) # book x user matrix
ratingmat <- ratingmat[, unique(summary(ratingmat)$j)] # remove users with no ratings
dimnames(ratingmat) <- list(book_id = as.character(1:10000), user_id = as.character(sort(unique(ratings$user_id))))

shinyServer(function(input, output, session) {
  
  # show the books to be rated
  output$ratings <- renderUI({
    num_rows <- 20
    num_books <- 6 # books per row
    
    lapply(1:num_rows, function(i) {
      list(fluidRow(lapply(1:num_books, function(j) {
        list(div(width = 2,
                #  div(img(src = books$image_url[(i - 1) * num_books + j])),
                 span(books$authors[(i - 1) * num_books + j]),
                 span(books$title[(i - 1) * num_books + j]),
                 span(ratingInput(paste0("", books$book_id[(i - 1) * num_books + j]), label = "")))) #00c0ef
      })))
    })
  })
  
  # Calculate recommendations when the sbumbutton is clicked
  df <- eventReactive(input$btn, {
    withBusyIndicatorServer("btn", { # showing the busy indicator
        # hide the rating container
        useShinyjs()
        jsCode <- "document.querySelector('[data-widget=collapse]').click();"
        runjs(jsCode)
        
        # get the user's rating data
        value_list <- reactiveValuesToList(input)
        user_ratings <- get_user_ratings(value_list)
        
        # add user's ratings as first column to rating matrix
        rmat <- cbind(user_ratings, ratingmat)
        
        # get the indices of which cells in the matrix should be predicted
        # predict all books the current user has not yet rated
        items_to_predict <- which(rmat[, 1] == 0)
        prediction_indices <- as.matrix(expand.grid(items_to_predict, 1))
        
        # run the ubcf-alogrithm
        res <- predict_cf(rmat, prediction_indices, "ubcf", TRUE, cal_cos, 1000, FALSE, 2000, 1000)
        
        # sort, organize, and return the results
        user_results <- sort(res[, 1], decreasing = TRUE)[1:20]
        user_predicted_ids <- as.numeric(names(user_results))
        recom_results <- data.table(Rank = 1:20, 
                                    Book_id = user_predicted_ids, 
                                    Author = books$authors[user_predicted_ids], 
                                    Title = books$title[user_predicted_ids], 
                                    Predicted_rating =  user_results)
        
    }) # still busy
    
  }) # clicked on button
  

  # display the recommendations
  output$results <- renderUI({
    num_rows <- 4
    num_books <- 5
    recom_result <- df()
    
    lapply(1:num_rows, function(i) {
      list(row(style = "padding: 20px;", lapply(1:num_books, function(j) {
        div(style = "padding: 20px;", title = paste0("Recommendation ", (i - 1) * num_books + j),            
          # div(, 
          #     a(href = paste0('https://www.goodreads.com/book/show/', books$best_book_id[recom_result$Book_id[(i - 1) * num_books + j]]), 
          #       target='blank', 
          #       img(src = books$image_url[recom_result$Book_id[(i - 1) * num_books + j]], height = 150)
          #     )
          #    ),
          span(books$authors[recom_result$Book_id[(i - 1) * num_books + j]]),
          span(strong(books$title[recom_result$Book_id[(i - 1) * num_books + j]]))
        )        
      }))) # columns
    }) # rows
    
  }) # renderUI function
  
}) # server function
