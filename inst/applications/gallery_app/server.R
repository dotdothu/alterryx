server <- function(input, output) {
  
  rv <- reactiveValues(
    connected = FALSE,
    selected_app = ""
  )
  
  connect_to_gallery <- function(gallery,
                                 api_key,
                                 api_secret) {
    
    options(alteryx_api_key = api_key)
    options(alteryx_secret_key = api_secret)
    options(alteryx_gallery = gallery)
    
    connection <- try(get_app(), silent = TRUE)
    
    if(class(connection) == "list") {
      rv$connected <- TRUE
    } else {
      rv$connected <- FALSE
    }
    
  }
  
  render_question_form <- function(question) {
    
    if(question$type == "QuestionTextBox") {
      
      textInput(
        question$name,
        question$description,
        question$value
      )
      
    } else if(question$type == "QuestionNumericUpDown") {
      
      numericInput(
        question$name,
        question$description,
        question$value
      )
      
    } else {
      NULL
    }
    
  }
  
  #save api key info
  observeEvent(input$save_info, {
    
    req(input$gallery)
    req(input$api_key)
    req(input$api_secret)

    connect_to_gallery(
      input$gallery,
      input$api_key,
      input$api_secret
    )
    
  })
  
  # observeEvent(input$run_app, {
  #   
  #   selected_subscription <- lapply(subscription(), function(x) {
  #     get_info(x)$id == rv$selected_app
  #   })
  #   
  #   app <- subscription()[unlist(selected_subscription)]
  #   
  #   lapply(selected_app_questions(), function(x) {
  #     
  #     
  #     
  #   })
  #   
  #   answers <- do.call()
  #   
  #   queue_job(app[[1]],
  #             answers)
  #   
  # })
  
  output$connection_indicator <- renderImage({
    
    input$save_info
    
    image_path <- paste0(getwd(), "/data/images")
    
    if(rv$connected) {
      image_name <- "connected.png"
    } else {
      image_name <- "not_connected.png"
    }
    
    list(src = file.path(image_path, image_name),
         width = 45,
         height = 45)
    
  }, deleteFile = FALSE)
  
  subscription <- reactive({
    
    input$save_info
    req(rv$connected)
    get_app()
    
  })
  
  selected_app_questions <- reactive({
    
    selected_subscription <- lapply(subscription(), function(x) {
      get_info(x)$id == rv$selected_app
    })
    
    app <- subscription()[unlist(selected_subscription)]
    
    if(length(app)) {
      return(get_app_questions(app[[1]]))
    } else {
      NULL
    }
    
  })
  
  output$app_questions <- renderUI({
    
    tagList(
      lapply(selected_app_questions(), function(x) {
        render_question_form(x)
      })
    )
    
  })
  
  # use lappy to create an infoBox for each app in subscription()
  observe({
    
    lapply(seq_along(subscription()), function(i, apps) {
      
      app_info <- get_info(apps[[i]])
      
      app_name <- app_info$fileName
      app_id <- app_info$id
      app_runs <- app_info$runCount
      
      output[[paste0("app_box_", i)]] <- renderInfoBox({
        info_box <- infoBox(
          app_name,
          app_runs,
          href = "#",
          color = "blue",
          icon = icon("sliders")
        )
        
        # this is a hacky way to turn an infoBox into an action button
        info_box$children[[1]]$attribs$class <- "action-button"
        info_box$children[[1]]$attribs$id <- paste0("app_box_", i)
        
        return(info_box)
      })
      
    }, apps = subscription())
    
  })
  
  # use lapply to render the infoBox(es) in the ui
  output$app_boxes <- renderUI({

    app_boxes <- lapply(seq_along(subscription()), function(i) {

      infoBoxOutput(paste0("app_box_", i))

    })

    do.call(tagList, app_boxes)

  })
  
  # create the action that updates the reactive value rv$selected_app with the
  # clicked app each time an infoBox is clicked
  observe({
    
    lapply(seq_along(subscription()), function(i, apps) {
      observeEvent(input[[paste0("app_box_", i)]], {
        rv$selected_app <- apps[[i]]$id
      })
    }, apps = subscription())
    
  })
  
}
