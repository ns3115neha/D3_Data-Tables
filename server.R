# --------------------------------------------------------
# Minimal shiny app demonstrating the D3TableFilter widget
# server.R
# --------------------------------------------------------

#install.packages("devtools")
#devtools::install_github("ThomasSiegmund/D3TableFilter")
library(shiny)
library(htmlwidgets)
library(D3TableFilter)

shinyServer(function(input, output, session) {
  output$mtcars <- renderD3tf({
    
    # Define table properties. See http://tablefilter.free.fr/doc.php
    # for a complete reference
    tableProps <- list(
      btn_reset = TRUE,
      sort = TRUE,
      sort_config = list(
        # alphabetic sorting for the row names column, numeric for all other columns
        sort_types = c("String", rep("Number", ncol(cleandata)))
      )
    );
    
    
    
    extensions <-  list(
      list(name = "sort"),
      list( name = "colsVisibility",
            at_start =  c(8, 9, 10, 11),
            text = 'Hide columns: ',
            enable_tick_all =  TRUE
      ),
      
      list( name = "filtersVisibility",
            visible_at_start =  TRUE)
    );
    
    observe({
      if(is.null(input$mtcars_filter)) return(NULL);
      
      filterSettings <-input$mtcars_filter$filterSettings;
      tmp <- lapply(filterSettings,
                    function(x) data.frame(Column = x$column,
                                           Filter = x$value, stringsAsFactors = FALSE));
      filters <- do.call("rbind", tmp);
      
      
      
      print("Active filters:")
      print(filters)
      
      rowIndex <- unlist(input$mtcars_filter$validRows);
      print("Valid rows:")
      print(cleandata[rowIndex, ]);
      
      
      output$download_filtered <- 
        downloadHandler(
          filename = "Filtered Data.csv",
          content = function(file){
            write.csv(cleandata[rowIndex, ],
                      file)
          }
        )
      
    })
    
    
    
    d3tf(cleandata,
         tableProps = tableProps,
         extensions = extensions,
         showRowNames = TRUE,
         filterInput = TRUE,
         edit = TRUE,
         tableStyle = "table table-bordered");
    
    
  })
})



