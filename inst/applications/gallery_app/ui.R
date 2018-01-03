library(shinydashboard)

ui <- dashboardPage(
  
  dashboardHeader(title = "Gallery Console"),
  
  dashboardSidebar(
    textInput(
      "gallery",
      "Gallery",
      "http://yourgallery.com/gallery"
    ),
    textInput(
      "api_key",
      "API Key"
    ),
    passwordInput(
      "api_secret",
      "API Secret"
    ),
    br(),
    column(width = 6,
      actionButton(
        "save_info",
        "Save Info"
      )
    ),
    column(width = 6,
      imageOutput("connection_indicator")
    )
  ),
  
  dashboardBody(
    column(width = 6,
      uiOutput("app_boxes")
    ),
    column(width = 6,
      h4("Select an application to the left to view the questions"),
      uiOutput("app_questions"),
      actionButton(
        "run_app",
        "Run App"
      )
    )
  )
  
)
